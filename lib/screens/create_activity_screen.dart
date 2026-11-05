import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'activity_library_screen.dart';
import '../widgets/custom_snackbar.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  // Scandinavian Obsidian / Carbon Dark Palette
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceContainer = Color(0xFF1D201F);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _forestGreen = Color(0xFF2E6B57);
  static const _mint = Color(0xFF95D3BB);
  static const _sage = Color(0xFFB6CCB5);
  static const _alpineBlue = Color(0xFF5D8FAF);
  static const _amber = Color(0xFFD97706);
  static const _errorMuted = Color(0xFF8B3A3A);
  static const _stoneGrey = Color(0xFFA7B0AB);
  static const _offWhite = Color(0xFFF5F6F2);

  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));
  static final _hairlineSide =
      BorderSide(color: Colors.white.withValues(alpha: 0.08));

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _iconSearchController = TextEditingController();

  // Selected State
  IconData _selectedIcon = Icons.pets;
  Color _selectedColor = _forestGreen;
  bool _isFavourite = false;
  final String _selectedCategory = 'Strength';
  String _iconSearchQuery = '';
  final List<CustomActivityMetric> _customMetrics = [];

  // Standard Swatches from Figma
  final List<Color> _swatches = const [
    _forestGreen,
    _sage,
    _alpineBlue,
    _amber,
    _errorMuted,
    _stoneGrey,
  ];

  // Recently used icons
  final List<IconData> _recentIcons = const [
    Icons.pets,
    Icons.directions_run,
    Icons.park,
    Icons.water_drop,
    Icons.fitness_center,
  ];

  // Catalog of all available icons with readable tags
  final List<Map<String, dynamic>> _allIcons = const [
    {'icon': Icons.pets, 'name': 'Paws / Agility', 'category': 'General'},
    {'icon': Icons.directions_run, 'name': 'Running / Sprint', 'category': 'Cardio'},
    {'icon': Icons.park, 'name': 'Outdoor / Trail', 'category': 'Terrain'},
    {'icon': Icons.water_drop, 'name': 'Water Work', 'category': 'Hydro'},
    {'icon': Icons.fitness_center, 'name': 'Weights / Strength', 'category': 'Power'},
    {'icon': Icons.pool, 'name': 'Dock Diving', 'category': 'Hydro'},
    {'icon': Icons.hiking, 'name': 'Hill Climb', 'category': 'Cardio'},
    {'icon': Icons.terrain, 'name': 'Rough Terrain', 'category': 'Terrain'},
    {'icon': Icons.timer, 'name': 'Intervals / Tabata', 'category': 'Power'},
    {'icon': Icons.speed, 'name': 'High Speed', 'category': 'Cardio'},
    {'icon': Icons.bolt, 'name': 'Explosive Power', 'category': 'Power'},
    {'icon': Icons.sports_tennis, 'name': 'Fetch / Retrieval', 'category': 'General'},
    {'icon': Icons.favorite, 'name': 'Cardio Heart Rate', 'category': 'Cardio'},
    {'icon': Icons.shield, 'name': 'Core Stability', 'category': 'Power'},
    {'icon': Icons.military_tech, 'name': 'Working Dog Drill', 'category': 'General'},
    {'icon': Icons.stars, 'name': 'High Drive / Focus', 'category': 'General'},
    {'icon': Icons.battery_charging_full, 'name': 'Endurance Base', 'category': 'Cardio'},
    {'icon': Icons.spa, 'name': 'Active Recovery', 'category': 'Recovery'},
    {'icon': Icons.waves, 'name': 'Current Swimming', 'category': 'Hydro'},
    {'icon': Icons.landscape, 'name': 'Distance Trekking', 'category': 'Terrain'},
    {'icon': Icons.self_improvement, 'name': 'Flexibility & Stretches', 'category': 'Recovery'},
    {'icon': Icons.flag, 'name': 'Course Completion', 'category': 'General'},
  ];

  // Extended custom color palette
  final List<Color> _extendedColors = const [
    Color(0xFF10B981), // Emerald
    Color(0xFF14B8A6), // Teal
    Color(0xFF06B6D4), // Cyan
    Color(0xFF0284C7), // Sky Blue
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Violet
    Color(0xFFA855F7), // Purple
    Color(0xFFD946EF), // Fuchsia
    Color(0xFFF43F5E), // Rose
    Color(0xFFE11D48), // Crimson
    Color(0xFFF97316), // Sunset Orange
    Color(0xFFEAB308), // Golden Yellow
    Color(0xFF84CC16), // Lime Green
    Color(0xFF3F6212), // Deep Olive
    Color(0xFF475569), // Slate
    Color(0xFFCBD5E1), // Cool Silver
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _descController.addListener(() => setState(() {}));
    _iconSearchController.addListener(() {
      setState(() {
        _iconSearchQuery = _iconSearchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _iconSearchController.dispose();
    super.dispose();
  }

  bool get _isFormValid => _nameController.text.trim().isNotEmpty;

  void _submitForm() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final desc = _descController.text.trim().isEmpty
        ? 'Custom conditioning activity'
        : _descController.text.trim();

    final newItem = LibraryActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: desc,
      sessionCount: 0,
      lastTrained: 'Never',
      streakDays: 0,
      isFavourite: _isFavourite,
      icon: _selectedIcon,
      category: _selectedCategory,
      equipment: 'Standard Gear',
      defaultDurationMinutes: 25,
      color: _selectedColor,
      customMetrics: List.unmodifiable(_customMetrics),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    AppSnackbar.show(
      context,
      message: 'Created activity "$name"',
      type: SnackbarType.success,
    );

    Navigator.of(context).pop(newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      // No duplicate bottomNavigationBar! Handled by MainLayout
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: Container(
          decoration: BoxDecoration(
            color: _obsidian,
            border: Border(bottom: _hairlineSide),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const UlvenikIcon(UlvenikIcons.back, color: _sage, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Text(
                    'Create Activity',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: _stoneGrey, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Reset form',
                    onPressed: () {
                      _nameController.clear();
                      _descController.clear();
                      _iconSearchController.clear();
                      setState(() {
                        _selectedIcon = Icons.pets;
                        _selectedColor = _forestGreen;
                        _isFavourite = false;
                        _customMetrics.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Activity Name
                _buildNameSection(),
                const SizedBox(height: 24),

                // 2. Description (Optional)
                _buildDescriptionSection(),
                const SizedBox(height: 24),

                // 3. Activity Icon
                _buildIconSection(),
                const SizedBox(height: 24),

                // 4. Activity Colour
                _buildColorSection(),
                const SizedBox(height: 24),

                // 5. Custom Metrics (Optional)
                _buildCustomMetricsSection(),
                const SizedBox(height: 24),

                // 6. Favourite Activity Toggle
                _buildFavouriteToggleSection(),
              ],
            ),
          ),

          // Pinned Bottom Action Button Area
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomActionBar(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION 1: ACTIVITY NAME
  // ==========================================
  Widget _buildNameSection() {
    final currentLength = _nameController.text.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Name',
          style: TextStyle(
            color: _offWhite,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: _hairlineBorder,
          ),
          child: TextField(
            controller: _nameController,
            maxLength: 100,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Enter activity name',
              hintStyle: const TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _forestGreen, width: 1.5),
              ),
              suffixIcon: _nameController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 16, color: _stoneGrey),
                      onPressed: () => _nameController.clear(),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'A short, memorable name',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '$currentLength/100',
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // SECTION 2: DESCRIPTION (OPTIONAL)
  // ==========================================
  Widget _buildDescriptionSection() {
    final currentLength = _descController.text.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Description ',
            style: TextStyle(
              color: _offWhite,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: '(Optional)',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          constraints: const BoxConstraints(minHeight: 100),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: _hairlineBorder,
          ),
          child: TextField(
            controller: _descController,
            maxLines: 4,
            maxLength: 500,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Add a description for this activity',
              hintStyle: const TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _forestGreen, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$currentLength/500',
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SECTION 3: ACTIVITY ICON
  // ==========================================
  Widget _buildIconSection() {
    // Filter icons if search has text
    final List<IconData> displayedIcons;
    if (_iconSearchQuery.isEmpty) {
      displayedIcons = _recentIcons;
    } else {
      final matches = _allIcons
          .where((item) =>
              (item['name'] as String).toLowerCase().contains(_iconSearchQuery) ||
              (item['category'] as String).toLowerCase().contains(_iconSearchQuery))
          .map((item) => item['icon'] as IconData)
          .take(5)
          .toList();
      displayedIcons = matches.isEmpty ? _recentIcons : matches;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Icon',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: _hairlineBorder,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input Inside Card
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: _obsidian,
                  borderRadius: BorderRadius.circular(8),
                  border: _hairlineBorder,
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: UlvenikIcon(UlvenikIcons.search, size: 18, color: _stoneGrey),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _iconSearchController,
                        style: const TextStyle(color: _offWhite, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Search icons...',
                          hintStyle: TextStyle(color: _stoneGrey, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    if (_iconSearchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, size: 16, color: _stoneGrey),
                        onPressed: () => _iconSearchController.clear(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Recently Used Header
              Text(
                _iconSearchQuery.isEmpty ? 'RECENTLY USED' : 'SEARCH RESULTS',
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              // Grid of 5 icon chips
              Row(
                children: displayedIcons.map((icon) {
                  final isSelected = _selectedIcon == icon;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected ? _surfaceContainer : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? _forestGreen
                                  : Colors.white.withValues(alpha: 0.08),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Center(
                            child: UlvenikIcon.fromMaterial(
                              icon,
                              color: isSelected ? _mint : _sage,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Browse all icons button
              InkWell(
                onTap: _showAllIconsBottomSheet,
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Browse all icons',
                        style: TextStyle(
                          color: _sage,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      UlvenikIcon(UlvenikIcons.details, size: 16, color: _sage),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SECTION 4: ACTIVITY COLOUR
  // ==========================================
  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Colour',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: _hairlineBorder,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 6 Swatches
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _swatches.map((swatchColor) {
                  final isSelected =
                      _selectedColor.toARGB32() == swatchColor.toARGB32();
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedColor = swatchColor;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: swatchColor,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: _obsidian, width: 2)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: swatchColor.withValues(alpha: 0.8),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(Icons.check,
                                size: 18,
                                color: _offWhite,
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Custom colour trigger button
              InkWell(
                onTap: _showCustomColorPickerBottomSheet,
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Custom colour',
                        style: TextStyle(
                          color: _sage,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.palette_outlined, size: 16, color: _sage),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SECTION 5: CUSTOM METRICS (OPTIONAL)
  // ==========================================
  Widget _buildCustomMetricsSection() {
    final metricCount = _customMetrics.length;
    final countLabel = metricCount == 1 ? '1 metric' : '$metricCount metrics';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Custom Metrics (Optional)',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_customMetrics.isNotEmpty)
              Text(
                countLabel,
                style: const TextStyle(
                  color: _mint,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Create whatever you want to track for this particular activity (e.g. Distance — metres, Load — kg, Incline — %).',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: _hairlineBorder,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_customMetrics.isEmpty) ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No custom metrics added yet. Tap "+ Add Metric" to create metrics specific to this activity.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ] else ...[
                ..._customMetrics.asMap().entries.map((entry) {
                  final index = entry.key;
                  final metric = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: _surfaceHigh,
                      borderRadius: BorderRadius.circular(8),
                      border: _hairlineBorder,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: _mint,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${metric.name} — ${metric.unit}',
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              size: 18, color: _stoneGrey),
                          tooltip: 'Remove metric',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _customMetrics.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 6),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _mint,
                    side: BorderSide(color: _mint.withValues(alpha: 0.6)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _showAddMetricSheet,
                  icon: const UlvenikIcon(UlvenikIcons.add, size: 18),
                  label: const Text(
                    '+ Add Metric',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddMetricSheet() {
    final nameCtrl = TextEditingController();
    final unitCtrl = TextEditingController();

    final metricSuggestions = const [
      'Distance',
      'Speed',
      'Incline',
      'Height',
      'Load',
      'Repetitions',
    ];

    final unitSuggestions = const [
      'metres',
      'mph',
      '%',
      'cm',
      'kg',
      'reps',
      'sec',
      'min',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Custom Metric',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: _stoneGrey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Define the metric name and unit you want to track for this activity.',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Metric Name Field
                  const Text(
                    'Metric Name',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(color: _offWhite, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'e.g. Distance, Load, Speed, Incline',
                      hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                      filled: true,
                      fillColor: _surfaceHigh,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: _hairlineSide,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: _hairlineSide,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _mint),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Metric Suggestions
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: metricSuggestions.map((suggestion) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text(suggestion),
                            labelStyle: const TextStyle(
                              color: _mint,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            backgroundColor: _surfaceHigh,
                            side: BorderSide(
                              color: _mint.withValues(alpha: 0.3),
                            ),
                            onPressed: () {
                              setSheetState(() {
                                nameCtrl.text = suggestion;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Metric Unit Field
                  const Text(
                    'Unit',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: unitCtrl,
                    style: const TextStyle(color: _offWhite, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'e.g. metres, mph, %, cm, kg, reps',
                      hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                      filled: true,
                      fillColor: _surfaceHigh,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: _hairlineSide,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: _hairlineSide,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _mint),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Unit Suggestions
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: unitSuggestions.map((suggestion) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text(suggestion),
                            labelStyle: const TextStyle(
                              color: _sage,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            backgroundColor: _surfaceHigh,
                            side: BorderSide(
                              color: _sage.withValues(alpha: 0.3),
                            ),
                            onPressed: () {
                              setSheetState(() {
                                unitCtrl.text = suggestion;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forestGreen,
                        foregroundColor: _offWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        final unit = unitCtrl.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          AppSnackbar.show(
                            context,
                            message: 'Please enter a metric name',
                            type: SnackbarType.warning,
                          );
                          return;
                        }
                        if (unit.isEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          AppSnackbar.show(
                            context,
                            message: 'Please enter a unit',
                            type: SnackbarType.warning,
                          );
                          return;
                        }

                        setState(() {
                          _customMetrics.add(
                            CustomActivityMetric(
                              id: 'm-${DateTime.now().millisecondsSinceEpoch}',
                              name: name,
                              unit: unit,
                            ),
                          );
                        });

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        AppSnackbar.show(
                          context,
                          message: 'Added metric: $name ($unit)',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Text(
                        'Add Metric',
                        style: TextStyle(
                          fontSize: 15,
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
      },
    );
  }

  // ==========================================
  // SECTION 6: FAVOURITE ACTIVITY TOGGLE
  // ==========================================
  Widget _buildFavouriteToggleSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: _hairlineBorder,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              UlvenikIcon.fromMaterial(
                _isFavourite ? Icons.star : Icons.star_border,
                color: _isFavourite ? _amber : _stoneGrey,
                size: 22,
              ),
              const SizedBox(width: 12),
              const Text(
                'Add to Favourites',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Switch(
            value: _isFavourite,
            activeThumbColor: _offWhite,
            activeTrackColor: _forestGreen,
            inactiveThumbColor: _stoneGrey,
            inactiveTrackColor: _obsidian,
            onChanged: (val) {
              setState(() {
                _isFavourite = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FIXED BOTTOM ACTION BAR
  // ==========================================
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _obsidian.withValues(alpha: 0.0),
            _obsidian.withValues(alpha: 0.95),
            _obsidian,
          ],
          stops: const [0.0, 0.35, 1.0],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isFormValid
                ? 'Ready to create activity'
                : 'Enter an activity name to continue',
            style: TextStyle(
              color: _isFormValid ? _mint : _stoneGrey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isFormValid ? _submitForm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _forestGreen,
                disabledBackgroundColor: _forestGreen.withValues(alpha: 0.4),
                foregroundColor: _offWhite,
                disabledForegroundColor: _offWhite.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: _isFormValid ? 3 : 0,
              ),
              child: const Text(
                'Create Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MODAL: ALL ICONS BROWSER
  // ==========================================
  void _showAllIconsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = _allIcons.where((item) {
              final name = (item['name'] as String).toLowerCase();
              final cat = (item['category'] as String).toLowerCase();
              return name.contains(query.toLowerCase()) ||
                  cat.contains(query.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Activity Icon',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Search in Sheet
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(10),
                      border: _hairlineBorder,
                    ),
                    child: TextField(
                      style: const TextStyle(color: _offWhite, fontSize: 13),
                      decoration: const InputDecoration(
                        prefixIcon:
                            UlvenikIcon(UlvenikIcons.search, size: 18, color: _stoneGrey),
                        hintText: 'Search canine exercise icons...',
                        hintStyle: TextStyle(color: _stoneGrey, fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 11),
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          query = val.trim();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Icons Grid
                  Expanded(
                    child: GridView.builder(
                      itemCount: filtered.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        final icon = item['icon'] as IconData;
                        final name = item['name'] as String;
                        final isSelected = _selectedIcon == icon;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon;
                            });
                            Navigator.pop(ctx);
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _surfaceContainer
                                  : _surfaceHigh.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? _forestGreen
                                    : Colors.white.withValues(alpha: 0.08),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UlvenikIcon.fromMaterial(
                                  icon,
                                  color: isSelected ? _mint : _sage,
                                  size: 26,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: isSelected ? _offWhite : _stoneGrey,
                                    fontSize: 10,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
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

  // ==========================================
  // MODAL: CUSTOM COLOUR PICKER
  // ==========================================
  void _showCustomColorPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose Custom Colour',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select an athletic accent colour for charts, badges, and activity logs',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Extended Colors Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _extendedColors.map((color) {
                  final isSelected =
                      _selectedColor.toARGB32() == color.toARGB32();
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: _offWhite, width: 2)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.8),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(Icons.check,
                                color: _offWhite,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
