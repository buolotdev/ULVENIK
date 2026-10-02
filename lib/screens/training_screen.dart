import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

// ─── Simple data models ───────────────────────────────────────────────────────

enum SessionStatus { draft, completed }

class TrainingSession {
  final String id;
  final String dogName;
  final String dogInitial;
  final String title;
  final String dateLabel;
  final SessionStatus status;
  final String? duration;
  final int? skillCount;
  final int? exerciseCount;
  final List<String> tags;
  final int? photoCount;
  final int? videoCount;
  final String? thumbnailUrl;
  final Color dogColor;

  const TrainingSession({
    required this.id,
    required this.dogName,
    required this.dogInitial,
    required this.title,
    required this.dateLabel,
    required this.status,
    this.duration,
    this.skillCount,
    this.exerciseCount,
    this.tags = const [],
    this.photoCount,
    this.videoCount,
    this.thumbnailUrl,
    required this.dogColor,
  });
}

// ─── Mock data ────────────────────────────────────────────────────────────────

const _allSessions = [
  TrainingSession(
    id: 's1',
    dogName: 'Rex',
    dogInitial: 'R',
    title: 'Tracking Session: Woodland Trail',
    dateLabel: 'Today · Incomplete',
    status: SessionStatus.draft,
    dogColor: AppColors.secondarySage,
  ),
  TrainingSession(
    id: 's2',
    dogName: 'Murphy',
    dogInitial: 'M',
    title: 'Morning Obedience Block',
    dateLabel: '14 Sep · 07:30',
    status: SessionStatus.completed,
    duration: '45 min',
    skillCount: 3,
    exerciseCount: 6,
    tags: ['Recall', 'Heel'],
    photoCount: 4,
    videoCount: 1,
    thumbnailUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBtnZIiE99uRwgthfLqDzuxeWGd8cxQATNqJM6VzC9pZrTZ31-ffB290LDjDtqheyJspt7ofm9yqIF0X0XFWx8dXCBjZbDHG8qdo0Mz-AuhKHlvFxLL-nAsQLvNI8DUFO-kmO-ZgtFTq-76pxDki6E3kNW1JrHqExT9Q5CibVDY4kJsbdsMkr3D67qmyZ2g8T-9UQBq28KytbkJ3sLu0KU1xi9Y5Mh_ZXxXm2p22Nih4geUdfZm0yE',
    dogColor: AppColors.secondarySage,
  ),
  TrainingSession(
    id: 's3',
    dogName: 'Koda',
    dogInitial: 'K',
    title: 'S&C Warm-Up + Play Session',
    dateLabel: '13 Sep · 16:00',
    status: SessionStatus.completed,
    dogColor: AppColors.infoAlpineBlue,
  ),
  TrainingSession(
    id: 's4',
    dogName: 'Murphy',
    dogInitial: 'M',
    title: 'Distance Recall Drills',
    dateLabel: '12 Sep · 09:00',
    status: SessionStatus.completed,
    duration: '30 min',
    skillCount: 2,
    exerciseCount: 4,
    tags: ['Recall'],
    dogColor: AppColors.secondarySage,
  ),
  TrainingSession(
    id: 's5',
    dogName: 'Rex',
    dogInitial: 'R',
    title: 'Protection Work: Sleeve Drive',
    dateLabel: '11 Sep · 17:00',
    status: SessionStatus.completed,
    duration: '60 min',
    skillCount: 1,
    exerciseCount: 8,
    tags: ['Protection', 'Drive'],
    dogColor: AppColors.secondarySage,
  ),
];

