import 'package:flutter/material.dart';
import 'competition_details_screen.dart';
import 'add_competition_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class CompetitionsOverviewScreen extends StatefulWidget {
  const CompetitionsOverviewScreen({super.key});

  @override
  State<CompetitionsOverviewScreen> createState() =>
      _CompetitionsOverviewScreenState();
}

class _CompetitionsOverviewScreenState extends State<CompetitionsOverviewScreen> {
  final List<Map<String, dynamic>> _competitions = [
    {
      'title': 'Essex Working Dog Trial',
      'date': '18 Sep 2026 • Essex, UK',
      'status': 'Upcoming',
      'stripeColor': _forest,
    },
    {
      'title': 'Club Trial — Autumn 2026',
      'date': '12 Oct 2026 • Location TBC',
      'status': 'Planned',
      'stripeColor': const Color(0xFFC4883A),
    },
    {
      'title': 'IGP National 2026',
      'date': '22 Jun 2026 • Munich',
      'status': 'Completed',
      'stripeColor': const Color(0xFF384347),
    },
    {
      'title': 'Club Trial — Spring 2026',
      'date': '15 Apr 2026 • Norwich',
      'status': 'Completed',
      'stripeColor': const Color(0xFF384347),
    },
    {
      'title': 'District Qualifier',
      'date': '8 Mar 2026 • Leeds',
      'status': 'Withdrawn',
      'stripeColor': const Color(0xFFE5484D),
    },
  ];

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
          'Competitions',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: _offWhite),
            onPressed: () {},
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
          // 4-CARD STATUS ROW
          Row(
            children: [
              _buildStatusCard('2', 'Upcoming'),
              const SizedBox(width: 8),
              _buildStatusCard('7', 'Completed'),
              const SizedBox(width: 8),
              _buildStatusCard('1', 'Withdrawn'),
              const SizedBox(width: 8),
              _buildStatusCard('0', 'Cancelled'),
            ],
          ),
          const SizedBox(height: 24),

          // ALL COMPETITIONS
          const Text(
            'ALL COMPETITIONS',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),

          for (final comp in _competitions) ...[
            _buildCompetitionCard(comp),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          children: [
            Text(count, style: const TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitionCard(Map<String, dynamic> comp) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CompetitionDetailsScreen()));
      },
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
                Container(width: 4, color: comp['stripeColor'] as Color),
                const SizedBox(width: 14),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF242A2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('I', style: TextStyle(color: _stoneGrey, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comp['title'] as String,
                          style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(comp['date'] as String, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
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
                  child: Text(
                    comp['status'] as String,
                    style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
