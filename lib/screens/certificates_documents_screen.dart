import 'package:flutter/material.dart';
import 'document_viewer_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class CertificatesDocumentsScreen extends StatefulWidget {
  const CertificatesDocumentsScreen({super.key});

  @override
  State<CertificatesDocumentsScreen> createState() =>
      _CertificatesDocumentsScreenState();
}

class _CertificatesDocumentsScreenState
    extends State<CertificatesDocumentsScreen> {
  String _sort = 'Most Recent';

  final List<Map<String, dynamic>> _docs = [
    {
      'title': 'IGP3 Title Certificate',
      'event': 'National IGP Championship 2024',
      'tag': 'CERTIFICATE',
      'date': '14 Sep 2024',
      'size': '2.4 MB',
      'isImage': false,
    },
    {
      'title': 'Tracking Score Sheet — Round 1',
      'event': 'National IGP Championship 2024',
      'tag': 'SCORE SHEET',
      'date': '14 Sep 2024',
      'size': '890 KB',
      'isImage': false,
    },
    {
      'title': 'Judge Sheet — Protection Phase',
      'event': 'Regional Qualifier 2023',
      'tag': 'JUDGE SHEET',
      'date': '22 Jun 2023',
      'size': '1.1 MB',
      'isImage': true,
    },
    {
      'title': 'Entry Confirmation',
      'event': 'Club Trial 2022',
      'tag': 'ENTRY DOCUMENT',
      'date': '05 Mar 2022',
      'size': '340 KB',
      'isImage': false,
    },
    {
      'title': 'IGP2 Qualification Certificate',
      'event': 'Regional Qualifier 2023',
      'tag': 'CERTIFICATE',
      'date': '22 Jun 2023',
      'size': '1.8 MB',
      'isImage': false,
    },
  ];

  void _uploadDocument() {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        title: const Text('Add Document', style: TextStyle(color: _offWhite)),
        content: TextField(
          controller: titleCtrl,
          style: const TextStyle(color: _offWhite),
          decoration: const InputDecoration(
            labelText: 'Document Title',
            labelStyle: TextStyle(color: _stoneGrey),
          ),
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
                  _docs.insert(0, {
                    'title': titleCtrl.text.trim(),
                    'event': 'Official Canine Document',
                    'tag': 'DOCUMENT',
                    'date': 'Today',
                    'size': '1.2 MB',
                    'isImage': false,
                  });
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Upload', style: TextStyle(color: _offWhite)),
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Certificates & Documents',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: _offWhite, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: _offWhite, size: 24),
            onPressed: _uploadDocument,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _uploadDocument,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Sub-bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_docs.length + 7} Documents',
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sort,
                    dropdownColor: _carbon,
                    icon: const Icon(Icons.keyboard_arrow_down, color: _stoneGrey, size: 18),
                    style: const TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w500),
                    items: const [
                      DropdownMenuItem(value: 'Most Recent', child: Text('Most Recent')),
                      DropdownMenuItem(value: 'Oldest', child: Text('Oldest')),
                      DropdownMenuItem(value: 'Name (A-Z)', child: Text('Name (A-Z)')),
                      DropdownMenuItem(value: 'Size', child: Text('Size')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _sort = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Document Cards
            ..._docs.map((doc) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DocumentViewerScreen(
                        title: doc['title'] as String,
                        documentType: doc['tag'] as String,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF14171A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: doc['isImage'] == true
                            ? const Icon(Icons.image, color: _stoneGrey, size: 24)
                            : const Icon(Icons.description_outlined, color: _stoneGrey, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['title'] as String,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              doc['event'] as String,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF262C30),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    doc['tag'] as String,
                                    style: const TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text('•', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                                const SizedBox(width: 6),
                                Text(
                                  doc['date'] as String,
                                  style: const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              doc['size'] as String,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
