import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);

class SectionScore {
  String name;
  double score;
  double maxScore;
  String notes;

  SectionScore({
    required this.name,
    required this.score,
    required this.maxScore,
    required this.notes,
  });
}

class JudgeFeedback {
  String name;
  String comments;

  JudgeFeedback({
    required this.name,
    required this.comments,
  });
}

class CompetitionResultsScreen extends StatefulWidget {
  final String title;

  const CompetitionResultsScreen({
    super.key,
    this.title = 'Regional Agility Trial 2026',
  });

  @override
  State<CompetitionResultsScreen> createState() =>
      _CompetitionResultsScreenState();
}

class _CompetitionResultsScreenState extends State<CompetitionResultsScreen> {
  String _outcome = 'Passed';
  String _qualificationStatus = 'Qualified';
  bool _isPersonalBest = true;

  final TextEditingController _overallRankController =
      TextEditingController(text: '1st');
  final TextEditingController _classRankController =
      TextEditingController(text: '1st / 18');
  final TextEditingController _teamRankController =
      TextEditingController(text: 'Optional');

  final TextEditingController _totalScoreController =
      TextEditingController(text: '92.40');
  final TextEditingController _maxScoreController =
      TextEditingController(text: '100.00');

  final TextEditingController _faultPointsController =
      TextEditingController(text: '0');
  final TextEditingController _penaltyPointsController =
      TextEditingController(text: '0');
  final TextEditingController _timeFaultsController =
      TextEditingController(text: '0.00 sec');
  final TextEditingController _eliminationsController =
      TextEditingController(text: 'Optional');

  final TextEditingController _notesController = TextEditingController(
    text:
        'Arya was calm and focused at the start line. Slight distraction on entry to weaves — work on this in next session. Great improvement vs last trial.',
  );

  final List<SectionScore> _sections = [
    SectionScore(
      name: 'Agility Round 1',
      score: 47.2,
      maxScore: 50.0,
      notes: 'Fast pace, clean contact on A-frame',
    ),
    SectionScore(
      name: 'Agility Round 2',
      score: 45.2,
      maxScore: 50.0,
      notes: 'Minor hesitation at weave entry #7',
    ),
  ];

  final List<String> _awards = [
    '🥇 First Place',
    '🎯 Qualification Certificate',
    '⭐ High in Trial',
  ];

  final List<JudgeFeedback> _judges = [
    JudgeFeedback(
      name: 'H. Andersen',
      comments:
          'Excellent focus throughout. Minor hesitation on obstacle 7. Strong finish.',
    ),
  ];

