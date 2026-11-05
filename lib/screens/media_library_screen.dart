import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'document_viewer_screen.dart';
import 'media_collections_screen.dart';
import 'media_favourites_screen.dart';
import 'media_search_screen.dart';
import 'media_upload_manager_screen.dart';
import 'photo_viewer_screen.dart';
import 'storage_manager_screen.dart';
import 'video_viewer_screen.dart';

enum MediaItemKind { photo, video, document }

class MediaLibraryItem {
  final String id;
  final String title;
  final String dateLabel;
  final DateTime sortDate;
  final MediaItemKind kind;
  final String? durationLabel;
  final String? docTypeLabel;
  final String dogName;
  final String categoryTag;
  final double sizeMb;
  final Color bgTop;
  final Color bgBottom;
  final int mountainVariant; // 0 = none, 1 = twin peaks, 2 = single peak
  bool isFavourite;

  MediaLibraryItem({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.sortDate,
    required this.kind,
    this.durationLabel,
    this.docTypeLabel,
    required this.dogName,
    required this.categoryTag,
    required this.sizeMb,
    required this.bgTop,
    required this.bgBottom,
    this.mountainVariant = 0,
    this.isFavourite = false,
  });
}

class MediaLibraryScreen extends StatefulWidget {
  final bool hasSportPack;

  const MediaLibraryScreen({
    super.key,
    this.hasSportPack = true,
  });

  @override
  State<MediaLibraryScreen> createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends State<MediaLibraryScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian;
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _sage = AppColors.secondarySage;
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _favGold = AppColors.favouriteGold;

  int _selectedTabIndex = 0; // 0: All, 1: Photos, 2: Videos, 3: Documents
  String _selectedDogFilter = 'All Dogs';
  String _sortBy = 'Newest First';
  bool _onlyFavourites = false;

