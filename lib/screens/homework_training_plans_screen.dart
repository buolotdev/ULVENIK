import 'package:flutter/material.dart';
import 'homework_details_screen.dart';

/// Screen: Homework & Training Plans (Node / frame homework_training_plans.png)
/// Comprehensive trainer hub for managing, reviewing, and assigning client homework
/// with tab filters, review queue, progress bars, and overdue statuses.
class HomeworkTrainingPlansScreen extends StatefulWidget {
  final String initialTab;

  const HomeworkTrainingPlansScreen({
    super.key,
    this.initialTab = 'Awaiting Review',
  });

  @override
  State<HomeworkTrainingPlansScreen> createState() => _HomeworkTrainingPlansScreenState();
}

class _HomeworkTrainingPlansScreenState extends State<HomeworkTrainingPlansScreen> {
  // Brand tokens
  static const Color _obsidian = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _cardBorder = Color(0x1FFFFFFF);
  static const Color _errorRed = Color(0xFFE5484D);

  late String _selectedTab;
  final List<String> _tabs = ['All', 'Awaiting Review', 'In Progress', 'Overdue', 'Completed'];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  void _showNewHomeworkSheet() {
    final titleController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assign New Homework', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              style: const TextStyle(color: _offWhite),
              decoration: InputDecoration(
                labelText: 'Assignment Title',
                labelStyle: const TextStyle(color: _stoneGrey),
                hintText: 'e.g. Foundation Recall 3x Daily',
                hintStyle: const TextStyle(color: _stoneGrey),
                filled: true,
                fillColor: _obsidian,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _cardBorder)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Homework plan assigned successfully'), backgroundColor: _forest),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Assign Homework'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Homework',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: _offWhite),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter homework...'), backgroundColor: _forest),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: _offWhite),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sort homework...'), backgroundColor: _forest),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _showNewHomeworkSheet,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── TABS ROW ───────────────────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _tabs.map((tab) {
                  final isSelected = _selectedTab == tab;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = tab),
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? _mint : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: isSelected ? _mint : _stoneGrey,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // ─── 4-METRIC STRIP CARD ────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                children: [
                  Expanded(child: _buildMetricCol('3', 'Awaiting\nReview', _mint)),
                  _buildDivider(),
                  Expanded(child: _buildMetricCol('6', 'In Progress', _offWhite)),
                  _buildDivider(),
                  Expanded(child: _buildMetricCol('2', 'Overdue', _errorRed)),
                  _buildDivider(),
                  Expanded(child: _buildMetricCol('18', 'Completed', _offWhite)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── SECTION: AWAITING REVIEW ───────────────────────────────────
            if (_selectedTab == 'All' || _selectedTab == 'Awaiting Review') ...[
              const Text(
                'AWAITING REVIEW',
                style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              _buildReviewCard(
                title: 'Recall Foundation Practice',
                subtitle: 'Murphy · Emma Johnson',
                dueText: 'Due Yesterday',
                detailText: '3 sessions completed · Video uploaded',
                detailIcon: Icons.videocam_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeworkDetailsScreen(
                      title: 'Recall Foundation Practice',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildReviewCard(
                title: 'Loose Lead Consistency',
                subtitle: 'Bella · James Harlow',
                dueText: 'Due 2 days ago',
                detailText: '5 sessions completed · Notes added',
                detailIcon: Icons.description_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeworkDetailsScreen(
                      title: 'Loose Lead Consistency',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ─── SECTION: IN PROGRESS ───────────────────────────────────────
            if (_selectedTab == 'All' || _selectedTab == 'In Progress') ...[
              const Text(
                'IN PROGRESS',
                style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              _buildProgressCard(
                title: 'Place Training Basics',
                meta: 'Murphy · Emma Johnson · Due in 3 days',
                completed: 2,
                total: 5,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeworkDetailsScreen(
                      title: 'Place Training Basics',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildProgressCard(
                title: 'Socialization Walks',
                meta: 'Bella · James Harlow · Due in 5 days',
                completed: 1,
                total: 5,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeworkDetailsScreen(
                      title: 'Socialization Walks',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ─── SECTION: OVERDUE ───────────────────────────────────────────
            if (_selectedTab == 'All' || _selectedTab == 'Overdue') ...[
              const Text(
                'OVERDUE',
                style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              _buildOverdueCard(
                title: 'Impulse Control Exercises',
                client: 'Murphy · Emma Johnson',
                overdueText: '3 days overdue',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeworkDetailsScreen(
                      title: 'Impulse Control Exercises',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCol(String number, String label, Color numColor) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(color: numColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _stoneGrey, fontSize: 11, height: 1.2),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 36,
      color: _cardBorder,
    );
  }

  Widget _buildReviewCard({
    required String title,
    required String subtitle,
    required String dueText,
    required String detailText,
    required IconData detailIcon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assignment_turned_in_outlined, color: _mint, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _forest),
                  ),
                  child: const Text(
                    'AWAITING REVIEW',
                    style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(color: _stoneGrey, fontSize: 13),
                ),
                const SizedBox(width: 8),
                const Text('•', style: TextStyle(color: _stoneGrey)),
                const SizedBox(width: 8),
                const Icon(Icons.access_time, color: _errorRed, size: 13),
                const SizedBox(width: 4),
                Text(
                  dueText,
                  style: const TextStyle(color: _errorRed, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: _cardBorder, height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(detailIcon, color: _stoneGrey, size: 15),
                const SizedBox(width: 6),
                Text(
                  detailText,
                  style: const TextStyle(color: _stoneGrey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String meta,
    required int completed,
    required int total,
    required VoidCallback onTap,
  }) {
    final ratio = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _obsidian,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Text(
                        'IN PROGRESS',
                        style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              meta,
              style: const TextStyle(color: _stoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: _obsidian,
                valueColor: const AlwaysStoppedAnimation<Color>(_mint),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$completed of $total sessions completed',
              style: const TextStyle(color: _stoneGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverdueCard({
    required String title,
    required String client,
    required String overdueText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: _errorRed,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(14)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _errorRed.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: _errorRed),
                                ),
                                child: const Text(
                                  'OVERDUE',
                                  style: TextStyle(color: _errorRed, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            client,
                            style: const TextStyle(color: _stoneGrey, fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          const Text('•', style: TextStyle(color: _stoneGrey)),
                          const SizedBox(width: 8),
                          Text(
                            overdueText,
                            style: const TextStyle(color: _errorRed, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
