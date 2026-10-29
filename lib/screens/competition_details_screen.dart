import 'package:flutter/material.dart';
import 'record_competition_result_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class CompetitionDetailsScreen extends StatelessWidget {
  final String title;

  const CompetitionDetailsScreen({
    super.key,
    this.title = 'Essex Working Dog Trial',
  });

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
          'Competition Details',
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: _offWhite, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242A2E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('IGP', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    const Text('• 18 September 2026', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _forest.withValues(alpha: 0.5)),
                  ),
                  child: const Text('Upcoming', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 14),
                Row(
                  children: const [
                    Icon(Icons.location_on_outlined, color: _stoneGrey, size: 16),
                    SizedBox(width: 6),
                    Text('Essex, UK', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // COMPETITION INFORMATION
          const Text(
            'COMPETITION INFORMATION',
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
                _buildInfoRow('Date', '18 September 2026'),
                const Divider(color: _cardBorder, height: 1),
                _buildInfoRow('Start Time', '09:00'),
                const Divider(color: _cardBorder, height: 1),
                _buildInfoRow('Organisation', 'SV'),
                const Divider(color: _cardBorder, height: 1),
                _buildInfoRow('Judge', 'Hans Müller'),
                const Divider(color: _cardBorder, height: 1),
                _buildInfoRow('Club', 'South Essex Working Dog Club'),
                const Divider(color: _cardBorder, height: 1),
                _buildInfoRow('Venue', 'Barleyfields Training Ground'),
                const Divider(color: _cardBorder, height: 1),
                _buildInfoRow('Entry Number', '47'),
                const Divider(color: _cardBorder, height: 1),
                _buildInfoRow('Entry Class', 'IGP 2'),
                const Divider(color: _cardBorder, height: 1),
                _buildInfoRow('Handler', 'James Walker'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // RESULT
          const Text(
            'RESULT',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                const Icon(Icons.workspace_premium_outlined, color: _stoneGrey, size: 40),
                const SizedBox(height: 10),
                const Text('No Result Recorded', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordCompetitionResultScreen()));
                    },
                    child: const Text('Record Result', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // QUALIFICATIONS & AWARDS
          const Text(
            'QUALIFICATIONS & AWARDS',
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
            child: const Center(
              child: Text(
                'No qualifications or awards linked to this competition.',
                style: TextStyle(color: _stoneGrey, fontSize: 13),
              ),
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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Entry confirmation received 2 Aug. Travel to Essex the evening before. Take tracking leads and dumbbells. Check tracking field conditions in advance.',
                  style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {},
                    child: const Text('Edit Notes', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ATTACHMENTS
          const Text(
            'ATTACHMENTS',
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
                _buildAttachmentTile('Entry Confirmation.pdf', 'Uploaded 2 Aug 2026'),
                const Divider(color: _cardBorder, height: 1),
                _buildAttachmentTile('Running Order.pdf', 'Uploaded 14 Sep 2026'),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // BOTTOM BUTTONS
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _cardBorder),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  child: const Text('Edit Competition', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordCompetitionResultScreen()));
                  },
                  child: const Text('Record Result', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 13)),
          Text(value, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildAttachmentTile(String name, String uploaded) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: _stoneGrey, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(uploaded, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Text('Open', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
