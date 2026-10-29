import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController(text: 'Recall');
  final List<String> _activeFilters = ['Murphy', 'Training'];

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
    });
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // SEARCH BAR HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: _carbon,
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
                              style: const TextStyle(color: _offWhite, fontSize: 15),
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                hintText: 'Search canine records...',
                                hintStyle: TextStyle(color: _stoneGrey),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              child: const Icon(Icons.close, color: _stoneGrey, size: 18),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            // FILTER CHIPS ROW
            if (_activeFilters.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    ..._activeFilters.map((f) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _carbon,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _cardBorder),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(f, style: const TextStyle(color: _offWhite, fontSize: 12)),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => _removeFilter(f),
                                  child: const Icon(Icons.close, color: _stoneGrey, size: 14),
                                ),
                              ],
                            ),
                          ),
                        )),
                    const Spacer(),
                    GestureDetector(
                      onTap: _clearAllFilters,
                      child: const Text('Clear All', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

            // RESULTS LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // TRAINING SESSIONS
                  const Text(
                    'TRAINING SESSIONS',
                    style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildResultTile(
                          icon: Icons.fitness_center_outlined,
                          titleLeading: 'Recall',
                          titleTrailing: ' Foundations',
                          subtitle: 'Murphy • 14 Sep 2026 • 45 min',
                          badge: 'TRAINING',
                        ),
                        const Divider(color: _cardBorder, height: 1),
                        _buildResultTile(
                          icon: Icons.fitness_center_outlined,
                          titleLeading: 'Advanced ',
                          titleHighlight: 'Recall',
                          titleTrailing: '',
                          subtitle: 'Murphy • 8 Sep 2026 • 30 min',
                          badge: 'TRAINING',
                        ),
                        const Divider(color: _cardBorder, height: 1),
                        _buildResultTile(
                          icon: Icons.fitness_center_outlined,
                          titleLeading: 'Recall',
                          titleTrailing: ' & Retrieve',
                          subtitle: 'Monty • 1 Sep 2026 • 60 min',
                          badge: 'TRAINING',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // GOALS
                  const Text(
                    'GOALS',
                    style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildResultTile(
                          icon: Icons.adjust_outlined,
                          titleLeading: 'Reliable ',
                          titleHighlight: 'Recall',
                          titleTrailing: '',
                          subtitle: 'Murphy • Active',
                          badge: 'ACTIVE',
                          badgeColor: _forest,
                        ),
                        const Divider(color: _cardBorder, height: 1),
                        _buildResultTile(
                          icon: Icons.adjust_outlined,
                          titleLeading: 'Off-Lead ',
                          titleHighlight: 'Recall',
                          titleTrailing: '',
                          subtitle: 'Monty • Active',
                          badge: 'ACTIVE',
                          badgeColor: _forest,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // MEDIA
                  const Text(
                    'MEDIA',
                    style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildMediaTile(
                          icon: Icons.play_arrow_outlined,
                          titleLeading: 'Recall',
                          titleTrailing: ' Training Video',
                          subtitle: 'Murphy • 10 Sep 2026',
                          badge: 'VIDEO',
                        ),
                        const Divider(color: _cardBorder, height: 1),
                        _buildMediaTile(
                          icon: Icons.image_outlined,
                          titleLeading: 'Recall',
                          titleTrailing: ' Session Photo',
                          subtitle: 'Murphy • 10 Sep 2026',
                          badge: 'PHOTO',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultTile({
    required IconData icon,
    required String titleLeading,
    String? titleHighlight,
    required String titleTrailing,
    required String subtitle,
    required String badge,
    Color? badgeColor,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $titleLeading${titleHighlight ?? ''}$titleTrailing...'), backgroundColor: _forest),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: titleLeading,
                          style: TextStyle(
                            color: titleHighlight == null ? _mint : _offWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (titleHighlight != null)
                          TextSpan(
                            text: titleHighlight,
                            style: const TextStyle(
                              color: _mint,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        TextSpan(
                          text: titleTrailing,
                          style: const TextStyle(
                            color: _offWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (badgeColor ?? const Color(0xFF242A2E)).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: badgeColor ?? _cardBorder),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: badgeColor != null ? _mint : _stoneGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaTile({
    required IconData icon,
    required String titleLeading,
    required String titleTrailing,
    required String subtitle,
    required String badge,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Viewing media: $titleLeading$titleTrailing'), backgroundColor: _forest),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF242A2E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _stoneGrey, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: titleLeading, style: const TextStyle(color: _mint, fontWeight: FontWeight.bold, fontSize: 14)),
                        TextSpan(text: titleTrailing, style: const TextStyle(color: _offWhite, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF242A2E),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }
}