  @override
  void dispose() {
    _overallRankController.dispose();
    _classRankController.dispose();
    _teamRankController.dispose();
    _totalScoreController.dispose();
    _maxScoreController.dispose();
    _faultPointsController.dispose();
    _penaltyPointsController.dispose();
    _timeFaultsController.dispose();
    _eliminationsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addSection() {
    setState(() {
      _sections.add(
        SectionScore(
          name: 'Section ${_sections.length + 1}',
          score: 0.0,
          maxScore: 50.0,
          notes: '',
        ),
      );
    });
  }

  void _addAwardDialog() {
    final textCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        title: const Text('Add Award', style: TextStyle(color: _offWhite)),
        content: TextField(
          controller: textCtrl,
          style: const TextStyle(color: _offWhite),
          decoration: const InputDecoration(
            hintText: 'e.g. Best in Show, High in Agility',
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
              if (textCtrl.text.trim().isNotEmpty) {
                setState(() => _awards.add(textCtrl.text.trim()));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  void _addJudgeDialog() {
    final nameCtrl = TextEditingController();
    final commCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        title: const Text('Add Judge Feedback', style: TextStyle(color: _offWhite)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: _offWhite),
              decoration: const InputDecoration(
                labelText: 'Judge Name',
                labelStyle: TextStyle(color: _stoneGrey),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: commCtrl,
              style: const TextStyle(color: _offWhite),
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Comments',
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
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _judges.add(
                    JudgeFeedback(
                      name: nameCtrl.text.trim(),
                      comments: commCtrl.text.trim(),
                    ),
                  );
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  void _saveResults() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Competition results saved successfully.'),
        backgroundColor: _forest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const outcomes = ['Passed', 'Failed', 'Withdrawn', 'Eliminated', 'Disqualified', 'Retired'];
    const statuses = ['Qualified', 'Not Qualified', 'Pending'];

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Competition Results',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveResults,
            child: const Text(
              'Save',
              style: TextStyle(
                color: _stoneGrey,
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
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.calendar_today_outlined, size: 14, color: _stoneGrey),
                        SizedBox(width: 6),
                        Text(
                          '29 July 2026',
                          style: TextStyle(color: _stoneGrey, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text(
                          '92.4',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'pts',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.circle, color: _gold, size: 10),
                        SizedBox(width: 6),
                        Text(
                          '1st Place',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0x1F34D399),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x4D34D399)),
                      ),
                      child: const Text(
                        'QUALIFIED',
                        style: TextStyle(
                          color: Color(0xFF34D399),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'OVERALL RESULT',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Overall Result Card
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
                    const Text(
                      'Competition Outcome',
                      style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: outcomes.map((o) {
                        final isSel = _outcome == o;
                        return InkWell(
                          onTap: () => setState(() => _outcome = o),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF14241E) : const Color(0xFF14171A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSel ? const Color(0xFF34D399) : _cardBorder,
                              ),
                            ),
                            child: Text(
                              o,
                              style: TextStyle(
                                color: isSel ? const Color(0xFF34D399) : _stoneGrey,
                                fontSize: 13,
                                fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Qualification Status',
                      style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: statuses.map((s) {
                        final isSel = _qualificationStatus == s;
                        return InkWell(
                          onTap: () => setState(() => _qualificationStatus = s),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF14241E) : const Color(0xFF14171A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSel ? const Color(0xFF34D399) : _cardBorder,
                              ),
                            ),
                            child: Text(
                              s,
                              style: TextStyle(
                                color: isSel ? const Color(0xFF34D399) : _stoneGrey,
                                fontSize: 13,
                                fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Placing & Ranks',
                      style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('OVERALL', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _overallRankController,
                                style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('CLASS', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _classRankController,
                                style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('TEAM', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _teamRankController,
                                style: const TextStyle(color: _stoneGrey, fontSize: 15, fontWeight: FontWeight.w500),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'SCORES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Scores Card
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
                    Row(
                      children: [
                        const Text('#', style: TextStyle(color: _stoneGrey, fontSize: 16)),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Total Score', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _totalScoreController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text('#', style: TextStyle(color: _stoneGrey, fontSize: 16)),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Maximum Score', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _maxScoreController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: const [
                        Text('#', style: TextStyle(color: _stoneGrey, fontSize: 16)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text('Percentage', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                        Text(
                          '92.4%',
                          style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Calculated automatically from Total + Maximum Score',
                      style: TextStyle(color: _stoneGrey, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                    const Divider(color: _cardBorder, height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.workspace_premium_outlined, color: _mint, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Personal Best',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Arya's personal best will be updated automatically.",
                                style: TextStyle(color: _stoneGrey, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isPersonalBest,
                          activeThumbColor: _mint,
                          activeTrackColor: _forest,
                          inactiveThumbColor: _stoneGrey,
                          inactiveTrackColor: const Color(0xFF262C30),
                          onChanged: (val) => setState(() => _isPersonalBest = val),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'SECTION SCORES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Add individual section scores for each part of the competition. Section names are fully customisable.',
                style: TextStyle(color: _stoneGrey, fontSize: 12),
              ),
              const SizedBox(height: 12),

              // Section Score Cards
              ..._sections.asMap().entries.map((entry) {
                final idx = entry.key;
                final sec = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                          const Text(
                            'SECTION NAME',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: _stoneGrey, size: 16),
                            onPressed: () {
                              setState(() => _sections.removeAt(idx));
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: sec.name,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                        ),
                        onChanged: (v) => sec.name = v,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('SCORE', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                                TextFormField(
                                  initialValue: sec.score.toString(),
                                  style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                                  ),
                                  onChanged: (v) => sec.score = double.tryParse(v) ?? 0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('MAX', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                                TextFormField(
                                  initialValue: sec.maxScore.toStringAsFixed(0),
                                  style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                                  ),
                                  onChanged: (v) => sec.maxScore = double.tryParse(v) ?? 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text('NOTES', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                      TextFormField(
                        initialValue: sec.notes,
                        style: const TextStyle(color: _stoneGrey, fontSize: 13),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                        ),
                        onChanged: (v) => sec.notes = v,
                      ),
                    ],
                  ),
                );
              }),

              // Add Section Score dashed button
              InkWell(
                onTap: _addSection,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14171A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: _mint, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Add Section Score',
                        style: TextStyle(color: _mint, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'FAULTS & PENALTIES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Faults & Penalties Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text('Fault Points', style: TextStyle(color: _offWhite, fontSize: 14))),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _faultPointsController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: _offWhite, fontSize: 14),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(child: Text('Penalty Points', style: TextStyle(color: _offWhite, fontSize: 14))),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _penaltyPointsController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: _offWhite, fontSize: 14),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 16, color: _stoneGrey),
                        const SizedBox(width: 6),
                        const Expanded(child: Text('Time Faults', style: TextStyle(color: _offWhite, fontSize: 14))),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _timeFaultsController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: _offWhite, fontSize: 14),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.close, size: 16, color: _stoneGrey),
                        const SizedBox(width: 6),
                        const Expanded(child: Text('Eliminations', style: TextStyle(color: _offWhite, fontSize: 14))),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _eliminationsController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: _stoneGrey, fontSize: 14),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'All fields optional.',
                style: TextStyle(color: _stoneGrey, fontSize: 11, fontStyle: FontStyle.italic),
              ),

              const SizedBox(height: 24),
              const Text(
                'AWARDS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Awards Card
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _awards.map((a) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF14171A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(a, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () => setState(() => _awards.remove(a)),
                                child: const Icon(Icons.close, size: 14, color: _stoneGrey),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: _addAwardDialog,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, color: _mint, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Add Award',
                            style: TextStyle(color: _mint, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'JUDGE FEEDBACK',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Judge Feedback
              ..._judges.asMap().entries.map((entry) {
                final idx = entry.key;
                final judge = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                          const Text('JUDGE NAME', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                          IconButton(
                            icon: const Icon(Icons.close, color: _stoneGrey, size: 16),
                            onPressed: () => setState(() => _judges.removeAt(idx)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      Text(judge.name, style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      const Text('COMMENTS', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(
                        judge.comments,
                        style: const TextStyle(color: _offWhite, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                );
              }),
              InkWell(
                onTap: _addJudgeDialog,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: const [
                      Icon(Icons.add, color: _mint, size: 18),
                      SizedBox(width: 6),
                      Text('Add Judge', style: TextStyle(color: _mint, fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'NOTES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Notes Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      style: const TextStyle(color: _offWhite, fontSize: 14, height: 1.4),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 24),
                    const Text('164 / 2000', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
              ),

              const SizedBox(height: 24),
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
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: [
                    _buildAttachmentRow(Icons.description_outlined, 'Score Sheets', 'PDF, DOC'),
                    const Divider(color: _cardBorder, height: 1),
                    _buildAttachmentRow(Icons.assignment_turned_in_outlined, 'Certificates', 'PDF, JPG'),
                    const Divider(color: _cardBorder, height: 1),
                    _buildAttachmentRow(Icons.photo_camera_outlined, 'Photos', 'JPG, PNG, HEIC'),
                    const Divider(color: _cardBorder, height: 1),
                    _buildAttachmentRow(Icons.videocam_outlined, 'Videos', 'MP4, MOV'),
                    const Divider(color: _cardBorder, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          _buildThumb('PDF\nScores'),
                          const SizedBox(width: 10),
                          _buildThumb('PDF\nCert.'),
                          const SizedBox(width: 10),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFF14241E),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _cardBorder),
                            ),
                            child: const Icon(Icons.image, color: _mint, size: 28),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Save Results Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveResults,
                  child: const Text(
                    'Save Results',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentRow(IconData icon, String title, String subtitle) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attach $title tapped'), backgroundColor: _forest),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildThumb(String text) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF14171A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _cardBorder),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
