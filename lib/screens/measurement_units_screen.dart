import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum _UnitSystemPreset { metric, imperial, custom }

class _UnitChoice {
  final String id;
  final String title;
  final String shortUnit;
  final String rowSample;
  final String previewValue;
  final String detailHint;

  const _UnitChoice({
    required this.id,
    required this.title,
    required this.shortUnit,
    required this.rowSample,
    required this.previewValue,
    required this.detailHint,
  });
}

class MeasurementUnitsScreen extends StatefulWidget {
  const MeasurementUnitsScreen({super.key});

  @override
  State<MeasurementUnitsScreen> createState() => _MeasurementUnitsScreenState();
}

class _MeasurementUnitsScreenState extends State<MeasurementUnitsScreen> {
  // Saved baseline state (defaults to Metric per Figma)
  _UnitSystemPreset _savedPreset = _UnitSystemPreset.metric;
  String _savedWeightId = 'kg';
  String _savedHeightId = 'cm';
  String _savedDistanceId = 'km';
  String _savedShortDistanceId = 'm';
  String _savedDurationId = 'hr_min';
  String _savedVolumeId = 'ml';

  // Active working state
  _UnitSystemPreset _selectedPreset = _UnitSystemPreset.metric;
  String _weightId = 'kg';
  String _heightId = 'cm';
  String _distanceId = 'km';
  String _shortDistanceId = 'm';
  String _durationId = 'hr_min';
  String _volumeId = 'ml';

  bool _showTrailElevationPreview = false;

  static const List<_UnitChoice> _weightChoices = [
    _UnitChoice(
      id: 'kg',
      title: 'Kilograms',
      shortUnit: 'kg',
      rowSample: '32.4 kg',
      previewValue: '32.4 kg',
      detailHint: 'Standard metric body weight & veterinary dosing',
    ),
    _UnitChoice(
      id: 'lb',
      title: 'Pounds',
      shortUnit: 'lb',
      rowSample: '71.4 lb',
      previewValue: '71.4 lb',
      detailHint: 'Imperial body weight & conditioning logs',
    ),
    _UnitChoice(
      id: 'st_lb',
      title: 'Stone & Pounds',
      shortUnit: 'st lb',
      rowSample: '5 st 1.4 lb',
      previewValue: '5 st 1.4 lb',
      detailHint: 'UK traditional weight display',
    ),
  ];

  static const List<_UnitChoice> _heightChoices = [
    _UnitChoice(
      id: 'cm',
      title: 'Centimetres',
      shortUnit: 'cm',
      rowSample: '68 cm',
      previewValue: '60 cm',
      detailHint: 'Withers height (68 cm) & agility jump height (60 cm)',
    ),
    _UnitChoice(
      id: 'in',
      title: 'Inches',
      shortUnit: 'in',
      rowSample: '26.8 in',
      previewValue: '24 in',
      detailHint: 'Withers height (26.8 in) & agility jump height (24 in)',
    ),
  ];

  static const List<_UnitChoice> _distanceChoices = [
    _UnitChoice(
      id: 'km',
      title: 'Kilometres',
      shortUnit: 'km',
      rowSample: '4.8 km',
      previewValue: '4.8 km',
      detailHint: 'Walks, canicross & tracking trails (4.8 km · +140 m elev)',
    ),
    _UnitChoice(
      id: 'mi',
      title: 'Miles',
      shortUnit: 'mi',
      rowSample: '3.0 mi',
      previewValue: '3.0 mi',
      detailHint: 'Walks, canicross & tracking trails (3.0 mi · +460 ft elev)',
    ),
  ];

  static const List<_UnitChoice> _shortDistanceChoices = [
    _UnitChoice(
      id: 'm',
      title: 'Metres',
      shortUnit: 'm',
      rowSample: '15 m',
      previewValue: '+140 m',
      detailHint: 'Recall send-aways (15 m) & trail elevation (+140 m)',
    ),
    _UnitChoice(
      id: 'yd',
      title: 'Yards',
      shortUnit: 'yd',
      rowSample: '16 yd',
      previewValue: '+153 yd',
      detailHint: 'Field trials, obedience retrieves & gundog casts',
    ),
    _UnitChoice(
      id: 'ft',
      title: 'Feet',
      shortUnit: 'ft',
      rowSample: '50 ft',
      previewValue: '+460 ft',
      detailHint: 'Long-line work (50 ft) & trail elevation (+460 ft)',
    ),
  ];