  late final List<MediaLibraryItem> _items = [
    MediaLibraryItem(
      id: 'm1',
      title: 'Forest Trail Recall — Kodi',
      dateLabel: '14 Jul',
      sortDate: DateTime(2026, 7, 14),
      kind: MediaItemKind.photo,
      dogName: 'Kodi',
      categoryTag: 'Obedience',
      sizeMb: 4.8,
      bgTop: const Color(0xFF1F2B24),
      bgBottom: const Color(0xFF17211B),
      mountainVariant: 1,
      isFavourite: true,
    ),
    MediaLibraryItem(
      id: 'm2',
      title: 'Heelwork Pivot Drill',
      dateLabel: '13 Jul',
      sortDate: DateTime(2026, 7, 13),
      kind: MediaItemKind.video,
      durationLabel: '0:45',
      dogName: 'Kodi',
      categoryTag: 'Heelwork',
      sizeMb: 68.4,
      bgTop: const Color(0xFF182026),
      bgBottom: const Color(0xFF131A1F),
      mountainVariant: 2,
    ),
    MediaLibraryItem(
      id: 'm3',
      title: 'Alpine Ridge Conditioning',
      dateLabel: '12 Jul',
      sortDate: DateTime(2026, 7, 12),
      kind: MediaItemKind.photo,
      dogName: 'Freja',
      categoryTag: 'Conditioning',
      sizeMb: 5.2,
      bgTop: const Color(0xFF19251E),
      bgBottom: const Color(0xFF131D17),
      mountainVariant: 2,
    ),
    MediaLibraryItem(
      id: 'm4',
      title: 'Dusk Scent Article Setup',
      dateLabel: '11 Jul',
      sortDate: DateTime(2026, 7, 11),
      kind: MediaItemKind.photo,
      dogName: 'Bjørn',
      categoryTag: 'Tracking',
      sizeMb: 3.9,
      bgTop: const Color(0xFF1C2329),
      bgBottom: const Color(0xFF151B20),
    ),
    MediaLibraryItem(
      id: 'm5',
      title: 'Vet Report',
      dateLabel: '10 Jul',
      sortDate: DateTime(2026, 7, 10),
      kind: MediaItemKind.document,
      docTypeLabel: 'PDF',
      dogName: 'Kodi',
      categoryTag: 'Health',
      sizeMb: 2.4,
      bgTop: const Color(0xFF1D2226),
      bgBottom: const Color(0xFF181D21),
    ),
    MediaLibraryItem(
      id: 'm6',
      title: 'Long-Line Impulse Control',
      dateLabel: '9 Jul',
      sortDate: DateTime(2026, 7, 9),
      kind: MediaItemKind.video,
      durationLabel: '1:20',
      dogName: 'Freja',
      categoryTag: 'Recall',
      sizeMb: 124.0,
      bgTop: const Color(0xFF162222),
      bgBottom: const Color(0xFF111B1B),
      isFavourite: true,
    ),
    MediaLibraryItem(
      id: 'm7',
      title: 'Balance Pad Core Hold',
      dateLabel: '8 Jul',
      sortDate: DateTime(2026, 7, 8),
      kind: MediaItemKind.photo,
      dogName: 'Kodi',
      categoryTag: 'S&C',
      sizeMb: 4.1,
      bgTop: const Color(0xFF18241E),
      bgBottom: const Color(0xFF131D18),
    ),
    MediaLibraryItem(
      id: 'm8',
      title: 'Post-Swim Coat Check',
      dateLabel: '6 Jul',
      sortDate: DateTime(2026, 7, 6),
      kind: MediaItemKind.photo,
      dogName: 'Bjørn',
      categoryTag: 'Hydro',
      sizeMb: 3.6,
      bgTop: const Color(0xFF1B2025),
      bgBottom: const Color(0xFF15191E),
    ),
    MediaLibraryItem(
      id: 'm9',
      title: 'weave Poles Entry Speed',
      dateLabel: '5 Jul',
      sortDate: DateTime(2026, 7, 5),
      kind: MediaItemKind.video,
      durationLabel: '0:24',
      dogName: 'Freja',
      categoryTag: 'Agility',
      sizeMb: 42.5,
      bgTop: const Color(0xFF172125),
      bgBottom: const Color(0xFF121A1D),
    ),
    MediaLibraryItem(
      id: 'm10',
      title: 'Morning Meadow Stay',
      dateLabel: '4 Jul',
      sortDate: DateTime(2026, 7, 4),
      kind: MediaItemKind.photo,
      dogName: 'Kodi',
      categoryTag: 'Obedience',
      sizeMb: 4.4,
      bgTop: const Color(0xFF17221D),
      bgBottom: const Color(0xFF121B17),
    ),
    MediaLibraryItem(
      id: 'm11',
      title: 'Cavaletti Stride Spacing',
      dateLabel: '2 Jul',
      sortDate: DateTime(2026, 7, 2),
      kind: MediaItemKind.photo,
      dogName: 'Freja',
      categoryTag: 'S&C',
      sizeMb: 4.0,
      bgTop: const Color(0xFF16211B),
      bgBottom: const Color(0xFF111A15),
    ),
    MediaLibraryItem(
      id: 'm12',
      title: 'Fjord Trail Summit',
      dateLabel: '28 Jun',
      sortDate: DateTime(2026, 6, 28),
      kind: MediaItemKind.photo,
      dogName: 'Bjørn',
      categoryTag: 'Endurance',
      sizeMb: 5.7,
      bgTop: const Color(0xFF18221D),
      bgBottom: const Color(0xFF131B17),
    ),
    MediaLibraryItem(
      id: 'm13',
      title: 'Vaccination Certificate',
      dateLabel: '21 Jun',
      sortDate: DateTime(2026, 6, 21),
      kind: MediaItemKind.document,
      docTypeLabel: 'PDF',
      dogName: 'Freja',
      categoryTag: 'Health',
      sizeMb: 1.8,
      bgTop: const Color(0xFF1D2226),
      bgBottom: const Color(0xFF181D21),
    ),
    MediaLibraryItem(
      id: 'm14',
      title: 'Hip & Elbow Screening',
      dateLabel: '14 Jun',
      sortDate: DateTime(2026, 6, 14),
      kind: MediaItemKind.document,
      docTypeLabel: 'PDF',
      dogName: 'Bjørn',
      categoryTag: 'Health',
      sizeMb: 3.2,
      bgTop: const Color(0xFF1D2226),
      bgBottom: const Color(0xFF181D21),
      isFavourite: true,
    ),
  ];

