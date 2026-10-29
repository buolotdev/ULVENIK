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
const Color _mutedGrey = Color(0xFF718096);
const Color _syncGreen = Color(0xFF4ADE80);

class FeatureRequestsScreen extends StatefulWidget {
  const FeatureRequestsScreen({super.key});

  @override
  State<FeatureRequestsScreen> createState() => _FeatureRequestsScreenState();
}

class _FeatureRequestsScreenState extends State<FeatureRequestsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Feature votes state matching Figma
  final Set<String> _votedIds = {'feat_templates'};

  void _onBottomNavTapped(int index) {
    if (index == 4) {
      Navigator.pop(context);
      return;
    }
    Widget target;
    switch (index) {
      case 0:
        target = const HomepageScreen();
        break;
      case 1:
        target = const MyDogsScreen();
        break;
      case 2:
        target = const TrainingScreen();
        break;
      case 3:
        target = const TimelineScreen();
        break;
      case 4:
        target = const MorePageScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  void _showSubmitFeatureModal() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
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
                  color: _mutedGrey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Submit New Feature',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'FEATURE TITLE',
              style: TextStyle(
                color: _mutedGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: _obsidian,
                hintText: 'e.g. Garmin Collar Ingestion',
                hintStyle: const TextStyle(color: _mutedGrey, fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'DESCRIPTION & USE CASE',
              style: TextStyle(
                color: _mutedGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: _obsidian,
                hintText: 'Describe how this helps your training workflow...',
                hintStyle: const TextStyle(color: _mutedGrey, fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Feature submitted for review.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: < Feature Requests ─────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left, color: _offWhite, size: 22),
                          SizedBox(width: 4),
                          Text(
                            'Feature Requests',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── FEATURE REQUESTS Banner ───────────────────────────
                  _buildSectionHeader('FEATURE REQUESTS'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline,
                                color: _stoneGrey, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Have an idea for Ulvenik?',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'We\'re always looking for ways to improve. Share your ideas and help shape future updates.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── Search Bar ────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: _stoneGrey, size: 20),
                        hintText: 'Search Feature Requests',
                        hintStyle: TextStyle(color: _mutedGrey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── POPULAR ───────────────────────────────────────────
                  _buildSectionHeader('POPULAR'),
                  const SizedBox(height: 8),

                  // Card 1: Training Templates (Planned)
                  _buildPopularFeatureCard(
                    id: 'feat_templates',
                    title: 'Training Templates',
                    desc: 'Save and reuse your favourite training session layouts.',
                    badge: 'Planned',
                    badgeBg: const Color(0xFF1E3A5F),
                    badgeText: const Color(0xFF90CDF4),
                    baseVotes: 1247,
                  ),
                  const SizedBox(height: 12),

                  // Card 2: Smart Health Insights (Under Review)
                  _buildPopularFeatureCard(
                    id: 'feat_health',
                    title: 'Smart Health Insights',
                    desc: 'AI-powered suggestions based on your dog\'s health history.',
                    badge: 'Under Review',
                    badgeBg: const Color(0xFF3D2E14),
                    badgeText: const Color(0xFFECC94B),
                    baseVotes: 847,
                  ),
                  const SizedBox(height: 12),

                  // Card 3: Multi-Dog Training Session (In Development)
                  _buildPopularFeatureCard(
                    id: 'feat_multidog',
                    title: 'Multi-Dog Training Session',
                    desc: 'Log a single session across multiple dogs at once.',
                    badge: 'In Development',
                    badgeBg: const Color(0xFF321E4B),
                    badgeText: const Color(0xFFD6BCFA),
                    baseVotes: 612,
                  ),

                  const SizedBox(height: 24),

                  // ─── SUBMIT ────────────────────────────────────────────
                  _buildSectionHeader('SUBMIT'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _showSubmitFeatureModal,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              color: _offWhite, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Submit New Feature',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Ideas are reviewed before becoming publicly visible.',
                      style: TextStyle(
                        color: _mutedGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── MY REQUESTS ───────────────────────────────────────
                  _buildSectionHeader('MY REQUESTS'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildMyRequestRow(
                          title: 'Offline Goal Tracking',
                          meta: 'Submitted 2 Sep • 18 votes',
                          badge: 'Under Review',
                          badgeBg: const Color(0xFF3D2E14),
                          badgeText: const Color(0xFFECC94B),
                        ),
                        _buildDivider(),
                        _buildMyRequestRow(
                          title: 'Custom Reward Icons',
                          meta: 'Submitted 28 Aug • 9 votes',
                          badge: 'Under Review',
                          badgeBg: const Color(0xFF3D2E14),
                          badgeText: const Color(0xFFECC94B),
                        ),
                        _buildDivider(),
                        _buildMyRequestRow(
                          title: 'Export to PDF',
                          meta: 'Submitted 15 Aug • 32 votes',
                          badge: 'Planned',
                          badgeBg: const Color(0xFF1E3A5F),
                          badgeText: const Color(0xFF90CDF4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // More tab active
        onTap: _onBottomNavTapped,
        backgroundColor: _obsidian,
        selectedItemColor: _mint,
        unselectedItemColor: _stoneGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            activeIcon: Icon(Icons.pets),
            label: 'Dogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _mutedGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0x0FFFFFFF),
      indent: 52,
    );
  }

  Widget _buildPopularFeatureCard({
    required String id,
    required String title,
    required String desc,
    required String badge,
    required Color badgeBg,
    required Color badgeText,
    required int baseVotes,
  }) {
    if (_searchQuery.isNotEmpty &&
        !title.toLowerCase().contains(_searchQuery) &&
        !desc.toLowerCase().contains(_searchQuery)) {
      return const SizedBox.shrink();
    }

    final isVoted = _votedIds.contains(id);
    final totalVotes = isVoted ? baseVotes + 1 : baseVotes;

    return Container(
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0x0FFFFFFF)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (isVoted) {
                      _votedIds.remove(id);
                    } else {
                      _votedIds.add(id);
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      isVoted ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                      color: isVoted ? _syncGreen : _stoneGrey,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isVoted ? 'Voted' : 'Vote',
                      style: TextStyle(
                        color: isVoted ? _syncGreen : _stoneGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${totalVotes.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} votes',
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyRequestRow({
    required String title,
    required String meta,
    required String badge,
    required Color badgeBg,
    required Color badgeText,
  }) {
    if (_searchQuery.isNotEmpty && !title.toLowerCase().contains(_searchQuery)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: _stoneGrey, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeText,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
        ],
      ),
    );
  }
}
