import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _LanguageOption {
  final String code;
  final String nativeTitle;
  final String englishSubtitle;
  final String interfaceLabel;
  final String sampleNavPreview;

  const _LanguageOption({
    required this.code,
    required this.nativeTitle,
    required this.englishSubtitle,
    required this.interfaceLabel,
    required this.sampleNavPreview,
  });
}

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  String _currentLanguageCode = 'en_GB';
  String _selectedLanguageCode = 'en_GB';
  bool _appliedUseDeviceLanguage = false;
  bool _useDeviceLanguage = false;

  static const List<_LanguageOption> _languages = [
    _LanguageOption(
      code: 'en_GB',
      nativeTitle: 'English (United Kingdom)',
      englishSubtitle: 'English · United Kingdom',
      interfaceLabel: 'Interface language · English',
      sampleNavPreview: 'Home · Dogs · Training · Timeline · More',
    ),
    _LanguageOption(
      code: 'en_US',
      nativeTitle: 'English (United States)',
      englishSubtitle: 'English · United States',
      interfaceLabel: 'Interface language · English (US)',
      sampleNavPreview: 'Home · Dogs · Training · Timeline · Favorites',
    ),
    _LanguageOption(
      code: 'de',
      nativeTitle: 'Deutsch',
      englishSubtitle: 'German',
      interfaceLabel: 'Interface language · German',
      sampleNavPreview: 'Start · Hunde · Training · Chronik · Mehr',
    ),
    _LanguageOption(
      code: 'es',
      nativeTitle: 'Español',
      englishSubtitle: 'Spanish',
      interfaceLabel: 'Interface language · Spanish',
      sampleNavPreview: 'Inicio · Perros · Entrenamiento · Historial · Más',
    ),
    _LanguageOption(
      code: 'fr',
      nativeTitle: 'Français',
      englishSubtitle: 'French',
      interfaceLabel: 'Interface language · French',
      sampleNavPreview: 'Accueil · Chiens · Entraînement · Journal · Plus',
    ),
    _LanguageOption(
      code: 'sv',
      nativeTitle: 'Svenska',
      englishSubtitle: 'Swedish',
      interfaceLabel: 'Interface language · Swedish',
      sampleNavPreview: 'Hem · Hundar · Träning · Tidslinje · Mer',
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
    super.dispose();
  }

  _LanguageOption get _currentLanguage =>
      _languages.firstWhere((l) => l.code == _currentLanguageCode);

  _LanguageOption get _selectedLanguage =>
      _languages.firstWhere((l) => l.code == _selectedLanguageCode);

  bool get _hasPendingChanges =>
      _selectedLanguageCode != _currentLanguageCode ||
      _useDeviceLanguage != _appliedUseDeviceLanguage;

  List<_LanguageOption> get _filteredLanguages {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _languages;
    return _languages.where((l) {
      return l.nativeTitle.toLowerCase().contains(q) ||
          l.englishSubtitle.toLowerCase().contains(q) ||
          l.sampleNavPreview.toLowerCase().contains(q);
    }).toList();
  }

  void _toggleUseDeviceLanguage(bool value) {
    setState(() {
      _useDeviceLanguage = value;
      if (value) {
        _selectedLanguageCode = 'en_GB';
      }
    });
  }

  void _selectLanguage(String code) {
    setState(() {
      _selectedLanguageCode = code;
      if (code != 'en_GB' && _useDeviceLanguage) {
        _useDeviceLanguage = false;
      }
    });
  }

  void _applyLanguage() {
    if (!_hasPendingChanges) {
      AppSnackbar.show(
        context,
        title: 'Language Active',
        message: '${_currentLanguage.nativeTitle} is already active.',
        type: SnackbarType.info,
      );
      return;
    }

    setState(() {
      _currentLanguageCode = _selectedLanguageCode;
      _appliedUseDeviceLanguage = _useDeviceLanguage;
    });

    AppSnackbar.show(
      context,
      title: 'Language Applied',
      message: _appliedUseDeviceLanguage
          ? 'Following device language (${_currentLanguage.nativeTitle}).'
          : 'Ulvenik interface updated to ${_currentLanguage.nativeTitle}.',
      type: SnackbarType.success,
    );
  }

  void _showComingSoonSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        const upcoming = [
          ('Norsk (Bokmål)', 'Norwegian · Nordic Pack Q4'),
          ('Dansk', 'Danish · Nordic Pack Q4'),
          ('Suomi', 'Finnish · Nordic Pack Q4'),
          ('Nederlands', 'Dutch · In Translation'),
          ('Italiano', 'Italian · Planned'),
        ];
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
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
                const Text(
                  'Upcoming Languages',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextOffWhite,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tap any language below to receive a notification as soon as its pack launches.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 14),
                for (final item in upcoming)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      item.$1,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextOffWhite,
                      ),
                    ),
                    subtitle: Text(
                      item.$2,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.primaryForestGreen,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.of(sheetCtx).pop();
                      AppSnackbar.show(
                        context,
                        title: 'Language Vote Recorded',
                        message:
                            'We will notify you when ${item.$1} is ready.',
                        type: SnackbarType.success,
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
                    _buildSectionLabel('CURRENT LANGUAGE'),
                    const SizedBox(height: 10),
                    _buildCurrentLanguageCard(),
                    const SizedBox(height: 14),
                    _buildUseDeviceLanguageCard(),
                    const SizedBox(height: 14),
                    _buildSearchField(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('SUPPORTED LANGUAGES'),
                    const SizedBox(height: 10),
                    _buildSupportedLanguagesCard(),
                  ],
                ),
              ),
            ),
            _buildBottomApplyDock(),
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
            onPressed: () =>
                Navigator.of(context).maybePop(_currentLanguage.nativeTitle),
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
              'Language',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextOffWhite,
              ),
            ),
          ),
          GestureDetector(
            onTap: _applyLanguage,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Text(
                'Apply',
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

  Widget _buildCurrentLanguageCard() {
    final current = _currentLanguage;
    final selected = _selectedLanguage;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(
                  Icons.language_rounded,
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
                      current.nativeTitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.26,
                        color: AppColors.primaryTextOffWhite,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _appliedUseDeviceLanguage
                          ? '${current.interfaceLabel} · Device Auto'
                          : current.interfaceLabel,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: const Text(
                  'CURRENT',
                  style: TextStyle(
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
          if (_selectedLanguageCode != _currentLanguageCode) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryForestGreen.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryForestGreen.withValues(alpha: 0.42),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview · ${selected.nativeTitle}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF53A689),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    selected.sampleNavPreview,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      color: AppColors.primaryTextOffWhite,
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

  Widget _buildUseDeviceLanguageCard() {
    return GestureDetector(
      onTap: () => _toggleUseDeviceLanguage(!_useDeviceLanguage),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.smartphone_rounded,
              size: 20,
              color: AppColors.secondaryTextStoneGrey,
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use Device Language',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextOffWhite,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Ulvenik follows your device language setting',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      height: 1.35,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _UlvenikPillSwitch(
              value: _useDeviceLanguage,
              onChanged: _toggleUseDeviceLanguage,
            ),
          ],
        ),
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
          const Icon(
            Icons.search_rounded,
            size: 19,
            color: AppColors.secondaryTextStoneGrey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (v) => setState(() => _searchQuery = v),
              cursorColor: AppColors.primaryForestGreen,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.5,
                color: AppColors.primaryTextOffWhite,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search languages',
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
                child: Icon(
                  Icons.close_rounded,
                  size: 17,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSupportedLanguagesCard() {
    final items = _filteredLanguages;
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
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No supported languages matching "${_searchQuery.trim()}"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
              )
            else
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0) Container(height: 1, color: AppColors.cardBorder),
                _buildLanguageRow(
                  items[i],
                  isSelected: _selectedLanguageCode == items[i].code,
                ),
              ],
            Container(height: 1, color: AppColors.cardBorder),
            InkWell(
              onTap: _showComingSoonSheet,
              child: const SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: Text(
                    'More languages coming soon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageRow(
    _LanguageOption option, {
    required bool isSelected,
  }) {
    return Material(
      color: isSelected
          ? AppColors.primaryForestGreen.withValues(alpha: 0.14)
          : Colors.transparent,
      child: InkWell(
        onTap: () => _selectLanguage(option.code),
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
                  padding: const EdgeInsets.fromLTRB(15, 13.5, 16, 13.5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.nativeTitle,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryTextOffWhite,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              option.englishSubtitle,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.5,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_rounded,
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

  Widget _buildBottomApplyDock() {
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
              onPressed: _applyLanguage,
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
                'Apply Language',
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
            'User-created content will not be translated.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _UlvenikPillSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _UlvenikPillSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 46,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? AppColors.primaryForestGreen : const Color(0xFF343A3D),
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value
                  ? AppColors.primaryTextOffWhite
                  : const Color(0xFFB7BFBA),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
