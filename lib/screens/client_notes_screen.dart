import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class NoteItem {
  String category;
  String date;
  String title;
  String body;
  String footer;
  bool isPinned;
  List<String> attachments;

  NoteItem({
    required this.category,
    required this.date,
    required this.title,
    required this.body,
    required this.footer,
    this.isPinned = false,
    this.attachments = const [],
  });
}

class ClientNotesScreen extends StatefulWidget {
  final String clientName;

  const ClientNotesScreen({
    super.key,
    this.clientName = 'Emma Johnson',
  });

  @override
  State<ClientNotesScreen> createState() => _ClientNotesScreenState();
}

class _ClientNotesScreenState extends State<ClientNotesScreen> {
  String _selectedFilter = 'ALL';
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  final List<NoteItem> _notes = [
    NoteItem(
      category: 'TRAINING',
      date: '14 Nov • 09:32',
      title: 'IGP Tracking Routine & High Toy Drive',
      body:
          'Murphy shows exceptional scent drive on damp turf. Prefers early morning sessions before...',
      footer: 'Last edited 16 Nov',
      isPinned: true,
      attachments: ['1 PDF', '2 Photos'],
    ),
    NoteItem(
      category: 'BEHAVIOUR',
      date: '12 Nov • 16:40',
      title: 'Reactivity Assessment with Decoy Handler',
      body:
          'Tested threshold at 25 metres with neutral decoy. Solid engagement and quick recovery to',
      footer: 'Session 4',
      isPinned: false,
      attachments: ['1 Video'],
    ),
    NoteItem(
      category: 'HOMEWORK',
      date: '08 Nov • 11:15',
      title: 'Week 4 Focus & Engagement Homework',
      body:
          'Emma to conduct 2× 5-minute eye contact reps daily prior to mealtime. No tug play in the living',
      footer: 'Last edited 09 Nov',
      isPinned: false,
      attachments: [],
    ),
    NoteItem(
      category: 'HEALTH',
      date: '02 Nov • 14:20',
      title: 'Right Hind Leg Stiffness Post-Agility',
      body:
          'Slight hesitation on A-frame descent. Recommended vet palpation before advancing',
      footer: 'Routine log',
      isPinned: false,
      attachments: [],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addNewNote() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    String category = 'TRAINING';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: _carbon,
          title: const Text('Add Client Note', style: TextStyle(color: _offWhite)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: _offWhite),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: _stoneGrey),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: category,
                isExpanded: true,
                dropdownColor: _carbon,
                items: const [
                  DropdownMenuItem(value: 'TRAINING', child: Text('TRAINING', style: TextStyle(color: _offWhite))),
                  DropdownMenuItem(value: 'BEHAVIOUR', child: Text('BEHAVIOUR', style: TextStyle(color: _offWhite))),
                  DropdownMenuItem(value: 'HOMEWORK', child: Text('HOMEWORK', style: TextStyle(color: _offWhite))),
                  DropdownMenuItem(value: 'HEALTH', child: Text('HEALTH', style: TextStyle(color: _offWhite))),
                ],
                onChanged: (v) {
                  if (v != null) setDlgState(() => category = v);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bodyCtrl,
                maxLines: 3,
                style: const TextStyle(color: _offWhite),
                decoration: const InputDecoration(
                  labelText: 'Note Content',
                  labelStyle: TextStyle(color: _stoneGrey),
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
              style: ElevatedButton.styleFrom(backgroundColor: _forest),
              onPressed: () {
                if (titleCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    _notes.insert(
                      0,
                      NoteItem(
                        category: category,
                        date: 'Just now',
                        title: titleCtrl.text.trim(),
                        body: bodyCtrl.text.trim(),
                        footer: 'Created today',
                      ),
                    );
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add Note', style: TextStyle(color: _offWhite)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _notes.where((n) {
      if (_selectedFilter == 'PINNED' && !n.isPinned) return false;
      if (_selectedFilter == 'TRAINING' && n.category != 'TRAINING') return false;
      if (_selectedFilter == 'BEHAVIOUR' && n.category != 'BEHAVIOUR') return false;
      if (_selectedFilter == 'HEALTH' && n.category != 'HEALTH') return false;
      if (_searchController.text.trim().isNotEmpty) {
        final q = _searchController.text.toLowerCase();
        return n.title.toLowerCase().contains(q) || n.body.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    final pinnedNotes = filteredNotes.where((n) => n.isPinned).toList();
    final otherNotes = filteredNotes.where((n) => !n.isPinned).toList();

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
          'Client Notes',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite, size: 22),
            onPressed: () => setState(() => _showSearch = !_showSearch),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: _offWhite, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: _offWhite, size: 24),
            onPressed: _addNewNote,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _addNewNote,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            if (_showSearch) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: _offWhite, fontSize: 14),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: _stoneGrey, size: 20),
                    suffixIcon: TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _showSearch = false);
                      },
                      child: const Text('Cancel', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],

