import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/custom_snackbar.dart';
import 'create_goal_screen.dart';
import 'goal_details_screen.dart';

class GoalsListScreen extends StatefulWidget {
  final bool initialHasData;
  const GoalsListScreen({super.key, this.initialHasData = true});

  @override
  State<GoalsListScreen> createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  late bool _hasData;
  int _activeFilter = 0; // 0: Active, 1: Completed, 2: Overdue, 3: All
  final List<String> _filters = ['Active', 'Completed', 'Overdue', 'All'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hasData = widget.initialHasData;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleData() {
    setState(() {
      _hasData = !_hasData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              GestureDetector(
                onDoubleTap: _toggleData, // double tap to toggle state
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'GOALS',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.05,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your Goals',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track everything you\'re working towards...',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              if (_hasData) ..._buildPopulatedState() else ..._buildEmptyState(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2e6b57), // primary container
        child: const Icon(Icons.add, color: AppColors.primaryTextOffWhite),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateGoalScreen()));
        },
      ),
    );
  }

  List<Widget> _buildPopulatedState() {
    return [
      _buildDogSelector(),
      const SizedBox(height: 16),
      _buildSummaryStrip(),
      const SizedBox(height: 24),
      _buildSearchBar(),
      const SizedBox(height: 16),
      _buildFilterPills(),
      const SizedBox(height: 24),
      const Text(
        'Active Goals',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 12),
      _buildGoalCardProgress(
        title: 'Complete 20 Recall Sessions',
        subtitle: 'Training • Target: Dec 31',
        current: 14,
        total: 20,
      ),
      const SizedBox(height: 12),
      _buildGoalCardCheckable(
        title: 'Pass BH',
        subtitle: 'Competition • Target: Spring 2024',
      ),
      const SizedBox(height: 12),
      _buildGoalCardOverdue(
        title: 'Record Weight Every Month',
        subtitle: 'Overdue by 5 days',
      ),
      const SizedBox(height: 12),
      _buildGoalCardQualitative(
        title: 'Improve Confidence Around Livestock',
        subtitle: 'Behavior • Ongoing',
      ),
      const SizedBox(height: 32),
      const Text(
        'Categories',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 12),
      _buildCategories(),
      const SizedBox(height: 100),
    ];
  }

  List<Widget> _buildEmptyState() {
    return [
      _buildDogSelector(),
      const SizedBox(height: 24),
      // Empty state stats (0, 0, 0)
      Row(
        children: [
          Expanded(child: _buildStatBox('SESSIONS', '0')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatBox('HOURS', '0')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatBox('STREAK', '0')),
        ],
      ),
      const SizedBox(height: 48),
      Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardsCarbon,
            border: Border.all(color: Colors.white12),
          ),
          child: const Icon(Icons.track_changes, color: AppColors.secondaryTextStoneGrey, size: 32),
        ),
      ),
      const SizedBox(height: 24),
      const Text(
        'Start Working Towards Your\nNext Achievement',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Create goals for training, health, and\ncompetition to track your progress.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 14,
          height: 1.4,
        ),
      ),
      const SizedBox(height: 32),
      ElevatedButton(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateGoalScreen()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2e6b57),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Create Your First Goal →',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      const SizedBox(height: 100),
    ];
  }

  Widget _buildDogSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2e6b57), width: 2),
              image: const DecorationImage(
                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBH5yvhXffjB1E_ttLWsU8bwi8L8Kv2cVB1QPBC-GRHKRGCnoMNHW-Dxq6eUDnXqo_eYsy6qshRRe_LgPzaVNta-g6Bfygs4uoA8h72Ns65qNXPlquOAo-1Mu7rx2HTXWodZqGMh_-rtc1RPijuoz_oxLiZlMFTONoKqq3hucCj40EJNr_Ih2UPf-NZTAgJAzd2e001sX1u1nqDIxl8zLWQ8wbdabBvVPHo60OSKeGacvcYcsNSnts'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_hasData ? 'Nova' : 'Atlas', style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
              Text(_hasData ? 'Belgian Malinois' : 'Malinois • 3y 2m', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
               AppSnackbar.show(context, message: 'Switch dog coming soon', type: SnackbarType.info);
            },
            child: const Text('Switch Dog', style: TextStyle(color: Color(0xFF95d3bb), fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStrip() {
    return Row(
      children: [
        Expanded(child: _buildSummaryBox('7', 'Active Goals', const Color(0xFF95d3bb))),
        const SizedBox(width: 8),
        Expanded(child: _buildSummaryBox('12', 'Completed', AppColors.primaryTextOffWhite)),
        const SizedBox(width: 8),
        Expanded(child: _buildSummaryBox('2', 'Overdue', const Color(0xFFffb4ab))),
      ],
    );
  }

  Widget _buildSummaryBox(String count, String label, Color countColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(count, style: TextStyle(color: countColor, fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 24, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search goals...',
          hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14), // center vertical align
        ),
      ),
    );
  }

  Widget _buildFilterPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: _filters.asMap().entries.map((entry) {
          final idx = entry.key;
          final label = entry.value;
          final isActive = _activeFilter == idx;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = idx),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF2e6b57) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isActive ? const Color(0xFF2e6b57) : Colors.white12),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGoalCardProgress({required String title, required String subtitle, required int current, required int total}) {
    final double percentage = total > 0 ? (current / total) : 0;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => GoalDetailsScreen(
          title: title,
          current: current,
          total: total,
        )));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: AppColors.secondaryTextStoneGrey, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$current/$total', style: const TextStyle(color: Color(0xFF95d3bb), fontSize: 12)),
              Text('${(percentage * 100).toInt()}%', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedProgressBar(
            value: percentage,
            height: 4,
            backgroundColor: const Color(0xFF323533),
            color: const Color(0xFF2e6b57),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildGoalCardCheckable({required String title, required String subtitle}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => GoalDetailsScreen(
          title: title,
        )));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
               AppSnackbar.show(context, message: 'Goal marked as complete', type: SnackbarType.success);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(Icons.check, color: AppColors.secondaryTextStoneGrey, size: 16),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildGoalCardOverdue({required String title, required String subtitle}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => GoalDetailsScreen(
          title: title,
        )));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: const Color(0xFFffb4ab).withOpacity(0.3)), // error tinted border
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFffb4ab), // error
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Color(0xFFffb4ab), size: 14),
                    const SizedBox(width: 4),
                    Text(subtitle, style: const TextStyle(color: Color(0xFFffb4ab), fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
               AppSnackbar.show(context, message: 'Goal marked as complete', type: SnackbarType.success);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(Icons.check, color: AppColors.secondaryTextStoneGrey, size: 16),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildGoalCardQualitative({required String title, required String subtitle}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => GoalDetailsScreen(
          title: title,
        )));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 20),
        ],
      ),
      ),
    );
  }

  Widget _buildCategories() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildCategoryChip(Icons.school_outlined, 'Training', 8),
        _buildCategoryChip(Icons.favorite_border, 'Health', 3),
        _buildCategoryChip(Icons.emoji_events_outlined, 'Sport', 4),
      ],
    );
  }

  Widget _buildCategoryChip(IconData icon, String label, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.secondaryTextStoneGrey, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
          const SizedBox(width: 8),
          Text('$count', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
        ],
      ),
    );
  }
}
