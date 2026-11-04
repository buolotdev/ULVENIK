import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/custom_snackbar.dart';

class GoalDetailsScreen extends StatelessWidget {
  final String title;
  final String category;
  final String targetText;
  final int current;
  final int total;
  final bool isAutomatic;
  final String priority;

  const GoalDetailsScreen({
    super.key,
    this.title = 'Complete 20 Recall Sessions',
    this.category = 'TRAINING',
    this.targetText = 'Sessions',
    this.current = 14,
    this.total = 20,
    this.isAutomatic = true,
    this.priority = 'HIGH',
  });

  void _showArchiveGoalDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryForestGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.archive_outlined,
                  color: AppColors.primaryForestGreen,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Archive Goal?',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This will archive ‘$title’ and remove it from your active goals. All data and linked sessions will remain intact, and you can restore it at any time.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    AppSnackbar.show(context, message: 'Goal archived', type: SnackbarType.success);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Archive Goal',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.white12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteGoalDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1A1A).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFFFB4AB),
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Goal?',
                style: TextStyle(
                  color: Color(0xFFFFB4AB),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This action is permanent and cannot be undone. Please review what will happen if you proceed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundObsidian,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 16, color: AppColors.primaryForestGreen),
                        SizedBox(width: 8),
                        Text(
                          'WILL NOT BE DELETED',
                          style: TextStyle(
                            color: AppColors.primaryForestGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'All linked training sessions\nNotes and media attached to sessions',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white12, height: 1),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFFFB4AB)),
                        SizedBox(width: 8),
                        Text(
                          'WILL BE PERMANENTLY REMOVED',
                          style: TextStyle(
                            color: Color(0xFFFFB4AB),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'Goal progress history and statistics\nGoal-specific notes and reminders',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    AppSnackbar.show(context, message: 'Goal deleted', type: SnackbarType.success);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBA1A1A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Delete Goal',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.white12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showManagementMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.archive_outlined, color: AppColors.primaryForestGreen),
                title: const Text('Archive Goal', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showArchiveGoalDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                title: const Text('Delete Goal', style: TextStyle(color: Color(0xFFFFB4AB))),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDeleteGoalDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = total > 0 ? (current / total) : 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.primaryTextOffWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Goal Details',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primaryTextOffWhite),
            onPressed: () => _showManagementMenu(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildProgressCard(percentage),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.05,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2e6b57).withValues(alpha: 0.2), // primary-container/20
                  border: Border.all(color: const Color(0xFF2e6b57)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$priority PRIORITY',
                  style: const TextStyle(
                    color: Color(0xFF95d3bb), // primary
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2e6b57), // primary container
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFaae9d0), // on-primary-container
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Color(0xFFaae9d0), // on-primary-container
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.05,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isAutomatic ? 'AUTOMATIC' : 'MANUAL',
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(double percentage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$current',
                    style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ $total $targetText',
                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: const TextStyle(color: Color(0xFF95d3bb), fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedProgressBar(
            value: percentage,
            height: 6,
            backgroundColor: const Color(0xFF323533),
            color: const Color(0xFF95d3bb), // primary
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.calendar_today, color: AppColors.secondaryTextStoneGrey, size: 16),
                  SizedBox(width: 8),
                  Text('Due Date', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                ],
              ),
              const Text('31 Dec 2026', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
