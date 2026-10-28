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

class ExportMyDataScreen extends StatefulWidget {
  const ExportMyDataScreen({super.key});

  @override
  State<ExportMyDataScreen> createState() => _ExportMyDataScreenState();
}

class _ExportMyDataScreenState extends State<ExportMyDataScreen> {
  bool _includeProfiles = true;
  bool _includeGps = true;
  bool _includeLogs = true;
  bool _includeMedia = true;
  String _format = 'Standard ZIP Archive (.zip)';
  bool _isExporting = false;
  double _exportProgress = 0.0;

  void _generateExport() async {
    if (_isExporting) return;
    setState(() {
      _isExporting = true;
      _exportProgress = 0.1;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 130));
      if (!mounted) return;
      setState(() => _exportProgress = i / 10.0);
    }

    if (!mounted) return;
    setState(() => _isExporting = false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Archive Ready', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: const Text(
          'Your complete canine archive (ulvenik_export_20261028.zip • 1.24 GB) has been packaged and a download link was dispatched to alex.rivers@k9alpine.com.',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done', style: TextStyle(color: _offWhite)),
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Export My Data',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. INFO CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.folder_zip_outlined, color: _mint, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Data Portability',
                        style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Generate a machine-readable archive of all canine biometrics, GPS coordinates, and media.',
                        style: TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. DATA CHECKLIST
          const Text('INCLUDE IN ARCHIVE', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildCheckRow('Canine Profiles & Health Records', 'Koda & Murphy medical logs, vaccines & weight curves', _includeProfiles, (v) => setState(() => _includeProfiles = v ?? false)),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildCheckRow('GPS Tracks & Topographic Waypoints', 'Raw GPX, KML and geo-referenced scent trail points', _includeGps, (v) => setState(() => _includeGps = v ?? false)),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildCheckRow('S&C Training & Agility Logs', 'Second-by-second telemetry, heart rate and fatigue scores', _includeLogs, (v) => setState(() => _includeLogs = v ?? false)),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildCheckRow('4K Video Attachments & Photos', 'All drill clips and session photos (~680 MB)', _includeMedia, (v) => setState(() => _includeMedia = v ?? false)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. ARCHIVE FORMAT SELECTION
          const Text('ARCHIVE FORMAT', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: ['Standard ZIP Archive (.zip)', 'JSON Database Export (.json)'].map((f) {
                final isSelected = _format == f;
                return InkWell(
                  onTap: () => setState(() => _format = f),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? _mint : _stoneGrey,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: _mint,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          f,
                          style: TextStyle(
                            color: isSelected ? _mint : _offWhite,
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // 4. PROGRESS BAR & GENERATE BUTTON
          if (_isExporting) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _exportProgress,
                backgroundColor: const Color(0xFF131718),
                valueColor: const AlwaysStoppedAnimation(_mint),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Packaging archive: ${(_exportProgress * 100).toInt()}%...',
                style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
          ],

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isExporting ? const Color(0xFF131718) : _forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _isExporting ? null : _generateExport,
              child: Text(
                _isExporting ? 'Generating Archive...' : 'Generate & Export Archive',
                style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCheckRow(String title, String subtitle, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: _mint,
            checkColor: Colors.black,
            onChanged: onChanged,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
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
