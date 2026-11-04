import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum DocumentCategoryFilter {
  all('All'),
  certificate('Certificates'),
  scoreSheet('Score Sheets'),
  judgeSheet('Judge Sheets'),
  entryDoc('Entry Documents'),
  health('Health Clearance'),
  award('Awards');

  final String label;
  const DocumentCategoryFilter(this.label);
}

enum DocumentSortOption {
  mostRecent('Most Recent'),
  oldestFirst('Oldest First'),
  titleAz('Title (A-Z)'),
  fileSizeLargest('File Size (Largest)');

  final String label;
  const DocumentSortOption(this.label);
}

class CertificateItem {
  final String id;
  final String title;
  final String eventOrOrg;
  final String badgeText;
  final DocumentCategoryFilter category;
  final String dateLabel;
  final DateTime date;
  final String fileSize;
  final double sizeInMb;
  final String dogName;
  final String? issuingBody;
  final String? scoreSummary;
  final bool isVerified;
  final bool hasThumbnail;

  const CertificateItem({
    required this.id,
    required this.title,
    required this.eventOrOrg,
    required this.badgeText,
    required this.category,
    required this.dateLabel,
    required this.date,
    required this.fileSize,
    required this.sizeInMb,
    required this.dogName,
    this.issuingBody,
    this.scoreSummary,
    this.isVerified = true,
    this.hasThumbnail = false,
  });

  CertificateItem copyWith({
    String? title,
    String? eventOrOrg,
    String? badgeText,
    DocumentCategoryFilter? category,
    String? dateLabel,
    DateTime? date,
    String? fileSize,
    double? sizeInMb,
    String? dogName,
    String? issuingBody,
    String? scoreSummary,
    bool? isVerified,
    bool? hasThumbnail,
  }) {
    return CertificateItem(
      id: id,
      title: title ?? this.title,
      eventOrOrg: eventOrOrg ?? this.eventOrOrg,
      badgeText: badgeText ?? this.badgeText,
      category: category ?? this.category,
      dateLabel: dateLabel ?? this.dateLabel,
      date: date ?? this.date,
      fileSize: fileSize ?? this.fileSize,
      sizeInMb: sizeInMb ?? this.sizeInMb,
      dogName: dogName ?? this.dogName,
      issuingBody: issuingBody ?? this.issuingBody,
      scoreSummary: scoreSummary ?? this.scoreSummary,
      isVerified: isVerified ?? this.isVerified,
      hasThumbnail: hasThumbnail ?? this.hasThumbnail,
    );
  }
}

class CertificatesDocumentsScreen extends StatefulWidget {
  const CertificatesDocumentsScreen({super.key});

  @override
  State<CertificatesDocumentsScreen> createState() =>
      _CertificatesDocumentsScreenState();
}