  List<MediaLibraryItem> get _filteredItems {
    final list = _items.where((item) {
      if (_selectedTabIndex == 1 && item.kind != MediaItemKind.photo) {
        return false;
      }
      if (_selectedTabIndex == 2 && item.kind != MediaItemKind.video) {
        return false;
      }
      if (_selectedTabIndex == 3 && item.kind != MediaItemKind.document) {
        return false;
      }
      if (_selectedDogFilter != 'All Dogs' &&
          item.dogName != _selectedDogFilter) {
        return false;
      }
      if (_onlyFavourites && !item.isFavourite) {
        return false;
      }
      return true;
    }).toList();

    switch (_sortBy) {
      case 'Oldest First':
        list.sort((a, b) => a.sortDate.compareTo(b.sortDate));
        break;
      case 'Largest Size':
        list.sort((a, b) => b.sizeMb.compareTo(a.sizeMb));
        break;
      default:
        list.sort((a, b) => b.sortDate.compareTo(a.sortDate));
    }
    return list;
  }

  int _parseDurationSeconds(String? durationLabel) {
    if (durationLabel == null || !durationLabel.contains(':')) return 60;
    final parts = durationLabel.split(':');
    final mins = int.tryParse(parts[0]) ?? 0;
    final secs = int.tryParse(parts[1]) ?? 45;
    return mins * 60 + secs;
  }

