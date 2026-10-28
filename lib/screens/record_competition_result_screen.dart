import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);

class RecordCompetitionResultScreen extends StatefulWidget {
  final String trialName;

  const RecordCompetitionResultScreen({
    super.key,
    this.trialName = 'Pacific Northwest IGP Championship',
  });

  @override
  State<RecordCompetitionResultScreen> createState() =>
      _RecordCompetitionResultScreenState();
}

class _RecordCompetitionResultScreenState
    extends State<RecordCompetitionResultScreen> {
  final _scoreAController = TextEditingController(text: '96');
  final _scoreBController = TextEditingController(text: '92');
  final _scoreCController = TextEditingController(text: '96');
  final _judgeController = TextEditingController(text: 'Dieter Müller');

  String _tsbRating = 'Pronounced (a)';
  String _placement = '1st Place (Gold)';

  @override
  void initState() {
    super.initState();
    _scoreAController.addListener(() => setState(() {}));
    _scoreBController.addListener(() => setState(() {}));
    _scoreCController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scoreAController.dispose();
    _scoreBController.dispose();
    _scoreCController.dispose();
    _judgeController.dispose();
    super.dispose();
  }

  int get _scoreA => int.tryParse(_scoreAController.text.trim()) ?? 0;
  int get _scoreB => int.tryParse(_scoreBController.text.trim()) ?? 0;
  int get _scoreC => int.tryParse(_scoreCController.text.trim()) ?? 0;
  int get _totalScore => _scoreA + _scoreB + _scoreC;

  String get _ratingLabel {
    if (_totalScore >= 286) return 'Vorzüglich (V) • Excellent';
    if (_totalScore >= 270) return 'Sehr Gut (SG) • Very Good';
    if (_totalScore >= 240) return 'Gut (G) • Good';
    if (_totalScore >= 210) return 'Befriedigend (B) • Satisfactory';
    return 'Mangelhaft (M) • Did Not Pass';
  }

  void _saveResult() {
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Official result saved: $_totalScore / 300 pts ($_ratingLabel).'),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. DYNAMIC RESULT BANNER
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('OFFICIAL SCORE SHEET', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('$_totalScore / 300 PTS', style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _ratingLabel,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text('Koda vom Alpenhof • ${widget.trialName}', style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. PHASE POINT INPUTS
          _buildSectionHeader('PHASE SCORES (MAX 100 PTS EACH)'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildScoreBox('Phase A (Track)', _scoreAController),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildScoreBox('Phase B (Obed)', _scoreBController),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildScoreBox('Phase C (Bite)', _scoreCController),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. TSB PROTECTION ASSESSMENT
          _buildSectionHeader('TSB (DRIVE, SELF-CONFIDENCE & STRESS EVALUATION)'),
          const SizedBox(height: 8),
          Row(
            children: ['Pronounced (a)', 'Present (vh)', 'Insufficient (u)'].map((tsb) {
              final isSel = _tsbRating == tsb;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ChoiceChip(
                    label: Center(child: Text(tsb.split(' ')[0], style: TextStyle(color: isSel ? _offWhite : _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700))),
                    selected: isSel,
                    selectedColor: _forest,
                    backgroundColor: _carbon,
                    onSelected: (_) => setState(() => _tsbRating = tsb),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // 4. PLACEMENT & JUDGE
          _buildSectionHeader('PODIUM PLACEMENT & JUDGE'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _placement,
                dropdownColor: _carbon,
                icon: const Icon(Icons.keyboard_arrow_down, color: _gold),
                style: const TextStyle(color: _offWhite, fontSize: 14),
                items: ['1st Place (Gold)', '2nd Place (Silver)', '3rd Place (Bronze)', 'Trial Passed', 'Did Not Qualify']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => _placement = val!),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: TextField(
              controller: _judgeController,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.gavel, color: _mint, size: 20),
                hintText: 'Judge Name',
                hintStyle: TextStyle(color: _stoneGrey, fontSize: 13),
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // 5. SAVE BUTTON
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _saveResult,
              child: const Text('Save Official Result to Registry', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildScoreBox(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _mint, fontSize: 22, fontWeight: FontWeight.w800),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          top: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomepageScreen()),
                );
              }),
              _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyDogsScreen()),
                );
              }),
              _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainingScreen()),
                );
              }),
              _buildNavItem(Icons.event_note_outlined, 'Timeline', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              }),
              _buildNavItem(Icons.more_horiz, 'More', true, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MorePageScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? _mint : _stoneGrey,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _mint : _stoneGrey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
