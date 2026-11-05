import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'document_viewer_screen.dart';
import 'photo_viewer_screen.dart';
import 'video_viewer_screen.dart';

enum CollectionEntryType { photo, video, document }

class CollectionMediaEntry {
  final String id;
  final String title;
  final String dateLabel;
  final String dogName;
  final CollectionEntryType type;
  final String badgeText;

  const CollectionMediaEntry({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.dogName,
    required this.type,
    required this.badgeText,
  });
}

class MediaCollectionAlbum {
  final String id;
  String title;
  int itemCount;
  String updatedLabel;
  final DateTime updatedAt;
  final String dogName;
  final String? coverAsset;
  final List<CollectionMediaEntry> previewEntries;
  final bool isCompetition;

  MediaCollectionAlbum({
    required this.id,
    required this.title,
    required this.itemCount,
    required this.updatedLabel,
    required this.updatedAt,
    required this.dogName,
    this.coverAsset,
    required this.previewEntries,
    this.isCompetition = false,
  });
}

class MediaCollectionsScreen extends StatefulWidget {
  final bool hasSportPack;

  const MediaCollectionsScreen({
    super.key,
    this.hasSportPack = true,
  });

  @override
  State<MediaCollectionsScreen> createState() => _MediaCollectionsScreenState();
}