  void _openItem(MediaLibraryItem item) {
    switch (item.kind) {
      case MediaItemKind.photo:
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => PhotoViewerScreen(overrideTitle: item.title),
          ),
        );
        break;
      case MediaItemKind.video:
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => VideoViewerScreen(
              title: item.title,
              fullDate: '${item.dateLabel} 2026',
              dogName: item.dogName,
              activity: item.categoryTag,
              durationSeconds: _parseDurationSeconds(item.durationLabel),
              resolutionAndSize: '1080p · ${item.sizeMb.toStringAsFixed(1)} MB',
              initialFavourite: item.isFavourite,
            ),
          ),
        );
        break;
      case MediaItemKind.document:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DocumentViewerScreen(
              overrideTitle: item.title,
              dogName: item.dogName,
              dateLabel: item.dateLabel,
              initialFavourite: item.isFavourite,
            ),
          ),
        );
        break;
    }
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaSearchScreen(hasSportPack: widget.hasSportPack),
      ),
    );
  }

  void _openUploadManager() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaUploadManagerScreen(hasSportPack: widget.hasSportPack),
      ),
    );
  }

  void _openCollections() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaCollectionsScreen(hasSportPack: widget.hasSportPack),
      ),
    );
  }

  void _openStorageManager() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StorageManagerScreen()),
    );
  }

  void _openFavourites() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaFavouritesScreen(hasSportPack: widget.hasSportPack),
      ),
    );
  }

  void _toggleFavourite(MediaLibraryItem item) {
    setState(() {
      item.isFavourite = !item.isFavourite;
    });
    AppSnackbar.show(
      context,
      title: item.isFavourite ? 'Added to Favourites' : 'Removed from Favourites',
      message: item.title,
      type: item.isFavourite ? SnackbarType.success : SnackbarType.info,
    );
  }

  void _showLibraryToolsSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stoneGrey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Media Library Tools',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Manage uploads, collections, favourites, and device storage',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHubOptionTile(
                  icon: Icons.cloud_upload_outlined,
                  iconColor: _forest,
                  title: 'Media Upload Manager',
                  subtitle: '2 active uploads · Queue & sync history',
                  onTap: () {
                    Navigator.pop(ctx);
                    _openUploadManager();
                  },
                ),
                const SizedBox(height: 8),
                _buildHubOptionTile(
                  icon: Icons.collections_bookmark_outlined,
                  iconColor: AppColors.infoAlpineBlue,
                  title: 'Media Collections',
                  subtitle: 'Smart albums & curated training folders',
                  onTap: () {
                    Navigator.pop(ctx);
                    _openCollections();
                  },
                ),
                const SizedBox(height: 8),
                _buildHubOptionTile(
                  icon: Icons.favorite_rounded,
                  iconColor: _favGold,
                  title: 'Favourites',
                  subtitle:
                      '${_items.where((e) => e.isFavourite).length} starred photos, videos & documents',
                  onTap: () {
                    Navigator.pop(ctx);
                    _openFavourites();
                  },
                ),
                const SizedBox(height: 8),
                _buildHubOptionTile(
                  icon: Icons.pie_chart_outline_rounded,
                  iconColor: _sage,
                  title: 'Storage Manager',
                  subtitle: '2.4 GB used · Breakdown & cache cleanup',
                  onTap: () {
                    Navigator.pop(ctx);
                    _openStorageManager();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHubOptionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _obsidian,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: UlvenikIcon.fromMaterial(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const UlvenikIcon(UlvenikIcons.details,
                color: _stoneGrey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final dogs = ['All Dogs', 'Kodi', 'Freja', 'Bjørn'];
            final sorts = ['Newest First', 'Oldest First', 'Largest Size'];
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _stoneGrey.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter & Sort Media',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _offWhite,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _selectedDogFilter = 'All Dogs';
                              _sortBy = 'Newest First';
                              _onlyFavourites = false;
                            });
                            setState(() {});
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _forest,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'DOG WORKSPACE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: dogs.map((dog) {
                        final selected = _selectedDogFilter == dog;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => _selectedDogFilter = dog);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _forest.withValues(alpha: 0.22)
                                  : _obsidian,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? _forest : _cardBorder,
                              ),
                            ),
                            child: Text(
                              dog,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: selected ? _offWhite : _stoneGrey,
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
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sorts.map((s) {
                        final selected = _sortBy == s;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => _sortBy = s);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _forest.withValues(alpha: 0.22)
                                  : _obsidian,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? _forest : _cardBorder,
                              ),
                            ),
                            child: Text(
                              s,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: selected ? _offWhite : _stoneGrey,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: const Text(
                        'Starred / Favourites Only',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _offWhite,
                        ),
                      ),
                      value: _onlyFavourites,
                      onChanged: (v) {
                        setModalState(() => _onlyFavourites = v);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showItemContextSheet(MediaLibraryItem item) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stoneGrey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.dogName} · ${item.categoryTag} · ${item.dateLabel} · ${item.sizeMb.toStringAsFixed(1)} MB',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: UlvenikIcon.fromMaterial(
                    item.isFavourite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: _favGold,
                  ),
                  title: Text(
                    item.isFavourite
                        ? 'Remove from Favourites'
                        : 'Add to Favourites',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: _offWhite,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _toggleFavourite(item);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const UlvenikIcon(UlvenikIcons.skills,
                    color: _stoneGrey,
                  ),
                  title: const Text(
                    'Add to Collection',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: _offWhite,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openCollections();
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const UlvenikIcon(UlvenikIcons.back,
                    color: AppColors.errorDestructive,
                  ),
                  title: const Text(
                    'Delete Media',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.errorDestructive,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _items.removeWhere((e) => e.id == item.id));
                    AppSnackbar.show(
                      context,
                      title: 'Media Deleted',
                      message: '${item.title} moved to trash.',
                      type: SnackbarType.warning,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _filteredItems;
    final hasActiveFilters =
        _selectedDogFilter != 'All Dogs' || _onlyFavourites || _sortBy != 'Newest First';

    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopAppBar(hasActiveFilters),
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'MEDIA LIBRARY',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                  color: _stoneGrey,
                                ),
                              ),
                              if (hasActiveFilters)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedDogFilter = 'All Dogs';
                                      _sortBy = 'Newest First';
                                      _onlyFavourites = false;
                                    });
                                  },
                                  child: Text(
                                    '$_selectedDogFilter${_onlyFavourites ? ' · ★' : ''} · Clear',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _forest,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildSummaryCard(),
                          const SizedBox(height: 12),
                          _buildQuickHubPills(),
                          const SizedBox(height: 16),
                          _buildCategoryTabs(),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                  if (visibleItems.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              UlvenikIcon(UlvenikIcons.play,
                                size: 42,
                                color: _stoneGrey.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No matching media items',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _offWhite,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Adjust your category tab or active workspace filter.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: _stoneGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.96,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildGridTile(visibleItems[index]),
                          childCount: visibleItems.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(bool hasActiveFilters) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          bottom: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _stoneGrey,
              size: 26,
            ),
            splashRadius: 20,
            tooltip: 'Back',
          ),
          const SizedBox(width: 2),
          const Expanded(
            child: Text(
              'Media Library',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.2,
              ),
            ),
          ),
          IconButton(
            onPressed: _openSearch,
            icon: const UlvenikIcon(UlvenikIcons.search,
              color: _stoneGrey,
              size: 21,
            ),
            splashRadius: 20,
            tooltip: 'Search Media',
          ),
          IconButton(
            onPressed: _showLibraryToolsSheet,
            icon: const UlvenikIcon(UlvenikIcons.sort,
              color: _stoneGrey,
              size: 21,
            ),
            splashRadius: 20,
            tooltip: 'Library Tools',
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: _showFilterSortSheet,
                icon: UlvenikIcon(UlvenikIcons.sort,
                  color: hasActiveFilters ? _forest : _stoneGrey,
                  size: 21,
                ),
                splashRadius: 20,
                tooltip: 'Filter & Sort',
              ),
              if (hasActiveFilters)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: _forest,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildKpiColumn(
                value: '147',
                label: 'PHOTOS',
                isSelected: _selectedTabIndex == 1,
                onTap: () => setState(() => _selectedTabIndex = 1),
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _buildKpiColumn(
                value: '34',
                label: 'VIDEOS',
                isSelected: _selectedTabIndex == 2,
                onTap: () => setState(() => _selectedTabIndex = 2),
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _buildKpiColumn(
                value: '12',
                label: 'DOCS',
                isSelected: _selectedTabIndex == 3,
                onTap: () => setState(() => _selectedTabIndex = 3),
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _buildKpiColumn(
                value: '2.4 GB',
                label: 'STORAGE',
                isSelected: false,
                onTap: _openStorageManager,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHubPills() {
    final actions = [
      (Icons.cloud_upload_outlined, 'Media Uploads', _openUploadManager),
      (Icons.collections_bookmark_outlined, 'Collections', _openCollections),
      (Icons.favorite_border_rounded, 'Favourites', _openFavourites),
      (Icons.pie_chart_outline_rounded, 'Storage', _openStorageManager),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: actions.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: entry.$3,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UlvenikIcon.fromMaterial(entry.$1, color: const Color(0xFF95D3BB), size: 15),
                    const SizedBox(width: 6),
                    Text(
                      entry.$2,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _offWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 36,
      color: _cardBorder,
    );
  }

  Widget _buildKpiColumn({
    required String value,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: _offWhite,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: isSelected ? _forest : _stoneGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    const tabs = ['All', 'Photos', 'Videos', 'Documents'];
    return Row(
      children: List.generate(tabs.length, (i) {
        final selected = _selectedTabIndex == i;
        return Padding(
          padding: const EdgeInsets.only(right: 22),
          child: GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = i),
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tabs[i],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? const Color(0xFF4C9B80) : _stoneGrey,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 2,
                  width: selected ? (i == 0 ? 18.0 : 44.0) : 0,
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGridTile(MediaLibraryItem item) {
    if (item.kind == MediaItemKind.document) {
      return GestureDetector(
        onTap: () => _openItem(item),
        onLongPress: () => _showItemContextSheet(item),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1B2024),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _cardBorder),
          ),
          child: Stack(
            children: [
              if (item.isFavourite)
                Positioned(
                  top: 7,
                  left: 7,
                  child: GestureDetector(
                    onTap: () => _toggleFavourite(item),
                    child: const UlvenikIcon(UlvenikIcons.health,
                      color: _favGold,
                      size: 14,
                    ),
                  ),
                ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UlvenikIcon(UlvenikIcons.training,
                      color: _sage.withValues(alpha: 0.9),
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.docTypeLabel ?? 'PDF',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _stoneGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 7,
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: _stoneGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openItem(item),
      onLongPress: () => _showItemContextSheet(item),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [item.bgTop, item.bgBottom],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _cardBorder),
          ),
          child: Stack(
            children: [
              if (item.mountainVariant > 0)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MountainSilhouettePainter(
                      variant: item.mountainVariant,
                      tint: item.kind == MediaItemKind.video
                          ? const Color(0xFF22303A)
                          : const Color(0xFF233329),
                    ),
                  ),
                ),
              if (item.isFavourite)
                Positioned(
                  top: 7,
                  left: 7,
                  child: GestureDetector(
                    onTap: () => _toggleFavourite(item),
                    child: const UlvenikIcon(UlvenikIcons.health,
                      color: _favGold,
                      size: 14,
                    ),
                  ),
                ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.42),
                    shape: BoxShape.circle,
                  ),
                  child: UlvenikIcon.fromMaterial(
                    item.kind == MediaItemKind.video
                        ? Icons.play_circle_outline_rounded
                        : Icons.image_outlined,
                    color: _offWhite.withValues(alpha: 0.9),
                    size: 13,
                  ),
                ),
              ),
              if (item.kind == MediaItemKind.video &&
                  item.durationLabel != null) ...[
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: _buildTilePill(item.durationLabel!),
                ),
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: _buildTilePill(
                    item.dateLabel,
                    textColor: _stoneGrey,
                  ),
                ),
              ] else
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: _buildTilePill(item.dateLabel),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTilePill(String text, {Color textColor = _offWhite}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _MountainSilhouettePainter extends CustomPainter {
  final int variant;
  final Color tint;

  const _MountainSilhouettePainter({
    required this.variant,
    required this.tint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = tint.withValues(alpha: 0.48)
      ..style = PaintingStyle.fill;

    if (variant == 1) {
      final leftPeak = Path()
        ..moveTo(size.width * 0.06, size.height)
        ..lineTo(size.width * 0.34, size.height * 0.48)
        ..lineTo(size.width * 0.62, size.height)
        ..close();
      final rightPeak = Path()
        ..moveTo(size.width * 0.38, size.height)
        ..lineTo(size.width * 0.72, size.height * 0.36)
        ..lineTo(size.width * 0.98, size.height)
        ..close();
      canvas.drawPath(leftPeak, paint);
      canvas.drawPath(rightPeak, paint);
    } else {
      final centerPeak = Path()
        ..moveTo(size.width * 0.14, size.height)
        ..lineTo(size.width * 0.56, size.height * 0.34)
        ..lineTo(size.width * 0.94, size.height)
        ..close();
      canvas.drawPath(centerPeak, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MountainSilhouettePainter oldDelegate) {
    return oldDelegate.variant != variant || oldDelegate.tint != tint;
  }
}
