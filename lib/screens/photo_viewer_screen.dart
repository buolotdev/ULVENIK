import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class PhotoSlideItem {
  final String id;
  final String headerTitle;
  final String cardTitle;
  final String shortDate;
  final String fullDate;
  final String timeLabel;
  final String dogName;
  final String activity;
  final String dimensionsAndSize;
  final String assetPath;
  String notes;
  final List<String> tags;
  final String cameraModel;
  final String lensAndExposure;
  final String gpsCoordinates;
  bool isFavourite;

  PhotoSlideItem({
    required this.id,
    required this.headerTitle,
    required this.cardTitle,
    required this.shortDate,
    required this.fullDate,
    required this.timeLabel,
    required this.dogName,
    required this.activity,
    required this.dimensionsAndSize,
    required this.assetPath,
    required this.notes,
    required this.tags,
    required this.cameraModel,
    required this.lensAndExposure,
    required this.gpsCoordinates,
    this.isFavourite = false,
  });
}

class PhotoViewerScreen extends StatefulWidget {
  final int initialIndex;
  final String? overrideTitle;
  final bool hasSportPack;

  const PhotoViewerScreen({
    super.key,
    this.initialIndex = 2, // "3 of 12" in Figma
    this.overrideTitle,
    this.hasSportPack = true,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  static const Color _black = AppColors.mediaViewerBackground; // #000000
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _favGold = AppColors.favouriteGold; // #B8920A

  late final PageController _pageController;
  final TransformationController _zoomController = TransformationController();
  late int _currentIndex;
  bool _isZoomed = false;
  bool _isSavedOffline = false;
  String? _selectedTag;

  late final List<PhotoSlideItem> _slides = [
    PhotoSlideItem(
      id: 'p1',
      headerTitle: 'Koda Training Session',
      cardTitle: 'Line Out — Forest Entry',
      shortDate: '12 Jul',
      fullDate: '12 Jul 2026',
      timeLabel: '09:58 AM',
      dogName: 'Koda',
      activity: 'Tracking',
      dimensionsAndSize: '4032 × 3024 · 4.1 MB',
      assetPath: 'assets/images/photo_viewer_2.jpg',
      notes:
          'Calm harness settle at start pole before casting onto the aged 45-minute woodland track.',
      tags: ['Tracking', 'Start Pole', 'Harness', 'Outdoor'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '24mm · f/1.78 · 1/500s · ISO 100',
      gpsCoordinates: '60.3911° N, 5.3218° E · 142m elev',
    ),
    PhotoSlideItem(
      id: 'p2',
      headerTitle: 'Koda Training Session',
      cardTitle: 'First Scent Article — Leather',
      shortDate: '10 Jul',
      fullDate: '10 Jul 2026',
      timeLabel: '10:11 AM',
      dogName: 'Koda',
      activity: 'Tracking',
      dimensionsAndSize: '4032 × 3024 · 3.6 MB',
      assetPath: 'assets/images/video_viewer_thumb.jpg',
      notes:
          'Immediate nose-down freeze and clean Sphinx down between front paws on article #1.',
      tags: ['Tracking', 'Article Indication', 'Outdoor'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '48mm · f/1.78 · 1/640s · ISO 125',
      gpsCoordinates: '60.3912° N, 5.3220° E · 145m elev',
    ),
    PhotoSlideItem(
      id: 'p3',
      headerTitle: 'Koda Training Session',
      cardTitle: 'Tracking — Outdoor Session',
      shortDate: '8 Jul',
      fullDate: '12 Jul 2026',
      timeLabel: '10:24 AM',
      dogName: 'Koda',
      activity: 'Tracking',
      dimensionsAndSize: '4032 × 3024 · 3.8 MB',
      assetPath: 'assets/images/photo_viewer_1.jpg',
      notes:
          'Extended the woodland track distance to 40m today. Took this photo mid-track while Koda was working the scent line through the trees.',
      tags: ['Tracking', 'Outdoor', 'Distance Work', 'Competition'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '24mm · f/1.78 · 1/800s · ISO 160',
      gpsCoordinates: '60.3913° N, 5.3221° E · 148m elev',
      isFavourite: true,
    ),
    PhotoSlideItem(
      id: 'p4',
      headerTitle: 'Koda Training Session',
      cardTitle: '90° Wet Moss Corner',
      shortDate: '5 Jul',
      fullDate: '5 Jul 2026',
      timeLabel: '08:40 AM',
      dogName: 'Koda',
      activity: 'Tracking',
      dimensionsAndSize: '4032 × 3024 · 4.4 MB',
      assetPath: 'assets/bg-images/onboarding_2.png',
      notes:
          'Tight 1.5m radius check at the right-hand corner without overshooting into windward fern bank.',
      tags: ['Tracking', 'Corners', 'Outdoor'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '24mm · f/1.78 · 1/400s · ISO 200',
      gpsCoordinates: '60.3918° N, 5.3229° E · 154m elev',
    ),
    PhotoSlideItem(
      id: 'p5',
      headerTitle: 'Freja Ridge Conditioning',
      cardTitle: 'Fjord Overlook Recall',
      shortDate: '3 Jul',
      fullDate: '3 Jul 2026',
      timeLabel: '07:15 AM',
      dogName: 'Freja',
      activity: 'Conditioning',
      dimensionsAndSize: '4032 × 3024 · 5.0 MB',
      assetPath: 'assets/bg-images/onboarding_1.png',
      notes:
          'Elevation climb interval session completed at steady trot with clean whistle recall at summit.',
      tags: ['Conditioning', 'Recall', 'Alpine'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '13mm · f/2.2 · 1/1200s · ISO 64',
      gpsCoordinates: '60.4102° N, 5.3490° E · 410m elev',
      isFavourite: true,
    ),
    PhotoSlideItem(
      id: 'p6',
      headerTitle: 'Bjørn Valley Endurance',
      cardTitle: 'Mist Valley Dawn Patrol',
      shortDate: '1 Jul',
      fullDate: '1 Jul 2026',
      timeLabel: '06:30 AM',
      dogName: 'Bjørn',
      activity: 'Endurance',
      dimensionsAndSize: '4032 × 3024 · 4.7 MB',
      assetPath: 'assets/bg-images/onboarding_3.png',
      notes:
          '6.4 km aerobic base trail in cool valley mist; recovery heart rate normal within 3 minutes.',
      tags: ['Endurance', 'Trail', 'Outdoor'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '24mm · f/1.78 · 1/1000s · ISO 80',
      gpsCoordinates: '60.4220° N, 5.3611° E · 320m elev',
    ),
    PhotoSlideItem(
      id: 'p7',
      headerTitle: 'Koda Training Session',
      cardTitle: 'Deep Pine Scent Corridor',
      shortDate: '29 Jun',
      fullDate: '29 Jun 2026',
      timeLabel: '09:12 AM',
      dogName: 'Koda',
      activity: 'Tracking',
      dimensionsAndSize: '4032 × 3024 · 3.9 MB',
      assetPath: 'assets/images/photo_viewer_1.jpg',
      notes: 'Consistent low head carriage through pine needle carpet.',
      tags: ['Tracking', 'Woodland', 'Focus'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '24mm · f/1.78 · 1/640s · ISO 125',
      gpsCoordinates: '60.3905° N, 5.3204° E · 139m elev',
    ),
    PhotoSlideItem(
      id: 'p8',
      headerTitle: 'Koda Training Session',
      cardTitle: 'Creek Crossing Transition',
      shortDate: '26 Jun',
      fullDate: '26 Jun 2026',
      timeLabel: '11:05 AM',
      dogName: 'Koda',
      activity: 'Tracking',
      dimensionsAndSize: '4032 × 3024 · 4.2 MB',
      assetPath: 'assets/images/video_viewer_thumb.jpg',
      notes: 'Re-acquired scent Cone 2m past shallow gravel stream.',
      tags: ['Tracking', 'Water', 'Terrain'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '24mm · f/1.78 · 1/500s · ISO 160',
      gpsCoordinates: '60.3899° N, 5.3198° E · 131m elev',
    ),
    PhotoSlideItem(
      id: 'p9',
      headerTitle: 'Freja Agility Prep',
      cardTitle: 'Rocky Switchback Footwork',
      shortDate: '23 Jun',
      fullDate: '23 Jun 2026',
      timeLabel: '04:40 PM',
      dogName: 'Freja',
      activity: 'Proprioception',
      dimensionsAndSize: '4032 × 3024 · 4.6 MB',
      assetPath: 'assets/bg-images/onboarding_2.png',
      notes: 'Deliberate hind-limb placement over uneven granite slabs.',
      tags: ['S&C', 'Proprioception', 'Outdoor'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '24mm · f/1.78 · 1/750s · ISO 100',
      gpsCoordinates: '60.4015° N, 5.3310° E · 215m elev',
    ),
    PhotoSlideItem(
      id: 'p10',
      headerTitle: 'Bjørn Mountain Hike',
      cardTitle: 'High Pass Rest Settle',
      shortDate: '20 Jun',
      fullDate: '20 Jun 2026',
      timeLabel: '01:20 PM',
      dogName: 'Bjørn',
      activity: 'Obedience',
      dimensionsAndSize: '4032 × 3024 · 4.9 MB',
      assetPath: 'assets/bg-images/onboarding_1.png',
      notes: '20-minute neutral down-stay while gear check completed.',
      tags: ['Obedience', 'Settle', 'Alpine'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '24mm · f/1.78 · 1/1600s · ISO 64',
      gpsCoordinates: '60.4310° N, 5.3712° E · 540m elev',
    ),
    PhotoSlideItem(
      id: 'p11',
      headerTitle: 'Koda Training Session',
      cardTitle: 'Final Glove Article Indication',
      shortDate: '17 Jun',
      fullDate: '17 Jun 2026',
      timeLabel: '09:48 AM',
      dogName: 'Koda',
      activity: 'Tracking',
      dimensionsAndSize: '4032 × 3024 · 3.7 MB',
      assetPath: 'assets/images/photo_viewer_2.jpg',
      notes: 'Confident indication at end of 400-pace track.',
      tags: ['Tracking', 'Article', 'Session 10'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '24mm · f/1.78 · 1/640s · ISO 125',
      gpsCoordinates: '60.3915° N, 5.3225° E · 149m elev',
    ),
    PhotoSlideItem(
      id: 'p12',
      headerTitle: 'Freja Lake Cooldown',
      cardTitle: 'Glacial Tarn Recovery',
      shortDate: '14 Jun',
      fullDate: '14 Jun 2026',
      timeLabel: '05:15 PM',
      dogName: 'Freja',
      activity: 'Recovery',
      dimensionsAndSize: '4032 × 3024 · 4.3 MB',
      assetPath: 'assets/bg-images/onboarding_3.png',
      notes: 'Gentle wading cooldown post hill-sprint block.',
      tags: ['Recovery', 'Hydro', 'Outdoor'],
      cameraModel: 'iPhone 16 Pro',
      lensAndExposure: '24mm · f/1.78 · 1/900s · ISO 80',
      gpsCoordinates: '60.4190° N, 5.3580° E · 298m elev',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _slides.length - 1);
    if (widget.overrideTitle != null && widget.overrideTitle!.isNotEmpty) {
      _slides[_currentIndex] = PhotoSlideItem(
        id: _slides[_currentIndex].id,
        headerTitle: _slides[_currentIndex].headerTitle,
        cardTitle: widget.overrideTitle!,
        shortDate: _slides[_currentIndex].shortDate,
        fullDate: _slides[_currentIndex].fullDate,
        timeLabel: _slides[_currentIndex].timeLabel,
        dogName: _slides[_currentIndex].dogName,
        activity: _slides[_currentIndex].activity,
        dimensionsAndSize: _slides[_currentIndex].dimensionsAndSize,
        assetPath: _slides[_currentIndex].assetPath,
        notes: _slides[_currentIndex].notes,
        tags: _slides[_currentIndex].tags,
        cameraModel: _slides[_currentIndex].cameraModel,
        lensAndExposure: _slides[_currentIndex].lensAndExposure,
        gpsCoordinates: _slides[_currentIndex].gpsCoordinates,
        isFavourite: _slides[_currentIndex].isFavourite,
      );
    }
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  PhotoSlideItem get _activeSlide => _slides[_currentIndex];

  void _resetZoom() {
    _zoomController.value = Matrix4.identity();
    if (_isZoomed) {
      setState(() => _isZoomed = false);
    }
  }

  void _toggleDoubleTapZoom() {
    if (_isZoomed) {
      _resetZoom();
    } else {
      _zoomController.value = Matrix4.diagonal3Values(2.2, 2.2, 1.0);
      setState(() => _isZoomed = true);
    }
  }

  void _goToSlide(int index) {
    final target = index.clamp(0, _slides.length - 1);
    if (target == _currentIndex) return;
    _resetZoom();
    _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _showExifSheet() {
    final item = _activeSlide;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                const Row(
                  children: [
                    Icon(Icons.camera_outlined, color: _forest, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'EXIF & Capture Metadata',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildExifRow('Resolution & File Size', item.dimensionsAndSize),
                _buildExifRow('Device / Camera', item.cameraModel),
                _buildExifRow('Optics & Exposure', item.lensAndExposure),
                _buildExifRow('Colour Profile', 'Display P3 · HEIF 10-bit'),
                _buildExifRow(
                  'Captured Timestamp',
                  '${item.fullDate} · ${item.timeLabel}',
                ),
                _buildExifRow('GPS Location', item.gpsCoordinates),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExifRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 142,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                color: _stoneGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: _offWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLinkedRecordSheet() {
    final item = _activeSlide;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Training Session — ${item.fullDate}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.activity} · 45 min · ${item.dogName}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Text(
                    item.notes,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      height: 1.45,
                      color: _offWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditNotesSheet() {
    final item = _activeSlide;
    final controller = TextEditingController(text: item.notes);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Photo Notes',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _offWhite,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 4,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: _offWhite,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _cardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
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
                    setState(() => item.notes = controller.text.trim());
                    Navigator.pop(ctx);
                    AppSnackbar.show(
                      context,
                      title: 'Notes Saved',
                      message: 'Photo notes updated.',
                      type: SnackbarType.success,
                    );
                  },
                  child: const Text(
                    'Save Notes',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOverflowSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _stoneGrey.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.edit_note_rounded, color: _offWhite),
                  title: const Text(
                    'Edit Photo Notes',
                    style: TextStyle(fontFamily: 'Inter', color: _offWhite),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showEditNotesSheet();
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.info_outline_rounded, color: _offWhite),
                  title: const Text(
                    'View EXIF & Camera Info',
                    style: TextStyle(fontFamily: 'Inter', color: _offWhite),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showExifSheet();
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.zoom_in_rounded, color: _offWhite),
                  title: Text(
                    _isZoomed ? 'Reset Photo Zoom (1×)' : 'Zoom In Photo (2.2×)',
                    style: const TextStyle(fontFamily: 'Inter', color: _offWhite),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _toggleDoubleTapZoom();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete() {
    final item = _activeSlide;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Photo?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: _offWhite,
          ),
        ),
        content: Text(
          'Remove "${item.cardTitle}" from your Media Library?',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.5,
            color: _stoneGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Inter', color: _stoneGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (_slides.length <= 1) {
                Navigator.of(context).maybePop();
                return;
              }
              setState(() {
                _slides.removeAt(_currentIndex);
                if (_currentIndex >= _slides.length) {
                  _currentIndex = _slides.length - 1;
                }
              });
              AppSnackbar.show(
                context,
                title: 'Photo Deleted',
                message: 'Removed from Media Library.',
                type: SnackbarType.warning,
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                color: AppColors.errorDestructive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slide = _activeSlide;
    // Pure #000000 black background, NO bottom navigation bar!
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: _isZoomed
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroCarousel(slide),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetadataCard(slide),
                    const SizedBox(height: 12),
                    _buildActionStripCard(slide),
                    const SizedBox(height: 22),
                    _buildSectionLabel('LINKED RECORD'),
                    const SizedBox(height: 10),
                    _buildLinkedRecordCard(slide),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionLabel('NOTES'),
                        GestureDetector(
                          onTap: _showEditNotesSheet,
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _forest,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildNotesCard(slide),
                    const SizedBox(height: 22),
                    _buildSectionLabel('TAGS'),
                    const SizedBox(height: 10),
                    _buildTagsRow(slide),
                    const SizedBox(height: 22),
                    _buildSectionLabel('RELATED PHOTOS'),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              _buildRelatedPhotosStrip(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCarousel(PhotoSlideItem slide) {
    return SizedBox(
      width: double.infinity,
      height: 306,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            physics: _isZoomed
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            itemCount: _slides.length,
            onPageChanged: (idx) {
              _resetZoom();
              setState(() => _currentIndex = idx);
            },
            itemBuilder: (context, idx) {
              final item = _slides[idx];
              return GestureDetector(
                onDoubleTap: _toggleDoubleTapZoom,
                child: InteractiveViewer(
                  transformationController:
                      idx == _currentIndex ? _zoomController : null,
                  minScale: 1.0,
                  maxScale: 4.0,
                  onInteractionEnd: (_) {
                    final scale = _zoomController.value.getMaxScaleOnAxis();
                    setState(() => _isZoomed = scale > 1.05);
                  },
                  child: Image.asset(
                    item.assetPath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              );
            },
          ),
          // Top gradient for legible header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 76,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.65),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Overlaid top header
          Positioned(
            top: 4,
            left: 6,
            right: 6,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: _offWhite,
                    size: 26,
                  ),
                  tooltip: 'Back',
                ),
                Expanded(
                  child: Text(
                    slide.headerTitle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _offWhite,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _showOverflowSheet,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: _offWhite,
                    size: 20,
                  ),
                  tooltip: 'Photo Options & EXIF',
                ),
              ],
            ),
          ),
          // Left carousel arrow
          if (_currentIndex > 0)
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  onPressed: () => _goToSlide(_currentIndex - 1),
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: _offWhite.withValues(alpha: 0.72),
                    size: 28,
                  ),
                  tooltip: 'Previous Photo',
                ),
              ),
            ),
          // Right carousel arrow
          if (_currentIndex < _slides.length - 1)
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  onPressed: () => _goToSlide(_currentIndex + 1),
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    color: _offWhite.withValues(alpha: 0.72),
                    size: 28,
                  ),
                  tooltip: 'Next Photo',
                ),
              ),
            ),
          // Bottom-right "3 of 12" pill
          Positioned(
            right: 14,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentIndex + 1} of ${_slides.length}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: _offWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataCard(PhotoSlideItem slide) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slide.cardTitle,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 17.5,
              fontWeight: FontWeight.w700,
              color: _offWhite,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMetaField('DATE', slide.fullDate)),
              Expanded(child: _buildMetaField('DOG', slide.dogName)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildMetaField('TIME', slide.timeLabel)),
              Expanded(child: _buildMetaField('ACTIVITY', slide.activity)),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showExifSheet,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  slide.dimensionsAndSize,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: _stoneGrey,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: _stoneGrey.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'EXIF',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: _stoneGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: _offWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildActionStripCard(PhotoSlideItem slide) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem(
            icon: slide.isFavourite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: slide.isFavourite ? _favGold : _stoneGrey,
            label: 'Favourite',
            onTap: () {
              setState(() => slide.isFavourite = !slide.isFavourite);
              AppSnackbar.show(
                context,
                title: slide.isFavourite
                    ? 'Added to Favourites'
                    : 'Removed from Favourites',
                message: slide.cardTitle,
                type: slide.isFavourite
                    ? SnackbarType.success
                    : SnackbarType.info,
              );
            },
          ),
          _buildActionItem(
            icon: Icons.ios_share_rounded,
            iconColor: _stoneGrey,
            label: 'Share',
            onTap: () {
              AppSnackbar.show(
                context,
                title: 'Share Photo',
                message: 'Prepared full-resolution photo for sharing.',
                type: SnackbarType.info,
              );
            },
          ),
          _buildActionItem(
            icon: _isSavedOffline
                ? Icons.download_done_rounded
                : Icons.download_rounded,
            iconColor: _isSavedOffline ? _forest : _stoneGrey,
            label: _isSavedOffline ? 'Saved' : 'Download',
            onTap: () {
              setState(() => _isSavedOffline = true);
              AppSnackbar.show(
                context,
                title: 'Photo Downloaded',
                message: '${slide.cardTitle} saved to device roll.',
                type: SnackbarType.success,
              );
            },
          ),
          _buildActionItem(
            icon: Icons.open_in_new_rounded,
            iconColor: _stoneGrey,
            label: 'Open Record',
            onTap: _showLinkedRecordSheet,
          ),
          _buildActionItem(
            icon: Icons.delete_outline_rounded,
            iconColor: _stoneGrey,
            label: 'Delete',
            onTap: _confirmDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 21),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: _stoneGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        color: _stoneGrey,
      ),
    );
  }

  Widget _buildLinkedRecordCard(PhotoSlideItem slide) {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: _showLinkedRecordSheet,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _cardBorder),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: _stoneGrey,
                size: 21,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Training Session — ${slide.fullDate}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${slide.activity} · 45 min · ${slide.dogName}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: _stoneGrey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesCard(PhotoSlideItem slide) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Text(
        slide.notes,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.5,
          height: 1.5,
          color: _stoneGrey,
        ),
      ),
    );
  }

  Widget _buildTagsRow(PhotoSlideItem slide) {
    final visibleTags = slide.tags
        .where(
          (tag) =>
              widget.hasSportPack ||
              !tag.toLowerCase().contains('competition'),
        )
        .toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: visibleTags.map((tag) {
          final selected = _selectedTag == tag;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedTag = selected ? null : tag;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: selected ? _forest.withValues(alpha: 0.22) : _carbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? _forest : _cardBorder,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: selected ? _offWhite : _stoneGrey,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRelatedPhotosStrip() {
    return SizedBox(
      height: 98,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _slides.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          final item = _slides[idx];
          final isSelected = idx == _currentIndex;
          return GestureDetector(
            onTap: () => _goToSlide(idx),
            child: Container(
              width: 98,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? _forest : _cardBorder,
                  width: isSelected ? 1.8 : 1.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.5),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      item.assetPath,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 6,
                      bottom: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.shortDate,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _offWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
