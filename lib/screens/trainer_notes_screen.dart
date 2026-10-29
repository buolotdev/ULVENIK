import 'package:flutter/material.dart';

/// Screen: Trainer Notes (Node / frame trainer_notes.png)
/// Confidential private notes ledger for professional trainers,
/// categorized with pinned items, client tags, and privacy enforcement indicators.
class TrainerNotesScreen extends StatefulWidget {
  const TrainerNotesScreen({super.key});

  @override
  State<TrainerNotesScreen> createState() => _TrainerNotesScreenState();
}

class _TrainerNotesScreenState extends State<TrainerNotesScreen> {
  // Brand tokens
  static const Color _obsidian = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _cardBorder = Color(0x1FFFFFFF);

  final TextEditingController _searchController = TextEditingController();

  void _showNewNoteDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Private Trainer Note', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: _offWhite),
              decoration: InputDecoration(
                labelText: 'Note Title',
                labelStyle: const TextStyle(color: _stoneGrey),
                hintText: 'e.g. Session observations',
                hintStyle: const TextStyle(color: _stoneGrey),
                filled: true,
                fillColor: _obsidian,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _cardBorder)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              maxLines: 4,
              style: const TextStyle(color: _offWhite),
              decoration: InputDecoration(
                labelText: 'Confidential Notes',
                labelStyle: const TextStyle(color: _stoneGrey),
                hintText: 'Private observations...',
                hintStyle: const TextStyle(color: _stoneGrey),
                filled: true,
                fillColor: _obsidian,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _cardBorder)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Private trainer note saved'), backgroundColor: _forest),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _forest, foregroundColor: _offWhite),
            child: const Text('Save Note'),
          ),
        ],
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
          'Trainer Notes',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: _offWhite),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter notes...'), backgroundColor: _forest),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _showNewNoteDialog,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── SEARCH INPUT ───────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _cardBorder),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: _stoneGrey, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Search notes, clients, tags...',
                        hintStyle: TextStyle(color: _stoneGrey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── NOTES COUNT ────────────────────────────────────────────────
            const Text(
              '14 Notes',
              style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ─── PRIVACY CALLOUT BANNER ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF131A1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'All notes are private and never shared with clients.',
                      style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─── SECTION: PINNED ────────────────────────────────────────────
            const Text(
              'PINNED',
              style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            _buildPinnedNoteCard(
              categoryPill: 'LESSON PLANNING',
              clientPill: 'Emma Johnson',
              title: 'Pre-lesson checklist — Thursday 10am',
              body: 'Check harness fit before start. Discuss long line options. Murphy showing improvement on...',
              timeText: 'Today',
            ),
            const SizedBox(height: 20),

            // ─── SECTION: RECENT NOTES ──────────────────────────────────────
            const Text(
              'RECENT NOTES',
              style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            _buildNoteCard(
              categoryPill: 'BEHAVIOUR OBSERVATIONS',
              tags: ['Murphy'],
              title: 'Distraction threshold observations',
              body: 'Threshold reducing near joggers. Consider systematic desensitisation...',
              timeText: 'Yesterday',
            ),
            const SizedBox(height: 12),
            _buildNoteCard(
              categoryPill: 'FOLLOW-UP REQUIRED',
              tags: ['James Harlow', 'Bella'],
              isFollowUp: true,
              title: 'Vet referral reminder',
              body: 'Bella limping slightly last session. Recommend James checks with vet before...',
              timeText: '2 days ago',
            ),
            const SizedBox(height: 12),
            _buildNoteCard(
              categoryPill: 'CLIENT COMMUNICATION',
              tags: [],
              title: 'Post-lesson summary call notes',
              body: 'Emma happy with progress. Wants to add agility to future sessions...',
              timeText: '5 days ago',
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedNoteCard({
    required String categoryPill,
    required String clientPill,
    required String title,
    required String body,
    required String timeText,
  }) {
    return Container(
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
                color: _forest,
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
                      children: [
                        const Icon(Icons.flash_on, color: _mint, size: 14),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _obsidian,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: Text(categoryPill, style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF263033),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(clientPill, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.3),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: _cardBorder, height: 1),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.lock_outline, color: _stoneGrey, size: 13),
                            SizedBox(width: 4),
                            Text('Private', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                          ],
                        ),
                        Text(timeText, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard({
    required String categoryPill,
    required List<String> tags,
    bool isFollowUp = false,
    required String title,
    required String body,
    required String timeText,
  }) {
    return Container(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _obsidian,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isFollowUp) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(categoryPill, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ...tags.map((tag) => Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF263033),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(tag, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              )),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.3),
          ),
          const SizedBox(height: 12),
          const Divider(color: _cardBorder, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.lock_outline, color: _stoneGrey, size: 13),
                  SizedBox(width: 4),
                  Text('Private', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                ],
              ),
              Text(timeText, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
