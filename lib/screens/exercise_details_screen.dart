import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/custom_snackbar.dart';
import 'edit_exercise_screen.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  const ExerciseDetailsScreen({super.key});

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryForestGreen),
          onPressed: () => Navigator.pop(context), 
        ),
        title: const Text(
          'Ulvenik',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHero(),
            _buildQuickActions(),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 24),
            _buildSkillHierarchy(),
            const SizedBox(height: 24),
            _buildActiveGoal(),
            const SizedBox(height: 24),
            _buildRecentSessions(),
          ],
        ),
      ),
    );
  }

  // ── Hero Section ────────────────────────────────────────────────────────
  Widget _buildHero() {
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBueCszLZ4HtZ9M8HO3ajK-D7RVLePGO2p2cqumBTDbbBUi4X_X1He-g6FrOROixcqUzW7MapbW9AlSSQHDVNujmiZLFIysng7iR2whfwOa0cP64tvjziDDCtwFCI59RLZ37QWpxecCzsOz4CZrdSkyIMJrTm_UmC93oAkUWWqXdEC4fvZs2aHZtNQl8nwfLJ4r2Ank5s9fc4RBlO-Zto84JCiTghI0CUn3E-M4TSO3O_t_l1Ybw6c',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundObsidian.withOpacity(0.0),
                  AppColors.backgroundObsidian.withOpacity(0.5),
                  AppColors.backgroundObsidian,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency Recall',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildChip('FOUNDATION'),
                    const SizedBox(width: 8),
                    _buildChip('OUTDOOR'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon.withOpacity(0.5),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // ── Quick Actions ───────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionIcon(
            icon: Icons.fiber_manual_record,
            label: 'RECORD',
            color: AppColors.primaryForestGreen,
            onTap: () {
              AppSnackbar.show(context, message: 'Record session coming soon', type: SnackbarType.info);
            },
          ),
          _buildActionIcon(
            icon: Icons.edit_outlined,
            label: 'EDIT',
            color: AppColors.secondaryTextStoneGrey,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EditExerciseScreen()));
            },
          ),
          _buildActionIcon(
            icon: Icons.account_tree_outlined,
            label: 'PARENT',
            color: AppColors.secondaryTextStoneGrey,
            onTap: () {
              AppSnackbar.show(context, message: 'Parent skill coming soon', type: SnackbarType.info);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isPrimary = color == AppColors.primaryForestGreen;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPrimary ? color.withOpacity(0.1) : AppColors.cardsCarbon,
              border: Border.all(
                color: isPrimary ? color.withOpacity(0.5) : Colors.white12,
              ),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  // ── Skill Hierarchy ─────────────────────────────────────────────────────
  Widget _buildSkillHierarchy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skill Hierarchy',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              AppSnackbar.show(context, message: 'Skill hierarchy coming soon', type: SnackbarType.info);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF191c1b), // surface-container-low
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Icon(Icons.hub_outlined, color: AppColors.secondaryTextStoneGrey, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Recall',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tap to view parent skill progression',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Active Goal ─────────────────────────────────────────────────────────
  Widget _buildActiveGoal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Goal',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Emergency Recall at 50m with distraction',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryForestGreen.withOpacity(0.1),
                        border: Border.all(color: AppColors.primaryForestGreen.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: AppColors.primaryForestGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const AnimatedProgressBar(
                  value: 0.55,
                  height: 6,
                  color: AppColors.primaryForestGreen,
                  backgroundColor: AppColors.backgroundObsidian,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Started 12 Jun',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                      ),
                    ),
                    AnimatedPercentText(
                      value: 0.55,
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
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

  // ── Recent Sessions ─────────────────────────────────────────────────────
  Widget _buildRecentSessions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const Text(
                'Recent Sessions',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppSnackbar.show(context, message: 'View All coming soon', type: SnackbarType.info);
                },
                child: const Text(
                  'VIEW ALL',
                  style: TextStyle(
                    color: AppColors.primaryForestGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSessionCard(
            month: 'JUL',
            day: '22',
            title: 'Forest Trail Alpha',
            successRate: '90%',
            indicatorColor: AppColors.primaryForestGreen,
          ),
          const SizedBox(height: 12),
          _buildSessionCard(
            month: 'JUL',
            day: '15',
            title: 'Open Field Training',
            successRate: '75%',
            indicatorColor: const Color(0xFF3a4e3c), // secondary-container approx
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard({
    required String month,
    required String day,
    required String title,
    required String successRate,
    required Color indicatorColor,
  }) {
    return GestureDetector(
      onTap: () {
        AppSnackbar.show(context, message: 'Session details coming soon', type: SnackbarType.info);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF323533), // surface-container-highest
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    month,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    day,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: indicatorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Success Rate: $successRate',
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey),
          ],
        ),
      ),
    );
  }
}
