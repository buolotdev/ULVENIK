import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _TrainerReportItem {
  final String id;
  final String title;
  final List<String> dogNames;
  final String createdDate;
  final String dateRange;
  final String reportType;
  final bool isCompetitionReport;
  bool isShared;
  final String fileSizeMb;

  _TrainerReportItem({
    required this.id,
    required this.title,
    required this.dogNames,
    required this.createdDate,
    required this.dateRange,
    required this.reportType,
    this.isCompetitionReport = false,
    required this.isShared,
    required this.fileSizeMb,
  });

  String get dogBadgeLabel => dogNames.join(' · ').toUpperCase();

  _TrainerReportItem copyWith({
    String? id,
    String? title,
    List<String>? dogNames,
    String? createdDate,
    String? dateRange,
    String? reportType,
    bool? isCompetitionReport,
    bool? isShared,
    String? fileSizeMb,
  }) {
    return _TrainerReportItem(
      id: id ?? this.id,
      title: title ?? this.title,
      dogNames: dogNames ?? List<String>.from(this.dogNames),
      createdDate: createdDate ?? this.createdDate,
      dateRange: dateRange ?? this.dateRange,
      reportType: reportType ?? this.reportType,
      isCompetitionReport: isCompetitionReport ?? this.isCompetitionReport,
      isShared: isShared ?? this.isShared,
      fileSizeMb: fileSizeMb ?? this.fileSizeMb,
    );
  }
}

class TrainerReportsScreen extends StatefulWidget {
  final bool hasSportPack;
  final bool hasCompetitionRecords;

  const TrainerReportsScreen({
    super.key,
    this.hasSportPack = true,
    this.hasCompetitionRecords = true,
  });

  @override
  State<TrainerReportsScreen> createState() => _TrainerReportsScreenState();
}

class _TrainerReportsScreenState extends State<TrainerReportsScreen> {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _cardBg = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _mintBright = Color(0xFF95D3BB);
  static const Color _sage = AppColors.secondarySage;
  static const Color _textPrimary = AppColors.primaryTextOffWhite;
  static const Color _textSecondary = AppColors.secondaryTextStoneGrey;
  static const Color _border = AppColors.cardBorder;
  static const Color _copyTileBg = Color(0xFF21313B);
  static const Color _copyAccent = Color(0xFF6BA6C9);
  static const Color _deleteTileBg = Color(0xFF3A2122);
  static const Color _deleteAccent = Color(0xFFE07A7A);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _shareFilter = 'ALL'; // ALL, SHARED, NOT_SHARED
  String _typeFilter = 'ALL';
  String? _swipedReportId;

  bool get _canAccessCompetitionReports =>
      widget.hasSportPack && widget.hasCompetitionRecords;

  List<String> get _availableReportTypes => [
        'Training Progress Report',
        'Puppy Progress Report',
        if (_canAccessCompetitionReports) 'Competition Progress Report',
        'Full Client Report',
      ];