  static const List<_UnitChoice> _durationChoices = [
    _UnitChoice(
      id: 'hr_min',
      title: 'Hours & Minutes',
      shortUnit: 'hr min',
      rowSample: '1 hr 30 min',
      previewValue: '1 hr 30 min',
      detailHint: 'Readable session & hike durations',
    ),
    _UnitChoice(
      id: 'min',
      title: 'Total Minutes',
      shortUnit: 'min',
      rowSample: '90 min',
      previewValue: '90 min',
      detailHint: 'Compact training drill & conditioning totals',
    ),
    _UnitChoice(
      id: 'hms',
      title: 'Stopwatch (HH:MM:SS)',
      shortUnit: 'hh:mm:ss',
      rowSample: '01:30:00',
      previewValue: '01:30:00',
      detailHint: 'Precision competition & agility course timing',
    ),
  ];

  static const List<_UnitChoice> _volumeChoices = [
    _UnitChoice(
      id: 'ml',
      title: 'Millilitres / Litres',
      shortUnit: 'ml',
      rowSample: '250 ml',
      previewValue: '250 ml',
      detailHint: 'Hydration intake, liquid supplements & medications',
    ),
    _UnitChoice(
      id: 'fl_oz',
      title: 'Fluid Ounces',
      shortUnit: 'fl oz',
      rowSample: '8.5 fl oz',
      previewValue: '8.5 fl oz',
      detailHint: 'Imperial water bowls & liquid supplement dosing',
    ),
    _UnitChoice(
      id: 'cups',
      title: 'Cups (US)',
      shortUnit: 'cups',
      rowSample: '1.0 cup',
      previewValue: '1.0 cup',
      detailHint: 'Daily ration & hydration portioning',
    ),
  ];

  _UnitChoice _byId(List<_UnitChoice> list, String id) =>
      list.firstWhere((e) => e.id == id, orElse: () => list.first);

  _UnitChoice get _weight => _byId(_weightChoices, _weightId);
  _UnitChoice get _height => _byId(_heightChoices, _heightId);
  _UnitChoice get _distance => _byId(_distanceChoices, _distanceId);
  _UnitChoice get _shortDistance =>
      _byId(_shortDistanceChoices, _shortDistanceId);
  _UnitChoice get _duration => _byId(_durationChoices, _durationId);
  _UnitChoice get _volume => _byId(_volumeChoices, _volumeId);

  bool get _hasPendingChanges =>
      _selectedPreset != _savedPreset ||
      _weightId != _savedWeightId ||
      _heightId != _savedHeightId ||
      _distanceId != _savedDistanceId ||
      _shortDistanceId != _savedShortDistanceId ||
      _durationId != _savedDurationId ||
      _volumeId != _savedVolumeId;

  bool get _matchesMetric =>
      _weightId == 'kg' &&
      _heightId == 'cm' &&
      _distanceId == 'km' &&
      _shortDistanceId == 'm' &&
      _volumeId == 'ml';

  bool get _matchesImperial =>
      _weightId == 'lb' &&
      _heightId == 'in' &&
      _distanceId == 'mi' &&
      (_shortDistanceId == 'yd' || _shortDistanceId == 'ft') &&
      _volumeId == 'fl_oz';

  String get _systemTitle {
    switch (_selectedPreset) {
      case _UnitSystemPreset.metric:
        return 'Metric';
      case _UnitSystemPreset.imperial:
        return 'Imperial';
      case _UnitSystemPreset.custom:
        return 'Custom';
    }
  }

  String get _systemBadge => _systemTitle.toUpperCase();

  String get _systemSummaryLine =>
      '${_weight.shortUnit} · ${_distance.shortUnit} · ${_height.shortUnit}';

