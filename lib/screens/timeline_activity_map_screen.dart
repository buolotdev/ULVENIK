import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'timeline_event_details_screen.dart';

class _MappedSessionItem {
  final String id;
  final String category;
  final Color categoryColor;
  final String title;
  final String subtitle;
  final String? thumbnailUrl;
  final bool isTrackIcon;
  final bool isHealthVariant;
  final bool isFavourite;
  final int durationMins;

  const _MappedSessionItem({
    required this.id,
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    required this.isTrackIcon,
    required this.isHealthVariant,
    required this.isFavourite,
    required this.durationMins,
  });
}

class _MapLocationPin {
  final String id;
  final String name;
  final String venueSubtitle;
  final String coordinates;
  final Offset normalizedPos; // 0..1 on default map
  final Offset selectedMapPos; // 0..1 on zoomed street/topo map
  final String primaryCategory;
  final Color pinColor;
  final int? clusterCount;
  final String? topBadge;
  final int visits;
  final String firstVisit;
  final String lastVisit;
  final List<String> recordedCategories;
  final int baseFavourites;
  final List<double> elevationMeters;
  final List<double> speedKmh;
  final String routeDistanceLabel;
  final List<_MappedSessionItem> sessions;
  final bool hasSavedLocation;
  bool isLocationFavourited;

  _MapLocationPin({
    required this.id,
    required this.name,
    required this.venueSubtitle,
    required this.coordinates,
    required this.normalizedPos,
    required this.selectedMapPos,
    required this.primaryCategory,
    required this.pinColor,
    required this.clusterCount,
    required this.topBadge,
    required this.visits,
    required this.firstVisit,
    required this.lastVisit,
    required this.recordedCategories,
    required this.baseFavourites,
    required this.elevationMeters,
    required this.speedKmh,
    required this.routeDistanceLabel,
    required this.sessions,
    required this.isLocationFavourited,
    this.hasSavedLocation = true,
  });
}

enum _MapLayerMode { darkVector, terrainTopo, heatmap }

class TimelineActivityMapScreen extends StatefulWidget {
  final bool initialEmpty;
  final bool hasSportPack;

  const TimelineActivityMapScreen({
    super.key,
    this.initialEmpty = false,
    this.hasSportPack = false,
  });

  @override
  State<TimelineActivityMapScreen> createState() =>
      _TimelineActivityMapScreenState();
}