  late final List<_TrainerReportItem> _reports = [
    _TrainerReportItem(
      id: 'rep_1',
      title: 'Training Progress Report — Oct 2026',
      dogNames: ['Luna', 'Bear'],
      createdDate: '12 Oct 2026',
      dateRange: 'Sep 2026 – Oct 2026',
      reportType: 'Training Progress Report',
      isShared: true,
      fileSizeMb: '2.4 MB',
    ),
    _TrainerReportItem(
      id: 'rep_2',
      title: 'Puppy Foundation & Drive Assessment',
      dogNames: ['Bear'],
      createdDate: '28 Sep 2026',
      dateRange: 'Aug 2026 – Sep 2026',
      reportType: 'Puppy Progress Report',
      isShared: true,
      fileSizeMb: '1.8 MB',
    ),
    _TrainerReportItem(
      id: 'rep_3',
      title: 'IGP Tracking & Protection Review',
      dogNames: ['Luna'],
      createdDate: '14 Sep 2026',
      dateRange: 'Jul 2026 – Sep 2026',
      reportType: 'Competition Progress Report',
      isCompetitionReport: true,
      isShared: false,
      fileSizeMb: '3.1 MB',
    ),
    _TrainerReportItem(
      id: 'rep_4',
      title: 'Comprehensive Q3 Client Review',
      dogNames: ['Luna', 'Bear'],
      createdDate: '01 Sep 2026',
      dateRange: 'Jun 2026 – Aug 2026',
      reportType: 'Full Client Report',
      isShared: false,
      fileSizeMb: '4.5 MB',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters =>
      _shareFilter != 'ALL' ||
      (_typeFilter != 'ALL' &&
          (_canAccessCompetitionReports ||
              _typeFilter != 'Competition Progress Report'));

  List<_TrainerReportItem> get _visibleReports {
    final query = _searchController.text.trim().toLowerCase();
    final activeTypeFilter =
        (!_canAccessCompetitionReports &&
                _typeFilter == 'Competition Progress Report')
            ? 'ALL'
            : _typeFilter;

    return _reports.where((report) {
      if (report.isCompetitionReport && !_canAccessCompetitionReports) {
        return false;
      }
      if (_shareFilter == 'SHARED' && !report.isShared) {
        return false;
      }
      if (_shareFilter == 'NOT_SHARED' && report.isShared) {
        return false;
      }
      if (activeTypeFilter != 'ALL' && report.reportType != activeTypeFilter) {
        return false;
      }
      if (query.isNotEmpty) {
        final matches = report.title.toLowerCase().contains(query) ||
            report.reportType.toLowerCase().contains(query) ||
            report.dogBadgeLabel.toLowerCase().contains(query) ||
            report.dateRange.toLowerCase().contains(query);
        if (!matches) return false;
      }
      return true;
    }).toList();
  }

  void _duplicateReport(_TrainerReportItem source) {
    final copy = source.copyWith(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      title: '${source.title} (Copy)',
      createdDate: 'Today',
      isShared: false,
    );
    setState(() {
      final index = _reports.indexWhere((r) => r.id == source.id);
      if (index != -1) {
        _reports.insert(index + 1, copy);
      } else {
        _reports.insert(0, copy);
      }
      _swipedReportId = null;
    });
    AppSnackbar.show(
      context,
      title: 'Report Duplicated',
      message: 'Created a copy of "${source.title}".',
      type: SnackbarType.success,
    );
  }

  Future<void> _confirmDeleteReport(_TrainerReportItem report) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: _cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _border),
          ),
          title: const Text(
            'Delete Report?',
            style: TextStyle(
              fontFamily: 'Inter',
              color: _textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete "${report.title}"? This action cannot be undone.',
            style: const TextStyle(
              fontFamily: 'Inter',
              color: _textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: _textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorDestructive,
                foregroundColor: _textPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text(
                'Delete Report',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() {
        _reports.removeWhere((r) => r.id == report.id);
        if (_swipedReportId == report.id) {
          _swipedReportId = null;
        }
      });
      AppSnackbar.show(
        context,
        title: 'Report Deleted',
        message: '"${report.title}" was permanently deleted.',
        type: SnackbarType.info,
      );
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final reportTypes = ['ALL', ..._availableReportTypes];
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Trainer Reports',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: _textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _shareFilter = 'ALL';
                              _typeFilter = 'ALL';
                            });
                            Navigator.of(ctx).pop();
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: _mintBright,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'SHARING STATUS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ('ALL', 'All'),
                        ('SHARED', 'Shared'),
                        ('NOT_SHARED', 'Not Shared'),
                      ].map((opt) {
                        final selected = _shareFilter == opt.$1;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => _shareFilter = opt.$1);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _forest.withValues(alpha: 0.22)
                                  : _bg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: selected ? _forest : _border,
                              ),
                            ),
                            child: Text(
                              opt.$2,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: selected ? _mintBright : _textSecondary,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'REPORT TYPE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: reportTypes.map((type) {
                        final selected = _typeFilter == type;
                        final label = type == 'ALL' ? 'All Types' : type;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => _typeFilter = type);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _forest.withValues(alpha: 0.22)
                                  : _bg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: selected ? _forest : _border,
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: selected ? _mintBright : _textSecondary,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
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

  void _openReportDetailsSheet(_TrainerReportItem report) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: _textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${report.dogBadgeLabel} · Created ${report.createdDate} · ${report.dateRange}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: _textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${report.reportType} · ${report.fileSizeMb} · PDF',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: _sage,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: const Text(
                        'Shared with Client',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _textPrimary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        report.isShared
                            ? 'Client currently has access to this PDF report'
                            : 'Private to trainer workspace until shared',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: _textSecondary,
                          fontSize: 12.5,
                        ),
                      ),
                      value: report.isShared,
                      onChanged: (val) {
                        setState(() => report.isShared = val);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _textPrimary,
                              side: const BorderSide(color: _border),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              _duplicateReport(report);
                            },
                            icon: const Icon(Icons.copy_rounded, size: 17),
                            label: const Text('Copy'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _deleteAccent,
                              side: BorderSide(
                                color: _deleteAccent.withValues(alpha: 0.45),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              _confirmDeleteReport(report);
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                            ),
                            label: const Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'PDF Ready',
                            message:
                                'Exported ${report.title} (${report.fileSizeMb} · PDF).',
                            type: SnackbarType.success,
                          );
                        },
                        icon: const Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 18,
                        ),
                        label: const Text(
                          'Download PDF',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  void _openCreateReportSheet() {
    final types = _availableReportTypes;
    String selectedType = types.first;
    final titleCtrl = TextEditingController();
    String selectedDogs = 'Luna · Bear';
    String selectedRange = 'Oct 2026 – Nov 2026';
    bool shareImmediately = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 22 + bottomInset),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'New Trainer Report',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: titleCtrl,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: _textPrimary,
                          fontSize: 14.5,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Report Title',
                          hintText: 'e.g. Monthly Training Progress Report',
                          labelStyle: const TextStyle(color: _textSecondary),
                          hintStyle: TextStyle(
                            color: _textSecondary.withValues(alpha: 0.55),
                          ),
                          filled: true,
                          fillColor: _bg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _forest),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'REPORT TYPE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: types.map((type) {
                          final selected = selectedType == type;
                          return GestureDetector(
                            onTap: () =>
                                setModalState(() => selectedType = type),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? _forest.withValues(alpha: 0.22)
                                    : _bg,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: selected ? _forest : _border,
                                ),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color:
                                      selected ? _mintBright : _textSecondary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'DOGS INCLUDED',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: ['Luna · Bear', 'Luna', 'Bear'].map((d) {
                          final selected = selectedDogs == d;
                          return GestureDetector(
                            onTap: () => setModalState(() => selectedDogs = d),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? _forest.withValues(alpha: 0.22)
                                    : _bg,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selected ? _forest : _border,
                                ),
                              ),
                              child: Text(
                                d,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color:
                                      selected ? _mintBright : _textSecondary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        activeTrackColor: _forest,
                        title: const Text(
                          'Share with Client Immediately',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: _textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: shareImmediately,
                        onChanged: (v) =>
                            setModalState(() => shareImmediately = v),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _forest,
                            foregroundColor: _textPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final title = titleCtrl.text.trim().isEmpty
                                ? '$selectedType — Nov 2026'
                                : titleCtrl.text.trim();
                            final dogs = selectedDogs
                                .split(' · ')
                                .map((s) => s.trim())
                                .toList();
                            setState(() {
                              _reports.insert(
                                0,
                                _TrainerReportItem(
                                  id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
                                  title: title,
                                  dogNames: dogs,
                                  createdDate: '04 Nov 2026',
                                  dateRange: selectedRange,
                                  reportType: selectedType,
                                  isCompetitionReport: selectedType ==
                                      'Competition Progress Report',
                                  isShared: shareImmediately,
                                  fileSizeMb: '2.1 MB',
                                ),
                              );
                            });
                            Navigator.of(ctx).pop();
                            AppSnackbar.show(
                              context,
                              title: 'Report Generated',
                              message: 'Created "$title" (PDF).',
                              type: SnackbarType.success,
                            );
                          },
                          child: const Text(
                            'Generate PDF Report',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 14.5,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleReports;

    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateReportSheet,
        backgroundColor: _forest,
        foregroundColor: _textPrimary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            const Divider(color: _border, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'REPORTS',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _textSecondary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      if (_hasActiveFilters)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _shareFilter = 'ALL';
                              _typeFilter = 'ALL';
                            });
                          },
                          child: const Text(
                            'Clear filters',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: _mintBright,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (visible.isEmpty)
                    _buildEmptyState()
                  else
                    ...visible.map(
                      (report) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildSwipeableReportCard(report),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: SizedBox(
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        color: _textSecondary,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _textSecondary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Text(
              'Trainer Reports',
              style: TextStyle(
                fontFamily: 'Inter',
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _searchFocusNode.requestFocus(),
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.search_rounded,
                      color: _textSecondary,
                      size: 21,
                    ),
                  ),
                  IconButton(
                    onPressed: _openFilterSheet,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.tune_rounded,
                      color: _hasActiveFilters ? _mintBright : _textSecondary,
                      size: 21,
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

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            size: 18,
            color: _textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: _textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Search reports...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: _textSecondary,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _searchController.clear();
              _searchFocusNode.unfocus();
              setState(() {});
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Inter',
                color: _textSecondary,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableReportCard(_TrainerReportItem report) {
    final isSwiped = _swipedReportId == report.id;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final vx = details.primaryVelocity ?? 0;
        if (vx < -140) {
          setState(() => _swipedReportId = report.id);
        } else if (vx > 140 && isSwiped) {
          setState(() => _swipedReportId = null);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildReportCardBody(
                    report,
                    isSwiped: isSwiped,
                  ),
                ),
                if (isSwiped) ...[
                  _buildSwipeActionTile(
                    backgroundColor: _copyTileBg,
                    accentColor: _copyAccent,
                    icon: Icons.copy_rounded,
                    label: 'COPY',
                    onTap: () => _duplicateReport(report),
                  ),
                  _buildSwipeActionTile(
                    backgroundColor: _deleteTileBg,
                    accentColor: _deleteAccent,
                    icon: Icons.delete_outline_rounded,
                    label: 'DELETE',
                    showSwipeHint: true,
                    onTap: () => _confirmDeleteReport(report),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeActionTile({
    required Color backgroundColor,
    required Color accentColor,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool showSwipeHint = false,
  }) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 74,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (showSwipeHint)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.swipe_left_outlined,
                    size: 15,
                    color: _textSecondary.withValues(alpha: 0.65),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 19, color: accentColor),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: accentColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCardBody(
    _TrainerReportItem report, {
    required bool isSwiped,
  }) {
    return InkWell(
      onTap: () {
        if (isSwiped) {
          setState(() => _swipedReportId = null);
        } else {
          _openReportDetailsSheet(report);
        }
      },
      onLongPress: () {
        setState(() {
          _swipedReportId = isSwiped ? null : report.id;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSwiped) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.description_outlined,
                      color: _sage,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    report.title,
                    maxLines: isSwiped ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: _textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ),
                if (!isSwiped) ...[
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _swipedReportId = report.id;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: _textSecondary,
                      size: 19,
                    ),
                  ),
                ],
              ],
            ),
            if (!isSwiped) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    report.dogBadgeLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: _textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: isSwiped ? 0 : 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSwiped
                        ? 'Created ${report.createdDate}\n${report.dateRange}'
                        : 'Created ${report.createdDate} · ${report.dateRange}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: _textSecondary,
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    report.reportType,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: _textSecondary.withValues(alpha: 0.8),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: _border, height: 1),
            const SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isSwiped) _buildShareStatusPill(report.isShared),
                Text(
                  '${report.fileSizeMb} · PDF',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: _textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareStatusPill(bool isShared) {
    final bg = isShared
        ? _forest.withValues(alpha: 0.22)
        : Colors.white.withValues(alpha: 0.06);
    final fg = isShared ? _mintBright : _textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isShared ? 'SHARED' : 'NOT SHARED',
        style: TextStyle(
          fontFamily: 'Inter',
          color: fg,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.description_outlined,
            color: _sage,
            size: 32,
          ),
          const SizedBox(height: 12),
          const Text(
            'No matching reports',
            style: TextStyle(
              fontFamily: 'Inter',
              color: _textPrimary,
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Adjust your search or filters, or tap + to generate a new client PDF report.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              color: _textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
