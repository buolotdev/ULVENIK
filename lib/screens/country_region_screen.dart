import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _CountryEntry {
  final String code;
  final String name;
  final String regionSubtitle;
  final String registryPreview;
  final List<Color> flagColors;
  final _FlagPattern pattern;

  const _CountryEntry({
    required this.code,
    required this.name,
    required this.regionSubtitle,
    required this.registryPreview,
    required this.flagColors,
    this.pattern = _FlagPattern.horizontalTri,
  });

  String get initial => name.substring(0, 1).toUpperCase();
}

enum _FlagPattern {
  uk,
  nordicCross,
  swissCross,
  verticalTri,
  horizontalTri,
  horizontalBi,
  usa,
  canada,
  australia,
}

class CountryRegionScreen extends StatefulWidget {
  const CountryRegionScreen({super.key});

  @override
  State<CountryRegionScreen> createState() => _CountryRegionScreenState();
}

class _CountryRegionScreenState extends State<CountryRegionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _currentCountryCode = 'GB';
  String _selectedCountryCode = 'GB';
  String? _activeIndexLetter;

  final Map<String, GlobalKey> _letterKeys = {
    for (final c in const ['A', 'C', 'D', 'F', 'G', 'N', 'S', 'U'])
      c: GlobalKey(),
  };

  static const List<String> _alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  static const List<_CountryEntry> _countries = [
    _CountryEntry(
      code: 'AU',
      name: 'Australia',
      regionSubtitle: 'AU · Commonwealth of Australia',
      registryPreview: 'Dogs Australia (ANKC) · AUD (\$)',
      flagColors: [Color(0xFF012169), Color(0xFFFFFFFF), Color(0xFFE4002B)],
      pattern: _FlagPattern.australia,
    ),
    _CountryEntry(
      code: 'AT',
      name: 'Austria',
      regionSubtitle: 'AT · Republic of Austria',
      registryPreview: 'Österreichischer Kynologenverband (ÖKV) · EUR (€)',
      flagColors: [Color(0xFFED2939), Color(0xFFFFFFFF), Color(0xFFED2939)],
      pattern: _FlagPattern.horizontalTri,
    ),
    _CountryEntry(
      code: 'CA',
      name: 'Canada',
      regionSubtitle: 'CA · Canada',
      registryPreview: 'Canadian Kennel Club (CKC) · CAD (\$)',
      flagColors: [Color(0xFFD80621), Color(0xFFFFFFFF), Color(0xFFD80621)],
      pattern: _FlagPattern.canada,
    ),
    _CountryEntry(
      code: 'DK',
      name: 'Denmark',
      regionSubtitle: 'DK · Kingdom of Denmark',
      registryPreview: 'Dansk Kennel Klub (DKK) · DKK (kr)',
      flagColors: [Color(0xFFC8102E), Color(0xFFFFFFFF)],
      pattern: _FlagPattern.nordicCross,
    ),
    _CountryEntry(
      code: 'FI',
      name: 'Finland',
      regionSubtitle: 'FI · Republic of Finland',
      registryPreview: 'Suomen Kennelliitto (FCI) · EUR (€)',
      flagColors: [Color(0xFFFFFFFF), Color(0xFF002F6C)],
      pattern: _FlagPattern.nordicCross,
    ),
    _CountryEntry(
      code: 'FR',
      name: 'France',
      regionSubtitle: 'FR · French Republic',
      registryPreview: 'Centrale Canine (SCC) · EUR (€)',
      flagColors: [Color(0xFF002395), Color(0xFFFFFFFF), Color(0xFFED2939)],
      pattern: _FlagPattern.verticalTri,
    ),
    _CountryEntry(
      code: 'DE',
      name: 'Germany',
      regionSubtitle: 'DE · Federal Republic of Germany',
      registryPreview: 'Verband für das Deutsche Hundewesen (VDH) · EUR (€)',
      flagColors: [Color(0xFF1A1A1A), Color(0xFFDD0000), Color(0xFFFFCE00)],
      pattern: _FlagPattern.horizontalTri,
    ),
    _CountryEntry(
      code: 'NO',
      name: 'Norway',
      regionSubtitle: 'NO · Kingdom of Norway',
      registryPreview: 'Norsk Kennel Klub (NKK) · NOK (kr)',
      flagColors: [Color(0xFFBA0C2F), Color(0xFF00205B), Color(0xFFFFFFFF)],
      pattern: _FlagPattern.nordicCross,
    ),
    _CountryEntry(
      code: 'SE',
      name: 'Sweden',
      regionSubtitle: 'SE · Kingdom of Sweden',
      registryPreview: 'Svenska Kennelklubben (SKK) · SEK (kr)',
      flagColors: [Color(0xFF006AA7), Color(0xFFFECC02)],
      pattern: _FlagPattern.nordicCross,
    ),
    _CountryEntry(
      code: 'CH',
      name: 'Switzerland',
      regionSubtitle: 'CH · Swiss Confederation',
      registryPreview: 'Société Cynologique Suisse (SKG) · CHF',
      flagColors: [Color(0xFFDA291C), Color(0xFFFFFFFF)],
      pattern: _FlagPattern.swissCross,
    ),
    _CountryEntry(
      code: 'GB',
      name: 'United Kingdom',
      regionSubtitle: 'GB · Great Britain',
      registryPreview: 'The Kennel Club (UK) · GBP (£)',
      flagColors: [Color(0xFF012169), Color(0xFFC8102E), Color(0xFFFFFFFF)],
      pattern: _FlagPattern.uk,
    ),
    _CountryEntry(
      code: 'US',
      name: 'United States',
      regionSubtitle: 'US · United States of America',
      registryPreview: 'American Kennel Club (AKC) · USD (\$)',
      flagColors: [Color(0xFFB22234), Color(0xFFFFFFFF), Color(0xFF3C3B6E)],
      pattern: _FlagPattern.usa,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _CountryEntry get _currentCountry =>
      _countries.firstWhere((c) => c.code == _currentCountryCode);

  _CountryEntry get _selectedCountry =>
      _countries.firstWhere((c) => c.code == _selectedCountryCode);

  bool get _hasPendingChange => _selectedCountryCode != _currentCountryCode;

  List<_CountryEntry> get _filteredCountries {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _countries;
    return _countries.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q) ||
          c.regionSubtitle.toLowerCase().contains(q) ||
          c.registryPreview.toLowerCase().contains(q);
    }).toList();
  }

  void _jumpToLetter(String letter) {
    setState(() => _activeIndexLetter = letter);
    // Find exact or nearest available section key
    GlobalKey? key = _letterKeys[letter];
    if (key == null || key.currentContext == null) {
      for (final available in _letterKeys.keys) {
        if (available.compareTo(letter) >= 0 &&
            _letterKeys[available]?.currentContext != null) {
          key = _letterKeys[available];
          break;
        }
      }
    }
    final ctx = key?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    }
  }

  void _applySelectedCountry() {
    if (!_hasPendingChange) {
      AppSnackbar.show(
        context,
        title: 'Country Unchanged',
        message: '${_currentCountry.name} is already set as your region.',
        type: SnackbarType.info,
      );
      return;
    }

    setState(() {
      _currentCountryCode = _selectedCountryCode;
    });

    AppSnackbar.show(
      context,
      title: 'Country Updated',
      message:
          'Region set to ${_currentCountry.name} (${_currentCountry.regionSubtitle}).',
      type: SnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestedUk = _countries.firstWhere((c) => c.code == 'GB');

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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 20, 28, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('CURRENT COUNTRY'),
                        const SizedBox(height: 10),
                        _buildCurrentCountryCard(),
                        const SizedBox(height: 18),
                        _buildSearchField(),
                        if (_searchQuery.trim().isEmpty) ...[
                          const SizedBox(height: 22),
                          _buildSectionLabel('SUGGESTED'),
                          const SizedBox(height: 10),
                          _buildSuggestedCard(suggestedUk),
                        ],
                        const SizedBox(height: 22),
                        _buildSectionLabel(
                          _searchQuery.trim().isEmpty
                              ? 'ALL COUNTRIES'
                              : 'SEARCH RESULTS',
                        ),
                        const SizedBox(height: 10),
                        _buildAllCountriesCard(),
                      ],
                    ),
                  ),
                  if (_searchQuery.trim().isEmpty)
                    Positioned(
                      right: 4,
                      top: 36,
                      bottom: 24,
                      child: _buildAlphabetRail(),
                    ),
                ],
              ),
            ),
            _buildBottomContinueDock(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(_currentCountry.name),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: AppColors.secondaryTextStoneGrey,
              size: 26,
            ),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 2),
          const Expanded(
            child: Text(
              'Country or Region',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextOffWhite,
              ),
            ),
          ),
          GestureDetector(
            onTap: _applySelectedCountry,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _hasPendingChange
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

  Widget _buildCurrentCountryCard() {
    final current = _currentCountry;
    final selected = _selectedCountry;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CountryCodeEmblem(entry: current, large: true),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextOffWhite,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      current.regionSubtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'CURRENT',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.9,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
              ),
            ],
          ),
          if (_hasPendingChange) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryForestGreen.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryForestGreen.withValues(alpha: 0.42),
                ),
              ),
              child: Row(
                children: [
                  _MiniFlagBadge(entry: selected),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Previewing ${selected.name} (${selected.code})',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextOffWhite,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          selected.registryPreview,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _searchFocusNode.hasFocus
              ? AppColors.primaryForestGreen.withValues(alpha: 0.55)
              : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.search,
            size: 19,
            color: AppColors.secondaryTextStoneGrey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (val) => setState(() => _searchQuery = val),
              cursorColor: AppColors.primaryForestGreen,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.5,
                color: AppColors.primaryTextOffWhite,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search countries or regions',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.5,
                  color: AppColors.secondaryTextStoneGrey,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close_rounded,
                  size: 17,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestedCard(_CountryEntry suggested) {
    final bool isSelected = _selectedCountryCode == suggested.code;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          children: [
            _buildCountryRow(suggested, isSelected: isSelected),
            Container(height: 1, color: AppColors.cardBorder),
            InkWell(
              onTap: () => setState(() => _selectedCountryCode = suggested.code),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    const _StGeorgeCrossFlag(),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Device Region detected: United Kingdom',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                      ),
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

  Widget _buildAllCountriesCard() {
    final items = _filteredCountries;
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            const Icon(Icons.public_off_rounded,
              color: AppColors.secondaryTextStoneGrey,
              size: 26,
            ),
            const SizedBox(height: 10),
            Text(
              'No countries matching "${_searchQuery.trim()}"',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextOffWhite,
              ),
            ),
          ],
        ),
      );
    }

    final grouped = <String, List<_CountryEntry>>{};
    for (final c in items) {
      grouped.putIfAbsent(c.initial, () => []).add(c);
    }
    final sortedLetters = grouped.keys.toList()..sort();

    final children = <Widget>[];
    for (int li = 0; li < sortedLetters.length; li++) {
      final letter = sortedLetters[li];
      final group = grouped[letter]!;

      for (int ci = 0; ci < group.length; ci++) {
        if (children.isNotEmpty) {
          children.add(Container(height: 1, color: AppColors.cardBorder));
        }
        final entry = group[ci];
        children.add(
          Container(
            key: ci == 0 && _searchQuery.trim().isEmpty
                ? _letterKeys[letter]
                : null,
            child: _buildCountryRow(
              entry,
              isSelected: _selectedCountryCode == entry.code,
            ),
          ),
        );
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildCountryRow(_CountryEntry entry, {required bool isSelected}) {
    return Material(
      color: isSelected
          ? AppColors.primaryForestGreen.withValues(alpha: 0.14)
          : Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedCountryCode = entry.code),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 3,
                color: isSelected
                    ? AppColors.primaryForestGreen
                    : Colors.transparent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 13, 16, 13),
                  child: Row(
                    children: [
                      _CountryCodeEmblem(entry: entry, large: false),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.name,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextOffWhite,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              entry.code,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_rounded,
                          size: 19,
                          color: AppColors.primaryForestGreen,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlphabetRail() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final double relY = details.localPosition.dy.clamp(0.0, 420.0);
        final int idx = ((relY / 420.0) * (_alphabet.length - 1))
            .round()
            .clamp(0, _alphabet.length - 1);
        _jumpToLetter(_alphabet[idx]);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final letter in _alphabet)
            GestureDetector(
              onTap: () => _jumpToLetter(letter),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 1.5,
                ),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.5,
                    fontWeight: _activeIndexLetter == letter
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: _activeIndexLetter == letter
                        ? const Color(0xFF53A689)
                        : AppColors.secondaryTextStoneGrey,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomContinueDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _applySelectedCountry,
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasPendingChange
                    ? AppColors.primaryForestGreen
                    : const Color(0xFF1A332B),
                foregroundColor: _hasPendingChange
                    ? AppColors.primaryTextOffWhite
                    : AppColors.secondarySage,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Changing country will not affect your language, units, or time zone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              height: 1.35,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryCodeEmblem extends StatelessWidget {
  final _CountryEntry entry;
  final bool large;

  const _CountryCodeEmblem({
    required this.entry,
    required this.large,
  });

  @override
  Widget build(BuildContext context) {
    final double w = large ? 42 : 34;
    final double h = large ? 30 : 24;
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CustomPaint(
          size: Size.infinite,
          painter: _FlagVectorPainter(
            colors: entry.flagColors,
            pattern: entry.pattern,
          ),
        ),
      ),
    );
  }
}

class _MiniFlagBadge extends StatelessWidget {
  final _CountryEntry entry;

  const _MiniFlagBadge({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 17,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.5),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CustomPaint(
          size: Size.infinite,
          painter: _FlagVectorPainter(
            colors: entry.flagColors,
            pattern: entry.pattern,
          ),
        ),
      ),
    );
  }
}