class _MediaCollectionsScreenState extends State<MediaCollectionsScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian; // #101214
  static const Color _carbon = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _cardBorder = AppColors.cardBorder;

  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  String _searchQuery = '';
  String _selectedDogFilter = 'All Dogs';
  String _sortBy = 'Recently Updated';

  late final List<MediaCollectionAlbum> _collections = [
    MediaCollectionAlbum(
      id: 'col_1',
      title: 'Agility Training — Summer',
      itemCount: 24,
      updatedLabel: 'Updated 2 days ago',
      updatedAt: DateTime(2026, 7, 13),
      dogName: 'Freja',
      coverAsset: 'assets/bg-images/onboarding_2.png',
      previewEntries: const [
        CollectionMediaEntry(
          id: 'ce_1',
          title: 'Weave Poles Entry Speed',
          dateLabel: '13 Jul',
          dogName: 'Freja',
          type: CollectionEntryType.video,
          badgeText: '0:45',
        ),
        CollectionMediaEntry(
          id: 'ce_2',
          title: 'A-Frame Contact Zone',
          dateLabel: '12 Jul',
          dogName: 'Freja',
          type: CollectionEntryType.photo,
          badgeText: 'JPG',
        ),
        CollectionMediaEntry(
          id: 'ce_3',
          title: 'Tunnel Exit Tight Turn',
          dateLabel: '10 Jul',
          dogName: 'Freja',
          type: CollectionEntryType.video,
          badgeText: '1:12',
        ),
        CollectionMediaEntry(
          id: 'ce_4',
          title: 'Summer Course Map #4',
          dateLabel: '9 Jul',
          dogName: 'Freja',
          type: CollectionEntryType.document,
          badgeText: 'PDF',
        ),
      ],
    ),
    MediaCollectionAlbum(
      id: 'col_2',
      title: 'Vet Visit Records',
      itemCount: 8,
      updatedLabel: 'Updated 1 week ago',
      updatedAt: DateTime(2026, 7, 8),
      dogName: 'Kodi',
      coverAsset: 'assets/images/photo_viewer_1.jpg',
      previewEntries: const [
        CollectionMediaEntry(
          id: 'ce_5',
          title: 'Vet Report — Annual Clearance',
          dateLabel: '10 Jul',
          dogName: 'Kodi',
          type: CollectionEntryType.document,
          badgeText: 'PDF',
        ),
        CollectionMediaEntry(
          id: 'ce_6',
          title: 'Vaccination Certificate',
          dateLabel: '21 Jun',
          dogName: 'Freja',
          type: CollectionEntryType.document,
          badgeText: 'PDF',
        ),
        CollectionMediaEntry(
          id: 'ce_7',
          title: 'Hip & Elbow Screening',
          dateLabel: '14 Jun',
          dogName: 'Bjørn',
          type: CollectionEntryType.document,
          badgeText: 'PDF',
        ),
        CollectionMediaEntry(
          id: 'ce_8',
          title: 'Gait Symmetry Frame',
          dateLabel: '8 Jul',
          dogName: 'Kodi',
          type: CollectionEntryType.photo,
          badgeText: 'JPG',
        ),
      ],
    ),
    MediaCollectionAlbum(
      id: 'col_3',
      isCompetition: true,
      title: 'Competition Day — Oslo',
      itemCount: 17,
      updatedLabel: 'Updated 3 weeks ago',
      updatedAt: DateTime(2026, 6, 24),
      dogName: 'Kodi',
      coverAsset: 'assets/bg-images/onboarding_1.png',
      previewEntries: const [
        CollectionMediaEntry(
          id: 'ce_9',
          title: 'Oslo Stadium Heelwork Routine',
          dateLabel: '24 Jun',
          dogName: 'Kodi',
          type: CollectionEntryType.video,
          badgeText: '1:34',
        ),
        CollectionMediaEntry(
          id: 'ce_10',
          title: 'Podium Ribbon Portrait',
          dateLabel: '24 Jun',
          dogName: 'Kodi',
          type: CollectionEntryType.photo,
          badgeText: 'JPG',
        ),
        CollectionMediaEntry(
          id: 'ce_11',
          title: 'IGP2 Trial Scorebook',
          dateLabel: '24 Jun',
          dogName: 'Kodi',
          type: CollectionEntryType.document,
          badgeText: 'PDF',
        ),
      ],
    ),
    MediaCollectionAlbum(
      id: 'col_4',
      title: 'Scent & Search Trials',
      isCompetition: true,
      itemCount: 31,
      updatedLabel: 'Updated 1 month ago',
      updatedAt: DateTime(2026, 6, 14),
      dogName: 'Bjørn',
      coverAsset: 'assets/bg-images/onboarding_3.png',
      previewEntries: const [
        CollectionMediaEntry(
          id: 'ce_12',
          title: 'Tracking Exercise — Session 14',
          dateLabel: '14 Jun',
          dogName: 'Kodi',
          type: CollectionEntryType.video,
          badgeText: '1:34',
        ),
        CollectionMediaEntry(
          id: 'ce_13',
          title: 'Dusk Scent Article Setup',
          dateLabel: '12 Jun',
          dogName: 'Bjørn',
          type: CollectionEntryType.photo,
          badgeText: 'JPG',
        ),
        CollectionMediaEntry(
          id: 'ce_14',
          title: '90° Wet Moss Corner',
          dateLabel: '10 Jun',
          dogName: 'Kodi',
          type: CollectionEntryType.photo,
          badgeText: 'JPG',
        ),
      ],
    ),
    MediaCollectionAlbum(
      id: 'col_5',
      title: 'Obedience Notes & Briefs',
      itemCount: 5,
      updatedLabel: 'Updated 2 months ago',
      updatedAt: DateTime(2026, 5, 15),
      dogName: 'Kodi',
      coverAsset: null, // Folder icon card matching Figma 5th row!
      previewEntries: const [
        CollectionMediaEntry(
          id: 'ce_15',
          title: 'IGP2 Trial Scorebook',
          dateLabel: '15 May',
          dogName: 'Kodi',
          type: CollectionEntryType.document,
          badgeText: 'PDF',
        ),
        CollectionMediaEntry(
          id: 'ce_16',
          title: 'Heelwork Pivot Drill',
          dateLabel: '12 May',
          dogName: 'Kodi',
          type: CollectionEntryType.video,
          badgeText: '0:45',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MediaCollectionAlbum> get _filteredCollections {
    final q = _searchQuery.trim().toLowerCase();
    final list = _collections.where((album) {
      if (!widget.hasSportPack && album.isCompetition) {
        return false;
      }
      if (_selectedDogFilter != 'All Dogs' &&
          album.dogName != _selectedDogFilter) {
        return false;
      }
      if (q.isNotEmpty) {
        final matchTitle = album.title.toLowerCase().contains(q);
        final matchDog = album.dogName.toLowerCase().contains(q);
        final matchEntry = album.previewEntries.any(
          (e) => e.title.toLowerCase().contains(q),
        );
        if (!matchTitle && !matchDog && !matchEntry) return false;
      }
      return true;
    }).toList();

    if (_sortBy == 'Most Items') {
      list.sort((a, b) => b.itemCount.compareTo(a.itemCount));
    } else if (_sortBy == 'Alphabetical (A–Z)') {
      list.sort((a, b) => a.title.compareTo(b.title));
    } else {
      list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    return list;
  }

  void _openEntryViewer(CollectionMediaEntry entry) {
    switch (entry.type) {
      case CollectionEntryType.photo:
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => PhotoViewerScreen(overrideTitle: entry.title),
          ),
        );
        break;
      case CollectionEntryType.video:
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => VideoViewerScreen(
              title: entry.title,
              dogName: entry.dogName,
            ),
          ),
        );
        break;
      case CollectionEntryType.document:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DocumentViewerScreen(
              overrideTitle: entry.title,
              dogName: entry.dogName,
              dateLabel: entry.dateLabel,
            ),
          ),
        );
        break;
    }
  }

  void _showSortAndFilterSheet() {
    final sortOptions = [
      'Recently Updated',
      'Most Items',
      'Alphabetical (A–Z)',
    ];
    final dogOptions = ['All Dogs', 'Kodi', 'Freja', 'Bjørn'];

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
                  'Sort & Filter Collections',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'DOG WORKSPACE',
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
                  children: dogOptions.map((dog) {
                    final active = _selectedDogFilter == dog;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedDogFilter = dog);
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
                  'SORT BY',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
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
                        ? const Icon(Icons.check_rounded,
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

  void _showCreateCollectionSheet() {
    final nameController = TextEditingController();
    String selectedDog = 'Kodi';
    int coverChoice = 0; // 0 = Forest Trail, 1 = Alpine Fjord, 2 = Folder Icon
    final coverAssets = <String?>[
      'assets/images/photo_viewer_2.jpg',
      'assets/bg-images/onboarding_1.png',
      null,
    ];
    final coverLabels = ['Trail Cover', 'Fjord Cover', 'Folder Icon'];

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 14,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
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
                'Create Collection',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'COLLECTION NAME',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                autofocus: true,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., Winter Tracking Camp — Bergen',
                  hintStyle: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                  filled: true,
                  fillColor: _obsidian,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _cardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _forest),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'DOG WORKSPACE',
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
                children: ['Kodi', 'Freja', 'Bjørn'].map((dog) {
                  final active = selectedDog == dog;
                  return GestureDetector(
                    onTap: () => setModalState(() => selectedDog = dog),
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
              const SizedBox(height: 14),
              const Text(
                'COVER STYLE',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(3, (idx) {
                  final selected = coverChoice == idx;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: idx < 2 ? 8 : 0),
                      child: GestureDetector(
                        onTap: () => setModalState(() => coverChoice = idx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? _forest.withValues(alpha: 0.22)
                                : _obsidian,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selected ? _forest : _cardBorder,
                            ),
                          ),
                          child: Column(
                            children: [
                              UlvenikIcon.fromMaterial(
                                idx == 2
                                    ? Icons.folder_outlined
                                    : Icons.image_outlined,
                                color: selected
                                    ? const Color(0xFF95D3BB)
                                    : _stoneGrey,
                                size: 18,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coverLabels[idx],
                                style: TextStyle(
                                  color: selected ? _offWhite : _stoneGrey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _offWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final raw = nameController.text.trim();
                    final title = raw.isEmpty
                        ? '$selectedDog Training Collection'
                        : raw;
                    final created = MediaCollectionAlbum(
                      id: 'col_${DateTime.now().millisecondsSinceEpoch}',
                      title: title,
                      itemCount: 3,
                      updatedLabel: 'Updated just now',
                      updatedAt: DateTime(2026, 7, 15),
                      dogName: selectedDog,
                      coverAsset: coverAssets[coverChoice],
                      previewEntries: [
                        CollectionMediaEntry(
                          id: 'new_1',
                          title: '$selectedDog Field Photo',
                          dateLabel: 'Today',
                          dogName: selectedDog,
                          type: CollectionEntryType.photo,
                          badgeText: 'JPG',
                        ),
                        CollectionMediaEntry(
                          id: 'new_2',
                          title: '$selectedDog Session Clip',
                          dateLabel: 'Today',
                          dogName: selectedDog,
                          type: CollectionEntryType.video,
                          badgeText: '0:52',
                        ),
                        CollectionMediaEntry(
                          id: 'new_3',
                          title: '$selectedDog Session Notes',
                          dateLabel: 'Today',
                          dogName: selectedDog,
                          type: CollectionEntryType.document,
                          badgeText: 'PDF',
                        ),
                      ],
                    );
                    setState(() {
                      _collections.insert(0, created);
                    });
                    Navigator.pop(ctx);
                    AppSnackbar.show(
                      context,
                      message: 'Created collection "$title".',
                      type: SnackbarType.success,
                    );
                  },
                  child: const Text(
                    'Create Collection',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCollectionInspector(MediaCollectionAlbum album) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album.title,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 17.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${album.itemCount} items · ${album.updatedLabel} · ${album.dogName}',
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete collection',
                    onPressed: () {
                      setState(() => _collections.remove(album));
                      Navigator.pop(ctx);
                      AppSnackbar.show(
                        context,
                        message: 'Deleted collection "${album.title}".',
                        type: SnackbarType.warning,
                      );
                    },
                    icon: const Icon(Icons.delete_outline_rounded,
                      color: _stoneGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'COLLECTION MEDIA — TAP TO OPEN VIEWER',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 10),
              ...album.previewEntries.map((entry) {
                IconData icon;
                switch (entry.type) {
                  case CollectionEntryType.photo:
                    icon = Icons.photo_outlined;
                    break;
                  case CollectionEntryType.video:
                    icon = Icons.play_circle_outline_rounded;
                    break;
                  case CollectionEntryType.document:
                    icon = Icons.description_outlined;
                    break;
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _openEntryViewer(entry);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _obsidian,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: _forest.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: UlvenikIcon.fromMaterial(
                              icon,
                              color: const Color(0xFF95D3BB),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.title,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${entry.dogName} · ${entry.dateLabel}',
                                  style: const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 11.5,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _carbon,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: _cardBorder),
                            ),
                            child: Text(
                              entry.badgeText,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const UlvenikIcon(UlvenikIcons.details,
                            color: _stoneGrey,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
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
    final visibleAlbums = _filteredCollections;

    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopHeader(),
            const Divider(color: _cardBorder, height: 1),
            if (_showSearchBar) _buildSearchAndFilterBar(),
            Expanded(
              child: visibleAlbums.isEmpty
                  ? _buildEmptySearchState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                      itemCount: visibleAlbums.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        return _buildCollectionCard(visibleAlbums[idx]);
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
              color: _offWhite,
              size: 28,
            ),
          ),
          const Expanded(
            child: Text(
              'Collections',
              style: TextStyle(
                color: _offWhite,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                fontFamily: 'Inter',
              ),
            ),
          ),
          IconButton(
            tooltip: 'Search collections',
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
            tooltip: 'Sort & filter collections',
            onPressed: _showSortAndFilterSheet,
            icon: Icon(Icons.drag_handle_rounded,
              color: _selectedDogFilter != 'All Dogs'
                  ? const Color(0xFF95D3BB)
                  : _stoneGrey,
              size: 23,
            ),
          ),
          IconButton(
            tooltip: 'Create collection',
            onPressed: _showCreateCollectionSheet,
            icon: const UlvenikIcon(UlvenikIcons.add,
              color: _stoneGrey,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: _carbon,
        border: Border(bottom: BorderSide(color: _cardBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
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
                hintText: 'Search collections or media items...',
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
                        icon: const Icon(Icons.close_rounded,
                          color: _stoneGrey,
                          size: 17,
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
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All Dogs', 'Kodi', 'Freja', 'Bjørn'].map((dog) {
                final selected = _selectedDogFilter == dog;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDogFilter = dog),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? _forest.withValues(alpha: 0.24)
                            : _obsidian,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? _forest : _cardBorder,
                        ),
                      ),
                      child: Text(
                        dog,
                        style: TextStyle(
                          color: selected
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
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(MediaCollectionAlbum album) {
    return GestureDetector(
      onTap: () => _openCollectionInspector(album),
      child: Container(
        height: 98,
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(13),
              ),
              child: Container(
                width: 88,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: _carbon,
                  border: Border(
                    right: BorderSide(color: _cardBorder),
                  ),
                ),
                child: album.coverAsset != null
                    ? Image.asset(
                        album.coverAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Center(
                          child: Icon(Icons.folder_outlined,
                            color: _stoneGrey,
                            size: 28,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.folder_outlined,
                          color: _stoneGrey,
                          size: 28,
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      album.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${album.itemCount} items · ${album.updatedLabel}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 13,
                        height: 1.32,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: UlvenikIcon(UlvenikIcons.details,
                color: _stoneGrey,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.folder_off_outlined, color: _stoneGrey, size: 40),
            const SizedBox(height: 12),
            const Text(
              'No matching collections',
              style: TextStyle(
                color: _offWhite,
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try clearing your search filter or tap + to create a new album.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12.5,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
