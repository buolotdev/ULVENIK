import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum _ExportFormat { zip, pdf, csv, json }

enum _MediaQuality { original, optimised, exclude }

enum _DateRangeMode { allData, customRange }

enum _ExportStage { idle, preparing, ready }

class _ScopeOption {
  final String id;
  final String label;
  final double sizeMb;
  final bool isMediaHeavy;

  const _ScopeOption({
    required this.id,
    required this.label,
    required this.sizeMb,
    this.isMediaHeavy = false,
  });
}

class _ScopeGroup {
  final String id;
  final String title;
  final String collapsedSubtitle;
  final IconData icon;
  final Color barColor;
  final List<_ScopeOption> options;

  const _ScopeGroup({
    required this.id,
    required this.title,
    required this.collapsedSubtitle,
    required this.icon,
    required this.barColor,
    required this.options,
  });
}

class ExportMyDataScreen extends StatefulWidget {
  final bool hasSportPack;
  final bool hasTrainerPack;

  const ExportMyDataScreen({
    super.key,
    this.hasSportPack = true,
    this.hasTrainerPack = true,
  });

  @override
  State<ExportMyDataScreen> createState() => _ExportMyDataScreenState();
}

class _ExportMyDataScreenState extends State<ExportMyDataScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian;
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _sage = AppColors.secondarySage;
  static const Color _sageMint = Color(0xFFB6CCB5);
  static const Color _alpineBlue = AppColors.infoAlpineBlue;
  static const Color _bronze = AppColors.bronzeAccent;
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _cardBorder = AppColors.cardBorder;

  List<_ScopeOption> get _packOptions => [
        if (widget.hasSportPack)
          const _ScopeOption(
            id: 'pack_sport',
            label: 'Competitions (Sport Pack)',
            sizeMb: 14.0,
          ),
        if (widget.hasTrainerPack)
          const _ScopeOption(
            id: 'pack_trainer',
            label: 'Trainer Pack Data',
            sizeMb: 21.0,
          ),
      ];

  List<_ScopeGroup> get _groups {
    final packOpts = _packOptions;
    return [
      const _ScopeGroup(
        id: 'account',
        title: 'Account',
        collapsedSubtitle:
            'Account Information · Preferences · Calendar · Custom Libraries',
        icon: Icons.person_outline_rounded,
        barColor: _sage,
        options: [
          _ScopeOption(
            id: 'acc_info',
            label: 'Account Information',
            sizeMb: 4.0,
          ),
          _ScopeOption(
            id: 'acc_prefs',
            label: 'Saved Preferences',
            sizeMb: 2.0,
          ),
          _ScopeOption(
            id: 'acc_cal',
            label: 'Calendar & Reminders',
            sizeMb: 8.0,
          ),
          _ScopeOption(
            id: 'acc_skills',
            label: 'Custom Skills',
            sizeMb: 6.0,
          ),
          _ScopeOption(
            id: 'acc_exercises',
            label: 'Custom Exercises',
            sizeMb: 7.0,
          ),
          _ScopeOption(
            id: 'acc_equipment',
            label: 'Equipment',
            sizeMb: 5.0,
          ),
          _ScopeOption(
            id: 'acc_rewards',
            label: 'Rewards',
            sizeMb: 3.0,
          ),
        ],
      ),
      const _ScopeGroup(
        id: 'dogs',
        title: 'Dogs',
        collapsedSubtitle: 'Dog Profiles',
        icon: Icons.pets_outlined,
        barColor: _forest,
        options: [
          _ScopeOption(
            id: 'dogs_profiles',
            label: 'Dog Profiles',
            sizeMb: 18.0,
          ),
          _ScopeOption(
            id: 'dogs_pedigree',
            label: 'Pedigree & Microchip Records',
            sizeMb: 12.0,
          ),
          _ScopeOption(
            id: 'dogs_titles',
            label: 'Qualifications, Titles & Awards',
            sizeMb: 9.0,
          ),
        ],
      ),
      const _ScopeGroup(
        id: 'training',
        title: 'Training',
        collapsedSubtitle: 'Training Records · S&C · Goals · Stats',
        icon: Icons.fitness_center_rounded,
        barColor: _alpineBlue,
        options: [
          _ScopeOption(
            id: 'trn_records',
            label: 'Training Records',
            sizeMb: 46.0,
          ),
          _ScopeOption(
            id: 'trn_sc',
            label: 'S&C Conditioning Logs',
            sizeMb: 22.0,
          ),
          _ScopeOption(
            id: 'trn_goals',
            label: 'Goals & Milestones',
            sizeMb: 11.0,
          ),
          _ScopeOption(
            id: 'trn_stats',
            label: 'Stats',
            sizeMb: 15.0,
          ),
        ],
      ),
      const _ScopeGroup(
        id: 'health',
        title: 'Health',
        collapsedSubtitle: 'Health Records · Medications · Vaccinations',
        icon: Icons.favorite_border_rounded,
        barColor: Color(0xFF9E6B7B),
        options: [
          _ScopeOption(
            id: 'hlth_records',
            label: 'Health Records & Vet Visits',
            sizeMb: 24.0,
          ),
          _ScopeOption(
            id: 'hlth_meds',
            label: 'Medications & Supplements',
            sizeMb: 9.0,
          ),
          _ScopeOption(
            id: 'hlth_vax',
            label: 'Vaccinations & Weight Logs',
            sizeMb: 11.0,
          ),
        ],
      ),
      const _ScopeGroup(
        id: 'media',
        title: 'Media & Documents',
        collapsedSubtitle: 'Photos · Videos · Documents · Notes · Timeline',
        icon: Icons.collections_outlined,
        barColor: _bronze,
        options: [
          _ScopeOption(
            id: 'med_photos',
            label: 'Photos',
            sizeMb: 340.0,
            isMediaHeavy: true,
          ),
          _ScopeOption(
            id: 'med_videos',
            label: 'Videos',
            sizeMb: 610.0,
            isMediaHeavy: true,
          ),
          _ScopeOption(
            id: 'med_docs',
            label: 'Documents & Certificates',
            sizeMb: 48.0,
          ),
          _ScopeOption(
            id: 'med_timeline',
            label: 'Notes & Timeline',
            sizeMb: 21.0,
          ),
        ],
      ),
      if (packOpts.isNotEmpty)
        _ScopeGroup(
          id: 'packs',
          title: 'Packs',
          collapsedSubtitle: packOpts.map((o) => o.label).join(' · '),
          icon: Icons.inventory_2_outlined,
          barColor: const Color(0xFF6B8A9E),
          options: packOpts,
        ),
    ];
  }

  // Matches Figma initial state: Account expanded; Equipment & Rewards unchecked;
  // all other core scopes checked (~1.2 GB total).
  final Set<String> _expandedGroups = {'account'};
  late final Set<String> _selectedOptionIds;

  _ExportFormat _exportFormat = _ExportFormat.zip;
  _MediaQuality _mediaQuality = _MediaQuality.original;
  _DateRangeMode _dateRangeMode = _DateRangeMode.allData;
  int _customRangeMonths = 12;

  bool _protectWithPassword = false;
  bool _obscureArchivePassword = true;
  final TextEditingController _archivePasswordController =
      TextEditingController();

  _ExportStage _exportStage = _ExportStage.idle;
  double _exportProgress = 0.0;
  String _exportStepLabel = '';
  bool _archiveDownloaded = false;

  @override
  void initState() {
    super.initState();
    _selectedOptionIds = {
      for (final g in _groups)
        for (final opt in g.options)
          if (opt.id != 'acc_equipment' && opt.id != 'acc_rewards') opt.id,
    };
    _archivePasswordController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _archivePasswordController.dispose();
    super.dispose();
  }

  int get _totalOptionCount =>
      _groups.fold(0, (sum, g) => sum + g.options.length);

  bool get _allSelected => _selectedOptionIds.length == _totalOptionCount;

  void _toggleSelectAll() {
    setState(() {
      if (_allSelected) {
        _selectedOptionIds.clear();
      } else {
        for (final g in _groups) {
          for (final opt in g.options) {
            _selectedOptionIds.add(opt.id);
          }
        }
      }
      if (_exportStage == _ExportStage.ready) {
        _exportStage = _ExportStage.idle;
      }
    });
  }

  double _effectiveOptionSizeMb(_ScopeOption opt) {
    if (!_selectedOptionIds.contains(opt.id)) return 0.0;

    double mb = opt.sizeMb;

    // Format & media quality scaling
    final excludesMedia = _exportFormat == _ExportFormat.csv ||
        _exportFormat == _ExportFormat.pdf ||
        _mediaQuality == _MediaQuality.exclude;

    if (opt.isMediaHeavy) {
      if (excludesMedia) {
        return 0.0;
      }
      if (_mediaQuality == _MediaQuality.optimised) {
        mb *= 0.36;
      }
    }

    if (_exportFormat == _ExportFormat.pdf) {
      mb *= 0.25;
    } else if (_exportFormat == _ExportFormat.csv) {
      mb *= 0.18;
    } else if (_exportFormat == _ExportFormat.json) {
      mb *= 0.85;
    }

    if (_dateRangeMode == _DateRangeMode.customRange) {
      final rangeScale = (_customRangeMonths / 24.0).clamp(0.15, 1.0);
      mb *= rangeScale;
    }

    return mb;
  }

  double _groupEstimatedMb(_ScopeGroup group) {
    double sum = 0.0;
    for (final opt in group.options) {
      sum += _effectiveOptionSizeMb(opt);
    }
    return sum;
  }

  double get _totalEstimatedMb {
    double total = 0.0;
    for (final g in _groups) {
      total += _groupEstimatedMb(g);
    }
    return total;
  }

  String _formatSize(double sizeMb) {
    if (sizeMb <= 0.05) return '0 MB';
    if (sizeMb >= 1000.0) {
      final gb = sizeMb / 1024.0;
      return '${gb.toStringAsFixed(1)} GB';
    }
    return '${sizeMb.round()} MB';
  }

  String get _archiveFileExtension {
    switch (_exportFormat) {
      case _ExportFormat.zip:
        return 'zip';
      case _ExportFormat.pdf:
        return 'pdf';
      case _ExportFormat.csv:
        return 'csv';
      case _ExportFormat.json:
        return 'json';
    }
  }

  String get _formatDisplayLabel {
    switch (_exportFormat) {
      case _ExportFormat.zip:
        return 'ZIP Archive';
      case _ExportFormat.pdf:
        return 'PDF Summary';
      case _ExportFormat.csv:
        return 'CSV Data';
      case _ExportFormat.json:
        return 'JSON Backup';
    }
  }

  Future<void> _startExportGeneration() async {
    if (_exportStage == _ExportStage.preparing) return;

    if (_selectedOptionIds.isEmpty) {
      AppSnackbar.show(
        context,
        title: 'No Data Selected',
        message: 'Select at least one category under Select Data to Include.',
        type: SnackbarType.warning,
      );
      return;
    }

    if (_protectWithPassword &&
        _archivePasswordController.text.trim().length < 6) {
      AppSnackbar.show(
        context,
        title: 'Archive Password Too Short',
        message:
            'Enter at least 6 characters to encrypt your export archive, or turn off Protect with Password.',
        type: SnackbarType.warning,
      );
      return;
    }

    final steps = <(double, String)>[
      (0.22, 'Indexing selected dog workspaces & training logs...'),
      (0.54, 'Packaging health records, custom skills & pack data...'),
      (0.82, 'Compressing $_formatDisplayLabel & verifying integrity...'),
      (
        0.96,
        _protectWithPassword
            ? 'Applying AES-256 password encryption...'
            : 'Signing 48-hour secure download token...'
      ),
    ];

    setState(() {
      _exportStage = _ExportStage.preparing;
      _exportProgress = 0.08;
      _exportStepLabel = steps.first.$2;
      _archiveDownloaded = false;
    });

    for (final step in steps) {
      await Future<void>.delayed(const Duration(milliseconds: 380));
      if (!mounted) return;
      setState(() {
        _exportProgress = step.$1;
        _exportStepLabel = step.$2;
      });
    }

    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _exportStage = _ExportStage.ready;
      _exportProgress = 1.0;
    });

    AppSnackbar.show(
      context,
      title: 'Export Archive Ready',
      message:
          'Prepared ${_formatSize(_totalEstimatedMb)} $_formatDisplayLabel · Valid for 48 hours.',
      type: SnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalMb = _totalEstimatedMb;

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
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(),
                    const SizedBox(height: 24),
                    _buildSelectDataHeaderRow(),
                    const SizedBox(height: 12),
                    for (int i = 0; i < _groups.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      _buildScopeAccordionCard(_groups[i]),
                    ],
                    const SizedBox(height: 26),
                    _buildSectionLabel('EXPORT FORMAT'),
                    const SizedBox(height: 10),
                    _buildExportFormatCard(),
                    const SizedBox(height: 26),
                    _buildSectionLabel('MEDIA QUALITY'),
                    const SizedBox(height: 10),
                    _buildMediaQualityCard(),
                    const SizedBox(height: 12),
                    _buildEstimatedSizeAndBreakdown(totalMb),
                    const SizedBox(height: 24),
                    _buildSectionLabel('DATE RANGE'),
                    const SizedBox(height: 10),
                    _buildDateRangeCard(),
                    const SizedBox(height: 26),
                    _buildSectionLabel('SECURITY'),
                    const SizedBox(height: 10),
                    _buildSecurityCard(),
                    const SizedBox(height: 24),
                    Container(height: 1, color: _cardBorder),
                    const SizedBox(height: 22),
                    _buildExportActionArea(totalMb),
                    const SizedBox(height: 14),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'Export files are prepared securely and links expire after 48 hours.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            height: 1.45,
                            color: _stoneGrey,
                          ),
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

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 14),
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
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: _offWhite,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Export My Data',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.cloud_download_outlined,
                color: _sageMint,
                size: 21,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Export Your Data',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.only(left: 33),
            child: Text(
              'Generate a downloadable copy of your Ulvenik account information. This export is for your personal records and is prepared securely.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                height: 1.5,
                color: _stoneGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectDataHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionLabel('SELECT DATA TO INCLUDE'),
        GestureDetector(
          onTap: _toggleSelectAll,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _allSelected
                    ? _forest.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.14),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _allSelected
                      ? Icons.check_box_rounded
                      : Icons.check_box_outlined,
                  size: 14,
                  color: _allSelected ? _forest : _stoneGrey,
                ),
                const SizedBox(width: 6),
                Text(
                  _allSelected ? 'Deselect All' : 'Select All',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _allSelected ? _offWhite : _stoneGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScopeAccordionCard(_ScopeGroup group) {
    final isExpanded = _expandedGroups.contains(group.id);
    final selectedInGroup = group.options
        .where((o) => _selectedOptionIds.contains(o.id))
        .length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedGroups.remove(group.id);
                } else {
                  _expandedGroups.add(group.id);
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                isExpanded ? 16 : 15,
                16,
                isExpanded ? 14 : 15,
              ),
              child: Row(
                children: [
                  Icon(
                    group.icon,
                    color: _sageMint,
                    size: 19,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              group.title,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _offWhite,
                              ),
                            ),
                            if (!isExpanded && selectedInGroup > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _forest.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$selectedInGroup/${group.options.length}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: _sageMint,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (!isExpanded) ...[
                          const SizedBox(height: 3),
                          Text(
                            group.collapsedSubtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.5,
                              color: _stoneGrey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: _stoneGrey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Column(
              children: [
                for (int idx = 0; idx < group.options.length; idx++) ...[
                  if (idx > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(height: 1, color: _cardBorder),
                    ),
                  _buildOptionCheckboxRow(group.options[idx]),
                ],
                const SizedBox(height: 4),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildOptionCheckboxRow(_ScopeOption option) {
    final checked = _selectedOptionIds.contains(option.id);
    return InkWell(
      onTap: () {
        setState(() {
          if (checked) {
            _selectedOptionIds.remove(option.id);
          } else {
            _selectedOptionIds.add(option.id);
          }
          if (_exportStage == _ExportStage.ready) {
            _exportStage = _ExportStage.idle;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: checked ? _stoneGrey : _stoneGrey.withValues(alpha: 0.78),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                color: checked ? _forest : _offWhite,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: checked
                      ? _forest
                      : Colors.white.withValues(alpha: 0.25),
                  width: 1.2,
                ),
              ),
              child: checked
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: _offWhite,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportFormatCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildFormatRadioRow(
            format: _ExportFormat.zip,
            icon: Icons.folder_zip_outlined,
            title: 'ZIP Archive',
            subtitle: 'Recommended. Everything in one compressed file.',
          ),
          _buildCardDivider(),
          _buildFormatRadioRow(
            format: _ExportFormat.pdf,
            icon: Icons.description_outlined,
            title: 'PDF Summary',
            subtitle: 'Readable summary of your records. No raw data.',
          ),
          _buildCardDivider(),
          _buildFormatRadioRow(
            format: _ExportFormat.csv,
            icon: Icons.grid_on_rounded,
            title: 'CSV Data',
            subtitle: 'Spreadsheet-compatible. Excludes media.',
          ),
          _buildCardDivider(),
          _buildFormatRadioRow(
            format: _ExportFormat.json,
            icon: Icons.code_rounded,
            title: 'JSON Backup',
            subtitle: 'Advanced. Full structured data export.',
          ),
        ],
      ),
    );
  }

  Widget _buildFormatRadioRow({
    required _ExportFormat format,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final selected = _exportFormat == format;
    return InkWell(
      onTap: () {
        setState(() {
          _exportFormat = format;
          if (_exportStage == _ExportStage.ready) {
            _exportStage = _ExportStage.idle;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                icon,
                color: selected ? _sageMint : _stoneGrey,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: _offWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      height: 1.4,
                      color: _stoneGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildRadioIndicator(selected),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaQualityCard() {
    final mediaAutoExcluded = _exportFormat == _ExportFormat.csv ||
        _exportFormat == _ExportFormat.pdf;

    return Opacity(
      opacity: mediaAutoExcluded ? 0.55 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _buildQualityRadioRow(
              quality: _MediaQuality.original,
              title: 'Original Quality',
              subtitle: 'Full resolution. Larger file size.',
              disabled: mediaAutoExcluded,
            ),
            _buildCardDivider(),
            _buildQualityRadioRow(
              quality: _MediaQuality.optimised,
              title: 'Optimised Quality',
              subtitle: 'Reduced size. Suitable for most purposes.',
              disabled: mediaAutoExcluded,
            ),
            _buildCardDivider(),
            _buildQualityRadioRow(
              quality: _MediaQuality.exclude,
              title: 'Exclude Media',
              subtitle: 'Only export records and documents.',
              disabled: mediaAutoExcluded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityRadioRow({
    required _MediaQuality quality,
    required String title,
    required String subtitle,
    required bool disabled,
  }) {
    final effectiveQuality =
        disabled ? _MediaQuality.exclude : _mediaQuality;
    final selected = effectiveQuality == quality;

    return InkWell(
      onTap: disabled
          ? () {
              AppSnackbar.show(
                context,
                title: 'Media Excluded by Format',
                message:
                    'Switch to ZIP Archive or JSON Backup to include photo and video files.',
                type: SnackbarType.info,
              );
            }
          : () {
              setState(() {
                _mediaQuality = quality;
                if (_exportStage == _ExportStage.ready) {
                  _exportStage = _ExportStage.idle;
                }
              });
            },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: _offWhite,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      color: _stoneGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildRadioIndicator(selected),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimatedSizeAndBreakdown(double totalMb) {
    final nonZeroSegments = _groups
        .map((g) => (group: g, mb: _groupEstimatedMb(g)))
        .where((entry) => entry.mb > 0.05)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated export size: ${_formatSize(totalMb)}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: _stoneGrey,
                ),
              ),
              Text(
                '${_selectedOptionIds.length} of $_totalOptionCount scopes',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.5,
                  color: _stoneGrey.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 7,
              width: double.infinity,
              color: _carbon,
              child: totalMb <= 0.05
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        for (int i = 0; i < nonZeroSegments.length; i++) ...[
                          if (i > 0) const SizedBox(width: 2),
                          Expanded(
                            flex: ((nonZeroSegments[i].mb / totalMb) * 1000)
                                .round()
                                .clamp(25, 1000),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutCubic,
                              color: nonZeroSegments[i].group.barColor,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
          if (nonZeroSegments.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: nonZeroSegments.map((seg) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: seg.group.barColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${seg.group.title} ${_formatSize(seg.mb)}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: _stoneGrey.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateRangeCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _dateRangeMode = _DateRangeMode.allData;
                if (_exportStage == _ExportStage.ready) {
                  _exportStage = _ExportStage.idle;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All Data',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: _offWhite,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Export everything in your account',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5,
                            color: _stoneGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildRadioIndicator(_dateRangeMode == _DateRangeMode.allData),
                ],
              ),
            ),
          ),
          _buildCardDivider(),
          InkWell(
            onTap: () {
              setState(() {
                _dateRangeMode = _DateRangeMode.customRange;
                if (_exportStage == _ExportStage.ready) {
                  _exportStage = _ExportStage.idle;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Custom Date Range',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5,
                        fontWeight: _dateRangeMode == _DateRangeMode.customRange
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: _offWhite,
                      ),
                    ),
                  ),
                  _buildRadioIndicator(
                    _dateRangeMode == _DateRangeMode.customRange,
                  ),
                ],
              ),
            ),
          ),
          if (_dateRangeMode == _DateRangeMode.customRange) ...[
            _buildCardDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SELECT EXPORT WINDOW',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                      color: _stoneGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [3, 6, 12, 18].map((months) {
                      final active = _customRangeMonths == months;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _customRangeMonths = months;
                            if (_exportStage == _ExportStage.ready) {
                              _exportStage = _ExportStage.idle;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? _forest.withValues(alpha: 0.24)
                                : _obsidian,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active ? _forest : _cardBorder,
                            ),
                          ),
                          child: Text(
                            'Last $months months',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight:
                                  active ? FontWeight.w600 : FontWeight.w400,
                              color: active ? _offWhite : _stoneGrey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: _sageMint,
                  size: 19,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protect with Password',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: _offWhite,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Encrypts your export. Ulvenik does not store this password.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          height: 1.4,
                          color: _stoneGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: _protectWithPassword,
                  activeThumbColor: _offWhite,
                  activeTrackColor: _forest,
                  inactiveThumbColor: _offWhite,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.16),
                  onChanged: (val) {
                    setState(() {
                      _protectWithPassword = val;
                      if (_exportStage == _ExportStage.ready) {
                        _exportStage = _ExportStage.idle;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          if (_protectWithPassword) ...[
            _buildCardDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ARCHIVE ENCRYPTION PASSWORD',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                      color: _stoneGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _archivePasswordController,
                    obscureText: _obscureArchivePassword,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
                      color: _offWhite,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Create password (min. 6 characters)',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5,
                        color: _stoneGrey.withValues(alpha: 0.6),
                      ),
                      filled: true,
                      fillColor: _obsidian,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: _forest,
                          width: 1.4,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureArchivePassword = !_obscureArchivePassword;
                          });
                        },
                        icon: Icon(
                          _obscureArchivePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                          color: _stoneGrey,
                        ),
                      ),
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

  Widget _buildExportActionArea(double totalMb) {
    if (_exportStage == _ExportStage.preparing) {
      final pct = (_exportProgress * 100).round();
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _forest.withValues(alpha: 0.45)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(_forest),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Preparing Secure Export...',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _offWhite,
                    ),
                  ),
                ),
                Text(
                  '$pct%',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _sageMint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _exportProgress,
                minHeight: 7,
                backgroundColor: _obsidian,
                valueColor: const AlwaysStoppedAnimation<Color>(_forest),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _exportStepLabel,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                color: _stoneGrey,
              ),
            ),
          ],
        ),
      );
    }

    if (_exportStage == _ExportStage.ready) {
      final fileName = 'ulvenik-export-2026-10-30.$_archiveFileExtension';
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _forest.withValues(alpha: 0.65)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    color: _sageMint,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Archive Ready to Download',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _offWhite,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$fileName · ${_formatSize(totalMb)}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          color: _sageMint,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_protectWithPassword)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Text(
                      'AES-256',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _sageMint,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() => _archiveDownloaded = true);
                  AppSnackbar.show(
                    context,
                    title: 'Download Started',
                    message: 'Saving $fileName (${_formatSize(totalMb)}) locally.',
                    type: SnackbarType.success,
                  );
                },
                icon: Icon(
                  _archiveDownloaded
                      ? Icons.check_circle_outline_rounded
                      : Icons.download_rounded,
                  size: 19,
                ),
                label: Text(
                  _archiveDownloaded ? 'Downloaded · Save Copy Again' : 'Download Archive',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _stoneGrey,
                      side: const BorderSide(color: _cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: 'https://vault.ulvenik.app/exports/$fileName',
                        ),
                      );
                      AppSnackbar.show(
                        context,
                        title: 'Secure Link Copied',
                        message:
                            'Copied 48-hour signed export link to clipboard.',
                        type: SnackbarType.info,
                      );
                    },
                    icon: const Icon(Icons.link_rounded, size: 17),
                    label: const Text(
                      'Copy 48h Link',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _stoneGrey,
                      side: const BorderSide(color: _cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    onPressed: _startExportGeneration,
                    icon: const Icon(Icons.refresh_rounded, size: 17),
                    label: const Text(
                      'Rebuild Export',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _forest,
          foregroundColor: _offWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: _startExportGeneration,
        child: const Text(
          'Generate Export',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildRadioIndicator(bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? _forest : Colors.white.withValues(alpha: 0.20),
          width: selected ? 1.8 : 1.3,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8.5,
                height: 8.5,
                decoration: const BoxDecoration(
                  color: _forest,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildCardDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(height: 1, color: _cardBorder),
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
          letterSpacing: 1.2,
          color: _stoneGrey,
        ),
      ),
    );
  }
}
