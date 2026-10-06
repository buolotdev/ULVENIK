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
            onPressed: () {
              AppSnackbar.show(context, message: 'More options coming soon', type: SnackbarType.info);
            },
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
                  color: const Color(0xFF2e6b57).withOpacity(0.2), // primary-container/20
                  border: Border.all(color: const Color(0xFF2e6b57)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'PRIORITY $priority',
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