  void _selectPreset(_UnitSystemPreset preset) {
    setState(() {
      _selectedPreset = preset;
      if (preset == _UnitSystemPreset.metric) {
        _weightId = 'kg';
        _heightId = 'cm';
        _distanceId = 'km';
        _shortDistanceId = 'm';
        _durationId = 'hr_min';
        _volumeId = 'ml';
      } else if (preset == _UnitSystemPreset.imperial) {
        _weightId = 'lb';
        _heightId = 'in';
        _distanceId = 'mi';
        _shortDistanceId = 'yd';
        _durationId = 'hr_min';
        _volumeId = 'fl_oz';
      }
    });
  }

  void _syncPresetAfterIndividualChange() {
    if (_matchesMetric && _durationId == 'hr_min') {
      _selectedPreset = _UnitSystemPreset.metric;
    } else if (_matchesImperial && _durationId == 'hr_min') {
      _selectedPreset = _UnitSystemPreset.imperial;
    } else {
      _selectedPreset = _UnitSystemPreset.custom;
    }
  }

  void _openCategoryPicker({
    required String categoryTitle,
    required List<_UnitChoice> choices,
    required String currentId,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryTextStoneGrey.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  categoryTitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextOffWhite,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Choose your preferred display unit for this category.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundObsidian,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder, width: 1),
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < choices.length; i++) ...[
                          if (i > 0)
                            Container(height: 1, color: AppColors.cardBorder),
                          _buildPickerOptionRow(
                            choice: choices[i],
                            isSelected: choices[i].id == currentId,
                            onTap: () {
                              Navigator.of(sheetCtx).pop();
                              setState(() {
                                onSelected(choices[i].id);
                                _syncPresetAfterIndividualChange();
                              });
                            },
                          ),
                        ],
                      ],
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

  Widget _buildPickerOptionRow({
    required _UnitChoice choice,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected
          ? AppColors.primaryForestGreen.withValues(alpha: 0.15)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          choice.title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextOffWhite,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            choice.rowSample,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryTextStoneGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      choice.detailHint,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (isSelected)
                const Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: AppColors.primaryForestGreen,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePreferences() {
    if (!_hasPendingChanges) {
      AppSnackbar.show(
        context,
        title: 'Units Up to Date',
        message: '$_systemTitle ($_systemSummaryLine) is already saved.',
        type: SnackbarType.info,
      );
      return;
    }

    setState(() {
      _savedPreset = _selectedPreset;
      _savedWeightId = _weightId;
      _savedHeightId = _heightId;
      _savedDistanceId = _distanceId;
      _savedShortDistanceId = _shortDistanceId;
      _savedDurationId = _durationId;
      _savedVolumeId = _volumeId;
    });

    AppSnackbar.show(
      context,
      title: 'Measurement Units Saved',
      message: 'Updated to $_systemTitle ($_systemSummaryLine).',
      type: SnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Container(height: 1, color: AppColors.cardBorder),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('CURRENT SYSTEM'),
                    const SizedBox(height: 10),
                    _buildCurrentSystemCard(),
                    const SizedBox(height: 14),
                    _buildPresetSelectorRow(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('MEASUREMENT CATEGORIES'),
                    const SizedBox(height: 10),
                    _buildCategoriesCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('PREVIEW'),
                    const SizedBox(height: 10),
                    _buildPreviewCard(),
                  ],
                ),
              ),
            ),
            _buildBottomSaveDock(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final savedSummary =
        '${_byId(_weightChoices, _savedWeightId).shortUnit} · '
        '${_byId(_distanceChoices, _savedDistanceId).shortUnit} · '
        '${_byId(_heightChoices, _savedHeightId).shortUnit}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(savedSummary),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.secondaryTextStoneGrey,
              size: 26,
            ),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 2),
          const Expanded(
            child: Text(
              'Measurement Units',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextOffWhite,
              ),
            ),
          ),
          GestureDetector(
            onTap: _savePreferences,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _hasPendingChanges
                      ? const Color(0xFF4CA384)
                      : AppColors.primaryForestGreen.withValues(alpha: 0.48),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
          color: AppColors.secondaryTextStoneGrey,
        ),
      ),
    );
  }

  Widget _buildCurrentSystemCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1D201F),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const _ScaleLineIcon(
              size: 21,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _systemTitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.18,
                    color: AppColors.primaryTextOffWhite,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _systemSummaryLine,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Text(
              _systemBadge,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.9,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetSelectorRow() {
    return Row(
      children: [
        Expanded(
          child: _buildPresetCard(
            preset: _UnitSystemPreset.metric,
            title: 'Metric',
            subtitle: 'kg · km · cm',
            isItalicSubtitle: false,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildPresetCard(
            preset: _UnitSystemPreset.imperial,
            title: 'Imperial',
            subtitle: 'lb · mi · in',
            isItalicSubtitle: false,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildPresetCard(
            preset: _UnitSystemPreset.custom,
            title: 'Custom',
            subtitle: 'Mix & match',
            isItalicSubtitle: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPresetCard({
    required _UnitSystemPreset preset,
    required String title,
    required String subtitle,
    required bool isItalicSubtitle,
  }) {
    final isSelected = _selectedPreset == preset;
    return GestureDetector(
      onTap: () => _selectPreset(preset),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 92,
        padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF15241F) : AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryForestGreen.withValues(alpha: 0.72)
                : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextOffWhite,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Color(0xFF56A98B),
                  ),
              ],
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                fontStyle:
                    isItalicSubtitle ? FontStyle.italic : FontStyle.normal,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryGroupHeader('BODY'),
            _buildCategoryRow(
              leading: const _ScaleLineIcon(
                size: 18,
                color: AppColors.secondaryTextStoneGrey,
              ),
              title: 'Dog Weight',
              unitLabel: _weight.title,
              sampleLabel: _weight.rowSample,
              onTap: () => _openCategoryPicker(
                categoryTitle: 'Dog Weight',
                choices: _weightChoices,
                currentId: _weightId,
                onSelected: (v) => _weightId = v,
              ),
            ),
            Container(height: 1, color: AppColors.cardBorder),
            _buildCategoryRow(
              leading: const Icon(
                Icons.straighten_rounded,
                size: 18,
                color: AppColors.secondaryTextStoneGrey,
              ),
              title: 'Height & Body',
              unitLabel: _height.title,
              sampleLabel: _height.rowSample,
              onTap: () => _openCategoryPicker(
                categoryTitle: 'Height & Body',
                choices: _heightChoices,
                currentId: _heightId,
                onSelected: (v) => _heightId = v,
              ),
            ),
            _buildCategoryGroupHeader('ACTIVITY'),
            _buildCategoryRow(
              leading: const Icon(
                Icons.route_outlined,
                size: 18,
                color: AppColors.secondaryTextStoneGrey,
              ),
              title: 'Distance',
              unitLabel: _distance.title,
              sampleLabel: _distance.rowSample,
              onTap: () => _openCategoryPicker(
                categoryTitle: 'Distance',
                choices: _distanceChoices,
                currentId: _distanceId,
                onSelected: (v) => _distanceId = v,
              ),
            ),
            Container(height: 1, color: AppColors.cardBorder),
            _buildCategoryRow(
              leading: const Icon(
                Icons.near_me_outlined,
                size: 18,
                color: AppColors.secondaryTextStoneGrey,
              ),
              title: 'Short Distance',
              unitLabel: _shortDistance.title,
              sampleLabel: _shortDistance.rowSample,
              onTap: () => _openCategoryPicker(
                categoryTitle: 'Short Distance',
                choices: _shortDistanceChoices,
                currentId: _shortDistanceId,
                onSelected: (v) => _shortDistanceId = v,
              ),
            ),
            Container(height: 1, color: AppColors.cardBorder),
            _buildCategoryRow(
              leading: const Icon(
                Icons.access_time_rounded,
                size: 18,
                color: AppColors.secondaryTextStoneGrey,
              ),
              title: 'Duration',
              unitLabel: _duration.title,
              sampleLabel: _duration.rowSample,
              onTap: () => _openCategoryPicker(
                categoryTitle: 'Duration',
                choices: _durationChoices,
                currentId: _durationId,
                onSelected: (v) => _durationId = v,
              ),
            ),
            _buildCategoryGroupHeader('ENVIRONMENT'),
            _buildCategoryRow(
              leading: const Icon(
                Icons.water_drop_outlined,
                size: 18,
                color: AppColors.secondaryTextStoneGrey,
              ),
              title: 'Liquid Volume',
              unitLabel: _volume.title,
              sampleLabel: _volume.rowSample,
              onTap: () => _openCategoryPicker(
                categoryTitle: 'Liquid Volume',
                choices: _volumeChoices,
                currentId: _volumeId,
                onSelected: (v) => _volumeId = v,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGroupHeader(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.025),
        border: const Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppColors.secondaryTextStoneGrey,
        ),
      ),
    );
  }

  Widget _buildCategoryRow({
    required Widget leading,
    required String title,
    required String unitLabel,
    required String sampleLabel,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 12, 13),
          child: Row(
            children: [
              SizedBox(width: 22, child: Center(child: leading)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextOffWhite,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    unitLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFC5CCC8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sampleLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    final thirdLabel =
        _showTrailElevationPreview ? 'ELEVATION GAIN' : 'JUMP HEIGHT';
    final thirdValue = _showTrailElevationPreview
        ? _shortDistance.previewValue
        : _height.previewValue;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildPreviewTile(
                  label: 'DOG WEIGHT',
                  value: _weight.previewValue,
                  onTap: () => _openCategoryPicker(
                    categoryTitle: 'Dog Weight',
                    choices: _weightChoices,
                    currentId: _weightId,
                    onSelected: (v) => _weightId = v,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildPreviewTile(
                  label: 'DISTANCE',
                  value: _distance.previewValue,
                  onTap: () => _openCategoryPicker(
                    categoryTitle: 'Distance',
                    choices: _distanceChoices,
                    currentId: _distanceId,
                    onSelected: (v) => _distanceId = v,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildPreviewTile(
                  label: thirdLabel,
                  value: thirdValue,
                  onTap: () {
                    setState(() {
                      _showTrailElevationPreview = !_showTrailElevationPreview;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              setState(() {
                _showTrailElevationPreview = !_showTrailElevationPreview;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: const Text(
              'Values shown using your current unit preferences.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFF1D201F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.9,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextOffWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSaveDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _savePreferences,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasPendingChanges
                ? AppColors.primaryForestGreen
                : const Color(0xFF1A332B),
            foregroundColor: _hasPendingChanges
                ? AppColors.primaryTextOffWhite
                : AppColors.secondarySage,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Save Measurement Units',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScaleLineIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _ScaleLineIcon({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ScaleLinePainter(color: color),
      ),
    );
  }
}

class _ScaleLinePainter extends CustomPainter {
  final Color color;

  const _ScaleLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.45
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Top weighing pan (shallow trapezoid bowl)
    final panPath = Path()
      ..moveTo(w * 0.16, h * 0.14)
      ..lineTo(w * 0.84, h * 0.14)
      ..lineTo(w * 0.66, h * 0.34)
      ..lineTo(w * 0.34, h * 0.34)
      ..close();
    canvas.drawPath(panPath, paint);

    // Stem connecting pan to dial base
    canvas.drawLine(
      Offset(w * 0.50, h * 0.34),
      Offset(w * 0.50, h * 0.48),
      paint,
    );

    // Semicircular dial base
    final basePath = Path()
      ..moveTo(w * 0.14, h * 0.88)
      ..arcToPoint(
        Offset(w * 0.86, h * 0.88),
        radius: Radius.circular(w * 0.38),
        clockwise: true,
      )
      ..close();
    canvas.drawPath(basePath, paint);

    // Dial needle pointing slightly right
    canvas.drawLine(
      Offset(w * 0.50, h * 0.84),
      Offset(w * 0.60, h * 0.63),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScaleLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