class _StGeorgeCrossFlag extends StatelessWidget {
  const _StGeorgeCrossFlag();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 13,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F2),
        borderRadius: BorderRadius.circular(2.5),
      ),
      child: CustomPaint(
        size: Size.infinite,
        painter: _StGeorgePainter(),
      ),
    );
  }
}

class _StGeorgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final red = Paint()..color = const Color(0xFFC8102E);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.36, size.width, size.height * 0.28),
      red,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.40, 0, size.width * 0.20, size.height),
      red,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FlagVectorPainter extends CustomPainter {
  final List<Color> colors;
  final _FlagPattern pattern;

  const _FlagVectorPainter({
    required this.colors,
    required this.pattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (pattern) {
      case _FlagPattern.horizontalTri:
        final sh = h / 3;
        for (int i = 0; i < 3; i++) {
          canvas.drawRect(
            Rect.fromLTWH(0, sh * i, w, sh + 0.5),
            Paint()..color = colors[i % colors.length],
          );
        }
        break;
      case _FlagPattern.horizontalBi:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, w, h / 2),
          Paint()..color = colors[0],
        );
        canvas.drawRect(
          Rect.fromLTWH(0, h / 2, w, h / 2),
          Paint()..color = colors[1],
        );
        break;
      case _FlagPattern.verticalTri:
        final sw = w / 3;
        for (int i = 0; i < 3; i++) {
          canvas.drawRect(
            Rect.fromLTWH(sw * i, 0, sw + 0.5, h),
            Paint()..color = colors[i % colors.length],
          );
        }
        break;
      case _FlagPattern.nordicCross:
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = colors[0]);
        if (colors.length > 2) {
          final outer = Paint()..color = colors[2];
          canvas.drawRect(Rect.fromLTWH(w * 0.28, 0, w * 0.18, h), outer);
          canvas.drawRect(Rect.fromLTWH(0, h * 0.36, w, h * 0.28), outer);
          final inner = Paint()..color = colors[1];
          canvas.drawRect(Rect.fromLTWH(w * 0.32, 0, w * 0.10, h), inner);
          canvas.drawRect(Rect.fromLTWH(0, h * 0.43, w, h * 0.14), inner);
        } else {
          final cross = Paint()..color = colors[1];
          canvas.drawRect(Rect.fromLTWH(w * 0.30, 0, w * 0.14, h), cross);
          canvas.drawRect(Rect.fromLTWH(0, h * 0.40, w, h * 0.20), cross);
        }
        break;
      case _FlagPattern.swissCross:
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = colors[0]);
        final white = Paint()..color = colors[1];
        canvas.drawRect(
          Rect.fromLTWH(w * 0.42, h * 0.20, w * 0.16, h * 0.60),
          white,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.28, h * 0.38, w * 0.44, h * 0.24),
          white,
        );
        break;
      case _FlagPattern.canada:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, w * 0.26, h),
          Paint()..color = colors[0],
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.26, 0, w * 0.48, h),
          Paint()..color = colors[1],
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.74, 0, w * 0.26, h),
          Paint()..color = colors[0],
        );
        canvas.drawCircle(
          Offset(w * 0.5, h * 0.5),
          h * 0.20,
          Paint()..color = colors[0],
        );
        break;
      case _FlagPattern.uk:
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = colors[0]);
        final whiteDiag = Paint()
          ..color = colors[2]
          ..strokeWidth = h * 0.22;
        canvas.drawLine(Offset.zero, Offset(w, h), whiteDiag);
        canvas.drawLine(Offset(w, 0), Offset(0, h), whiteDiag);
        final redDiag = Paint()
          ..color = colors[1]
          ..strokeWidth = h * 0.10;
        canvas.drawLine(Offset.zero, Offset(w, h), redDiag);
        canvas.drawLine(Offset(w, 0), Offset(0, h), redDiag);
        final whiteCross = Paint()..color = colors[2];
        canvas.drawRect(Rect.fromLTWH(0, h * 0.35, w, h * 0.30), whiteCross);
        canvas.drawRect(Rect.fromLTWH(w * 0.39, 0, w * 0.22, h), whiteCross);
        final redCross = Paint()..color = colors[1];
        canvas.drawRect(Rect.fromLTWH(0, h * 0.41, w, h * 0.18), redCross);
        canvas.drawRect(Rect.fromLTWH(w * 0.43, 0, w * 0.14, h), redCross);
        break;
      case _FlagPattern.usa:
        final stripeH = h / 7;
        for (int i = 0; i < 7; i++) {
          canvas.drawRect(
            Rect.fromLTWH(0, stripeH * i, w, stripeH + 0.4),
            Paint()..color = i.isEven ? colors[0] : colors[1],
          );
        }
        canvas.drawRect(
          Rect.fromLTWH(0, 0, w * 0.46, h * 0.56),
          Paint()..color = colors[2],
        );
        break;
      case _FlagPattern.australia:
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = colors[0]);
        final cantonW = w * 0.48;
        final cantonH = h * 0.52;
        final wCross = Paint()..color = colors[1];
        canvas.drawRect(
          Rect.fromLTWH(0, cantonH * 0.36, cantonW, cantonH * 0.28),
          wCross,
        );
        canvas.drawRect(
          Rect.fromLTWH(cantonW * 0.38, 0, cantonW * 0.24, cantonH),
          wCross,
        );
        final rCross = Paint()..color = colors[2];
        canvas.drawRect(
          Rect.fromLTWH(0, cantonH * 0.42, cantonW, cantonH * 0.16),
          rCross,
        );
        canvas.drawRect(
          Rect.fromLTWH(cantonW * 0.43, 0, cantonW * 0.14, cantonH),
          rCross,
        );
        final star = Paint()..color = colors[1];
        canvas.drawCircle(Offset(w * 0.24, h * 0.76), 1.8, star);
        canvas.drawCircle(Offset(w * 0.75, h * 0.30), 1.3, star);
        canvas.drawCircle(Offset(w * 0.75, h * 0.72), 1.4, star);
        canvas.drawCircle(Offset(w * 0.64, h * 0.52), 1.2, star);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
