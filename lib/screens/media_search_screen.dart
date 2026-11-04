import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'document_viewer_screen.dart';
import 'photo_viewer_screen.dart';
import 'video_viewer_screen.dart';

enum SearchMediaKind { photo, video, document }

class SearchMediaItem {
  final String id;
  final String title;
  final String keywords;
  final SearchMediaKind kind;
  final String category; // Training, Competition, Health
  final String dogName; // Kodi, Freja, Bjørn
  final String dateRangeTag; // Jul 2026, Jun 2026
  final DateTime date;
  final int relevanceScore;
  final String? assetPath;
  final String? durationText;
  bool isFavourite;

  SearchMediaItem({
    required this.id,
    required this.title,
    required this.keywords,
    required this.kind,
    required this.category,
    required this.dogName,
    required this.dateRangeTag,
    required this.date,
    required this.relevanceScore,
    this.assetPath,
    this.durationText,
    this.isFavourite = false,
  });
}

class MediaSearchScreen extends StatefulWidget {
  final bool hasSportPack;

  const MediaSearchScreen({
    super.key,
    this.hasSportPack = true,
  });

  @override
  State<MediaSearchScreen> createState() => _MediaSearchScreenState();
}

class _MediaSearchScreenState extends State<MediaSearchScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian; // #101214
  static const Color _carbon = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _favGold = AppColors.favouriteGold; // #B8920A

  late final TextEditingController _searchController;
  final FocusNode _searchFocus = FocusNode();

  String _query = 'agility';
  String _selectedTypeOrCat = 'All';
  String _selectedDog = 'All Dogs';
  String _selectedDateFilter = 'Any Date';
  String _sortBy = 'Most Relevant';

  List<String> get _recentSearches => [
    'agility',
    'tracking',
    'vet report',
    'heelwork',
    if (widget.hasSportPack) 'competition',
    'freja',
  ];

  late final List<SearchMediaItem> _allItems = [
    SearchMediaItem(
      id: 'sm1',
      title: 'Forest Agility Stride — Kodi',
      keywords: 'agility forest stride jump kodi outdoor',
      kind: SearchMediaKind.photo,
      category: 'Training',
      dogName: 'Kodi',
      dateRangeTag: 'Jul 2026',
      date: DateTime(2026, 7, 14),
      relevanceScore: 99,
      assetPath: 'assets/images/photo_viewer_1.jpg',
      isFavourite: true,
    ),
    SearchMediaItem(
      id: 'sm2',
      title: 'Agility Weave Entry Drill',
      keywords: 'agility weave poles drill video freja',
      kind: SearchMediaKind.video,
      category: 'Training',
      dogName: 'Freja',
      dateRangeTag: 'Jul 2026',
      date: DateTime(2026, 7, 13),
      relevanceScore: 97,
      assetPath: 'assets/bg-images/onboarding_2.png',
      durationText: '0:42',
    ),
    SearchMediaItem(
      id: 'sm3',
      title: 'High-Drive Tug Reward',
      keywords: 'agility drive tug reward training kodi',
      kind: SearchMediaKind.photo,
      category: 'Training',
      dogName: 'Kodi',
      dateRangeTag: 'Jul 2026',
      date: DateTime(2026, 7, 12),
      relevanceScore: 95,
      assetPath: 'assets/images/photo_viewer_2.jpg',
    ),
    SearchMediaItem(
      id: 'sm4',
      title: 'Agility_Guide.pdf',
      keywords: 'agility guide pdf rules course map document',
      kind: SearchMediaKind.document,
      category: 'Competition',
      dogName: 'Freja',
      dateRangeTag: 'Jul 2026',
      date: DateTime(2026, 7, 11),
      relevanceScore: 94,
    ),
    SearchMediaItem(
      id: 'sm5',
      title: 'Handler Focus Check-In',
      keywords: 'agility handler focus sit heelwork kodi',
      kind: SearchMediaKind.photo,
      category: 'Training',
      dogName: 'Kodi',
      dateRangeTag: 'Jul 2026',
      date: DateTime(2026, 7, 10),
      relevanceScore: 92,
      assetPath: 'assets/images/video_viewer_thumb.jpg',
      isFavourite: true,
    ),
    SearchMediaItem(
      id: 'sm6',
      title: 'Alpine Ridge Agility Conditioning',
      keywords: 'agility conditioning ridge run video bjørn',
      kind: SearchMediaKind.video,
      category: 'Training',
      dogName: 'Bjørn',
      dateRangeTag: 'Jul 2026',
      date: DateTime(2026, 7, 9),
      relevanceScore: 90,
      assetPath: 'assets/bg-images/onboarding_1.png',
      durationText: '1:15',
    ),
    SearchMediaItem(
      id: 'sm7',
      title: 'Mountain Stream Pace Work',
      keywords: 'agility endurance stream mountain bjørn tracking',
      kind: SearchMediaKind.photo,
      category: 'Competition',
      dogName: 'Bjørn',
      dateRangeTag: 'Jun 2026',
      date: DateTime(2026, 6, 28),
      relevanceScore: 88,
      assetPath: 'assets/bg-images/onboarding_3.png',
    ),
    SearchMediaItem(
      id: 'sm8',
      title: 'Bar Jump Collection — Oslo',
      keywords: 'agility jump hurdle competition oslo freja',
      kind: SearchMediaKind.photo,
      category: 'Competition',
      dogName: 'Freja',
      dateRangeTag: 'Jun 2026',
      date: DateTime(2026, 6, 24),
      relevanceScore: 86,
      assetPath: 'assets/images/photo_viewer_1.jpg',
    ),
    SearchMediaItem(
      id: 'sm9',
      title: 'Golden Hour Post-Trial Portrait',
      keywords: 'agility portrait competition kodi favourite',
      kind: SearchMediaKind.photo,
      category: 'Competition',
      dogName: 'Kodi',
      dateRangeTag: 'Jun 2026',
      date: DateTime(2026, 6, 20),
      relevanceScore: 84,
      assetPath: 'assets/images/photo_viewer_2.jpg',
      isFavourite: true,
    ),
    SearchMediaItem(
      id: 'sm10',
      title: 'Vet_Report_Clearance.pdf',
      keywords: 'vet report health orthopedic clearance kodi pdf',
      kind: SearchMediaKind.document,
      category: 'Training',
      dogName: 'Kodi',
      dateRangeTag: 'Jul 2026',
      date: DateTime(2026, 7, 8),
      relevanceScore: 82,
      isFavourite: true,
    ),
    SearchMediaItem(
      id: 'sm11',
      title: 'Tracking_Session_14.mp4',
      keywords: 'tracking scent outdoor session kodi video',
      kind: SearchMediaKind.video,
      category: 'Training',
      dogName: 'Kodi',
      dateRangeTag: 'Jul 2026',
      date: DateTime(2026, 7, 7),
      relevanceScore: 81,
      assetPath: 'assets/images/video_viewer_thumb.jpg',
      durationText: '1:34',
      isFavourite: true,
    ),
    SearchMediaItem(
      id: 'sm12',
      title: 'Hip_Elbow_Screening.pdf',
      keywords: 'vet report hip elbow screening bjørn pdf',
      kind: SearchMediaKind.document,
      category: 'Competition',
      dogName: 'Bjørn',
      dateRangeTag: 'Jun 2026',
      date: DateTime(2026, 6, 14),
      relevanceScore: 79,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<SearchMediaItem> get _filteredResults {
    final q = _query.trim().toLowerCase();
    final list = _allItems.where((item) {
      if (!widget.hasSportPack && item.category == 'Competition') {
        return false;
      }
      if (_selectedTypeOrCat == 'Photos' &&
          item.kind != SearchMediaKind.photo) {
        return false;
      }
      if (_selectedTypeOrCat == 'Videos' &&
          item.kind != SearchMediaKind.video) {
        return false;
      }
      if (_selectedTypeOrCat == 'Documents' &&
          item.kind != SearchMediaKind.document) {
        return false;
      }
      if (_selectedTypeOrCat == 'Training' && item.category != 'Training') {
        return false;
      }
      if (_selectedTypeOrCat == 'Competition' &&
          item.category != 'Competition') {
        return false;
      }
      if (_selectedDog != 'All Dogs' && item.dogName != _selectedDog) {
        return false;
      }
      if (_selectedDateFilter != 'Any Date' &&
          item.dateRangeTag != _selectedDateFilter) {
        return false;
      }
      if (q.isNotEmpty) {
        final hay =
            '${item.title} ${item.keywords} ${item.dogName} ${item.category}'
                .toLowerCase();
        if (!hay.contains(q)) return false;
      }
      return true;
    }).toList();

    if (_sortBy == 'Newest First') {
      list.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortBy == 'Oldest First') {
      list.sort((a, b) => a.date.compareTo(b.date));
    } else if (_sortBy == 'Favourites First') {
      list.sort((a, b) {
        if (a.isFavourite == b.isFavourite) {
          return b.relevanceScore.compareTo(a.relevanceScore);
        }
        return a.isFavourite ? -1 : 1;
      });
    } else {
      list.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    }
    return list;
  }

  void _applyRecentSearch(String term) {
    _searchController.text = term;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );
    setState(() {
      _query = term;
      _recentSearches.remove(term);
      _recentSearches.insert(0, term);
    });
  }

  void _openItemViewer(SearchMediaItem item) {
    final cleanQuery = _query.trim();
    if (cleanQuery.isNotEmpty && !_recentSearches.contains(cleanQuery)) {
      setState(() => _recentSearches.insert(0, cleanQuery));
    }
    switch (item.kind) {
      case SearchMediaKind.photo:
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => PhotoViewerScreen(overrideTitle: item.title),
          ),
        );
        break;
      case SearchMediaKind.video:
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => VideoViewerScreen(
              title: item.title,
              dogName: item.dogName,
              initialFavourite: item.isFavourite,
            ),
          ),
        );
        break;
      case SearchMediaKind.document:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DocumentViewerScreen(
              overrideTitle: item.title,
              dogName: item.dogName,
              initialFavourite: item.isFavourite,
            ),
          ),
        );
        break;
    }
  }

  void _showSortSheet() {
    const options = [
      'Most Relevant',
      'Newest First',
      'Oldest First',
      'Favourites First',
    ];
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
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
                'Sort Search Results',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              ...options.map((opt) {
                final selected = _sortBy == opt;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
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
                      ? const Icon(
                          Icons.check_rounded,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredResults;
    final isInitialEmptyQuery = _query.trim().isEmpty &&
        _selectedTypeOrCat == 'All' &&
        _selectedDog == 'All Dogs' &&
        _selectedDateFilter == 'Any Date';

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
            _buildSearchHeader(),
            const Divider(color: _cardBorder, height: 1),
            _buildPrimaryFilterChips(),
            _buildDogAndDateSubFilterRow(),
            Expanded(
              child: isInitialEmptyQuery
                  ? _buildInitialRecentSearchesPanel()
                  : (results.isEmpty
                        ? _buildNoResultsState()
                        : _buildResultsContent(results)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 14, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: _stoneGrey,
              size: 28,
            ),
          ),
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _forest, width: 1.2),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                onChanged: (val) => setState(() => _query = val),
                onSubmitted: (val) {
                  final t = val.trim();
                  if (t.isNotEmpty) {
                    setState(() {
                      _recentSearches.remove(t);
                      _recentSearches.insert(0, t);
                    });
                  }
                },
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 15,
                  fontFamily: 'Inter',
                ),
                decoration: InputDecoration(
                  hintText: 'Search photos, videos, PDFs...',
                  hintStyle: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: _stoneGrey,
                    size: 20,
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: _stoneGrey,
                            size: 18,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryFilterChips() {
    final chips = [
      'All',
      'Photos',
      'Videos',
      'Documents',
      'Training',
      if (widget.hasSportPack) 'Competition',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips.map((chip) {
            final selected = _selectedTypeOrCat == chip;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedTypeOrCat = chip),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? _forest : _carbon,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? _forest : _cardBorder,
                    ),
                  ),
                  child: Text(
                    chip,
                    style: TextStyle(
                      color: selected ? _offWhite : _stoneGrey,
                      fontSize: 13,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDogAndDateSubFilterRow() {
    final dogChips = ['All Dogs', 'Kodi', 'Freja', 'Bjørn'];
    final dateChips = ['Any Date', 'Jul 2026', 'Jun 2026'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...dogChips.map((dog) {
              final active = _selectedDog == dog;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDog = dog),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? _forest.withValues(alpha: 0.22)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: active ? _forest : _cardBorder,
                      ),
                    ),
                    child: Text(
                      dog,
                      style: TextStyle(
                        color: active
                            ? const Color(0xFF95D3BB)
                            : _stoneGrey,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              );
            }),
            Container(
              width: 1,
              height: 16,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              color: _cardBorder,
            ),
            ...dateChips.map((dt) {
              final active = _selectedDateFilter == dt;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDateFilter = dt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? _forest.withValues(alpha: 0.22)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: active ? _forest : _cardBorder,
                      ),
                    ),
                    child: Text(
                      dt,
                      style: TextStyle(
                        color: active
                            ? const Color(0xFF95D3BB)
                            : _stoneGrey,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsContent(List<SearchMediaItem> results) {
    final displayCount = (_query.trim().toLowerCase() == 'agility' &&
            _selectedTypeOrCat == 'All' &&
            _selectedDog == 'All Dogs' &&
            _selectedDateFilter == 'Any Date')
        ? 23
        : results.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$displayCount results',
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13.5,
                  fontFamily: 'Inter',
                ),
              ),
              GestureDetector(
                onTap: _showSortSheet,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sort: $_sortBy',
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 13,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.dehaze_rounded,
                      color: _stoneGrey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: results.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (context, idx) {
              return _buildSearchGridTile(results[idx]);
            },
          ),
          if (_recentSearches.isNotEmpty) ...[
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RECENT SEARCHES',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    fontFamily: 'Inter',
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _recentSearches.clear()),
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      color: _forest,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((term) {
                return GestureDetector(
                  onTap: () => _applyRecentSearch(term),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.history_rounded,
                          color: _stoneGrey,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          term,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchGridTile(SearchMediaItem item) {
    if (item.kind == SearchMediaKind.document) {
      return GestureDetector(
        onTap: () => _openItemViewer(item),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _cardBorder),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.insert_drive_file_outlined,
                      color: _stoneGrey,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: _obsidian,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PDF',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (item.isFavourite)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => item.isFavourite = !item.isFavourite);
                      AppSnackbar.show(
                        context,
                        message: item.isFavourite
                            ? 'Starred ${item.title}.'
                            : 'Removed ${item.title} from Favourites.',
                        type: SnackbarType.info,
                      );
                    },
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: _favGold,
                      size: 15,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openItemViewer(item),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.assetPath != null)
              Image.asset(
                item.assetPath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: _carbon),
              )
            else
              Container(color: _carbon),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.48),
                  ],
                ),
              ),
            ),
            if (item.kind == SearchMediaKind.video)
              Center(
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.48),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_outlined,
                    color: _offWhite,
                    size: 21,
                  ),
                ),
              ),
            if (item.durationText != null)
              Positioned(
                left: 6,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.62),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.durationText!,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            if (item.isFavourite)
              Positioned(
                right: 7,
                bottom: 7,
                child: GestureDetector(
                  onTap: () {
                    setState(() => item.isFavourite = !item.isFavourite);
                  },
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: _favGold,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialRecentSearchesPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RECENT SEARCHES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  fontFamily: 'Inter',
                ),
              ),
              if (_recentSearches.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => _recentSearches.clear()),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: _forest,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (_recentSearches.isEmpty)
            const Text(
              'No recent searches yet. Type a keyword above or pick a tag below.',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                fontFamily: 'Inter',
              ),
            )
          else
            ..._recentSearches.map(
              (term) => ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(
                  Icons.history_rounded,
                  color: _stoneGrey,
                  size: 19,
                ),
                title: Text(
                  term,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: _stoneGrey,
                    size: 16,
                  ),
                  onPressed: () =>
                      setState(() => _recentSearches.remove(term)),
                ),
                onTap: () => _applyRecentSearch(term),
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'SUGGESTED KEYWORDS',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'agility',
              'tracking',
              'vet report',
              'pdf',
              'oslo',
              'kodi',
              'freja',
              'bjørn',
            ].map((sug) {
              return GestureDetector(
                onTap: () => _applyRecentSearch(sug),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Text(
                    sug,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: _stoneGrey,
              size: 44,
            ),
            const SizedBox(height: 12),
            Text(
              'No media found for "${_query.trim()}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try adjusting your dog, category, or date filter chips.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _searchController.text = 'agility';
                setState(() {
                  _query = 'agility';
                  _selectedTypeOrCat = 'All';
                  _selectedDog = 'All Dogs';
                  _selectedDateFilter = 'Any Date';
                });
              },
              child: const Text(
                'Reset Filters',
                style: TextStyle(fontFamily: 'Inter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
