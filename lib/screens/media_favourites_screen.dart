import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'document_viewer_screen.dart';
import 'photo_viewer_screen.dart';
import 'video_viewer_screen.dart';

enum FavouriteEntryKind { photo, video, document, trainingSession, goal }

class FavouriteMediaEntry {
  final String id;
  final String title;
  final FavouriteEntryKind kind;
  final String pillLabel;
  final String dogName;
  final String addedAgoLabel;
  final DateTime addedDate;
  final String? assetPath;
  final bool isSport;
  final bool isCompetition;

  const FavouriteMediaEntry({
    required this.id,
    required this.title,
    required this.kind,
    required this.pillLabel,
    required this.dogName,
    required this.addedAgoLabel,
    required this.addedDate,
    this.assetPath,
    this.isSport = false,
    this.isCompetition = false,
  });
}

class MediaFavouritesScreen extends StatefulWidget {
  final bool hasSportPack;

  const MediaFavouritesScreen({
    super.key,
    this.hasSportPack = true,
  });

  @override
  State<MediaFavouritesScreen> createState() => _MediaFavouritesScreenState();
}

class _MediaFavouritesScreenState extends State<MediaFavouritesScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian; // #101214
  static const Color _carbon = AppColors.cardsCarbon; // #1A1F22
  static const Color _thumbDark = Color(0xFF131618);
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _sage = AppColors.secondarySage; // #7A8F7A
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _favGold = AppColors.favouriteGold; // #B8920A

  List<String> get _tabs => [
    'All',
    'Photos',
    'Videos',
    'Documents',
    'Training',
    if (widget.hasSportPack) 'Sport',
    if (widget.hasSportPack) 'Competition',
  ];

  final TextEditingController _searchController = TextEditingController();
  int _selectedTabIndex = 0;
  bool _showSearchBar = false;
  String _searchQuery = '';
  String _selectedDog = 'All Dogs';
  String _sortBy = 'Recently Added';

  FavouriteMediaEntry? _lastRemovedItem;
  int? _lastRemovedIndex;

  static final List<FavouriteMediaEntry> _seedItems = [
    FavouriteMediaEntry(
      id: 'fav_1',
      isSport: true,
      isCompetition: true,
      title: 'Agility Finals — Örebro',
      kind: FavouriteEntryKind.photo,
      pillLabel: 'Photo',
      dogName: 'Zeus',
      addedAgoLabel: 'Added 1 day ago',
      addedDate: DateTime(2026, 7, 14),
      assetPath: 'assets/images/photo_viewer_1.jpg',
    ),
    FavouriteMediaEntry(
      id: 'fav_2',
      title: 'Weave Pole Session #12',
      kind: FavouriteEntryKind.video,
      pillLabel: 'Video',
      dogName: 'Zeus',
      addedAgoLabel: 'Added 3 days ago',
      addedDate: DateTime(2026, 7, 12),
      assetPath: 'assets/bg-images/onboarding_2.png',
    ),
    FavouriteMediaEntry(
      id: 'fav_3',
      title: 'Advanced Agility — Week 4',
      kind: FavouriteEntryKind.trainingSession,
      pillLabel: 'Training Session',
      dogName: 'Zeus',
      addedAgoLabel: 'Added 5 days ago',
      addedDate: DateTime(2026, 7, 10),
    ),
    FavouriteMediaEntry(
      id: 'fav_4',
      title: 'Morning Run — Pine Trail',
      kind: FavouriteEntryKind.photo,
      pillLabel: 'Photo',
      dogName: 'Luna',
      addedAgoLabel: 'Added 1 week ago',
      addedDate: DateTime(2026, 7, 8),
      assetPath: 'assets/bg-images/onboarding_1.png',
    ),
    FavouriteMediaEntry(
      id: 'fav_5',
      title: 'Achieve Off-Lead Recall',
      kind: FavouriteEntryKind.goal,
      pillLabel: 'Goal',
      dogName: 'Zeus',
      addedAgoLabel: 'Added 2 weeks ago',
      addedDate: DateTime(2026, 7, 1),
    ),
    FavouriteMediaEntry(
      id: 'fav_6',
      title: 'Vet Report — July 2026',
      kind: FavouriteEntryKind.document,
      pillLabel: 'Document',
      dogName: 'Luna',
      addedAgoLabel: 'Added 3 weeks ago',
      addedDate: DateTime(2026, 6, 24),
    ),
    FavouriteMediaEntry(
      id: 'fav_7',
      title: 'Tracking Exercise — Session 14',
      kind: FavouriteEntryKind.video,
      pillLabel: 'Video',
      dogName: 'Kodi',
      addedAgoLabel: 'Added 3 weeks ago',
      addedDate: DateTime(2026, 6, 21),
      assetPath: 'assets/images/video_viewer_thumb.jpg',
    ),
    FavouriteMediaEntry(
      id: 'fav_8',
      title: 'Hip & Elbow Screening',
      kind: FavouriteEntryKind.document,
      pillLabel: 'Document',
      dogName: 'Kodi',
      addedAgoLabel: 'Added 1 month ago',
      addedDate: DateTime(2026, 6, 14),
    ),
  ];

  late List<FavouriteMediaEntry> _favourites = List.of(_seedItems);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FavouriteMediaEntry> get _filteredFavourites {
    final q = _searchQuery.trim().toLowerCase();
    final tab = _selectedTabIndex < _tabs.length ? _tabs[_selectedTabIndex] : 'All';

    final list = _favourites.where((item) {
      if (!widget.hasSportPack && (item.isSport || item.isCompetition)) {
        return false;
      }
      if (tab == 'Sport' && !item.isSport) {
        return false;
      }
      if (tab == 'Competition' && !item.isCompetition) {
        return false;
      }
      if (tab == 'Photos' && item.kind != FavouriteEntryKind.photo) {
        return false;
      }
      if (tab == 'Videos' && item.kind != FavouriteEntryKind.video) {
        return false;
      }
      if (tab == 'Documents' && item.kind != FavouriteEntryKind.document) {
        return false;
      }
      if (tab == 'Training' &&
          item.kind != FavouriteEntryKind.trainingSession &&
          item.kind != FavouriteEntryKind.goal) {
        return false;
      }
      if (_selectedDog != 'All Dogs' && item.dogName != _selectedDog) {
        return false;
      }
      if (q.isNotEmpty) {
        final hay = '${item.title} ${item.dogName} ${item.pillLabel}'
            .toLowerCase();
        if (!hay.contains(q)) return false;
      }
      return true;
    }).toList();

    if (_sortBy == 'Oldest Added') {
      list.sort((a, b) => a.addedDate.compareTo(b.addedDate));
    } else if (_sortBy == 'Alphabetical (A–Z)') {
      list.sort((a, b) => a.title.compareTo(b.title));
    } else {
      list.sort((a, b) => b.addedDate.compareTo(a.addedDate));
    }
    return list;
  }

  void _unfavouriteItem(FavouriteMediaEntry item) {
    final idx = _favourites.indexOf(item);
    if (idx == -1) return;
    setState(() {
      _lastRemovedItem = item;
      _lastRemovedIndex = idx;
      _favourites.removeAt(idx);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _carbon,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _cardBorder),
        ),
        duration: const Duration(seconds: 4),
        content: Text(
          'Removed "${item.title}" from Favourites',
          style: const TextStyle(
            color: _offWhite,
            fontSize: 13,
            fontFamily: 'Inter',
          ),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: _favGold,
          onPressed: _restoreLastRemoved,
        ),
      ),
    );
  }

  void _restoreLastRemoved() {
    if (_lastRemovedItem == null) return;
    setState(() {
      final insertAt = (_lastRemovedIndex ?? 0).clamp(0, _favourites.length);
      _favourites.insert(insertAt, _lastRemovedItem!);
      _lastRemovedItem = null;
      _lastRemovedIndex = null;
    });
  }

  void _openFavouriteEntry(FavouriteMediaEntry item) {
    switch (item.kind) {
      case FavouriteEntryKind.photo:
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => PhotoViewerScreen(overrideTitle: item.title),
          ),
        );
        break;
      case FavouriteEntryKind.video:
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => VideoViewerScreen(
              title: item.title,
              dogName: item.dogName,
              initialFavourite: true,
            ),
          ),
        );
        break;
      case FavouriteEntryKind.document:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DocumentViewerScreen(
              overrideTitle: item.title,
              dogName: item.dogName,
              initialFavourite: true,
            ),
          ),
        );
        break;
      case FavouriteEntryKind.trainingSession:
      case FavouriteEntryKind.goal:
        _showLinkedSummarySheet(item);
        break;
    }
  }

  void _showLinkedSummarySheet(FavouriteMediaEntry item) {
    final isGoal = item.kind == FavouriteEntryKind.goal;
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _thumbDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: UlvenikIcon.fromMaterial(
                      isGoal ? Icons.gps_fixed_rounded : Icons.pets_outlined,
                      color: _sage,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item.pillLabel} · ${item.dogName} · ${item.addedAgoLabel}',
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _obsidian,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: Text(
                  isGoal
                      ? 'Milestone target at 85% completion — 6 consecutive clean long-line whistle recalls logged under outdoor distraction.'
                      : '45 min structured agility sequence · 94% contact zone accuracy · 3 video clips attached.',
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 13,
                    height: 1.45,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _offWhite,
                        side: const BorderSide(color: _cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _unfavouriteItem(item);
                      },
                      child: const Text(
                        'Unfavourite',
                        style: TextStyle(fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => VideoViewerScreen(
                              title: item.title,
                              dogName: item.dogName,
                              initialFavourite: true,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Watch Session Clip',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortAndFilterSheet() {
    const sortOptions = [
      'Recently Added',
      'Oldest Added',
      'Alphabetical (A–Z)',
    ];
    const dogs = ['All Dogs', 'Zeus', 'Luna', 'Kodi'];

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sort & Filter Favourites',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'DOG',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: dogs.map((dog) {
                    final active = _selectedDog == dog;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedDog = dog);
                        setModalState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? _forest.withValues(alpha: 0.24)
                              : _obsidian,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: active ? _forest : _cardBorder,
                          ),
                        ),
                        child: Text(
                          dog,
                          style: TextStyle(
                            color: active ? const Color(0xFF95D3BB) : _offWhite,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'SORT ORDER',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 6),
                ...sortOptions.map((opt) {
                  final selected = _sortBy == opt;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      opt,
                      style: TextStyle(
                        color: selected ? const Color(0xFF95D3BB) : _offWhite,
                        fontSize: 14,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),
                    trailing: selected
                        ? const UlvenikIcon(UlvenikIcons.completed,
                            color: Color(0xFF95D3BB),
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      setState(() => _sortBy = opt);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filteredFavourites;

    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeader(),
            const Divider(color: _cardBorder, height: 1),
            if (_showSearchBar) _buildInlineSearchBar(),
            _buildUnderlineTabsBar(),
            const Divider(color: _cardBorder, height: 1),
            if (_lastRemovedItem != null) _buildUndoBanner(),
            Expanded(
              child: visible.isEmpty
                  ? _buildEmptyFavouritesState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                      itemCount: visible.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        return _buildFavouriteRowCard(visible[idx]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _stoneGrey,
              size: 24,
            ),
          ),
          const Expanded(
            child: Text(
              'Favourites',
              style: TextStyle(
                color: _offWhite,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                fontFamily: 'Inter',
              ),
            ),
          ),
          IconButton(
            tooltip: 'Search favourites',
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
                if (!_showSearchBar) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
            icon: UlvenikIcon(UlvenikIcons.search,
              color: _showSearchBar ? const Color(0xFF95D3BB) : _stoneGrey,
              size: 23,
            ),
          ),
          IconButton(
            tooltip: 'Sort & filter',
            onPressed: _showSortAndFilterSheet,
            icon: UlvenikIcon(UlvenikIcons.sort,
              color: _selectedDog != 'All Dogs'
                  ? const Color(0xFF95D3BB)
                  : _stoneGrey,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        color: _carbon,
        border: Border(bottom: BorderSide(color: _cardBorder)),
      ),
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(
            color: _offWhite,
            fontSize: 13.5,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            hintText: 'Search starred photos, videos, PDFs...',
            hintStyle: const TextStyle(
              color: _stoneGrey,
              fontSize: 13,
              fontFamily: 'Inter',
            ),
            prefixIcon: const UlvenikIcon(UlvenikIcons.search,
              color: _stoneGrey,
              size: 19,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    icon: const UlvenikIcon(UlvenikIcons.back,
                      color: _stoneGrey,
                      size: 16,
                    ),
                  )
                : null,
            filled: true,
            fillColor: _obsidian,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _forest),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnderlineTabsBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_tabs.length, (idx) {
          final active = idx == _selectedTabIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = idx),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.only(right: 22),
              padding: const EdgeInsets.only(top: 14, bottom: 11),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active ? _forest : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Text(
                _tabs[idx],
                style: TextStyle(
                  color: active ? _offWhite : _stoneGrey,
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUndoBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _favGold.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.goals, color: _favGold, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Removed "${_lastRemovedItem!.title}"',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 12.5,
                fontFamily: 'Inter',
              ),
            ),
          ),
          GestureDetector(
            onTap: _restoreLastRemoved,
            child: const Text(
              'Undo',
              style: TextStyle(
                color: _favGold,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavouriteRowCard(FavouriteMediaEntry item) {
    return GestureDetector(
      onTap: () => _openFavouriteEntry(item),
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            _buildLeftThumbnailWithGoldBadge(item),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 6, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF23292D),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.pillLabel,
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '· ${item.dogName} · ${item.addedAgoLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 12.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: UlvenikIcon(UlvenikIcons.details,
                color: _stoneGrey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftThumbnailWithGoldBadge(FavouriteMediaEntry item) {
    Widget innerContent;
    if (item.assetPath != null) {
      innerContent = Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            item.assetPath!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: _thumbDark),
          ),
          if (item.kind == FavouriteEntryKind.video)
            Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const UlvenikIcon(UlvenikIcons.play,
                  color: _offWhite,
                  size: 18,
                ),
              ),
            ),
        ],
      );
    } else {
      IconData iconData;
      switch (item.kind) {
        case FavouriteEntryKind.document:
          iconData = Icons.description_outlined;
          break;
        case FavouriteEntryKind.goal:
          iconData = Icons.gps_fixed_rounded;
          break;
        case FavouriteEntryKind.trainingSession:
        default:
          iconData = Icons.pets_outlined;
          break;
      }
      innerContent = Container(
        color: _thumbDark,
        child: Center(
          child: UlvenikIcon.fromMaterial(iconData, color: _sage, size: 28),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(13)),
      child: Container(
        width: 88,
        height: double.infinity,
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: _cardBorder)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            innerContent,
            Positioned(
              right: 7,
              bottom: 7,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _unfavouriteItem(item),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: UlvenikIcon(UlvenikIcons.health,
                    color: _favGold,
                    size: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFavouritesState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _favGold.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const UlvenikIcon(UlvenikIcons.health,
                color: _favGold,
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No Favourites in This View',
              style: TextStyle(
                color: _offWhite,
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Starred photos, training videos, and health documents appear here for instant access.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                height: 1.4,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                setState(() {
                  _favourites = List.of(_seedItems);
                  _selectedTabIndex = 0;
                  _selectedDog = 'All Dogs';
                  _searchQuery = '';
                  _searchController.clear();
                  _lastRemovedItem = null;
                });
              },
              child: const Text(
                'Restore Default Favourites',
                style: TextStyle(fontFamily: 'Inter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
