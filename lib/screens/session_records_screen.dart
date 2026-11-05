import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'record_session_screen.dart';
import 'session_details_screen.dart';
import 'trainer_dashboard_screen.dart';

class SessionRecordItem {
  final String id;
  final String dateText;
  final String timeText;
  final String category;
  final String title;
  final List<String> dogs;
  final String location;
  final String durationText;
  final bool hasHomework;
  final String monthGroup;

  const SessionRecordItem({
    required this.id,
    required this.dateText,
    required this.timeText,
    required this.category,
    required this.title,
    required this.dogs,
    required this.location,
    required this.durationText,
    this.hasHomework = false,
    required this.monthGroup,
  });
}

class SessionRecordsScreen extends StatefulWidget {
  final String? clientId;

  const SessionRecordsScreen({
    super.key,
    this.clientId,
  });

  @override
  State<SessionRecordsScreen> createState() => _SessionRecordsScreenState();
}

class _SessionRecordsScreenState extends State<SessionRecordsScreen> {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _cardBg = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _greenAccent = Color(0xFF479A7B);
  static const Color _mintBright = Color(0xFFB1F0D6);
  static const Color _sage = AppColors.secondarySage; // #7A8F7A
  static const Color _textPrimary = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _textSecondary = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _border = AppColors.cardBorder;

  final TextEditingController _searchCtrl = TextEditingController();
  bool _isSearching = false;

  final List<SessionRecordItem> _records = const [
    SessionRecordItem(
      id: 'sr_1',
      dateText: '15 Sep',
      timeText: '09:00',
      category: 'ONE-TO-ONE',
      title: 'Recall & Distraction Work',
      dogs: ['Murphy'],
      location: 'Chelmsford Training Ground',
      durationText: '60 min',
      hasHomework: true,
      monthGroup: 'SEPTEMBER 2026',
    ),
    SessionRecordItem(
      id: 'sr_2',
      dateText: '8 Sep',
      timeText: '09:00',
      category: 'ONE-TO-ONE',
      title: 'Loose Lead Walking — Advanced',
      dogs: ['Murphy', 'Bella'],
      location: 'Private Session',
      durationText: '60 min',
      hasHomework: false,
      monthGroup: 'SEPTEMBER 2026',
    ),
    SessionRecordItem(
      id: 'sr_3',
      dateText: '1 Sep',
      timeText: '09:30',
      category: 'BEHAVIOUR CONSULTATION',
      title: 'Reactivity Assessment',
      dogs: ['Bella'],
      location: 'Client\'s Home',
      durationText: '90 min',
      hasHomework: false,
      monthGroup: 'SEPTEMBER 2026',
    ),
    SessionRecordItem(
      id: 'sr_4',
      dateText: '28 Aug',
      timeText: '10:00',
      category: 'ONE-TO-ONE',
      title: 'Foundation Heelwork',
      dogs: ['Murphy'],
      location: 'Chelmsford Training Ground',
      durationText: '60 min',
      hasHomework: false,
      monthGroup: 'AUGUST 2026',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openRecordSession() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RecordSessionScreen(),
      ),
    );
  }

  void _openSessionDetail(SessionRecordItem record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SessionDetailsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar: const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        foregroundColor: _textPrimary,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: _openRecordSession,
        child: const UlvenikIcon(UlvenikIcons.add, size: 26),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<TrainerClient>>(
          valueListenable: TrainerPackStore.clientsNotifier,
          builder: (context, _, _) {
            final client = TrainerPackStore.findClient(widget.clientId);
            final clientName = client.fullName.isNotEmpty ? client.fullName : 'Emma Johnson';
            final bannerSubtitle = '$clientName · Murphy & Bella · 12 Sessions Total';

            return Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                    children: [
                      _buildHeaderBanner(client, bannerSubtitle),
                      const SizedBox(height: 16),
                      // September items
                      ..._records
                          .where((r) => r.monthGroup == 'SEPTEMBER 2026')
                          .map((r) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildSessionCard(r),
                              )),
                      const SizedBox(height: 8),
                      // August header
                      const Text(
                        'AUGUST 2026',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._records
                          .where((r) => r.monthGroup == 'AUGUST 2026')
                          .map((r) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildSessionCard(r),
                              )),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(bottom: BorderSide(color: _border, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            visualDensity: VisualDensity.compact,
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _textSecondary,
              size: 26,
            ),
          ),
          Expanded(
            child: _isSearching
                ? TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    style: const TextStyle(color: _textPrimary, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Search session records...',
                      hintStyle: TextStyle(color: _textSecondary, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  )
                : const Text(
                    'Session Records',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      fontFamily: 'Inter',
                    ),
                  ),
          ),
          IconButton(
            tooltip: 'Search',
            visualDensity: VisualDensity.compact,
            onPressed: () => setState(() => _isSearching = !_isSearching),
            icon: UlvenikIcon.fromMaterial(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: _textSecondary,
              size: 22,
            ),
          ),
          IconButton(
            tooltip: 'Filter',
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded,
              color: _textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner(TrainerClient client, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF282F32),
              shape: BoxShape.circle,
              border: Border.all(color: _border),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person_outline_rounded,
              color: _textSecondary,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(SessionRecordItem r) {
    return InkWell(
      onTap: () => _openSessionDetail(r),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Time block on left
            SizedBox(
              width: 58,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.dateText,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    r.timeText,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Middle session info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252B28),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _border),
                    ),
                    child: Text(
                      r.category,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    r.title,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...r.dogs.map(
                        (d) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF242A2D),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _border),
                          ),
                          child: Text(
                            d,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_outlined, color: _sage, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            r.location,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 11.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        r.durationText,
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (r.hasHomework) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _forest.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _forest.withValues(alpha: 0.45)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.assignment_turned_in_outlined,
                                  color: _greenAccent, size: 12),
                              SizedBox(width: 4),
                              Text(
                                'Homework Assigned',
                                style: TextStyle(
                                  color: _mintBright,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const UlvenikIcon(UlvenikIcons.details,
              color: _textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

