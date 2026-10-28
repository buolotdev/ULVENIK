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

class DocumentViewerScreen extends StatefulWidget {
  final String title;
  final String documentType;

  const DocumentViewerScreen({
    super.key,
    this.title = 'Koda_OFA_Hips_Elbows_Certificate.pdf',
    this.documentType = 'Veterinary Orthopedic Certificate',
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  int _currentPage = 1;
  final int _totalPages = 3;
  double _zoomLevel = 1.0;

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
        title: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              widget.documentType,
              style: const TextStyle(color: _stoneGrey, fontSize: 10),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined, color: _offWhite),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AirPrint dialog opened.'), backgroundColor: _forest),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: _mint),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Document exported to system share sheet.'), backgroundColor: _forest),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. TOOLBAR STRIP (Page Counter & Zoom Controls)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: _carbon,
              border: Border(bottom: BorderSide(color: _cardBorder)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: _stoneGrey, size: 20),
                      onPressed: _currentPage > 1
                          ? () => setState(() => _currentPage--)
                          : null,
                    ),
                    Text(
                      'Page $_currentPage of $_totalPages',
                      style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: _stoneGrey, size: 20),
                      onPressed: _currentPage < _totalPages
                          ? () => setState(() => _currentPage++)
                          : null,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_out, color: _stoneGrey, size: 20),
                      onPressed: _zoomLevel > 0.8
                          ? () => setState(() => _zoomLevel -= 0.1)
                          : null,
                    ),
                    Text(
                      '${(_zoomLevel * 100).toInt()}%',
                      style: const TextStyle(color: _offWhite, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_in, color: _mint, size: 20),
                      onPressed: _zoomLevel < 1.8
                          ? () => setState(() => _zoomLevel += 0.1)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. DOCUMENT PAGE CANVAS
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Transform.scale(
                    scale: _zoomLevel,
                    child: Container(
                      width: 320,
                      height: 440,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ORTHOPEDIC FOUNDATION',
                                    style: TextStyle(
                                      color: Colors.grey.shade900,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  Text(
                                    'FOR ANIMALS (OFA)',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.green.shade700),
                                ),
                                child: Text(
                                  'EXCELLENT',
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.grey.shade300, height: 24),
                          _buildDocField('CANINE NAME:', 'KODA VOM ALPENHOF'),
                          _buildDocField('BREED:', 'BELGIAN MALINOIS'),
                          _buildDocField('MICROCHIP:', '985141002348123'),
                          _buildDocField('EVALUATION:', 'HIPS: EXCELLENT (GRADE 1) • ELBOWS: NORMAL'),
                          _buildDocField('RADIOLOGIST:', 'DR. H. LINDQVIST, DVM, DACVR'),
                          _buildDocField('DATE OF ISSUE:', 'OCTOBER 14, 2026'),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                                ),
                                child: Center(
                                  child: Icon(Icons.verified, color: Colors.blue.shade700, size: 28),
                                ),
                              ),
                              Text(
                                'OFFICIAL CERTIFICATE OF RECORD',
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 7, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDocField(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 8, fontWeight: FontWeight.w700)),
          Text(val, style: TextStyle(color: Colors.grey.shade900, fontSize: 10, fontWeight: FontWeight.w800)),
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
