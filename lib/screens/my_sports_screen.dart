import 'package:flutter/material.dart';
import 'sport_details_igp_screen.dart';
import 'create_sport_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class MySportsScreen extends StatefulWidget {
  const MySportsScreen({super.key});

  @override
  State<MySportsScreen> createState() => _MySportsScreenState();
}

class _MySportsScreenState extends State<MySportsScreen> {
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
          'My Sports',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.view_agenda_outlined, color: _offWhite),
            onPressed: () {},
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
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateSportScreen()));
        },
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
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
                    _buildSummaryMetric('3', 'Active Sports'),
                    _buildSummaryMetric('0', 'Archived Sports'),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildSummaryMetric('38', 'Total Skills'),
                    _buildSummaryMetric('486', 'Total Sessions'),
                    _buildSummaryMetric('11', 'Total Competitions'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MY SPORTS
          const Text(
            'MY SPORTS',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),

          // 1. IGP
          _buildSportDetailedCard(
            letter: 'I',
            name: 'IGP',
            badge: 'IGP',
            org: 'Organisation: SV',
            level: 'Level: IGP 2',
            skills: '18',
            exercises: '54',
            sessions: '286',
            competitions: '7',
            lastActive: 'Yesterday',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SportDetailsIgpScreen()));
            },
          ),
          const SizedBox(height: 14),

          // 2. Agility
          _buildSportDetailedCard(
            letter: 'A',
            name: 'Agility',
            badge: 'AGILITY',
            org: 'No organisation',
            level: 'Level: Foundation',
            skills: '12',
            exercises: '28',
            sessions: '146',
            competitions: '4',
            lastActive: '3 days ago',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SportDetailsIgpScreen()));
            },
          ),
          const SizedBox(height: 14),

          // 3. PSA
          _buildSportDetailedCard(
            letter: 'P',
            name: 'PSA',
            badge: 'PSA',
            org: 'Organisation: PSA UK',
            level: 'Level: No level',
            skills: '8',
            exercises: '22',
            sessions: '54',
            competitions: '0',
            lastActive: '2 weeks ago',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SportDetailsIgpScreen()));
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
          Text(val, style: const TextStyle(color: _offWhite, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSportDetailedCard({
    required String letter,
    required String name,
    required String badge,
    required String org,
    required String level,
    required String skills,
    required String exercises,
    required String sessions,
    required String competitions,
    required String lastActive,
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
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFF242A2E),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242A2E),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(badge, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(org, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(level, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
            const SizedBox(height: 16),
            const Divider(color: _cardBorder),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildSubCol(skills, 'Skills'),
                _buildSubCol(exercises, 'Exercises'),
                _buildSubCol(sessions, 'Sessions'),
                _buildSubCol(competitions, 'Competitions'),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: _cardBorder),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: _stoneGrey, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('Last active: $lastActive', style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                ),
                const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCol(String val, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(val, style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10)),
        ],
      ),
    );
  }
}
