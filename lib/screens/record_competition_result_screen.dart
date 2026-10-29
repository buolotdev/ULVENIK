import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class RecordCompetitionResultScreen extends StatefulWidget {
  final String trialName;

  const RecordCompetitionResultScreen({
    super.key,
    this.trialName = 'Essex Working Dog Trial',
  });

  @override
  State<RecordCompetitionResultScreen> createState() =>
      _RecordCompetitionResultScreenState();
}

class _RecordCompetitionResultScreenState
    extends State<RecordCompetitionResultScreen> {
  String _resultStatus = 'Completed';
  late final TextEditingController _overallResultController;
  late final TextEditingController _scoreController;
  late final TextEditingController _placementController;
  late final TextEditingController _judgeCommentsController;
  late final TextEditingController _personalNotesController;

  final List<String> _qualifications = ['IGP 1'];
  final List<String> _awards = [];
  final List<Map<String, String>> _attachments = [
    {'name': 'Score Sheet.pdf', 'size': '28 KB'},
  ];

  @override
  void initState() {
    super.initState();
    _overallResultController = TextEditingController(text: 'Excellent');
    _scoreController = TextEditingController(text: '287.5 / 300');
    _placementController = TextEditingController(text: '2nd');
    _judgeCommentsController = TextEditingController(
      text:
          'Excellent heelwork. Tracking start slightly hesitant. Strong retrieve.',
    );
    _personalNotesController = TextEditingController(
      text: 'What went well, areas to improve, weather conditions...',
    );
  }

  @override
  void dispose() {
    _overallResultController.dispose();
    _scoreController.dispose();
    _placementController.dispose();
    _judgeCommentsController.dispose();
    _personalNotesController.dispose();
    super.dispose();
  }

  void _addQualification() {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: _carbon,
          title: const Text('Add Qualification', style: TextStyle(color: _offWhite)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: _offWhite),
            decoration: const InputDecoration(
              hintText: 'e.g. IGP 2, BH-VT',
              hintStyle: TextStyle(color: _stoneGrey),
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
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _qualifications.add(controller.text.trim());
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add', style: TextStyle(color: _offWhite)),
            ),
          ],
        );
      },
    );
  }

  void _addAward() {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: _carbon,
          title: const Text('Add Award', style: TextStyle(color: _offWhite)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: _offWhite),
            decoration: const InputDecoration(
              hintText: 'e.g. High in Trial, Best Protection',
              hintStyle: TextStyle(color: _stoneGrey),
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
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _awards.add(controller.text.trim());
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add', style: TextStyle(color: _offWhite)),
            ),
          ],
        );
      },
    );
  }

  void _saveResult() {
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Result saved: ${_overallResultController.text} (${_scoreController.text}).',
        ),
        backgroundColor: _forest,
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
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        title: const Text(
          'Record Result',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveResult,
            child: const Text(
              'Save',
              style: TextStyle(
                color: _offWhite,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.trialName,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF243447),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'IGP',
                            style: TextStyle(
                              color: Color(0xFF93C5FD),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '18 September 2026',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x1F34D399),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0x4D34D399)),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          color: Color(0xFF34D399),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'RESULT',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Result Section Card
              Container(
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RESULT STATUS *',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14241E),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0x4D34D399)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _resultStatus,
                                isExpanded: true,
                                dropdownColor: _carbon,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: _stoneGrey,
                                ),
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Completed',
                                    child: Text('Completed'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Withdrawn',
                                    child: Text('Withdrawn'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Disqualified',
                                    child: Text('Disqualified'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'In Progress',
                                    child: Text('In Progress'),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _resultStatus = val);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'OVERALL RESULT',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _overallResultController,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SCORE',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _scoreController,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PLACEMENT',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _placementController,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'QUALIFICATIONS & AWARDS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Qualifications & Awards Card
              Container(
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _addQualification,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: _mint, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Add Qualification',
                              style: TextStyle(
                                color: _mint,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_qualifications.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Wrap(
                          spacing: 8,
                          children: _qualifications.map((q) {
                            return Chip(
                              backgroundColor: const Color(0xFF262C30),
                              label: Text(
                                q,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 16,
                                color: _stoneGrey,
                              ),
                              onDeleted: () {
                                setState(() {
                                  _qualifications.remove(q);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    const Divider(color: _cardBorder, height: 1),
                    InkWell(
                      onTap: _addAward,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: _mint, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Add Award',
                              style: TextStyle(
                                color: _mint,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_awards.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Wrap(
                          spacing: 8,
                          children: _awards.map((a) {
                            return Chip(
                              backgroundColor: const Color(0xFF262C30),
                              label: Text(
                                a,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 16,
                                color: _stoneGrey,
                              ),
                              onDeleted: () {
                                setState(() {
                                  _awards.remove(a);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'COMMENTS & NOTES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Comments & Notes Card
              Container(
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "JUDGE'S COMMENTS",
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _judgeCommentsController,
                            maxLines: 3,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 14,
                              height: 1.4,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PERSONAL NOTES',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _personalNotesController,
                            maxLines: 2,
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 14,
                              height: 1.4,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'ATTACHMENTS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Attachments Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _attachments.add({
                            'name': 'Photos_${_attachments.length + 1}.jpg',
                            'size': '1.4 MB',
                          });
                        });
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.attach_file, color: _mint, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Add Attachment',
                            style: TextStyle(
                              color: _mint,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._attachments.map((att) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14171A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.description_outlined,
                              color: _stoneGrey,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    att['name']!,
                                    style: const TextStyle(
                                      color: _offWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    att['size']!,
                                    style: const TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: _stoneGrey,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _attachments.remove(att);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bottom Cancel & Save Result buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C2226),
                        side: const BorderSide(color: _cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveResult,
                      child: const Text(
                        'Save Result',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
