import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  State<AppearanceSettingsScreen> createState() =>
      _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _lightCream = Color(0xFFFAF8F4);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);
  static const Color _switchOffTrack = Color(0xFF2B3135);
  static const Color _destructive = Color(0xFF8B3A3A);
  static const Color _destructiveText = Color(0xFFA84646);

  String _selectedTheme = 'Dark'; // 'System', 'Dark', 'Light'
  String _selectedTextSize = 'Default'; // 'Small', 'Default', 'Large', 'Extra Large'
  String _selectedDensity = 'Comfortable'; // 'Comfortable', 'Compact', 'Spacious'
  bool _reduceMotion = false;
  bool _hapticFeedback = true;
  bool _justSaved = false;
  int _previewActiveDot = 4;
  bool _previewActionToggled = true;

  Duration get _animDuration => _reduceMotion
      ? const Duration(milliseconds: 40)
      : const Duration(milliseconds: 280);

  double get _textScaleFactor {
    switch (_selectedTextSize) {
      case 'Small':
        return 0.86;
      case 'Large':
        return 1.14;
      case 'Extra Large':
        return 1.28;
      case 'Default':
      default:
        return 1.0;
    }
  }

  double get _densityGap {
    switch (_selectedDensity) {
      case 'Compact':
        return 6.0;
      case 'Spacious':
        return 13.0;
      case 'Comfortable':
      default:
        return 9.0;
    }
  }

  double get _densityCardPad {
    switch (_selectedDensity) {
      case 'Compact':
        return 8.0;
      case 'Spacious':
        return 14.0;
      case 'Comfortable':
      default:
        return 11.0;
    }
  }

  String get _themeModeSubtitle {
    switch (_selectedTheme) {
      case 'Light':
        return 'Light Mode';
      case 'System':
        return 'System Default';
      case 'Dark':
      default:
        return 'Dark Mode';
    }
  }

  void _triggerFeedbackAndSave() {
    if (_hapticFeedback) {
      HapticFeedback.selectionClick();
    }
    setState(() => _justSaved = true);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _justSaved = false);
    });
  }

  void _resetDefaults() {
    setState(() {
      _selectedTheme = 'Dark';
      _selectedTextSize = 'Default';
      _selectedDensity = 'Comfortable';
      _reduceMotion = false;
      _hapticFeedback = true;
      _previewActiveDot = 4;
      _previewActionToggled = true;
    });
    _triggerFeedbackAndSave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('PREVIEW'),
                    const SizedBox(height: 10),
                    _buildLivePreviewCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('THEME'),
                    const SizedBox(height: 10),
                    _buildThemeCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('TEXT SIZE'),
                    const SizedBox(height: 10),
                    _buildTextSizeCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('DISPLAY DENSITY'),
                    const SizedBox(height: 10),
                    _buildDisplayDensityCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('REDUCE MOTION'),
                    const SizedBox(height: 10),
                    _buildReduceMotionCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('HAPTIC FEEDBACK'),
                    const SizedBox(height: 10),
                    _buildHapticCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('RESET'),
                    const SizedBox(height: 10),
                    _buildResetCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 14),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(bottom: BorderSide(color: _cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(_themeModeSubtitle),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: UlvenikIcon(UlvenikIcons.back,
                color: _stoneGrey,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Appearance',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.3,
              ),
            ),
          ),
          AnimatedDefaultTextStyle(
            duration: _animDuration,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: _justSaved ? _forest : _stoneGrey,
            ),
            child: const Text('Saved'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _stoneGrey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildLivePreviewCard() {
    final isLight = _selectedTheme == 'Light';
    final isSystem = _selectedTheme == 'System';

    final mockBg = isLight
        ? _lightCream
        : (isSystem ? const Color(0xFF15191C) : _obsidian);
    final mockSurface = isLight
        ? const Color(0xFFEBE8E1)
        : (isSystem ? const Color(0xFF20262A) : _carbon);
    final mockPrimaryBar = isLight
        ? const Color(0xFF222628)
        : _offWhite.withValues(alpha: 0.85);
    final mockSecondaryBar = isLight
        ? const Color(0xFF8C8F8D)
        : _stoneGrey.withValues(alpha: 0.45);
    final mockBorder = isLight
        ? Colors.black.withValues(alpha: 0.08)
        : _cardBorder;

    final scale = _textScaleFactor;
    final barHeight = (4.5 * scale).clamp(3.8, 6.5);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: _animDuration,
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.all(_densityCardPad + 3),
            decoration: BoxDecoration(
              color: mockBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: mockBorder, width: 1),
            ),
            child: Column(
              children: [
                // Mock App Bar
                AnimatedContainer(
                  duration: _animDuration,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: _densityCardPad * 0.72,
                  ),
                  decoration: BoxDecoration(
                    color: mockSurface,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: mockBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        duration: _animDuration,
                        width: (46 * scale).clamp(36.0, 74.0),
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: mockPrimaryBar,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: mockSecondaryBar,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: _densityGap),
                // Mock Hero Content Row
                AnimatedContainer(
                  duration: _animDuration,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: _densityCardPad,
                  ),
                  decoration: BoxDecoration(
                    color: mockSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: mockBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: _animDuration,
                            width: (64 * scale).clamp(48.0, 96.0),
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: mockPrimaryBar,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedContainer(
                            duration: _animDuration,
                            width: (40 * scale).clamp(30.0, 62.0),
                            height: (barHeight * 0.78).clamp(3.0, 5.2),
                            decoration: BoxDecoration(
                              color: mockSecondaryBar,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: mockSecondaryBar.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: _densityGap),
                // Mock Interactive Action Card
                GestureDetector(
                  onTap: () {
                    setState(
                      () => _previewActionToggled = !_previewActionToggled,
                    );
                    if (_hapticFeedback) HapticFeedback.lightImpact();
                  },
                  child: AnimatedContainer(
                    duration: _animDuration,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: _densityCardPad * 0.9,
                    ),
                    decoration: BoxDecoration(
                      color: mockSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: mockBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedContainer(
                          duration: _animDuration,
                          width: (78 * scale).clamp(58.0, 118.0),
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: mockPrimaryBar,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        AnimatedContainer(
                          duration: _animDuration,
                          width: 40,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _previewActionToggled
                                ? _forest
                                : _switchOffTrack,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Container(
                            width: 18,
                            height: 3.5,
                            decoration: BoxDecoration(
                              color: _offWhite,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: _densityGap),
                // Mock Bottom Navigation Dots
                AnimatedContainer(
                  duration: _animDuration,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: mockSurface,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: mockBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (idx) {
                      final active = idx == _previewActiveDot;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _previewActiveDot = idx);
                          if (_hapticFeedback) HapticFeedback.selectionClick();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: AnimatedContainer(
                            duration: _animDuration,
                            width: 5.5,
                            height: 5.5,
                            decoration: BoxDecoration(
                              color: active ? _forest : mockSecondaryBar,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Updates instantly as you change settings',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _stoneGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildThemeOption(
              id: 'System',
              label: 'System',
              subLabel: 'Default',
              thumbnail: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: CustomPaint(
                  painter: _SplitSystemThemePainter(),
                  child: const SizedBox(height: 68, width: double.infinity),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildThemeOption(
              id: 'Dark',
              label: 'Dark',
              thumbnail: Container(
                height: 68,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _obsidian,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: _stoneGrey.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 40,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: _stoneGrey.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildThemeOption(
              id: 'Light',
              label: 'Light',
              thumbnail: Container(
                height: 68,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _lightCream,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC5C3BD),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 40,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C9A94),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required String id,
    required String label,
    String? subLabel,
    required Widget thumbnail,
  }) {
    final selected = _selectedTheme == id;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTheme = id);
        _triggerFeedbackAndSave();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          AnimatedContainer(
            duration: _animDuration,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? _forest : _cardBorder,
                width: selected ? 1.5 : 1.0,
              ),
            ),
            child: Stack(
              children: [
                thumbnail,
                if (selected)
                  Positioned(
                    right: 7,
                    bottom: 7,
                    child: Container(
                      width: 17,
                      height: 17,
                      decoration: const BoxDecoration(
                        color: _forest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded,
                        color: _offWhite,
                        size: 11.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? _offWhite : _stoneGrey,
            ),
          ),
          if (subLabel != null) ...[
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.5,
                color: _stoneGrey.withValues(alpha: 0.72),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextSizeCard() {
    const items = [
      ('Small', null),
      ('Default', 'Recommended'),
      ('Large', null),
      ('Extra Large', null),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final selected = _selectedTextSize == item.$1;
          return Column(
            children: [
              if (idx > 0) Container(height: 1, color: _cardBorder),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() => _selectedTextSize = item.$1);
                    _triggerFeedbackAndSave();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: item.$2 != null ? 13 : 16,
                    ),
                    child: Row(
                      children: [
                        const _TypeTIcon(color: _stoneGrey),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.$1,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _offWhite,
                                ),
                              ),
                              if (item.$2 != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  item.$2!,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: _stoneGrey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (selected)
                          const Icon(Icons.check_rounded,
                            color: _forest,
                            size: 19,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDisplayDensityCard() {
    final items = [
      (
        'Comfortable',
        'Recommended',
        const Icon(Icons.grid_view_outlined, color: _stoneGrey, size: 19),
      ),
      (
        'Compact',
        'More content on screen',
        const _StackedRowsIcon(barCount: 3, color: _stoneGrey),
      ),
      (
        'Spacious',
        'More breathing room',
        const _StackedRowsIcon(barCount: 2, color: _stoneGrey),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final selected = _selectedDensity == item.$1;
          return Column(
            children: [
              if (idx > 0) Container(height: 1, color: _cardBorder),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() => _selectedDensity = item.$1);
                    _triggerFeedbackAndSave();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Center(child: item.$3),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.$1,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _offWhite,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.$2,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: _stoneGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selected)
                          const Icon(Icons.check_rounded,
                            color: _forest,
                            size: 19,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReduceMotionCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_border_rounded, color: _stoneGrey, size: 20),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reduce Motion',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _offWhite,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Simplifies transitions and animations',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: _stoneGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _AppearanceSwitch(
            value: _reduceMotion,
            duration: _animDuration,
            onChanged: (v) {
              setState(() => _reduceMotion = v);
              _triggerFeedbackAndSave();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHapticCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.back_hand_outlined, color: _stoneGrey, size: 19),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Haptic Feedback',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _offWhite,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Vibration response on interactions',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: _stoneGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _AppearanceSwitch(
            value: _hapticFeedback,
            duration: _animDuration,
            onChanged: (v) {
              setState(() => _hapticFeedback = v);
              _triggerFeedbackAndSave();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResetCard() {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _showResetSheet,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder, width: 1),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.replay_rounded, color: _destructiveText, size: 18),
              SizedBox(width: 8),
              Text(
                'Reset Appearance Settings',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: _destructiveText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
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
                      color: _stoneGrey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reset Appearance Settings?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Restores Dark theme, Default text size, Comfortable density, standard animations, and Haptic Feedback.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    height: 1.45,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _cardBorder),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: _offWhite),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _destructive,
                          foregroundColor: _offWhite,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          _resetDefaults();
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'Appearance Reset',
                            message:
                                'Restored default Dark Mode & Comfortable layout.',
                            type: SnackbarType.success,
                          );
                        },
                        child: const Text('Reset'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SplitSystemThemePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()..color = const Color(0xFF101214);
    final lightPaint = Paint()..color = const Color(0xFFFAF8F4);

    final topTriangle = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(topTriangle, darkPaint);

    final bottomTriangle = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(bottomTriangle, lightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TypeTIcon extends StatelessWidget {
  final Color color;
  const _TypeTIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _TypeTPainter(color: color),
    );
  }
}

class _TypeTPainter extends CustomPainter {
  final Color color;
  const _TypeTPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawLine(const Offset(4, 5), const Offset(16, 5), p);
    canvas.drawLine(const Offset(4, 5), const Offset(4, 7.5), p);
    canvas.drawLine(const Offset(16, 5), const Offset(16, 7.5), p);
    canvas.drawLine(const Offset(10, 5), const Offset(10, 16), p);
    canvas.drawLine(const Offset(7.5, 16), const Offset(12.5, 16), p);
  }

  @override
  bool shouldRepaint(covariant _TypeTPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _StackedRowsIcon extends StatelessWidget {
  final int barCount;
  final Color color;
  const _StackedRowsIcon({required this.barCount, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(18, 18),
      painter: _StackedRowsPainter(barCount: barCount, color: color),
    );
  }
}

class _StackedRowsPainter extends CustomPainter {
  final int barCount;
  final Color color;
  const _StackedRowsPainter({required this.barCount, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    if (barCount == 3) {
      for (int i = 0; i < 3; i++) {
        final y = 2.0 + i * 5.2;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(1.5, y, 15.0, 3.6),
            const Radius.circular(1.2),
          ),
          p,
        );
      }
    } else {
      for (int i = 0; i < 2; i++) {
        final y = 3.0 + i * 7.2;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(1.5, y, 15.0, 4.4),
            const Radius.circular(1.2),
          ),
          p,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StackedRowsPainter oldDelegate) =>
      oldDelegate.barCount != barCount || oldDelegate.color != color;
}

class _AppearanceSwitch extends StatelessWidget {
  final bool value;
  final Duration duration;
  final ValueChanged<bool> onChanged;

  const _AppearanceSwitch({
    required this.value,
    required this.duration,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOutCubic,
        width: 46,
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: value
              ? _AppearanceSettingsScreenState._forest
              : _AppearanceSettingsScreenState._switchOffTrack,
          borderRadius: BorderRadius.circular(13),
        ),
        child: AnimatedAlign(
          duration: duration,
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: _AppearanceSettingsScreenState._offWhite,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
