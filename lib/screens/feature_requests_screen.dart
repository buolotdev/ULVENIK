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
const Color _blue = Color(0xFF5D8FAF);

class FeatureRequestsScreen extends StatefulWidget {
  const FeatureRequestsScreen({super.key});

  @override
  State<FeatureRequestsScreen> createState() => _FeatureRequestsScreenState();
}

class _FeatureRequestsScreenState extends State<FeatureRequestsScreen> {
  String _selectedFilter = 'Trending';
  final Set<String> _upvotedIds = {'feat_1'};

  final List<Map<String, dynamic>> _features = [
    {
      'id': 'feat_1',
      'title': 'Garmin Alpha & Astro Live GPS Collar Integration',
      'description': 'Direct wireless ingestion of live canine positioning and speed telemetry from Garmin hunting transmitters.',
      'status': 'In Development',
      'statusColor': _mint,
      'votes': 842,
      'category': 'Hardware Integration',
    },
    {
      'id': 'feat_2',
      'title': 'Voice-Activated Drill Rep & Interval Counter',
      'description': 'Hands-free voice triggers like "Ulvenik, next weave rep" to log conditioning intervals without touching the phone.',
      'status': 'Under Review',
      'statusColor': _gold,
      'votes': 619,
      'category': 'S&C Training',
    },
    {
      'id': 'feat_3',
      'title': 'Export 3D GPX / KML for Google Earth Mountain Flyover',
      'description': 'Visualize high-altitude alpine tracking sessions with exact 3D slope gradients and contour perspectives.',
      'status': 'Planned',
      'statusColor': _blue,
      'votes': 528,
      'category': 'Activity Map & Export',
    },
    {
      'id': 'feat_4',
      'title': 'Canine Rest & Overnight Biometric Recovery Index',
      'description': 'Continuous sleep telemetry and heart rate dip scoring to predict next-day agility readiness.',
      'status': 'Under Review',
      'statusColor': _gold,
      'votes': 488,
      'category': 'Health & Biometrics',
    },
  ];

  void _toggleUpvote(String id) {
    setState(() {
      if (_upvotedIds.contains(id)) {
        _upvotedIds.remove(id);
      } else {
        _upvotedIds.add(id);
      }
    });
  }

  void _showNewProposalModal() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: _mint, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Propose a New Feature',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: titleController,
                style: const TextStyle(color: _offWhite, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Feature Title (e.g. Drone Video Overlay)',
                  hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFF131718),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _cardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                style: const TextStyle(color: _offWhite, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Explain why this feature would benefit canine trainers & handlers...',
                  hintStyle: const TextStyle(color: _stoneGrey, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF131718),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _cardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feature proposal submitted for handler community voting!'),
                        backgroundColor: _forest,
                      ),
                    );
                  },
                  child: const Text('Submit Proposal', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
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
          'Feature Requests',
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
          // 1. FILTER PILLS
          _buildFilterPills(),
          const SizedBox(height: 16),

          // 2. PROPOSAL LIST
          ..._features.map((feat) => _buildFeatureCard(feat)),
          const SizedBox(height: 60),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _forest,
        icon: const Icon(Icons.add, color: _offWhite),
        label: const Text('Propose Feature', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        onPressed: _showNewProposalModal,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFilterPills() {
    final filters = ['Trending', 'In Development', 'Under Review', 'Planned'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : _carbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? _mint : _cardBorder,
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? _offWhite : _stoneGrey,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feat) {
    final String id = feat['id'];
    final bool isUpvoted = _upvotedIds.contains(id);
    final int votes = feat['votes'] + (isUpvoted ? 1 : 0);
    final Color statusColor = feat['statusColor'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upvote Column
          GestureDetector(
            onTap: () => _toggleUpvote(id),
            child: Container(
              width: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isUpvoted ? _forest : const Color(0xFF131718),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isUpvoted ? _mint : _cardBorder),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.arrow_drop_up,
                    color: isUpvoted ? _mint : _stoneGrey,
                    size: 26,
                  ),
                  Text(
                    '$votes',
                    style: TextStyle(
                      color: isUpvoted ? _mint : _offWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        feat['status'],
                        style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      feat['category'],
                      style: const TextStyle(color: _stoneGrey, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  feat['title'],
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feat['description'],
                  style: const TextStyle(color: _stoneGrey, fontSize: 12, height: 1.4),
                ),
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