class _TimelineActivityMapScreenState extends State<TimelineActivityMapScreen>
    with SingleTickerProviderStateMixin {
  // ─── Design Tokens (Exact from Figma SVGs) ─────────────────────────────────
  static const Color _obsidian = Color(0xFF101214);
  static const Color _appBarBg = Color(0xFF111417);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _panelBg = Color(0xFF15191C);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _sage = Color(0xFFB6CCB5);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _bronze = Color(0xFFB4823C);
  static const Color _healthRed = Color(0xFF8B3A3A);
  static const Color _gold = Color(0xFFB8920A);
  static const Color _purple = Color(0xFF7A5BAF);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x16FFFFFF);

  static const String _dogFieldThumb =
      'https://images.unsplash.com/photo-1551730459-92db2a308d6a?q=80&w=300&auto=format&fit=crop';
  static const String _ridgeThumb =
      'https://images.unsplash.com/photo-1534361960057-19889db9621e?q=80&w=300&auto=format&fit=crop';

  late bool _isEmptyState;
  late bool _hasSportPack;
  String? _selectedLocationId; // null => Default State; non-null => Marker Selected State
  String _activeCategoryFilter = 'ALL'; // 'ALL', 'TRAINING', 'S&C', 'HEALTH', 'GOALS', 'MEDIA', 'COMPETITION'
  String _dateRangeFilter = 'All Time';
  String _sessionSortMode = 'Chronological'; // 'Chronological', 'Longest First'
  _MapLayerMode _layerMode = _MapLayerMode.darkVector;
  bool _showRouteTrails = true;
  bool _showInlineTelemetry = false;
  String _telemetryMetric = 'Elevation'; // 'Elevation' | 'Pace'
  int? _scrubIndex;
  double _mapZoom = 1.0;
  int _emptyHeadingIndex = 0;

  static const List<String> _emptyHeadings = [
    '390m • SE 142°',
    '412m • NW 318°',
    '385m • NE 044°',
  ];

  late AnimationController _chartAnimController;
  late Animation<double> _chartAnim;

  late final List<_MapLocationPin> _locations = [
    _MapLocationPin(
      id: 'riverside_trail',
      name: 'Riverside Trail',
      venueSubtitle: 'Training Field · Guildford, UK',
      coordinates: '51.236° N · 0.570° W',
      normalizedPos: const Offset(0.195, 0.365),
      selectedMapPos: const Offset(0.455, 0.42),
      primaryCategory: 'TRAINING',
      pinColor: _forest,
      clusterCount: 18,
      topBadge: null,
      visits: 34,
      firstVisit: 'Jan 2022',
      lastVisit: '3 Sep 2026',
      recordedCategories: const ['Training', 'S&C', 'Health', 'Goals', 'Media'],
      baseFavourites: 6,
      elevationMeters: const [42, 48, 56, 63, 71, 68, 79, 86, 74, 62, 51, 45],
      speedKmh: const [6.2, 7.4, 8.1, 7.8, 6.9, 8.6, 9.2, 8.4, 7.5, 7.9, 6.8, 6.4],
      routeDistanceLabel: '4.8 km',
      isLocationFavourited: false,
      sessions: const [
        _MappedSessionItem(
          id: 'rs-1',
          category: 'TRAINING',
          categoryColor: _alpineBlue,
          title: 'Advanced Heel Work Session',
          subtitle: '3 Sep 2026 · 42 mins',
          thumbnailUrl: _dogFieldThumb,
          isTrackIcon: false,
          isHealthVariant: false,
          isFavourite: true,
          durationMins: 42,
        ),
        _MappedSessionItem(
          id: 'rs-2',
          category: 'TRAINING',
          categoryColor: _alpineBlue,
          title: 'Scent Work — Track B',
          subtitle: '28 Aug 2026 · 550m distance',
          thumbnailUrl: null,
          isTrackIcon: true,
          isHealthVariant: false,
          isFavourite: true,
          durationMins: 35,
        ),
        _MappedSessionItem(
          id: 'rs-3',
          category: 'GOALS',
          categoryColor: _gold,
          title: 'Distance Down Proofing — 30m',
          subtitle: '19 Aug 2026 · 28 mins',
          thumbnailUrl: _ridgeThumb,
          isTrackIcon: false,
          isHealthVariant: false,
          isFavourite: false,
          durationMins: 28,
        ),
      ],
    ),
    _MapLocationPin(
      id: 'canal_towpath',
      name: 'Riverside Canal Towpath',
      venueSubtitle: 'Waterfront Linear Path · Guildford, UK',
      coordinates: '51.244° N · 0.576° W',
      normalizedPos: const Offset(0.395, 0.285),
      selectedMapPos: const Offset(0.34, 0.30),
      primaryCategory: 'TRAINING',
      pinColor: _alpineBlue,
      clusterCount: null,
      topBadge: null,
      visits: 19,
      firstVisit: 'Apr 2023',
      lastVisit: '29 Aug 2026',
      recordedCategories: const ['Training', 'Goals'],
      baseFavourites: 4,
      elevationMeters: const [38, 39, 40, 41, 40, 42, 43, 41, 40, 39, 38, 38],
      speedKmh: const [7.1, 7.6, 8.0, 8.2, 7.9, 8.4, 8.5, 8.1, 7.8, 7.5, 7.3, 7.0],
      routeDistanceLabel: '3.6 km',
      isLocationFavourited: true,
      sessions: const [
        _MappedSessionItem(
          id: 'ct-1',
          category: 'TRAINING',
          categoryColor: _alpineBlue,
          title: 'Neutrality Around Cyclists & Joggers',
          subtitle: '29 Aug 2026 · 38 mins',
          thumbnailUrl: _ridgeThumb,
          isTrackIcon: false,
          isHealthVariant: false,
          isFavourite: true,
          durationMins: 38,
        ),
        _MappedSessionItem(
          id: 'ct-2',
          category: 'TRAINING',
          categoryColor: _alpineBlue,
          title: 'Structured Loose-Lead Pace Drill',
          subtitle: '14 Aug 2026 · 3.6 km towpath',
          thumbnailUrl: null,
          isTrackIcon: true,
          isHealthVariant: false,
          isFavourite: false,
          durationMins: 31,
        ),
      ],
    ),
    _MapLocationPin(
      id: 'north_ridge',
      name: 'North Ridge Trail',
      venueSubtitle: 'Incline Conditioning Ridge · Surrey Hills',
      coordinates: '51.249° N · 0.551° W',
      normalizedPos: const Offset(0.692, 0.238),
      selectedMapPos: const Offset(0.61, 0.25),
      primaryCategory: 'S&C',
      pinColor: _bronze,
      clusterCount: null,
      topBadge: null,
      visits: 14,
      firstVisit: 'Sep 2023',
      lastVisit: '24 Aug 2026',
      recordedCategories: const ['S&C', 'Training'],
      baseFavourites: 3,
      elevationMeters: const [55, 68, 84, 98, 114, 128, 134, 122, 108, 92, 76, 61],
      speedKmh: const [5.8, 6.2, 6.0, 5.5, 5.2, 6.4, 7.8, 8.6, 8.2, 7.4, 6.9, 6.3],
      routeDistanceLabel: '5.4 km',
      isLocationFavourited: false,
      sessions: const [
        _MappedSessionItem(
          id: 'nr-1',
          category: 'S&C',
          categoryColor: _bronze,
          title: 'Hill Repeats & Hindquarter Drive',
          subtitle: '24 Aug 2026 · 48 mins',
          thumbnailUrl: _ridgeThumb,
          isTrackIcon: false,
          isHealthVariant: false,
          isFavourite: true,
          durationMins: 48,
        ),
        _MappedSessionItem(
          id: 'nr-2',
          category: 'S&C',
          categoryColor: _bronze,
          title: 'North Ridge Ascent Loop',
          subtitle: '11 Aug 2026 · 5.4 km · +142m gain',
          thumbnailUrl: null,
          isTrackIcon: true,
          isHealthVariant: false,
          isFavourite: false,
          durationMins: 52,
        ),
      ],
    ),
    _MapLocationPin(
      id: 'vet_clinic_hq',
      name: 'Vet Clinic HQ',
      venueSubtitle: 'Canine Sports Medicine · West Clandon',
      coordinates: '51.241° N · 0.518° W',
      normalizedPos: const Offset(0.282, 0.506),
      selectedMapPos: const Offset(0.635, 0.37),
      primaryCategory: 'HEALTH',
      pinColor: _healthRed,
      clusterCount: null,
      topBadge: null,
      visits: 8,
      firstVisit: 'Mar 2022',
      lastVisit: '18 Aug 2026',
      recordedCategories: const ['Health'],
      baseFavourites: 2,
      elevationMeters: const [52, 52, 53, 53, 52, 52],
      speedKmh: const [4.2, 4.5, 4.4, 4.3, 4.5, 4.2],
      routeDistanceLabel: '0.6 km',
      isLocationFavourited: false,
      sessions: const [
        _MappedSessionItem(
          id: 'vc-1',
          category: 'HEALTH',
          categoryColor: _healthRed,
          title: 'Orthopaedic Gait & Joint Assessment',
          subtitle: '18 Aug 2026 · Cleared full sport load',
          thumbnailUrl: null,
          isTrackIcon: false,
          isHealthVariant: true,
          isFavourite: true,
          durationMins: 30,
        ),
        _MappedSessionItem(
          id: 'vc-2',
          category: 'HEALTH',
          categoryColor: _healthRed,
          title: 'Annual Vaccination & Titre Check',
          subtitle: '4 May 2026 · All markers optimal',
          thumbnailUrl: null,
          isTrackIcon: false,
          isHealthVariant: true,
          isFavourite: false,
          durationMins: 25,
        ),
      ],
    ),
    _MapLocationPin(
      id: 'box_hill_track',
      name: 'Box Hill Track',
      venueSubtitle: 'Open Chalk Meadow · Surrey',
      coordinates: '51.255° N · 0.588° W',
      normalizedPos: const Offset(0.576, 0.458),
      selectedMapPos: const Offset(0.26, 0.22),
      primaryCategory: 'GOALS',
      pinColor: _gold,
      clusterCount: null,
      topBadge: null,
      visits: 11,
      firstVisit: 'Jun 2023',
      lastVisit: '15 Aug 2026',
      recordedCategories: const ['Goals', 'Training'],
      baseFavourites: 3,
      elevationMeters: const [74, 82, 91, 96, 102, 99, 90, 84, 78, 75],
      speedKmh: const [6.8, 7.5, 8.2, 8.9, 8.4, 7.9, 8.1, 7.6, 7.2, 6.9],
      routeDistanceLabel: '3.2 km',
      isLocationFavourited: false,
      sessions: const [
        _MappedSessionItem(
          id: 'bh-1',
          category: 'GOALS',
          categoryColor: _gold,
          title: '200m Whistle Recall Benchmark',
          subtitle: '15 Aug 2026 · Sub-14s response',
          thumbnailUrl: _dogFieldThumb,
          isTrackIcon: false,
          isHealthVariant: false,
          isFavourite: true,
          durationMins: 34,
        ),
        _MappedSessionItem(
          id: 'bh-2',
          category: 'TRAINING',
          categoryColor: _alpineBlue,
          title: 'Wind-Scented Article Indication',
          subtitle: '2 Aug 2026 · 420m meadow track',
          thumbnailUrl: null,
          isTrackIcon: true,
          isHealthVariant: false,
          isFavourite: false,
          durationMins: 40,
        ),
      ],
    ),
    _MapLocationPin(
      id: 'blackwood_woods',
      name: 'Blackwood Woods',
      venueSubtitle: 'Woodland Scent & Canopy Trail · Albury',
      coordinates: '51.224° N · 0.531° W',
      normalizedPos: const Offset(0.755, 0.586),
      selectedMapPos: const Offset(0.75, 0.68),
      primaryCategory: 'TRAINING',
      pinColor: _forest,
      clusterCount: 7,
      topBadge: null,
      visits: 21,
      firstVisit: 'Nov 2022',
      lastVisit: '1 Sep 2026',
      recordedCategories: const ['Training', 'S&C'],
      baseFavourites: 5,
      elevationMeters: const [62, 66, 74, 81, 78, 85, 89, 82, 73, 68, 64],
      speedKmh: const [6.5, 7.0, 7.4, 7.1, 7.8, 8.0, 7.6, 7.2, 6.9, 6.7, 6.5],
      routeDistanceLabel: '4.1 km',
      isLocationFavourited: true,
      sessions: const [
        _MappedSessionItem(
          id: 'bw-1',
          category: 'TRAINING',
          categoryColor: _alpineBlue,
          title: 'Aged Woodland Track — 90 Min Lay',
          subtitle: '1 Sep 2026 · 680m · 3 corners',
          thumbnailUrl: null,
          isTrackIcon: true,
          isHealthVariant: false,
          isFavourite: true,
          durationMins: 46,
        ),
        _MappedSessionItem(
          id: 'bw-2',
          category: 'S&C',
          categoryColor: _bronze,
          title: 'Fallen Timber Proprioception Circuit',
          subtitle: '21 Aug 2026 · 35 mins',
          thumbnailUrl: _ridgeThumb,
          isTrackIcon: false,
          isHealthVariant: false,
          isFavourite: false,
          durationMins: 35,
        ),
      ],
    ),
    _MapLocationPin(
      id: 'south_meadows',
      name: 'South Meadows',
      venueSubtitle: 'Open Tracking Pasture · Guildford South',
      coordinates: '51.229° N · 0.582° W',
      normalizedPos: const Offset(0.448, 0.672),
      selectedMapPos: const Offset(0.36, 0.58),
      primaryCategory: 'TRAINING',
      pinColor: _purple,
      clusterCount: null,
      topBadge: null,
      visits: 9,
      firstVisit: 'Feb 2024',
      lastVisit: '12 Aug 2026',
      recordedCategories: const ['Training', 'Goals', 'Media'],
      baseFavourites: 2,
      elevationMeters: const [46, 48, 50, 52, 51, 49, 47, 46],
      speedKmh: const [7.2, 7.8, 8.3, 8.1, 7.7, 7.9, 7.4, 7.1],
      routeDistanceLabel: '2.9 km',
      isLocationFavourited: false,
      sessions: const [
        _MappedSessionItem(
          id: 'sm-1',
          category: 'TRAINING',
          categoryColor: _alpineBlue,
          title: 'Cross-Track Discrimination Test',
          subtitle: '12 Aug 2026 · Zero false alerts',
          thumbnailUrl: null,
          isTrackIcon: true,
          isHealthVariant: false,
          isFavourite: true,
          durationMins: 32,
        ),
      ],
    ),
    _MapLocationPin(
      id: 'trial_grounds',
      name: 'Guildford Trial Grounds',
      venueSubtitle: 'Working Dog Championship Arena · Surrey',
      coordinates: '51.218° N · 0.591° W',
      normalizedPos: const Offset(0.306, 0.778),
      selectedMapPos: const Offset(0.22, 0.74),
      primaryCategory: 'COMPETITION',
      pinColor: _forest,
      clusterCount: null,
      topBadge: '1ST PLACE',
      visits: 6,
      firstVisit: 'Oct 2023',
      lastVisit: '20 Jul 2026',
      recordedCategories: const ['Competition', 'Goals'],
      baseFavourites: 4,
      elevationMeters: const [44, 45, 45, 46, 45, 44, 44],
      speedKmh: const [8.4, 9.1, 9.6, 9.2, 8.8, 9.4, 8.7],
      routeDistanceLabel: '1.9 km',
      isLocationFavourited: true,
      sessions: const [
        _MappedSessionItem(
          id: 'tg-1',
          category: 'COMPETITION',
          categoryColor: _forest,
          title: 'Regional IGP II — 1st Place Qualification',
          subtitle: '20 Jul 2026 · 286/300 pts · High in Trial',
          thumbnailUrl: _dogFieldThumb,
          isTrackIcon: false,
          isHealthVariant: false,
          isFavourite: true,
          durationMins: 60,
        ),
      ],
    ),
    _MapLocationPin(
      id: 'riverside_loop',
      name: 'Riverside Trail Loop',
      venueSubtitle: 'Endurance Perimeter · Guildford East',
      coordinates: '51.221° N · 0.548° W',
      normalizedPos: const Offset(0.678, 0.755),
      selectedMapPos: const Offset(0.52, 0.70),
      primaryCategory: 'TRAINING',
      pinColor: _alpineBlue,
      clusterCount: null,
      topBadge: null,
      visits: 15,
      firstVisit: 'May 2023',
      lastVisit: '2 Sep 2026',
      recordedCategories: const ['Training', 'S&C'],
      baseFavourites: 3,
      elevationMeters: const [41, 47, 55, 64, 72, 69, 61, 54, 48, 43],
      speedKmh: const [7.5, 8.1, 8.6, 8.4, 7.9, 8.8, 9.0, 8.5, 7.9, 7.4],
      routeDistanceLabel: '4.8 km',
      isLocationFavourited: false,
      hasSavedLocation: true,
      sessions: const [
        _MappedSessionItem(
          id: 'rl-1',
          category: 'TRAINING',
          categoryColor: _alpineBlue,
          title: 'Riverside Trail Loop — Tempo Conditioning',
          subtitle: '2 Sep 2026 · 4.8 km · Avg 8.2 km/h',
          thumbnailUrl: null,
          isTrackIcon: true,
          isHealthVariant: false,
          isFavourite: true,
          durationMins: 36,
        ),
      ],
    ),
    _MapLocationPin(
      id: 'unmapped_indoor_session',
      name: 'Indoor Conditioning Hall',
      venueSubtitle: 'Location not saved',
      coordinates: '',
      normalizedPos: const Offset(0.5, 0.5),
      selectedMapPos: const Offset(0.5, 0.5),
      primaryCategory: 'S&C',
      pinColor: _bronze,
      clusterCount: null,
      topBadge: null,
      visits: 3,
      firstVisit: 'Jul 2026',
      lastVisit: '28 Aug 2026',
      recordedCategories: const ['S&C'],
      baseFavourites: 0,
      elevationMeters: const [40, 40],
      speedKmh: const [0, 0],
      routeDistanceLabel: '0 km',
      isLocationFavourited: false,
      hasSavedLocation: false,
      sessions: const [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _hasSportPack = widget.hasSportPack;
    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _chartAnim = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    super.dispose();
  }

  List<String> _recordedCategoriesForPin(_MapLocationPin pin) {
    const canonicalLabels = <String, String>{
      'TRAINING': 'Training',
      'S&C': 'S&C',
      'HEALTH': 'Health',
      'GOALS': 'Goals',
      'MEDIA': 'Media',
      'COMPETITION': 'Competition',
    };
    const canonicalOrder = [
      'TRAINING',
      'S&C',
      'HEALTH',
      'GOALS',
      'MEDIA',
      'COMPETITION',
    ];

    final foundUpper = <String>{};
    final customLabels = <String>[];

    void addCategory(String raw) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) return;
      final upper = trimmed.toUpperCase();
      if (upper == 'COMPETITION' && !_hasSportPack) return;
      if (canonicalLabels.containsKey(upper)) {
        foundUpper.add(upper);
      } else if (!customLabels
          .any((existing) => existing.toUpperCase() == upper)) {
        customLabels.add(trimmed);
      }
    }

    for (final c in pin.recordedCategories) {
      addCategory(c);
    }
    for (final s in pin.sessions) {
      addCategory(s.category);
    }

    return [
      for (final key in canonicalOrder)
        if (foundUpper.contains(key)) canonicalLabels[key]!,
      ...customLabels,
    ];
  }

  List<_MapLocationPin> get _savedLocations {
    return _locations.where((p) {
      if (!p.hasSavedLocation) return false;
      if (!_hasSportPack && p.primaryCategory.toUpperCase() == 'COMPETITION') {
        return false;
      }
      return _recordedCategoriesForPin(p).isNotEmpty;
    }).toList();
  }

  List<String> get _mappedLegendCategories {
    const canonicalOrder = [
      'TRAINING',
      'S&C',
      'HEALTH',
      'GOALS',
      'MEDIA',
      'COMPETITION',
    ];
    final availableUpper = <String>{};
    final customUpper = <String>[];

    for (final loc in _savedLocations) {
      for (final cat in _recordedCategoriesForPin(loc)) {
        final upper = cat.toUpperCase();
        if (canonicalOrder.contains(upper)) {
          availableUpper.add(upper);
        } else if (!customUpper.contains(upper)) {
          customUpper.add(upper);
        }
      }
    }

    return [
      for (final key in canonicalOrder)
        if (availableUpper.contains(key)) key,
      ...customUpper,
    ];
  }

  _MapLocationPin? get _selectedPin {
    if (_selectedLocationId == null) return null;
    for (final p in _savedLocations) {
      if (p.id == _selectedLocationId) return p;
    }
    return null;
  }

  List<_MapLocationPin> get _visiblePins {
    final saved = _savedLocations;
    if (_activeCategoryFilter == 'ALL') return saved;
    return saved.where((p) {
      if (p.primaryCategory.toUpperCase() == _activeCategoryFilter) {
        return true;
      }
      return _recordedCategoriesForPin(p)
          .any((c) => c.toUpperCase() == _activeCategoryFilter);
    }).toList();
  }

  void _selectPin(String id) {
    setState(() {
      _selectedLocationId = id;
      _scrubIndex = null;
    });
    _chartAnimController.forward(from: 0);
  }

  void _clearSelectedPin() {
    setState(() {
      _selectedLocationId = null;
      _scrubIndex = null;
    });
  }

  void _cycleMapLayer() {
    setState(() {
      _layerMode = _MapLayerMode
          .values[(_layerMode.index + 1) % _MapLayerMode.values.length];
    });
    final label = switch (_layerMode) {
      _MapLayerMode.darkVector => 'Dark Vector Grid',
      _MapLayerMode.terrainTopo => 'Nordic Topographic Terrain',
      _MapLayerMode.heatmap => 'Session Density Heatmap',
    };
    AppSnackbar.show(
      context,
      message: 'Map layer switched to $label',
      type: SnackbarType.info,
    );
  }

  void _recenterMap() {
    setState(() {
      _mapZoom = 1.0;
      _scrubIndex = null;
    });
    AppSnackbar.show(
      context,
      message: _selectedPin != null
          ? 'Centered on ${_selectedPin!.name} (${_selectedPin!.coordinates})'
          : 'Map recentered on Guildford sector (23 locations)',
      type: SnackbarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: _isEmptyState
          ? _buildEmptyState()
          : (_selectedPin != null
              ? _buildMarkerSelectedState(_selectedPin!)
              : _buildDefaultMapState()),
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.timeline),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final String appBarTitle = (_isEmptyState || _selectedPin != null)
        ? 'Timeline Activity Map'
        : 'Activity Map';

    return AppBar(
      backgroundColor: _appBarBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: const UlvenikIcon(UlvenikIcons.back, color: _stoneGrey, size: 22),
        onPressed: () {
          if (!_isEmptyState && _selectedPin != null) {
            _clearSelectedPin();
            return;
          }
          Navigator.maybePop(context);
        },
      ),
      title: Text(
        appBarTitle,
        style: const TextStyle(
          color: _offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Search Mapped Locations',
          icon: const UlvenikIcon(UlvenikIcons.search, color: _stoneGrey, size: 21),
          onPressed: _showSearchLocationsSheet,
        ),
        IconButton(
          tooltip: 'Filter Map Categories & Range',
          icon: const Icon(Icons.tune, color: _stoneGrey, size: 20),
          onPressed: _showMapFilterSheet,
        ),
        PopupMenuButton<String>(
          icon: const UlvenikIcon(UlvenikIcons.more, color: _stoneGrey, size: 21),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: _cardBorder),
          ),
          onSelected: (value) {
            if (value == 'default_state') {
              setState(() {
                _isEmptyState = false;
                _selectedLocationId = null;
              });
            } else if (value == 'marker_state') {
              setState(() {
                _isEmptyState = false;
                _selectedLocationId = 'riverside_trail';
              });
              _chartAnimController.forward(from: 0);
            } else if (value == 'empty_state') {
              setState(() {
                _isEmptyState = !_isEmptyState;
                if (_isEmptyState) _selectedLocationId = null;
              });
              AppSnackbar.show(
                context,
                message: _isEmptyState
                    ? 'Switched to Empty State preview'
                    : 'Switched to Populated Activity Map',
                type: SnackbarType.info,
              );
            } else if (value == 'route_inspector') {
              _showRouteElevationSheet(_selectedPin ?? _savedLocations.first);
            } else if (value == 'toggle_sport_pack') {
              setState(() {
                _hasSportPack = !_hasSportPack;
                if (!_hasSportPack && _activeCategoryFilter == 'COMPETITION') {
                  _activeCategoryFilter = 'ALL';
                }
                if (!_hasSportPack && _selectedLocationId == 'trial_grounds') {
                  _selectedLocationId = null;
                }
              });
              AppSnackbar.show(
                context,
                message: _hasSportPack
                    ? 'Sport Pack enabled: Competition locations & key shown'
                    : 'Standard subscription: Competition hidden',
                type: SnackbarType.info,
              );
            } else if (value == 'reset') {
              setState(() {
                _activeCategoryFilter = 'ALL';
                _dateRangeFilter = 'All Time';
                _layerMode = _MapLayerMode.darkVector;
                _showRouteTrails = true;
                _mapZoom = 1.0;
              });
              AppSnackbar.show(
                context,
                message: 'Map filters and layers reset',
                type: SnackbarType.info,
              );
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'default_state',
              child: Text(
                'Default Map Overview',
                style: TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'marker_state',
              child: Text(
                'Inspect Marker Selected (Riverside Trail)',
                style: TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            PopupMenuItem(
              value: 'empty_state',
              child: Text(
                _isEmptyState
                    ? 'Switch to Populated Map'
                    : 'Switch to Empty State',
                style: const TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'route_inspector',
              child: Text(
                'Open Elevation & Pace Route Profile',
                style: TextStyle(color: _mint, fontSize: 13),
              ),
            ),
            PopupMenuItem(
              value: 'toggle_sport_pack',
              child: Text(
                _hasSportPack
                    ? 'Disable Sport Pack (Hide Competition)'
                    : 'Enable Sport Pack (Show Competition)',
                style: const TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'reset',
              child: Text(
                'Reset Map Layers & Filters',
                style: TextStyle(color: _stoneGrey, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _cardBorder),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. DEFAULT STATE (Matches 02_activity_map_default.png 100%)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildDefaultMapState() {
    final pins = _visiblePins;
    final totalEvents = _activeCategoryFilter == 'ALL'
        ? 147
        : pins.fold<int>(0, (sum, p) => sum + p.visits);

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;

              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // Interactive Zoomable / Pannable Dark Vector Canvas
                  Positioned.fill(
                    child: GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          _mapZoom = _mapZoom < 1.25 ? 1.28 : 1.0;
                        });
                      },
                      child: AnimatedScale(
                        scale: _mapZoom,
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        child: AnimatedBuilder(
                          animation: _chartAnim,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: _DefaultActivityMapPainter(
                                layerMode: _layerMode,
                                showRoutes: _showRouteTrails,
                                routeProgress: _chartAnim.value,
                                pins: pins,
                              ),
                              child: Stack(
                                children: [
                                  for (final pin in pins)
                                    _buildDefaultMapMarker(pin, w, h),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Top Horizontal Stat Cards Strip
                  Positioned(
                    top: 14,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 76,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildTopStatCard(
                            value: '${pins.length == _locations.length ? 23 : pins.length}',
                            label: 'LOCATIONS',
                            width: 108,
                            onTap: _showSearchLocationsSheet,
                          ),
                          const SizedBox(width: 10),
                          _buildTopStatCard(
                            value: 'Riverside Trail',
                            label: 'MOST VISITED',
                            isTitleValue: true,
                            width: 126,
                            onTap: () => _selectPin('riverside_trail'),
                          ),
                          const SizedBox(width: 10),
                          _buildTopStatCard(
                            value: '$totalEvents',
                            label: 'MAPPED\nEVENTS',
                            width: 116,
                            onTap: _showMapFilterSheet,
                          ),
                          const SizedBox(width: 10),
                          _buildTopStatCard(
                            value: '68.4 km',
                            label: 'GPS DISTANCE',
                            isTitleValue: true,
                            width: 120,
                            onTap: () =>
                                _showRouteElevationSheet(_locations.first),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Active Filter Pill Banner (if filtered)
                  if (_activeCategoryFilter != 'ALL' ||
                      _dateRangeFilter != 'All Time')
                    Positioned(
                      top: 98,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _carbon.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: _mint.withValues(alpha: 0.35)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.filter_alt_outlined,
                                color: _mint, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              [
                                if (_activeCategoryFilter != 'ALL')
                                  _activeCategoryFilter,
                                if (_dateRangeFilter != 'All Time')
                                  _dateRangeFilter,
                              ].join(' · '),
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() {
                                _activeCategoryFilter = 'ALL';
                                _dateRangeFilter = 'All Time';
                              }),
                              child: const Icon(Icons.close,
                                  color: _mint, size: 14),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Right-side 3 Circular Floating Map Control Buttons
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildRoundMapControl(
                          icon: Icons.layers_outlined,
                          isActive: _layerMode != _MapLayerMode.darkVector,
                          tooltip: 'Cycle Map Layer',
                          onTap: _cycleMapLayer,
                        ),
                        const SizedBox(height: 10),
                        _buildRoundMapControl(
                          icon: Icons.alt_route,
                          isActive: _showRouteTrails,
                          tooltip: 'Toggle GPS Route Trails',
                          onTap: () {
                            setState(() => _showRouteTrails = !_showRouteTrails);
                            if (_showRouteTrails) {
                              _chartAnimController.forward(from: 0);
                            }
                            AppSnackbar.show(
                              context,
                              message: _showRouteTrails
                                  ? 'GPS route trails visible'
                                  : 'GPS route trails hidden',
                              type: SnackbarType.info,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildRoundMapControl(
                          icon: Icons.my_location,
                          isActive: false,
                          tooltip: 'Recenter Map',
                          onTap: _recenterMap,
                        ),
                      ],
                    ),
                  ),

                  // Bottom Floating Route Preview Card ("Riverside Trail Loop")
                  Positioned(
                    left: 16,
                    right: 74,
                    bottom: 16,
                    child: GestureDetector(
                      onTap: () => _showRouteElevationSheet(
                        _locations.firstWhere(
                          (e) => e.id == 'riverside_loop',
                          orElse: () => _locations.first,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: _carbon.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: _obsidian,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.06)),
                              ),
                              child: const Icon(Icons.directions_run,
                                color: _alpineBlue,
                                size: 19,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Riverside Trail Loop',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: _offWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '3 sessions mapped · 4.8 km',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const UlvenikIcon(UlvenikIcons.details,
                              color: _stoneGrey,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Interactive Category Legend Bar
        _buildCategoryLegendBar(),
      ],
    );
  }

  Widget _buildTopStatCard({
    required String value,
    required String label,
    required double width,
    required VoidCallback onTap,
    bool isTitleValue = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: _carbon.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _offWhite,
                fontSize: isTitleValue ? 14 : 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                height: 1.15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                height: 1.15,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultMapMarker(_MapLocationPin pin, double w, double h) {
    final cx = pin.normalizedPos.dx * w;
    final cy = pin.normalizedPos.dy * h;

    if (pin.clusterCount != null) {
      return Positioned(
        left: cx - 28,
        top: cy - 28,
        child: GestureDetector(
          onTap: () => _selectPin(pin.id),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pin.pinColor.withValues(alpha: 0.14),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _carbon,
                border: Border.all(
                  color: pin.pinColor.withValues(alpha: 0.85),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${pin.clusterCount}',
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Positioned(
      left: cx - 42,
      top: pin.topBadge != null ? cy - 46 : cy - 18,
      width: 84,
      child: GestureDetector(
        onTap: () => _selectPin(pin.id),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pin.topBadge != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: _forest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  pin.topBadge!,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _obsidian.withValues(alpha: 0.85),
                border: Border.all(color: pin.pinColor, width: 2),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pin.pinColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundMapControl({
    required IconData icon,
    required bool isActive,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? _forest.withValues(alpha: 0.35)
                : _carbon.withValues(alpha: 0.94),
            border: Border.all(
              color: isActive
                  ? _mint.withValues(alpha: 0.55)
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          alignment: Alignment.center,
          child: UlvenikIcon.fromMaterial(
            icon,
            color: isActive ? _mint : _stoneGrey,
            size: 19,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryLegendBar() {
    final items = [
      for (final cat in _mappedLegendCategories)
        (cat, _colorForCategoryLabel(cat)),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: const BoxDecoration(
        color: Color(0xFF161A1D),
        border: Border(
          top: BorderSide(color: _cardBorder),
          bottom: BorderSide(color: _cardBorder),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 14),
              GestureDetector(
                onTap: () {
                  final cat = items[i].$1;
                  setState(() {
                    _activeCategoryFilter =
                        _activeCategoryFilter == cat ? 'ALL' : cat;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: _activeCategoryFilter == items[i].$1
                        ? items[i].$2.withValues(alpha: 0.22)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: items[i].$2,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        items[i].$1,
                        style: TextStyle(
                          color: _activeCategoryFilter == items[i].$1
                              ? _offWhite
                              : _stoneGrey,
                          fontSize: 10.5,
                          fontWeight: _activeCategoryFilter == items[i].$1
                              ? FontWeight.w700
                              : FontWeight.w600,
                          letterSpacing: 0.4,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. MARKER SELECTED STATE (Matches 02_activity_map_marker_selected.png 100%)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildMarkerSelectedState(_MapLocationPin selected) {
    final sessions = selected.sessions
        .where(
            (s) => _hasSportPack || s.category.toUpperCase() != 'COMPETITION')
        .toList();
    if (_sessionSortMode == 'Longest First') {
      sessions.sort((a, b) => b.durationMins.compareTo(a.durationMins));
    }

    final favCount =
        selected.baseFavourites + (selected.isLocationFavourited ? 1 : 0);

    return Column(
      children: [
        // Top Topographic / Regional Map Viewport (~36% height)
        SizedBox(
          height: 256,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final mw = constraints.maxWidth;
              final mh = constraints.maxHeight;

              return Stack(
                children: [
                  // Tap map background to return to Default Overview
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _clearSelectedPin,
                      child: CustomPaint(
                        painter: _SelectedSectorTopoPainter(
                          showRoutes: _showRouteTrails,
                          layerMode: _layerMode,
                        ),
                      ),
                    ),
                  ),

                  // Nearby Secondary Location Pills (tappable to switch marker!)
                  _buildSecondaryMapPill(
                    label: 'Box Hill Track',
                    left: mw * 0.16,
                    top: mh * 0.14,
                    isSelected: selected.id == 'box_hill_track',
                    onTap: () => _selectPin('box_hill_track'),
                  ),
                  _buildSecondaryMapPill(
                    label: 'Vet Clinic HQ',
                    dotColor: const Color(0xFFFFB4AC),
                    left: mw * 0.65,
                    top: mh * 0.33,
                    isSelected: selected.id == 'vet_clinic_hq',
                    onTap: () => _selectPin('vet_clinic_hq'),
                  ),
                  _buildSecondaryMapPill(
                    label: 'South Meadows',
                    left: mw * 0.25,
                    top: mh * 0.65,
                    isSelected: selected.id == 'south_meadows',
                    onTap: () => _selectPin('south_meadows'),
                  ),

                  // Woodland green pins on topo map
                  Positioned(
                    left: mw * 0.73,
                    top: mh * 0.72,
                    child: GestureDetector(
                      onTap: () => _selectPin('blackwood_woods'),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _forest,
                          shape: BoxShape.circle,
                          border: Border.all(color: _offWhite, width: 1.5),
                        ),
                        child: const Icon(Icons.park, color: _offWhite, size: 12),
                      ),
                    ),
                  ),
                  if (_hasSportPack)
                    Positioned(
                      left: mw * 0.18,
                      top: mh * 0.82,
                      child: GestureDetector(
                        onTap: () => _selectPin('trial_grounds'),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _purple,
                            shape: BoxShape.circle,
                            border: Border.all(color: _offWhite, width: 1.5),
                          ),
                          child: const Icon(Icons.emoji_events,
                              color: _offWhite, size: 12),
                        ),
                      ),
                    ),

                  // Center Active SELECTED Pin + Halo + "SELECTED" Pill
                  Positioned(
                    left: mw * 0.5 - 64,
                    top: mh * 0.30,
                    width: 128,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _forest.withValues(alpha: 0.25),
                          ),
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _obsidian,
                                  border: Border.all(
                                      color: _forest.withValues(alpha: 0.9),
                                      width: 2),
                                ),
                                child: const Icon(Icons.location_on_outlined,
                                  color: _alpineBlue,
                                  size: 20,
                                ),
                              ),
                              Positioned(
                                right: 3,
                                top: 3,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: _alpineBlue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11, vertical: 4.5),
                          decoration: BoxDecoration(
                            color: _obsidian.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, color: _mint, size: 6),
                              SizedBox(width: 6),
                              Text(
                                'SELECTED',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Top-Left Coordinate Pill
                  Positioned(
                    top: 12,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _carbon.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.explore_outlined,
                              color: _sage, size: 13),
                          const SizedBox(width: 6),
                          Text(
                            selected.coordinates,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Top-Right 3 Rounded-Square Controls
                  Positioned(
                    top: 12,
                    right: 14,
                    child: Column(
                      children: [
                        _buildSquareTopoControl(
                          icon: Icons.my_location,
                          onTap: _recenterMap,
                        ),
                        const SizedBox(height: 8),
                        _buildSquareTopoControl(
                          icon: Icons.alt_route,
                          isActive: _showInlineTelemetry,
                          onTap: () {
                            setState(() {
                              _showInlineTelemetry = !_showInlineTelemetry;
                            });
                            if (_showInlineTelemetry) {
                              _chartAnimController.forward(from: 0);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildSquareTopoControl(
                          icon: Icons.layers_outlined,
                          onTap: _cycleMapLayer,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Docked Rounded-Top Location Details Sheet
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: _panelBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: _cardBorder)),
            ),
            child: Column(
              children: [
                // Drag Handle (tap to dismiss back to Default Map)
                GestureDetector(
                  onTap: _clearSelectedPin,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8),
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: _carbon,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _forest.withValues(alpha: 0.45),
                                ),
                              ),
                              child: const Icon(Icons.location_on_outlined,
                                color: _mint,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selected.name,
                                    style: const TextStyle(
                                      color: _offWhite,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    selected.venueSubtitle,
                                    style: const TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selected.isLocationFavourited =
                                      !selected.isLocationFavourited;
                                });
                                AppSnackbar.show(
                                  context,
                                  message: selected.isLocationFavourited
                                      ? '${selected.name} saved to Favourite Locations'
                                      : '${selected.name} removed from Favourites',
                                  type: SnackbarType.success,
                                );
                              },
                              icon: UlvenikIcon.fromMaterial(
                                selected.isLocationFavourited
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: selected.isLocationFavourited
                                    ? _mint
                                    : _stoneGrey,
                                size: 21,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // 3-Column Visits / First Visit / Last Visit Strip
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: _cardBorder),
                              bottom: BorderSide(color: _cardBorder),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildMarkerMetricColumn(
                                  value: '${selected.visits}',
                                  label: 'VISITS',
                                  valueSize: 21,
                                ),
                              ),
                              Container(
                                  width: 1, height: 34, color: _cardBorder),
                              Expanded(
                                child: _buildMarkerMetricColumn(
                                  value: selected.firstVisit,
                                  label: 'FIRST VISIT',
                                  valueSize: 15,
                                ),
                              ),
                              Container(
                                  width: 1, height: 34, color: _cardBorder),
                              Expanded(
                                child: _buildMarkerMetricColumn(
                                  value: selected.lastVisit,
                                  label: 'LAST VISIT',
                                  valueSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Recorded Here + Route Telemetry Pill
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'Recorded here:',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 12.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                            for (final cat
                                in _recordedCategoriesForPin(selected))
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _colorForCategoryLabel(cat),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    cat,
                                    style: const TextStyle(
                                      color: _offWhite,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.favorite_border,
                                color: _stoneGrey, size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '$favCount favourite events at this location',
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12.5,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showInlineTelemetry = !_showInlineTelemetry;
                                });
                                if (_showInlineTelemetry) {
                                  _chartAnimController.forward(from: 0);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _showInlineTelemetry
                                      ? _forest.withValues(alpha: 0.25)
                                      : _carbon,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _showInlineTelemetry
                                        ? _mint.withValues(alpha: 0.4)
                                        : _cardBorder,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const UlvenikIcon(UlvenikIcons.progress,
                                        color: _mint, size: 13),
                                    const SizedBox(width: 4),
                                    Text(
                                      _showInlineTelemetry
                                          ? 'Hide Profile'
                                          : 'Route Profile',
                                      style: const TextStyle(
                                        color: _mint,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Interactive Animated Route Elevation / Pace Profile (expandable)
                        if (_showInlineTelemetry) ...[
                          const SizedBox(height: 14),
                          _buildInteractiveRouteChartCard(selected),
                        ],

                        const SizedBox(height: 18),

                        // RECENT FIELD SESSIONS Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'RECENT FIELD SESSIONS',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.7,
                                fontFamily: 'Inter',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _sessionSortMode =
                                      _sessionSortMode == 'Chronological'
                                          ? 'Longest First'
                                          : 'Chronological';
                                });
                              },
                              child: Text(
                                _sessionSortMode,
                                style: const TextStyle(
                                  color: _sage,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Session Cards (first 2 shown cleanly like Figma)
                        for (final session in sessions.take(2)) ...[
                          _buildMarkerSessionCard(session, selected),
                          const SizedBox(height: 10),
                        ],

                        const SizedBox(height: 6),

                        // Bottom 2 Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 46,
                                child: OutlinedButton(
                                  onPressed: () =>
                                      _showAllLocationEventsSheet(selected),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFF14181A),
                                    foregroundColor: _mint,
                                    side: BorderSide(
                                        color: _forest.withValues(alpha: 0.75)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                  ),
                                  child: const Text(
                                    'View All Events Here',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: () {
                                    AppSnackbar.show(
                                      context,
                                      message:
                                          'Opening Timeline filtered to ${selected.name}',
                                      type: SnackbarType.info,
                                    );
                                    Navigator.maybePop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _forest,
                                    foregroundColor: _offWhite,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Open in Timeline',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      UlvenikIcon(UlvenikIcons.details, size: 15),
                                    ],
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryMapPill({
    required String label,
    required double left,
    required double top,
    required bool isSelected,
    required VoidCallback onTap,
    Color? dotColor,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? _forest.withValues(alpha: 0.9)
                : const Color(0xFF434B49).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.16),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dotColor != null) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareTopoControl({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive
              ? _forest.withValues(alpha: 0.88)
              : _carbon.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _cardBorder),
        ),
        child: UlvenikIcon.fromMaterial(
          icon,
          color: isActive ? _offWhite : _stoneGrey,
          size: 17,
        ),
      ),
    );
  }

  Widget _buildMarkerMetricColumn({
    required String value,
    required String label,
    required double valueSize,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: _offWhite,
            fontSize: valueSize,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Color _colorForCategoryLabel(String label) {
    switch (label.toUpperCase()) {
      case 'TRAINING':
        return _alpineBlue;
      case 'HEALTH':
        return _healthRed;
      case 'GOALS':
        return _gold;
      case 'S&C':
        return _bronze;
      case 'MEDIA':
        return _purple;
      case 'COMPETITION':
        return _forest;
      default:
        return _mint;
    }
  }

  Widget _buildMarkerSessionCard(
      _MappedSessionItem session, _MapLocationPin pin) {
    return GestureDetector(
      onTap: () {
        if (session.isTrackIcon) {
          _showRouteElevationSheet(pin);
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TimelineEventDetailsScreen(
              initialVariant: session.isHealthVariant
                  ? TimelineEventVariant.health
                  : TimelineEventVariant.training,
              eventId: session.id,
              initialTitle: session.title,
              initialDog: 'Murphy',
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: session.categoryColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        session.category,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    session.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    session.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (session.thumbnailUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  session.thumbnailUrl!,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 44,
                    height: 44,
                    color: _obsidian,
                    child: const UlvenikIcon(UlvenikIcons.dogs, color: _mint, size: 18),
                  ),
                ),
              )
            else
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF212629),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _cardBorder),
                ),
                child: UlvenikIcon.fromMaterial(
                  session.isTrackIcon
                      ? Icons.route_outlined
                      : Icons.medical_services_outlined,
                  color: _stoneGrey,
                  size: 20,
                ),
              ),
            const SizedBox(width: 8),
            const UlvenikIcon(UlvenikIcons.details, color: _stoneGrey, size: 17),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERACTIVE ANIMATED ROUTE ELEVATION / PACE TELEMETRY CHART
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildInteractiveRouteChartCard(_MapLocationPin pin) {
    final values = _telemetryMetric == 'Elevation'
        ? pin.elevationMeters
        : pin.speedKmh;
    final unit = _telemetryMetric == 'Elevation' ? 'm' : 'km/h';
    final accent = _telemetryMetric == 'Elevation' ? _mint : _alpineBlue;
    final activeIdx =
        (_scrubIndex != null && _scrubIndex! < values.length) ? _scrubIndex : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.terrain, color: _mint, size: 15),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'GPS ROUTE TELEMETRY · ${pin.routeDistanceLabel}',
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              _buildMetricToggleChip('Elevation'),
              const SizedBox(width: 6),
              _buildMetricToggleChip('Pace'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                activeIdx != null
                    ? 'Split ${activeIdx + 1}/${values.length}: ${values[activeIdx].toStringAsFixed(1)} $unit'
                    : (_telemetryMetric == 'Elevation'
                        ? 'Peak ${values.reduce(math.max).toStringAsFixed(0)} m · Scrub graph to inspect'
                        : 'Top speed ${values.reduce(math.max).toStringAsFixed(1)} km/h · Scrub to inspect'),
                style: TextStyle(
                  color: activeIdx != null ? _offWhite : _stoneGrey,
                  fontSize: 11.5,
                  fontWeight:
                      activeIdx != null ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (activeIdx != null)
                GestureDetector(
                  onTap: () => setState(() => _scrubIndex = null),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 108,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                void updateTouch(Offset localPos) {
                  if (values.length < 2) return;
                  final ratio =
                      (localPos.dx / constraints.maxWidth).clamp(0.0, 1.0);
                  final idx = (ratio * (values.length - 1)).round();
                  if (_scrubIndex != idx) {
                    setState(() => _scrubIndex = idx);
                  }
                }

                return GestureDetector(
                  onTapDown: (d) => updateTouch(d.localPosition),
                  onHorizontalDragUpdate: (d) => updateTouch(d.localPosition),
                  child: AnimatedBuilder(
                    animation: _chartAnim,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _RouteProfileChartPainter(
                          values: values,
                          progress: _chartAnim.value,
                          accentColor: accent,
                          selectedIndex: activeIdx,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricToggleChip(String metric) {
    final selected = _telemetryMetric == metric;
    return GestureDetector(
      onTap: () {
        setState(() {
          _telemetryMetric = metric;
          _scrubIndex = null;
        });
        _chartAnimController.forward(from: 0);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
        decoration: BoxDecoration(
          color: selected
              ? _forest.withValues(alpha: 0.35)
              : _obsidian.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? _mint.withValues(alpha: 0.5) : _cardBorder,
          ),
        ),
        child: Text(
          metric,
          style: TextStyle(
            color: selected ? _offWhite : _stoneGrey,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. EMPTY STATE (Matches 02_activity_map_empty.png 100%)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Stack(
      children: [
        // Subtle Nordic Sport Radar Grid Canvas
        const Positioned.fill(
          child: CustomPaint(
            painter: _EmptyRadarGridPainter(),
          ),
        ),

        // Top GPS Status & Heading Pills
        Positioned(
          top: 18,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                decoration: BoxDecoration(
                  color: _carbon.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _cardBorder),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: _mint, size: 7),
                    SizedBox(width: 7),
                    Text(
                      'GPS ACTIVE • OFFLINE READY',
                      style: TextStyle(
                        color: _sage,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: _carbon.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _cardBorder),
                ),
                child: Text(
                  _emptyHeadings[_emptyHeadingIndex],
                  style: const TextStyle(
                    color: _sage,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),

        // Center Floating "No Recorded Locations" Card
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
              decoration: BoxDecoration(
                color: _carbon.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _cardBorder),
              ),
              child: Stack(
                children: [
                  // Subtle corner rivet dots matching SVG
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 6),
                      Stack(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF252C30),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: const Icon(Icons.location_off_outlined,
                              color: _sage,
                              size: 28,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: _sage,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 4.5),
                        decoration: BoxDecoration(
                          color: _obsidian,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.explore_outlined,
                                color: _sage, size: 12),
                            SizedBox(width: 6),
                            Text(
                              "64°08'N 21°56'W",
                              style: TextStyle(
                                color: _sage,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'No Recorded Locations',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Timeline events with location\ninformation will appear here\nautomatically.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 14,
                          height: 1.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.maybePop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _forest,
                            foregroundColor: _offWhite,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Go to Timeline',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(width: 8),
                              UlvenikIcon(UlvenikIcons.details, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom-Left Scale Bar + WGS 84 Readout
        Positioned(
          left: 18,
          bottom: 22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 3.5,
                    decoration: const BoxDecoration(
                      color: _sage,
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(2)),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 3.5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF323533),
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(2)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '500 m',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'WGS 84 • NORDIC SPORT GRID',
                style: TextStyle(
                  color: _stoneGrey.withValues(alpha: 0.65),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.7,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),

        // Bottom-Right Globe & Compass Buttons
        Positioned(
          right: 18,
          bottom: 18,
          child: Column(
            children: [
              _buildRoundMapControl(
                icon: Icons.public,
                isActive: false,
                tooltip: 'Load Sample Mapped Sector',
                onTap: () {
                  setState(() => _isEmptyState = false);
                  AppSnackbar.show(
                    context,
                    message: 'Loaded Guildford sector (23 mapped locations)',
                    type: SnackbarType.success,
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildRoundMapControl(
                icon: Icons.explore_outlined,
                isActive: false,
                tooltip: 'Rotate Compass Bearing',
                onTap: () {
                  setState(() {
                    _emptyHeadingIndex =
                        (_emptyHeadingIndex + 1) % _emptyHeadings.length;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERACTIVE BOTTOM SHEETS (Search, Filters, Route Profile, All Events)
  // ═══════════════════════════════════════════════════════════════════════════
  void _showSearchLocationsSheet() {
    String query = '';
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final matches = _savedLocations.where((loc) {
              if (query.trim().isEmpty) return true;
              final q = query.toLowerCase();
              return loc.name.toLowerCase().contains(q) ||
                  loc.venueSubtitle.toLowerCase().contains(q) ||
                  loc.primaryCategory.toLowerCase().contains(q);
            }).toList();

            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
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
                    'Search Mapped Locations',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    autofocus: true,
                    style: const TextStyle(color: _offWhite, fontSize: 14),
                    onChanged: (v) => setModalState(() => query = v),
                    decoration: InputDecoration(
                      hintText: 'Search trail, clinic, or arena...',
                      hintStyle:
                          const TextStyle(color: _stoneGrey, fontSize: 13),
                      prefixIcon:
                          const UlvenikIcon(UlvenikIcons.search, color: _stoneGrey, size: 19),
                      filled: true,
                      fillColor: _obsidian,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: matches.length,
                      separatorBuilder: (_, _) =>
                          const Divider(color: _cardBorder, height: 1),
                      itemBuilder: (_, idx) {
                        final loc = matches[idx];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: loc.pinColor.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(Icons.place_outlined,
                                color: loc.pinColor, size: 18),
                          ),
                          title: Text(
                            loc.name,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${loc.visits} visits · ${loc.venueSubtitle}',
                            style: const TextStyle(
                                color: _stoneGrey, fontSize: 12),
                          ),
                          trailing: const UlvenikIcon(UlvenikIcons.details,
                              color: _stoneGrey, size: 18),
                          onTap: () {
                            Navigator.pop(ctx);
                            setState(() => _isEmptyState = false);
                            _selectPin(loc.id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMapFilterSheet() {
    final categories = [
      'ALL',
      ..._mappedLegendCategories,
    ];
    const ranges = ['All Time', 'Last 30 Days', '2026 Season', '2025 Archive'];

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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
                    'Filter Activity Map',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'EVENT CATEGORY',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final cat in categories)
                        ChoiceChip(
                          label: Text(cat),
                          selected: _activeCategoryFilter == cat,
                          onSelected: (_) {
                            setModalState(() => _activeCategoryFilter = cat);
                            setState(() => _activeCategoryFilter = cat);
                          },
                          selectedColor: _forest,
                          backgroundColor: _obsidian,
                          labelStyle: TextStyle(
                            color: _activeCategoryFilter == cat
                                ? _offWhite
                                : _stoneGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DATE WINDOW',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final r in ranges)
                        ChoiceChip(
                          label: Text(r),
                          selected: _dateRangeFilter == r,
                          onSelected: (_) {
                            setModalState(() => _dateRangeFilter = r);
                            setState(() => _dateRangeFilter = r);
                          },
                          selectedColor: _forest,
                          backgroundColor: _obsidian,
                          labelStyle: TextStyle(
                            color:
                                _dateRangeFilter == r ? _offWhite : _stoneGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Map Filters',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRouteElevationSheet(_MapLocationPin pin) {
    _chartAnimController.forward(from: 0);
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _panelBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final values = _telemetryMetric == 'Elevation'
                ? pin.elevationMeters
                : pin.speedKmh;
            final unit = _telemetryMetric == 'Elevation' ? 'm' : 'km/h';
            final accent =
                _telemetryMetric == 'Elevation' ? _mint : _alpineBlue;

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
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
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _carbon,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: const Icon(Icons.directions_run,
                            color: _alpineBlue, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pin.name,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${pin.sessions.length} sessions mapped · ${pin.routeDistanceLabel}',
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _selectPin(pin.id);
                        },
                        child: const Text(
                          'Inspect Pin',
                          style: TextStyle(
                              color: _mint, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      for (final m in ['Elevation', 'Pace']) ...[
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _telemetryMetric = m;
                              _scrubIndex = null;
                            });
                            setState(() {});
                            _chartAnimController.forward(from: 0);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _telemetryMetric == m ? _forest : _carbon,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _cardBorder),
                            ),
                            child: Text(
                              m == 'Elevation'
                                  ? 'Elevation Profile (m)'
                                  : 'Speed / Pace (km/h)',
                              style: TextStyle(
                                color: _telemetryMetric == m
                                    ? _offWhite
                                    : _stoneGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _scrubIndex != null && _scrubIndex! < values.length
                        ? 'Waypoint ${_scrubIndex! + 1}/${values.length}: ${values[_scrubIndex!].toStringAsFixed(1)} $unit'
                        : 'Drag across chart to inspect waypoint telemetry',
                    style: const TextStyle(
                      color: _sage,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 145,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        void onScrub(Offset pos) {
                          final r =
                              (pos.dx / constraints.maxWidth).clamp(0.0, 1.0);
                          final idx = (r * (values.length - 1)).round();
                          setModalState(() => _scrubIndex = idx);
                          setState(() => _scrubIndex = idx);
                        }

                        return GestureDetector(
                          onTapDown: (d) => onScrub(d.localPosition),
                          onHorizontalDragUpdate: (d) =>
                              onScrub(d.localPosition),
                          child: AnimatedBuilder(
                            animation: _chartAnim,
                            builder: (context, _) {
                              return CustomPaint(
                                painter: _RouteProfileChartPainter(
                                  values: values,
                                  progress: _chartAnim.value,
                                  accentColor: accent,
                                  selectedIndex: _scrubIndex,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAllLocationEventsSheet(_MapLocationPin pin) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: _panelBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
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
              Text(
                'All Events at ${pin.name} (${pin.visits})',
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${pin.firstVisit} – ${pin.lastVisit} · ${pin.venueSubtitle}',
                style: const TextStyle(color: _stoneGrey, fontSize: 12.5),
              ),
              const SizedBox(height: 14),
              for (final s in pin.sessions) ...[
                _buildMarkerSessionCard(s, pin),
                const SizedBox(height: 10),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS FOR ALL 3 STATES + ANIMATED ROUTE CHART
// ═════════════════════════════════════════════════════════════════════════════

class _DefaultActivityMapPainter extends CustomPainter {
  final _MapLayerMode layerMode;
  final bool showRoutes;
  final double routeProgress;
  final List<_MapLocationPin> pins;

  _DefaultActivityMapPainter({
    required this.layerMode,
    required this.showRoutes,
    required this.routeProgress,
    required this.pins,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgColor = switch (layerMode) {
      _MapLayerMode.darkVector => const Color(0xFF101316),
      _MapLayerMode.terrainTopo => const Color(0xFF131B19),
      _MapLayerMode.heatmap => const Color(0xFF0E1114),
    };
    canvas.drawRect(Offset.zero & size, Paint()..color = bgColor);

    // Subtle woodland / park polygons
    final parkPaint = Paint()
      ..color = layerMode == _MapLayerMode.terrainTopo
          ? const Color(0xFF1C2B25)
          : const Color(0xFF14191D);

    final nwWoods = Path()
      ..moveTo(0, size.height * 0.06)
      ..lineTo(size.width * 0.34, size.height * 0.08)
      ..quadraticBezierTo(size.width * 0.30, size.height * 0.28,
          size.width * 0.14, size.height * 0.34)
      ..lineTo(0, size.height * 0.28)
      ..close();
    canvas.drawPath(nwWoods, parkPaint);

    final eastWoods = Path()
      ..moveTo(size.width * 0.58, size.height * 0.50)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.46, size.width,
          size.height * 0.56)
      ..lineTo(size.width, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.76,
          size.width * 0.58, size.height * 0.58)
      ..close();
    canvas.drawPath(eastWoods, parkPaint);

    final swPark = Path()
      ..moveTo(size.width * 0.05, size.height * 0.68)
      ..quadraticBezierTo(size.width * 0.42, size.height * 0.65,
          size.width * 0.42, size.height * 0.84)
      ..lineTo(size.width * 0.10, size.height * 0.92)
      ..close();
    canvas.drawPath(swPark, parkPaint);

    // Heatmap glow overlay when Heatmap layer selected
    if (layerMode == _MapLayerMode.heatmap) {
      for (final p in pins) {
        final center =
            Offset(p.normalizedPos.dx * size.width, p.normalizedPos.dy * size.height);
        final radius = p.clusterCount != null ? 86.0 : 54.0;
        final shader = RadialGradient(
          colors: [
            p.pinColor.withValues(alpha: 0.38),
            p.pinColor.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
        canvas.drawCircle(center, radius, Paint()..shader = shader);
      }
    }

    // Winding RIVERSIDE CANAL water body
    final canalPath = Path()
      ..moveTo(size.width * 0.45, 0)
      ..cubicTo(
        size.width * 0.36,
        size.height * 0.24,
        size.width * 0.28,
        size.height * 0.38,
        size.width * 0.46,
        size.height * 0.56,
      )
      ..cubicTo(
        size.width * 0.61,
        size.height * 0.70,
        size.width * 0.50,
        size.height * 0.86,
        size.width * 0.43,
        size.height,
      );

    canvas.drawPath(
      canalPath,
      Paint()
        ..color = const Color(0xFF15222C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.round,
    );

    // Tributary stream on left
    final branchPath = Path()
      ..moveTo(0, size.height * 0.43)
      ..quadraticBezierTo(size.width * 0.18, size.height * 0.36,
          size.width * 0.35, size.height * 0.36);
    canvas.drawPath(
      branchPath,
      Paint()
        ..color = const Color(0xFF15222C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9,
    );

    // Subtle canal center dashed line
    _drawDashedPath(
      canvas,
      canalPath,
      Paint()
        ..color = const Color(0xFF233645)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
      dashWidth: 6,
      dashSpace: 6,
      progress: 1.0,
    );

    // Vector Road Network
    final roadPaint = Paint()
      ..color = const Color(0xFF22282C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6;

    final thinRoadPaint = Paint()
      ..color = const Color(0xFF1C2125)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawLine(
      Offset(0, size.height * 0.22),
      Offset(size.width, size.height * 0.39),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.10, 0),
      Offset(size.width * 0.27, size.height * 0.50),
      thinRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.27, size.height * 0.50),
      Offset(size.width * 0.18, size.height),
      thinRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.23, size.height * 0.47),
      Offset(size.width * 0.78, size.height * 0.57),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.78, size.height * 0.57),
      Offset(size.width, size.height * 0.69),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.71, size.height * 0.10),
      Offset(size.width * 0.67, size.height * 0.42),
      thinRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.67, size.height * 0.42),
      Offset(size.width, size.height * 0.50),
      thinRoadPaint,
    );

    // Animated GPS Dashed Trails
    if (showRoutes) {
      final northTrail = Path()
        ..moveTo(size.width * 0.33, size.height * 0.27)
        ..cubicTo(
          size.width * 0.52,
          size.height * 0.34,
          size.width * 0.66,
          size.height * 0.22,
          size.width * 0.87,
          size.height * 0.32,
        );
      _drawDashedPath(
        canvas,
        northTrail,
        Paint()
          ..color = const Color(0xFF7A8F7A).withValues(alpha: 0.75)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
        dashWidth: 4,
        dashSpace: 4,
        progress: routeProgress,
      );

      final southTrail = Path()
        ..moveTo(size.width * 0.20, size.height * 0.66)
        ..cubicTo(
          size.width * 0.38,
          size.height * 0.65,
          size.width * 0.48,
          size.height * 0.72,
          size.width * 0.62,
          size.height * 0.67,
        )
        ..quadraticBezierTo(
          size.width * 0.73,
          size.height * 0.65,
          size.width * 0.84,
          size.height * 0.76,
        );
      _drawDashedPath(
        canvas,
        southTrail,
        Paint()
          ..color = const Color(0xFF5D8FAF).withValues(alpha: 0.72)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
        dashWidth: 3.5,
        dashSpace: 4,
        progress: routeProgress,
      );
    }

    // Map Typography Labels (matching Figma Default State)
    _drawMapLabel(
      canvas,
      text: 'RIVERSIDE CANAL',
      offset: Offset(size.width * 0.18, size.height * 0.22),
      angle: 0.28,
    );
    _drawMapLabel(
      canvas,
      text: 'NORTH RIDGE TRAIL',
      offset: Offset(size.width * 0.60, size.height * 0.245),
      angle: 0.0,
    );
    _drawMapLabel(
      canvas,
      text: 'BLACKWOOD WOODS',
      offset: Offset(size.width * 0.71, size.height * 0.51),
      angle: 0.0,
    );
  }

  void _drawMapLabel(
    Canvas canvas, {
    required String text,
    required Offset offset,
    required double angle,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF5D6763),
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(angle);
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashWidth,
    required double dashSpace,
    required double progress,
  }) {
    for (final metric in path.computeMetrics()) {
      final maxLen = metric.length * progress.clamp(0.0, 1.0);
      double dist = 0;
      while (dist < maxLen) {
        final next = math.min(dist + dashWidth, maxLen);
        canvas.drawPath(metric.extractPath(dist, next), paint);
        dist += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DefaultActivityMapPainter oldDelegate) {
    return oldDelegate.layerMode != layerMode ||
        oldDelegate.showRoutes != showRoutes ||
        oldDelegate.routeProgress != routeProgress ||
        oldDelegate.pins.length != pins.length;
  }
}

class _SelectedSectorTopoPainter extends CustomPainter {
  final bool showRoutes;
  final _MapLayerMode layerMode;

  _SelectedSectorTopoPainter({
    required this.showRoutes,
    required this.layerMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Soft sage-tinted regional topographic/street look matching 02_activity_map_marker_selected.png
    final rect = Offset.zero & size;
    final grad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: layerMode == _MapLayerMode.darkVector
          ? const [
              Color(0xFF6B8078),
              Color(0xFFB7D2C6),
              Color(0xFF7B9089),
            ]
          : const [
              Color(0xFF567468),
              Color(0xFFA8CBB9),
              Color(0xFF69837A),
            ],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = grad);

    // Parkland green patches
    final meadowPaint = Paint()
      ..color = const Color(0xFF88B99D).withValues(alpha: 0.55);
    canvas.drawOval(
      Rect.fromLTWH(
          size.width * 0.58, size.height * 0.42, size.width * 0.28, 65),
      meadowPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(
          size.width * 0.04, size.height * 0.26, size.width * 0.26, 70),
      meadowPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(
          size.width * 0.36, size.height * 0.72, size.width * 0.32, 60),
      meadowPaint,
    );

    // River Wey blue ribbon
    final river = Path()
      ..moveTo(size.width * 0.62, 0)
      ..cubicTo(
        size.width * 0.56,
        size.height * 0.35,
        size.width * 0.44,
        size.height * 0.58,
        size.width * 0.39,
        size.height,
      );
    canvas.drawPath(
      river,
      Paint()
        ..color = const Color(0xFF6FA4C4).withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    // A3 / Regional Highway & Secondary Roads
    final highway = Path()
      ..moveTo(size.width * 0.88, 0)
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.34,
        size.width * 0.42,
        size.height * 0.60,
        size.width * 0.08,
        size.height * 0.88,
      );
    canvas.drawPath(
      highway,
      Paint()
        ..color = const Color(0xFF7B8599)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    final secRoad = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawLine(
      Offset(0, size.height * 0.48),
      Offset(size.width, size.height * 0.56),
      secRoad,
    );
    canvas.drawLine(
      Offset(size.width * 0.24, 0),
      Offset(size.width * 0.46, size.height),
      secRoad,
    );

    if (showRoutes) {
      final activeLoop = Path()
        ..moveTo(size.width * 0.43, size.height * 0.45)
        ..quadraticBezierTo(size.width * 0.52, size.height * 0.32,
            size.width * 0.58, size.height * 0.46)
        ..quadraticBezierTo(size.width * 0.50, size.height * 0.58,
            size.width * 0.43, size.height * 0.45);
      canvas.drawPath(
        activeLoop,
        Paint()
          ..color = const Color(0xFF2E6B57)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4,
      );
    }

    // Subtle town labels matching Guildford / Surrey view
    _paintTown(canvas, 'Worplesdon', Offset(size.width * 0.21, size.height * 0.38));
    _paintTown(canvas, 'Send', Offset(size.width * 0.63, size.height * 0.20));
    _paintTown(canvas, 'Guildford', Offset(size.width * 0.41, size.height * 0.72), bold: true);
    _paintTown(canvas, 'Clandon Park', Offset(size.width * 0.66, size.height * 0.54), green: true);
    _paintTown(canvas, 'Chantry Wood', Offset(size.width * 0.38, size.height * 0.83), green: true);

    // Top & bottom subtle vignette so pills and docked sheet blend cleanly
    final vignette = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withValues(alpha: 0.32),
        Colors.transparent,
        Colors.black.withValues(alpha: 0.38),
      ],
      stops: const [0.0, 0.45, 1.0],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = vignette);
  }

  void _paintTown(
    Canvas canvas,
    String name,
    Offset pos, {
    bool bold = false,
    bool green = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: name,
        style: TextStyle(
          color: green ? const Color(0xFF21523E) : const Color(0xFF242B29),
          fontSize: bold ? 10.5 : 9.5,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant _SelectedSectorTopoPainter oldDelegate) {
    return oldDelegate.showRoutes != showRoutes ||
        oldDelegate.layerMode != layerMode;
  }
}

class _EmptyRadarGridPainter extends CustomPainter {
  const _EmptyRadarGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFF0D1013));

    final center = Offset(size.width * 0.52, size.height * 0.46);
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final r in [110.0, 190.0, 275.0, 360.0]) {
      canvas.drawCircle(center, r, ringPaint);
    }

    final axisPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width * 0.20, 0),
      Offset(size.width * 0.82, size.height),
      axisPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.28),
      Offset(size.width, size.height * 0.66),
      axisPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RouteProfileChartPainter extends CustomPainter {
  final List<double> values;
  final double progress;
  final Color accentColor;
  final int? selectedIndex;

  _RouteProfileChartPainter({
    required this.values,
    required this.progress,
    required this.accentColor,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final span = (maxV - minV).abs() < 0.01 ? 1.0 : (maxV - minV);

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    for (int i = 0; i < 3; i++) {
      final y = size.height * (0.15 + i * 0.35);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final norm = (values[i] - minV) / span;
      final targetY = size.height * 0.86 - (norm * size.height * 0.68);
      final animatedY =
          size.height * 0.88 + (targetY - size.height * 0.88) * progress;
      points.add(Offset(x, animatedY));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final fillShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        accentColor.withValues(alpha: 0.32),
        accentColor.withValues(alpha: 0.0),
      ],
    ).createShader(Offset.zero & size);

    canvas.drawPath(fillPath, Paint()..shader = fillShader);
    canvas.drawPath(
      linePath,
      Paint()
        ..color = accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );

    if (selectedIndex != null &&
        selectedIndex! >= 0 &&
        selectedIndex! < points.length) {
      final pt = points[selectedIndex!];
      canvas.drawLine(
        Offset(pt.dx, 0),
        Offset(pt.dx, size.height),
        Paint()
          ..color = accentColor.withValues(alpha: 0.45)
          ..strokeWidth = 1.2,
      );
      canvas.drawCircle(
        pt,
        6,
        Paint()..color = accentColor.withValues(alpha: 0.28),
      );
      canvas.drawCircle(pt, 3.8, Paint()..color = const Color(0xFFF5F6F2));
    }
  }

  @override
  bool shouldRepaint(covariant _RouteProfileChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.values != values;
  }
}
