import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class DocumentViewerScreen extends StatefulWidget {
  final String title;
  final String documentType;

  const DocumentViewerScreen({
    super.key,
    this.title = 'Koda_OFA_Hips_Certificate.pdf',
    this.documentType = 'Veterinary Orthopedic Certificate',
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  bool _isFavorite = false;

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
        title: Text(
          widget.title,
          style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: _offWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // DOCUMENT PREVIEW CANVAS
          Container(
            height: 240,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.description_outlined, color: _mint, size: 54),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.documentType,
                        style: const TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF242A2E),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('PDF • 1.8 MB', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // METADATA CARD
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
                        'Veterinary Health Certificate',
                        style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildMetaCol('DATE', '10 Jul 2026')),
                          Expanded(child: _buildMetaCol('DOG', 'Koda')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildMetaCol('PAGES', '3 Pages')),
                          Expanded(child: _buildMetaCol('CATEGORY', 'Health Record')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: _cardBorder),
                      const SizedBox(height: 8),
                      const Text(
                        'OFA Official Rating: Excellent • Clear',
                        style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ACTION BUTTONS BAR
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionBtn(
                        icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                        label: 'Favourite',
                        color: _isFavorite ? const Color(0xFFECC94B) : _stoneGrey,
                        onTap: () => setState(() => _isFavorite = !_isFavorite),
                      ),
                      _buildActionBtn(icon: Icons.share_outlined, label: 'Share', color: _stoneGrey, onTap: () {}),
                      _buildActionBtn(icon: Icons.download_outlined, label: 'Download', color: _stoneGrey, onTap: () {}),
                      _buildActionBtn(icon: Icons.print_outlined, label: 'Print', color: _stoneGrey, onTap: () {}),
                      _buildActionBtn(icon: Icons.delete_outline, label: 'Delete', color: _stoneGrey, onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // LINKED RECORD
                const Text(
                  'LINKED RECORD',
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
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_outline, color: Color(0xFFE5484D), size: 22),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Orthopedic Evaluation — 10 Jul 2026',
                              style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text('Riverside Veterinary Clinic • Dr. Sarah Jenkins', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
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
                    'Full radiographic survey completed. Hips and elbows evaluated according to FCI/OFA standards. No evidence of dysplasia or osteoarthritis detected. Dog cleared for high-drive IGP tracking and protection training.',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }
}