class _CertificatesDocumentsScreenState
    extends State<CertificatesDocumentsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  DocumentCategoryFilter _selectedCategory = DocumentCategoryFilter.all;
  DocumentSortOption _selectedSort = DocumentSortOption.mostRecent;

  late List<CertificateItem> _documents;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();

    _documents = [
      CertificateItem(
        id: 'doc-1',
        title: 'IGP3 Title Certificate',
        eventOrOrg: 'National IGP Championship 2024',
        badgeText: 'CERTIFICATE',
        category: DocumentCategoryFilter.certificate,
        dateLabel: '14 Sep 2024',
        date: DateTime(2024, 9, 14),
        fileSize: '2.4 MB',
        sizeInMb: 2.4,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'SV / FCI Registered Authority',
        scoreSummary: '286/300 (V) Excellent',
        isVerified: true,
      ),
      CertificateItem(
        id: 'doc-2',
        title: 'Tracking Score Sheet — Round 1',
        eventOrOrg: 'National IGP Championship 2024',
        badgeText: 'SCORE SHEET',
        category: DocumentCategoryFilter.scoreSheet,
        dateLabel: '14 Sep 2024',
        date: DateTime(2024, 9, 14),
        fileSize: '890 KB',
        sizeInMb: 0.89,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'Head Judge: Markus Bauer (FCI)',
        scoreSummary: 'Phase A: 98/100 (V)',
        isVerified: true,
      ),
      CertificateItem(
        id: 'doc-3',
        title: 'Judge Sheet — Protection Phase',
        eventOrOrg: 'Regional Qualifier 2023',
        badgeText: 'JUDGE SHEET',
        category: DocumentCategoryFilter.judgeSheet,
        dateLabel: '22 Jun 2023',
        date: DateTime(2023, 6, 22),
        fileSize: '1.1 MB',
        sizeInMb: 1.1,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'Helper: Tobias Lindner, Judge: Elena Richter',
        scoreSummary: 'Phase C: 96/100 (V) Pronounced (TSB a)',
        isVerified: true,
        hasThumbnail: true,
      ),
      CertificateItem(
        id: 'doc-4',
        title: 'Entry Confirmation',
        eventOrOrg: 'Club Trial 2022',
        badgeText: 'ENTRY DOCUMENT',
        category: DocumentCategoryFilter.entryDoc,
        dateLabel: '05 Mar 2022',
        date: DateTime(2022, 3, 5),
        fileSize: '340 KB',
        sizeInMb: 0.34,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'SV Ortsgruppe Oberland #412',
        isVerified: true,
      ),
      CertificateItem(
        id: 'doc-5',
        title: 'IGP2 Qualification Certificate',
        eventOrOrg: 'Regional Qualifier 2023',
        badgeText: 'CERTIFICATE',
        category: DocumentCategoryFilter.certificate,
        dateLabel: '22 Jun 2023',
        date: DateTime(2023, 6, 22),
        fileSize: '1.8 MB',
        sizeInMb: 1.8,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'DVG Landesgruppe Bayern',
        scoreSummary: '280/300 (SG) Very Good',
        isVerified: true,
      ),
      CertificateItem(
        id: 'doc-6',
        title: 'IGP1 Title Certificate',
        eventOrOrg: 'Spring Club Trial 2022',
        badgeText: 'CERTIFICATE',
        category: DocumentCategoryFilter.certificate,
        dateLabel: '18 Apr 2022',
        date: DateTime(2022, 4, 18),
        fileSize: '2.1 MB',
        sizeInMb: 2.1,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'SV National Working Registry',
        scoreSummary: '276/300 (SG) Very Good',
        isVerified: true,
      ),
      CertificateItem(
        id: 'doc-7',
        title: 'Judge Sheet — Obedience Phase',
        eventOrOrg: 'Regional Qualifier 2023',
        badgeText: 'JUDGE SHEET',
        category: DocumentCategoryFilter.judgeSheet,
        dateLabel: '21 Jun 2023',
        date: DateTime(2023, 6, 21),
        fileSize: '750 KB',
        sizeInMb: 0.75,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'Judge: Dr. Hans Becker',
        scoreSummary: 'Phase B: 94/100 (SG)',
        isVerified: true,
      ),
      CertificateItem(
        id: 'doc-8',
        title: 'HD/ED Hip & Elbow Clearance',
        eventOrOrg: 'Official Veterinary Registry',
        badgeText: 'HEALTH CLEARANCE',
        category: DocumentCategoryFilter.health,
        dateLabel: '10 Jan 2021',
        date: DateTime(2021, 1, 10),
        fileSize: '3.2 MB',
        sizeInMb: 3.2,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'SV Breed Hygiene Commission (HD a-normal, ED normal)',
        isVerified: true,
      ),
      CertificateItem(
        id: 'doc-9',
        title: 'Official Working Dog Scorebook',
        eventOrOrg: 'DVG National Federation',
        badgeText: 'SCOREBOOK',
        category: DocumentCategoryFilter.scoreSheet,
        dateLabel: '01 Feb 2021',
        date: DateTime(2021, 2, 1),
        fileSize: '5.4 MB',
        sizeInMb: 5.4,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'Passbook #DVG-2021-99410',
        isVerified: true,
      ),
      CertificateItem(
        id: 'doc-10',
        title: 'BH/VT Companion Dog Certificate',
        eventOrOrg: 'Autumn Club Trial 2021',
        badgeText: 'CERTIFICATE',
        category: DocumentCategoryFilter.certificate,
        dateLabel: '12 Oct 2021',
        date: DateTime(2021, 10, 12),
        fileSize: '1.5 MB',
        sizeInMb: 1.5,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'FCI Working Section (Passed Traffic & Obedience)',
        scoreSummary: 'Passed with Distinction',
        isVerified: true,
      ),
      CertificateItem(
        id: 'doc-11',
        title: 'DNA Profile & Parentage Verification',
        eventOrOrg: 'Genetic Laboratory Screening',
        badgeText: 'HEALTH CLEARANCE',
        category: DocumentCategoryFilter.health,
        dateLabel: '15 Jan 2021',
        date: DateTime(2021, 1, 15),
        fileSize: '1.2 MB',
        sizeInMb: 1.2,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'Laboklin Cert #DNA-DE-882194',
        isVerified: true,
      ),
      CertificateItem(
        id: 'doc-12',
        title: 'Regional Vice-Champion Award',
        eventOrOrg: 'Regional Championship 2023',
        badgeText: 'AWARD',
        category: DocumentCategoryFilter.award,
        dateLabel: '23 Jun 2023',
        date: DateTime(2023, 6, 23),
        fileSize: '2.9 MB',
        sizeInMb: 2.9,
        dogName: 'Ares vom Wolfsblick',
        issuingBody: 'IGP Regional Federation Cup',
        scoreSummary: '2nd Place Overall Trophy',
        isVerified: true,
      ),
    ];
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<CertificateItem> get _filteredAndSortedDocuments {
    List<CertificateItem> list = _documents.where((doc) {
      if (_selectedCategory != DocumentCategoryFilter.all &&
          doc.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = doc.title.toLowerCase().contains(q);
        final matchesEvent = doc.eventOrOrg.toLowerCase().contains(q);
        final matchesDog = doc.dogName.toLowerCase().contains(q);
        final matchesBadge = doc.badgeText.toLowerCase().contains(q);
        if (!matchesTitle && !matchesEvent && !matchesDog && !matchesBadge) {
          return false;
        }
      }
      return true;
    }).toList();

    switch (_selectedSort) {
      case DocumentSortOption.mostRecent:
        list.sort((a, b) => b.date.compareTo(a.date));
        break;
      case DocumentSortOption.oldestFirst:
        list.sort((a, b) => a.date.compareTo(b.date));
        break;
      case DocumentSortOption.titleAz:
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case DocumentSortOption.fileSizeLargest:
        list.sort((a, b) => b.sizeInMb.compareTo(a.sizeInMb));
        break;
    }

    return list;
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sort Documents',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.secondaryTextStoneGrey),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...DocumentSortOption.values.map((sort) {
                  final isSelected = _selectedSort == sort;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedSort = sort;
                      });
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryForestGreen.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryForestGreen
                              : AppColors.cardBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sort.label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primaryTextOffWhite
                                  : AppColors.secondaryTextStoneGrey,
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontFamily: 'Inter',
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryForestGreen,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterModal() {
    DocumentCategoryFilter tempCat = _selectedCategory;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter by Category',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempCat = DocumentCategoryFilter.all;
                            });
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: AppColors.primaryForestGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: DocumentCategoryFilter.values.map((cat) {
                        final isSelected = tempCat == cat;
                        return ChoiceChip(
                          label: Text(cat.label),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) {
                              setModalState(() {
                                tempCat = cat;
                              });
                            }
                          },
                          backgroundColor: AppColors.backgroundObsidian,
                          selectedColor: AppColors.primaryForestGreen,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.primaryTextOffWhite
                                : AppColors.secondaryTextStoneGrey,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primaryForestGreen
                                  : AppColors.cardBorder,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryForestGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedCategory = tempCat;
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text(
                          'Apply Filter',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            fontFamily: 'Inter',
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

  void _showDocumentDetails(CertificateItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: AppColors.primaryForestGreen,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.eventOrOrg,
                              style: const TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryForestGreen
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.primaryForestGreen
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          item.badgeText,
                          style: const TextStyle(
                            color: AppColors.primaryForestGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (item.isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.infoAlpineBlue
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.infoAlpineBlue
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: AppColors.infoAlpineBlue,
                                size: 13,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'VERIFIED REGISTRY',
                                style: TextStyle(
                                  color: AppColors.infoAlpineBlue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  const SizedBox(height: 18),
                  _buildDetailRow('Dog Assigned', item.dogName),
                  _buildDetailRow('Date of Issuance', item.dateLabel),
                  _buildDetailRow('File Size', item.fileSize),
                  if (item.issuingBody != null)
                    _buildDetailRow('Issuing Authority', item.issuingBody!),
                  if (item.scoreSummary != null)
                    _buildDetailRow('Recorded Score', item.scoreSummary!),
                  _buildDetailRow('Digital Signature', 'SHA-256 Verified ✓'),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: AppColors.primaryForestGreen),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.cardsCarbon,
                                content: Text(
                                  'Downloading "${item.title}" (${item.fileSize})...',
                                  style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite,
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.download_rounded,
                            color: AppColors.primaryForestGreen,
                            size: 18,
                          ),
                          label: const Text(
                            'Download',
                            style: TextStyle(
                              color: AppColors.primaryForestGreen,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryForestGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.cardsCarbon,
                                content: Text(
                                  'Opening preview for "${item.title}"...',
                                  style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite,
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.fullscreen_rounded, size: 20),
                          label: const Text(
                            'View Full',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.errorDestructive,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _confirmDeleteDocument(item);
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text(
                        'Delete Document',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteDocument(CertificateItem item) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardsCarbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Document?',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          content: Text(
            'Are you sure you want to remove "${item.title}"? This action cannot be undone.',
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorDestructive,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _documents.removeWhere((d) => d.id == item.id);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.cardsCarbon,
                    content: Text(
                      'Deleted "${item.title}"',
                      style: const TextStyle(color: AppColors.primaryTextOffWhite),
                    ),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDocumentSheet() {
    final titleController = TextEditingController();
    final eventController = TextEditingController();
    final authorityController = TextEditingController();
    DocumentCategoryFilter selectedType = DocumentCategoryFilter.certificate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upload Document',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: AppColors.secondaryTextStoneGrey),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Document Type',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 13,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        DocumentCategoryFilter.certificate,
                        DocumentCategoryFilter.scoreSheet,
                        DocumentCategoryFilter.judgeSheet,
                        DocumentCategoryFilter.entryDoc,
                        DocumentCategoryFilter.health,
                        DocumentCategoryFilter.award,
                      ].map((cat) {
                        final isSel = selectedType == cat;
                        return ChoiceChip(
                          label: Text(cat.label),
                          selected: isSel,
                          onSelected: (val) {
                            if (val) {
                              setSheetState(() {
                                selectedType = cat;
                              });
                            }
                          },
                          backgroundColor: AppColors.backgroundObsidian,
                          selectedColor: AppColors.primaryForestGreen,
                          labelStyle: TextStyle(
                            color: isSel
                                ? AppColors.primaryTextOffWhite
                                : AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                            fontWeight:
                                isSel ? FontWeight.w600 : FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSel
                                  ? AppColors.primaryForestGreen
                                  : AppColors.cardBorder,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontFamily: 'Inter',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Document Title',
                        labelStyle: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundObsidian,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primaryForestGreen),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: eventController,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontFamily: 'Inter',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Event / Competition / Trial',
                        labelStyle: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundObsidian,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primaryForestGreen),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: authorityController,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontFamily: 'Inter',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Issuing Body (e.g. SV, FCI, DVG)',
                        labelStyle: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundObsidian,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primaryForestGreen),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryForestGreen.withValues(alpha: 0.4),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.upload_file_rounded,
                            color: AppColors.primaryForestGreen,
                            size: 28,
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'certificate_igp3_scan.pdf',
                                  style: TextStyle(
                                    color: AppColors.primaryTextOffWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Ready to attach · 2.1 MB',
                                  style: TextStyle(
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primaryForestGreen,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryForestGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final title = titleController.text.trim();
                          if (title.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a document title'),
                              ),
                            );
                            return;
                          }

                          final newItem = CertificateItem(
                            id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
                            title: title,
                            eventOrOrg: eventController.text.trim().isEmpty
                                ? 'Club Working Trial'
                                : eventController.text.trim(),
                            badgeText: selectedType.name.toUpperCase(),
                            category: selectedType,
                            dateLabel: 'Today, 01 Nov 2026',
                            date: DateTime.now(),
                            fileSize: '2.1 MB',
                            sizeInMb: 2.1,
                            dogName: 'Ares vom Wolfsblick',
                            issuingBody: authorityController.text.trim().isEmpty
                                ? 'Official SV Working Committee'
                                : authorityController.text.trim(),
                            isVerified: true,
                          );

                          setState(() {
                            _documents.insert(0, newItem);
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.cardsCarbon,
                              content: Text(
                                'Added "${newItem.title}" to documents.',
                                style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Upload & Save',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
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

  @override
  Widget build(BuildContext context) {
    final docs = _filteredAndSortedDocuments;

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryTextOffWhite,
            size: 20,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Certificates & Documents',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearchVisible ? Icons.search_off_rounded : Icons.search_rounded,
              color: _isSearchVisible
                  ? AppColors.primaryForestGreen
                  : AppColors.primaryTextOffWhite,
            ),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: AppColors.primaryTextOffWhite,
            ),
            onPressed: _showFilterModal,
          ),
          IconButton(
            icon: const Icon(
              Icons.add_rounded,
              color: AppColors.primaryTextOffWhite,
              size: 26,
            ),
            onPressed: _showAddDocumentSheet,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontFamily: 'Inter',
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search documents, trials, or dogs...',
                    hintStyle: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.secondaryTextStoneGrey,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.cardsCarbon,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryForestGreen,
                      ),
                    ),
                  ),
                ),
              ),

            // Horizontal Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: DocumentCategoryFilter.values.map((cat) {
                  final isSel = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat.label),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                      backgroundColor: AppColors.cardsCarbon,
                      selectedColor: AppColors.primaryForestGreen,
                      labelStyle: TextStyle(
                        color: isSel
                            ? AppColors.primaryTextOffWhite
                            : AppColors.secondaryTextStoneGrey,
                        fontSize: 13,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSel
                              ? AppColors.primaryForestGreen
                              : AppColors.cardBorder,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Subheader: Document count & Sort Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${docs.length} Documents',
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                  InkWell(
                    onTap: _showSortModal,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedSort.label,
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.secondaryTextStoneGrey,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Documents List / Empty State
            Expanded(
              child: docs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.folder_open_rounded,
                            size: 64,
                            color: AppColors.secondaryTextStoneGrey
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No documents found',
                            style: TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No results matching "$_searchQuery"'
                                : 'No documents in this category yet',
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 13,
                              fontFamily: 'Inter',
                            ),
                          ),
                          if (_searchQuery.isNotEmpty ||
                              _selectedCategory != DocumentCategoryFilter.all) ...[
                            const SizedBox(height: 16),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.primaryForestGreen),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _searchController.clear();
                                  _selectedCategory = DocumentCategoryFilter.all;
                                });
                              },
                              child: const Text(
                                'Clear Filters',
                                style: TextStyle(
                                  color: AppColors.primaryForestGreen,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 4, bottom: 90),
                      itemCount: docs.length,
                      separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                      itemBuilder: (ctx, index) {
                        final item = docs[index];
                        return _buildDocumentCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryForestGreen,
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: _showAddDocumentSheet,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.dogs,
      ),
    );
  }

  Widget _buildDocumentCard(CertificateItem item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDocumentDetails(item),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon / Thumbnail Container
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF232A2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: item.hasThumbnail
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                color: const Color(0xFF1E2824),
                                child: const Icon(
                                  Icons.shield_outlined,
                                  color: AppColors.primaryForestGreen,
                                  size: 26,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.description_outlined,
                            color: AppColors.secondaryTextStoneGrey,
                            size: 24,
                          ),
                        ),
                ),
                const SizedBox(width: 14),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.eventOrOrg,
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF232A2E),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                            child: Text(
                              item.badgeText,
                              style: const TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '·',
                            style: TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.dateLabel,
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.fileSize,
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey
                              .withValues(alpha: 0.8),
                          fontSize: 11,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.secondaryTextStoneGrey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