// ─── Main screen ──────────────────────────────────────────────────────────────

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  bool _hasData = true;
  int _activeFilter = 0; // 0=All Dogs, 1=My Dogs, 2=Sport Dogs, 3=Client Dogs
  bool _sortNewest = true;
  bool _videoPlaying = false;

  final List<String> _filters = ['All Dogs', 'My Dogs', 'Sport Dogs', 'Client Dogs'];

  // Active filter chips (dog name + date range)
  final List<String> _activeChips = ['Murphy', 'Last 30 Days'];

  // Search
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const String _heroImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAzU4TdlERYJVUgVdsr7lJ8DZFavYDTksXswDyQuEMLlNsKiXqJGjJad2zRGqd2ibKYehwzPDTAizHKzNhifbp44NfWAFL-Rl4zffvvhWUMt93n77tVP4tql3yPVRn8sNdzWjJLNSKuYVoDJXAnLeoqdAtzst_h1iNayOteb9nZ0HLwqIgjNL3zU2DYy8wU-k1SfK2rg8DPnSut9yIGwM0aDTFJGGUGg76OCK6Laj93d4g7ijmaPXU';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Derived filtered + sorted session list ────────────────────────────────

  List<TrainingSession> get _filteredSessions {
    final dogFilter = switch (_activeFilter) {
      1 => ['Rex', 'Murphy'], // My Dogs
      2 => ['Koda'],          // Sport Dogs
      3 => <String>[],        // Client Dogs (empty for demo)
      _ => null,              // All Dogs — no filter
    };

    var list = _allSessions.where((s) {
      // Dog filter
      if (dogFilter != null && !dogFilter.contains(s.dogName)) return false;
      // Active chip dog filter
      final chipDog = _activeChips.where((c) =>
          ['Murphy', 'Rex', 'Koda'].contains(c));
      if (chipDog.isNotEmpty && !chipDog.contains(s.dogName)) return false;
      // Search
      if (_searchQuery.isNotEmpty) {
        return s.title.toLowerCase().contains(_searchQuery) ||
            s.dogName.toLowerCase().contains(_searchQuery) ||
            s.tags.any((t) => t.toLowerCase().contains(_searchQuery));
      }
      return true;
    }).toList();

    return _sortNewest ? list : list.reversed.toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: CustomScrollView(
        slivers: [
          _buildHero(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                  const SizedBox(height: 20),
                  _buildFilterPills(),
                  const SizedBox(height: 16),
                  if (_hasData) ...[
                    if (_activeChips.isNotEmpty) ...[
                      _buildActiveChips(),
                      const SizedBox(height: 20),
                    ],
                    _buildSessionListHeader(),
                    const SizedBox(height: 12),
                    _buildSessionList(),
                  ] else
                    _buildEmptyState(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _buildHero() {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: false,
      stretch: true,
      backgroundColor: AppColors.backgroundObsidian,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(_heroImage, fit: BoxFit.cover),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x33101214), AppColors.backgroundObsidian],
                ),
              ),
            ),
            // Top controls
            Positioned(
              top: 48,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: AppColors.primaryTextOffWhite, size: 28),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.cardsCarbon,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white12),
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            color: AppColors.primaryTextOffWhite, size: 20),
                      ),
                      Positioned(
                        top: 8,
                        right: 9,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primaryForestGreen,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.backgroundObsidian, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Hero text — double tap to toggle state
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: GestureDetector(
                onDoubleTap: () => setState(() => _hasData = !_hasData),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'TRAINING',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.05,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your Sessions',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Across all dogs',
                      style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.search,
              color: AppColors.secondaryTextStoneGrey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                  color: AppColors.primaryTextOffWhite, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search sessions, dogs, skills...',
                hintStyle: TextStyle(
                    color: AppColors.secondaryTextStoneGrey, fontSize: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => AppSnackbar.show(context,
                message: 'Voice search coming soon',
                type: SnackbarType.info),
            child: const Icon(Icons.mic_outlined,
                color: AppColors.secondaryTextStoneGrey, size: 20),
          ),
        ],
      ),
    );
  }

  // ── Quick actions ─────────────────────────────────────────────────────────

  Widget _buildQuickActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildQuickAction(
            label: 'New Session',
            icon: Icons.add,
            isPrimary: true,
            onTap: _showNewSessionSheet,
          ),
          const SizedBox(width: 12),
          if (_hasData)
            _buildQuickAction(
              label: 'Continue Draft',
              icon: Icons.edit_outlined,
              hasDot: true,
              onTap: () => AppSnackbar.show(context,
                  message: 'Resuming draft: Tracking Session, Woodland Trail',
                  type: SnackbarType.info),
            ),
          if (_hasData) const SizedBox(width: 12),
          _buildQuickAction(
            label: 'Recent Sessions',
            icon: Icons.schedule_outlined,
            onTap: () {
              setState(() {
                _sortNewest = true;
                _searchController.clear();
              });
              AppSnackbar.show(context,
                  message: 'Showing most recent sessions',
                  type: SnackbarType.info);
            },
          ),
          if (_hasData) ...[
            const SizedBox(width: 12),
            _buildQuickAction(
              label: 'All Dogs',
              icon: Icons.pets_outlined,
              onTap: () => setState(() => _activeFilter = 0),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required String label,
    required IconData icon,
    bool isPrimary = false,
    bool hasDot = false,
    VoidCallback? onTap,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isPrimary
                    ? AppColors.primaryForestGreen
                    : AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isPrimary
                        ? AppColors.primaryForestGreen
                        : Colors.white12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon,
                      size: 18,
                      color: isPrimary
                          ? AppColors.primaryTextOffWhite
                          : AppColors.secondaryTextStoneGrey),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasDot)
          Positioned(
            top: -3,
            right: -3,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.primaryForestGreen,
                shape: BoxShape.circle,
                border:
                    Border.all(color: AppColors.backgroundObsidian, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  // ── Filter pills ──────────────────────────────────────────────────────────

  Widget _buildFilterPills() {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: List.generate(_filters.length, (i) {
        final isActive = _activeFilter == i;
        return GestureDetector(
          onTap: () => setState(() => _activeFilter = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primaryForestGreen
                  : AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(
                  color: isActive
                      ? AppColors.primaryForestGreen
                      : Colors.white12),
            ),
            child: Text(
              _filters[i],
              style: TextStyle(
                color: isActive
                    ? AppColors.primaryTextOffWhite
                    : AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Active chips ──────────────────────────────────────────────────────────

  Widget _buildActiveChips() {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _activeChips
                .map((chip) => _buildChip(chip,
                    onRemove: () =>
                        setState(() => _activeChips.remove(chip))))
                .toList(),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _activeChips.clear()),
          child: const Text('Clear All',
              style: TextStyle(
                  color: AppColors.primaryForestGreen, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildChip(String label, {required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 4),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border:
            Border.all(color: AppColors.primaryForestGreen.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.primaryTextOffWhite, fontSize: 12)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 14, color: AppColors.secondaryTextStoneGrey),
          ),
        ],
      ),
    );
  }

  // ── Session list header ───────────────────────────────────────────────────

  Widget _buildSessionListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'RECENT SESSIONS (${_filteredSessions.length})',
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _sortNewest = !_sortNewest),
          child: Row(
            children: [
              Text(
                _sortNewest ? 'Newest First' : 'Oldest First',
                style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey, fontSize: 12),
              ),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: _sortNewest ? 0 : 0.5,
                duration: const Duration(milliseconds: 250),
                child: const Icon(Icons.swap_vert,
                    size: 16, color: AppColors.secondaryTextStoneGrey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Session list ──────────────────────────────────────────────────────────

  Widget _buildSessionList() {
    final sessions = _filteredSessions;

    if (sessions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off,
                  size: 40,
                  color: AppColors.secondaryTextStoneGrey.withOpacity(0.5)),
              const SizedBox(height: 12),
              const Text(
                'No sessions match your filters',
                style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey, fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    _activeFilter = 0;
                    _activeChips.clear();
                    _searchController.clear();
                  });
                },
                child: const Text('Clear Filters',
                    style: TextStyle(color: AppColors.primaryForestGreen)),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: sessions
          .map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSessionCard(s),
              ))
          .toList(),
    );
  }

  Widget _buildSessionCard(TrainingSession session) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => AppSnackbar.show(
          context,
          message: session.status == SessionStatus.draft
              ? 'Resuming: ${session.title}'
              : 'Opening: ${session.title}',
          type: session.status == SessionStatus.draft
              ? SnackbarType.warning
              : SnackbarType.info,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardThumbnail(session),
              const SizedBox(width: 16),
              Expanded(child: _buildCardContent(session)),
              if (session.status == SessionStatus.draft)
                _buildDraftBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardThumbnail(TrainingSession session) {
    if (session.thumbnailUrl != null) {
      return GestureDetector(
        onTap: () => setState(() => _videoPlaying = !_videoPlaying),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: Image.network(
                  session.thumbnailUrl!,
                  fit: BoxFit.cover,
                  color: Colors.black45,
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      key: ValueKey(_videoPlaying),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.black54, shape: BoxShape.circle),
                      child: Icon(
                        _videoPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.primaryTextOffWhite,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // No thumbnail
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF111412),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Icon(
        session.status == SessionStatus.draft
            ? Icons.edit_outlined
            : Icons.landscape_outlined,
        color: session.status == SessionStatus.draft
            ? AppColors.secondaryTextStoneGrey
            : AppColors.secondaryTextStoneGrey.withOpacity(0.2),
        size: session.status == SessionStatus.draft ? 28 : 36,
      ),
    );
  }

  Widget _buildCardContent(TrainingSession session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dog row
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: session.dogColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12),
              ),
              child: Center(
                child: Text(
                  session.dogInitial,
                  style: TextStyle(
                    color: session.dogColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              session.dogName,
              style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          session.title,
          style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          session.dateLabel,
          style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey, fontSize: 12),
        ),
        // Stats row
        if (session.duration != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              if (session.duration != null)
                _buildStat(Icons.schedule_outlined, session.duration!),
              if (session.skillCount != null)
                _buildStat(Icons.layers_outlined, '${session.skillCount} Skills'),
              if (session.exerciseCount != null)
                _buildStat(Icons.repeat, '${session.exerciseCount} Ex'),
            ],
          ),
        ],
        // Tags
        if (session.tags.isNotEmpty || session.photoCount != null) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ...session.tags.map((t) => _buildTag(t)),
              if (session.photoCount != null)
                _buildMediaTag(Icons.photo_camera_outlined,
                    '${session.photoCount}'),
              if (session.videoCount != null)
                _buildMediaTag(Icons.videocam_outlined,
                    '${session.videoCount}'),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStat(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.secondaryTextStoneGrey),
          const SizedBox(width: 3),
          Text(label,
              style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF111412),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
    );
  }

  Widget _buildMediaTag(IconData icon, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF111412),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: AppColors.secondaryTextStoneGrey),
          const SizedBox(width: 3),
          Text(count,
              style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildDraftBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF8d504a),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'DRAFT',
        style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12),
            ),
            child: const Icon(Icons.bookmark_border_outlined,
                color: AppColors.primaryForestGreen, size: 32),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Sessions Yet',
            style: TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Text(
            "Start recording your first training\nsession to begin building your dog's\nlifelong training history.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 14,
                height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showNewSessionSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryForestGreen,
                foregroundColor: AppColors.primaryTextOffWhite,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                'Start Training Session →',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── New Session bottom sheet ───────────────────────────────────────────────

  void _showNewSessionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _NewSessionSheet(),
    );
  }
}

