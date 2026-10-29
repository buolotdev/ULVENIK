import 'package:flutter/material.dart';
import 'competition_details_screen.dart';
import 'add_competition_screen.dart';
import 'qualifications_titles_awards_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _crimson = Color(0xFFE5484D);

class SportDetailsIgpScreen extends StatelessWidget {
  const SportDetailsIgpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sport Details',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: _offWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // HERO CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFF242A2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('IGP', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('IGP', style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('SV • IGP 2', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _forest.withValues(alpha: 0.5)),
                  ),
                  child: const Text('Active', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // OVERVIEW
          const Text(
            'OVERVIEW',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Created', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                    Text('March 2024', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: _cardBorder),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildOverviewCol('18', 'Skills'),
                    _buildOverviewCol('54', 'Exercises'),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: _cardBorder),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildOverviewCol('286', 'Sessions'),
                    _buildOverviewCol('7', 'Competitions'),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: _cardBorder),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildOverviewCol('4', 'Qualifications'),
                    _buildOverviewCol('2', 'Awards'),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: _cardBorder),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Last Activity', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                    Text('Yesterday', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // SKILLS
          const Text(
            'SKILLS',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildSkillRow('Heelwork', '8 Exercises • 46 Sessions • Last: 2 days ago'),
                const Divider(color: _cardBorder, height: 1),
                _buildSkillRow('Retrieve', '6 Exercises • 38 Sessions • Last: Yesterday'),
                const Divider(color: _cardBorder, height: 1),
                _buildSkillRow('Tracking', '12 Exercises • 64 Sessions • Last: 3 days ago'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('View All 18 Skills →', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),

          // COMPETITIONS
          const Text(
            'COMPETITIONS',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          _buildCompItem(
            stripeColor: _forest,
            title: 'Essex Working Dog Trial',
            status: 'Upcoming',
            details: '18 Sep 2026 • Essex',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CompetitionDetailsScreen()));
            },
          ),
          const SizedBox(height: 10),
          _buildCompItem(
            stripeColor: const Color(0xFF384347),
            title: 'Club Trial — Spring 2026',
            status: 'Completed',
            details: '15 Apr 2026 • Norwich',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CompetitionDetailsScreen()));
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('View All 7 Competitions →', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),

          // QUALIFICATIONS & AWARDS
          const Text(
            'QUALIFICATIONS & AWARDS',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildAwardTile('IGP 1', 'IGP', '15 Sep 2026'),
                const Divider(color: _cardBorder, height: 1),
                _buildAwardTile('Best Protection', 'IGP', '15 Sep 2026'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // STATISTICS
          const Text(
            'STATISTICS',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildStatBento('286', 'Training Sessions'),
                    _buildStatBento('142h', 'Training Hours'),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatBento('7', 'Competitions'),
                    _buildStatBento('4', 'Qualifications'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // NOTES
          const Text(
            'NOTES',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: const Text(
              'Tracking phase begins October. Need to source new tracking articles. Judge feedback from Sep trial: strong heelwork, loose tracking start.',
              style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
            ),
          ),
          const SizedBox(height: 24),

          // QUICK ACTIONS
          const Text(
            'QUICK ACTIONS',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildActionRow(Icons.near_me_outlined, 'Create Skill', () {}),
                const Divider(color: _cardBorder, height: 1),
                _buildActionRow(Icons.calendar_today_outlined, 'Record Training Session', () {}),
                const Divider(color: _cardBorder, height: 1),
                _buildActionRow(Icons.emoji_events_outlined, 'Add Competition', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCompetitionScreen()));
                }),
                const Divider(color: _cardBorder, height: 1),
                _buildActionRow(Icons.star_outline, 'Add Qualification or Award', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const QualificationsTitlesAwardsScreen()));
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MORE OPTIONS
          const Text(
            'MORE OPTIONS',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildOptionRow('Edit Sport', _offWhite, () {}),
                const Divider(color: _cardBorder, height: 1),
                _buildOptionRow('Archive Sport', _offWhite, () {}),
                const Divider(color: _cardBorder, height: 1),
                _buildOptionRow('Delete Sport', _crimson, () {}),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildOverviewCol(String val, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(val, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSkillRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
            ],
          ),
          const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
        ],
      ),
    );
  }

  Widget _buildCompItem({
    required Color stripeColor,
    required String title,
    required String status,
    required String details,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _cardBorder),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 4, color: stripeColor),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF242A2E),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(status, style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(details, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAwardTile(String title, String tag, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_outlined, color: _stoneGrey, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: [
                Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242A2E),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(tag, style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Text(date, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
        ],
      ),
    );
  }

  Widget _buildStatBento(String val, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(val, style: const TextStyle(color: _offWhite, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(child: Text(title, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }
}