            // Filter Pills Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['ALL', 'PINNED', 'TRAINING', 'BEHAVIOUR', 'HEALTH'].map((f) {
                  final isSel = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _selectedFilter = f),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFF14241E) : const Color(0xFF14171A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSel ? const Color(0xFF34D399) : _cardBorder),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: isSel ? const Color(0xFF34D399) : _stoneGrey,
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            if (pinnedNotes.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'PINNED',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              ...pinnedNotes.map((note) => _buildNoteCard(note, isPinnedCard: true)),
            ],

            if (otherNotes.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'NOTES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              ...otherNotes.map((note) => _buildNoteCard(note, isPinnedCard: false)),
            ],

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'SWIPE GESTURE PREVIEW',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Swipe left on cards',
                  style: TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Swipe Preview Box
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('26 Oct', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    color: const Color(0xFF1E2B2A),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.visibility_outlined, color: _mint, size: 18),
                        SizedBox(height: 2),
                        Text('VIEW', style: TextStyle(color: _mint, fontSize: 9, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    color: const Color(0xFF183329),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.edit_outlined, color: Color(0xFF34D399), size: 18),
                        SizedBox(height: 2),
                        Text('EDIT', style: TextStyle(color: Color(0xFF34D399), fontSize: 9, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFF342323),
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(14)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.archive_outlined, color: Color(0xFFEF4444), size: 18),
                        SizedBox(height: 2),
                        Text('ARCHIVE', style: TextStyle(color: Color(0xFFEF4444), fontSize: 9, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(NoteItem note, {required bool isPinnedCard}) {
    IconData catIcon = Icons.assignment_outlined;
    if (note.category == 'BEHAVIOUR') catIcon = Icons.lightbulb_outline;
    if (note.category == 'HOMEWORK') catIcon = Icons.check_circle_outline;
    if (note.category == 'HEALTH') catIcon = Icons.favorite_border;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: isPinnedCard
                ? const Border(left: BorderSide(color: Color(0xFF34D399), width: 4))
                : null,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(catIcon, size: 14, color: _stoneGrey),
                  const SizedBox(width: 6),
                  Text(
                    note.category,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const Spacer(),
                  if (note.isPinned) ...[
                    const Icon(Icons.push_pin, size: 12, color: _mint),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    note.date,
                    style: const TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                note.title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                note.body,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const Divider(color: _cardBorder, height: 20),
              Row(
                children: [
                  Text(
                    note.footer,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  ...note.attachments.map((att) {
                    final isPdf = att.contains('PDF');
                    final isPhoto = att.contains('Photos');
                    final isVideo = att.contains('Video');
                    return Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14171A),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isPdf
                                ? Icons.description_outlined
                                : isPhoto
                                    ? Icons.image_outlined
                                    : isVideo
                                        ? Icons.videocam_outlined
                                        : Icons.attach_file,
                            size: 11,
                            color: _stoneGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            att,
                            style: const TextStyle(color: _stoneGrey, fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
