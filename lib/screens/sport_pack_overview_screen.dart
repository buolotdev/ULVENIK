import 'package:flutter/material.dart';
import 'my_sports_screen.dart';
import 'sport_details_igp_screen.dart';
import 'create_sport_screen.dart';
import 'competitions_overview_screen.dart';
import 'competition_details_screen.dart';
import 'qualifications_titles_awards_screen.dart';
import 'add_competition_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class SportPackOverviewScreen extends StatelessWidget {
  const SportPackOverviewScreen({super.key});

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
          'Sports',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MySportsScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: _offWhite),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateSportScreen()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCompetitionScreen()));
        },
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // ACTIVE DOG
          const Text(
            'ACTIVE DOG',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFF242A2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Icon(Icons.pets, color: _mint, size: 20)),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Zeus', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('Belgian Malinois', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // SPORT SUMMARY
          const Text(
            'SPORT SUMMARY',
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
                    _buildSummaryMetric('3', 'Total Sports'),
                    _buildSummaryMetric('42', 'Sport Skills'),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildSummaryMetric('286', 'Training Sessions'),
                    _buildSummaryMetric('2', 'Upcoming Competitions'),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildSummaryMetric('9', 'Competitions Completed'),
                    _buildSummaryMetric('7', 'Qualifications'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MY SPORTS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MY SPORTS',
                style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MySportsScreen()));
                },
                child: const Text('View All', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // IGP Card
          _buildSportCard(
            context,
            name: 'IGP',
            org: 'Organisation: SV',
            details: '18 Skills • 286 Sessions • 7 Competitions • Last: Yesterday',
            next: 'Next: 18 Sep 2026',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SportDetailsIgpScreen()));
            },
          ),
          const SizedBox(height: 12),

          // Agility Card
          _buildSportCard(
            context,
            name: 'Agility',
            org: 'No organisation',
            details: '12 Skills • 146 Sessions • 4 Competitions • Last: 3 days ago',
            next: null,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SportDetailsIgpScreen()));
            },
          ),
          const SizedBox(height: 12),

          // PSA Card
          _buildSportCard(
            context,
            name: 'PSA',
            org: 'Organisation: PSA UK',
            details: '8 Skills • 54 Sessions • 0 Competitions • Last: 2 weeks ago',
            next: null,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SportDetailsIgpScreen()));
            },
          ),
          const SizedBox(height: 24),

          // UPCOMING COMPETITIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'UPCOMING COMPETITIONS',
                style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CompetitionsOverviewScreen()));
                },
                child: const Text('View All', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          _buildCompetitionTile(
            stripeColor: _forest,
            title: 'Essex Working Dog Trial',
            sport: 'IGP',
            details: '18 Sep 2026 • Essex, UK',
            status: 'Entered',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CompetitionDetailsScreen()));
            },
          ),
          const SizedBox(height: 10),

          _buildCompetitionTile(
            stripeColor: const Color(0xFFC4883A),
            title: 'Club Trial — Autumn 2026',
            sport: 'IGP',
            details: '12 Oct 2026 • Location TBC',
            status: 'Planned',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CompetitionDetailsScreen()));
            },
          ),
          const SizedBox(height: 24),

          // RECENT ACTIVITY
          const Text(
            'RECENT ACTIVITY',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildActivityRow(Icons.emoji_events_outlined, 'IGP 1 Qualification recorded', 'IGP', '2 days ago'),
                const Divider(color: _cardBorder, height: 1),
                _buildActivityRow(Icons.fitness_center_outlined, 'Advanced Tracking — session', 'IGP', 'Yesterday'),
                const Divider(color: _cardBorder, height: 1),
                _buildActivityRow(Icons.add, 'Competition added', 'IGP', '3 days ago'),
                const Divider(color: _cardBorder, height: 1),
                _buildActivityRow(Icons.star_outline, 'Agility Weave Poles skill', 'Agility', '1 week ago'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // QUALIFICATIONS & AWARDS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'QUALIFICATIONS & AWARDS',
                style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const QualificationsTitlesAwardsScreen()));
                },
                child: const Text('View All', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          _buildAwardCard(
            icon: Icons.emoji_events_outlined,
            title: 'IGP 1',
            subtitle: 'Qualification • IGP • 15 Sep 2026 • SV',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const QualificationsTitlesAwardsScreen()));
            },
          ),
          const SizedBox(height: 10),

          _buildAwardCard(
            icon: Icons.star_outline,
            title: 'Best Protection Work',
            subtitle: 'Award • IGP • 15 Sep 2026',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const QualificationsTitlesAwardsScreen()));
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric(String val, String label) {
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

  Widget _buildSportCard(
    BuildContext context, {
    required String name,
    required String org,
    required String details,
    required String? next,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242A2E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(name, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(org, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
            const SizedBox(height: 12),
            Text(details, style: const TextStyle(color: _stoneGrey, fontSize: 12, height: 1.3)),
            if (next != null) ...[
              const SizedBox(height: 12),
              const Divider(color: _cardBorder),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: _stoneGrey, size: 14),
                  const SizedBox(width: 8),
                  Text(next, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitionTile({
    required Color stripeColor,
    required String title,
    required String sport,
    required String details,
    required String status,
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
                        Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF242A2E),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(sport, style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Text(details, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242A2E),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(status, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityRow(IconData icon, String title, String sport, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: _stoneGrey, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(color: _offWhite, fontSize: 12)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF242A2E),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(sport, style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Text(date, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildAwardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF242A2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: _stoneGrey, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }
}