// ─── New Session bottom sheet ─────────────────────────────────────────────────

class _NewSessionSheet extends StatefulWidget {
  @override
  State<_NewSessionSheet> createState() => _NewSessionSheetState();
}

class _NewSessionSheetState extends State<_NewSessionSheet> {
  String? _selectedDog;

  final List<Map<String, dynamic>> _dogs = [
    {'name': 'Rex', 'initial': 'R', 'breed': 'German Shepherd', 'color': AppColors.secondarySage},
    {'name': 'Murphy', 'initial': 'M', 'breed': 'Belgian Malinois', 'color': AppColors.secondarySage},
    {'name': 'Koda', 'initial': 'K', 'breed': 'Dutch Shepherd', 'color': AppColors.infoAlpineBlue},
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: Colors.white12),
          ),
          padding: EdgeInsets.only(
            top: 12,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
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
              const SizedBox(height: 20),
              const Text(
                'New Training Session',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select the dog for this session',
                style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              // Dog list
              ..._dogs.map((dog) {
                final isSelected = _selectedDog == dog['name'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedDog = dog['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryForestGreen.withOpacity(0.15)
                          : AppColors.backgroundObsidian,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryForestGreen
                            : Colors.white12,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                (dog['color'] as Color).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              dog['initial'] as String,
                              style: TextStyle(
                                color: dog['color'] as Color,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dog['name'] as String,
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              dog['breed'] as String,
                              style: const TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              color: AppColors.primaryForestGreen, size: 20),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              // CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedDog == null
                      ? null
                      : () {
                          Navigator.pop(context);
                          AppSnackbar.show(
                            context,
                            message:
                                'Starting session for $_selectedDog. Training Session screen coming soon!',
                            type: SnackbarType.success,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    disabledBackgroundColor:
                        AppColors.primaryForestGreen.withOpacity(0.3),
                    foregroundColor: AppColors.primaryTextOffWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    _selectedDog == null
                        ? 'Select a Dog to Continue'
                        : 'Start Session with $_selectedDog →',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
