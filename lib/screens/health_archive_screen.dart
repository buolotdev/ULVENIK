import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'health_records_screen.dart';

class ArchivedRecord {
  final String id;
  final String category;
  final Color categoryColor;
  final IconData icon;
  final String title;
  final String dateArchived;
  final int attachmentsCount;
  final double sizeMb;
  final String clinicOrDoctor;
  final String notes;

  const ArchivedRecord({
    required this.id,
    required this.category,
    required this.categoryColor,
    required this.icon,
    required this.title,
    required this.dateArchived,
    required this.attachmentsCount,
    required this.sizeMb,
    required this.clinicOrDoctor,
    required this.notes,
  });
}

class ArchiveMonthPoint {
  final String month;
  final int count;
  final double sizeMb;

  const ArchiveMonthPoint({
    required this.month,
    required this.count,
    required this.sizeMb,
  });
}

class ArchiveDogProfile {
  final String name;
  final String breed;
  final String age;
  final String avatarUrl;
  final bool hasRecords;

  const ArchiveDogProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.avatarUrl,
    required this.hasRecords,
  });
}

class HealthArchiveScreen extends StatefulWidget {
  final bool initialEmpty;
  const HealthArchiveScreen({super.key, this.initialEmpty = false});

  @override
  State<HealthArchiveScreen> createState() => _HealthArchiveScreenState();
}

class _HealthArchiveScreenState extends State<HealthArchiveScreen>
    with SingleTickerProviderStateMixin {
  // Scandinavian Theme Palette
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _surfaceDeep = Color(0xFF15181A);
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _sage = Color(0xFF7A8F7A);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _muted = Color(0xFFA7B0AB);

  // Subtle border hairline that blends with the dark theme
  static final _hairlineBorder = Border.all(color: Colors.white.withValues(alpha: 0.07));

  late bool _isEmpty;
  late AnimationController _animController;
  late Animation<double> _chartAnim;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSort = 'Newest'; // 'Newest', 'Oldest', 'Size'
  String _chartMetric = 'Records'; // 'Records' or 'Storage'
  int _selectedChartIndex = -1;

  // Selected Dog Profile
  int _selectedDogIndex = 0;
  final List<ArchiveDogProfile> _dogProfiles = const [
    ArchiveDogProfile(
      name: 'Koda',
      breed: 'Belgian Malinois',
      age: '4y 2m',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA8KyYHGdNo9slfVCJ4d5ObsgPLVXpVm7HtrbLEbB3GCpICQHei-p36TLcE6XUBMSwa8H_rzfQMhuFhx9uPCst10cC02J5JER4HfoxwTfphzo8iUeyiMJ-q5GjO1ZMoKxD2xwzJ28a4jT2aProgpZds1xACb9TdGV9TewoJaXMQqTP1zsbxJcbJiIPPtR3oiVt1H0H_RrA-VAYgvW5h5QlwgLQvm7iYPmxewQZOjmo7b2k4nahBYlI',
      hasRecords: true,
    ),
    ArchiveDogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '3y 8m',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDA43LSpqLueVgbV65C1BaUj8KmxU2uKYKkeOe869GPR6xGf7rZKXYqunE1wBNA3oSCOAA6IO77wsbLpg7BoDxBt6fbKNFh7r3Rn3RouJQxRp8-Hq_3F4IODz3kTbyfHFv6A--BsaKYHIF3RBVJYYuof7iNi_Hdc1xgK3cictN40i8cC7BjM-6V0mkqZI8G1GrUnzmduUQqWjvoRs4b0QiEbgtMpLPEF96BWQuexFVl7uRcedhssAc',
      hasRecords: true,
    ),
    ArchiveDogProfile(
      name: 'Fenris',
      breed: 'Working Malinois',
      age: '3 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=500&q=80',
      hasRecords: false,
    ),
    ArchiveDogProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
      hasRecords: true,
    ),
  ];
  ArchiveDogProfile get _currentDog => _dogProfiles[_selectedDogIndex];

  // Active Category Filters
  final Set<String> _selectedCategories = {'Vet Visits', 'Injuries'};

  final List<String> _availableCategories = const [
    'Vet Visits',
    'Injuries',
    'Vaccinations',
    'Medications',
    'Surgeries',
    'Test Results',
  ];

  // Historical Monthly Data for the Graph
  final List<ArchiveMonthPoint> _monthlyPoints = const [
    ArchiveMonthPoint(month: 'Jan', count: 4, sizeMb: 1.8),
    ArchiveMonthPoint(month: 'Feb', count: 7, sizeMb: 3.2),
    ArchiveMonthPoint(month: 'Mar', count: 12, sizeMb: 5.1),
    ArchiveMonthPoint(month: 'Apr', count: 18, sizeMb: 7.4),
    ArchiveMonthPoint(month: 'May', count: 26, sizeMb: 9.8),
    ArchiveMonthPoint(month: 'Jun', count: 34, sizeMb: 12.7),
  ];

  // Archived Records List (Mutable for interactive Restore action)
  late List<ArchivedRecord> _records;
  ArchivedRecord? _lastRestoredRecord;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();

    _records = [
      const ArchivedRecord(
        id: 'rec-1',
        category: 'Vet Visit',
        categoryColor: _mint,
        icon: Icons.local_hospital,
        title: 'Annual Health Check — City Vets',
        dateArchived: '14 Jun 2026',
        attachmentsCount: 2,
        sizeMb: 1.4,
        clinicOrDoctor: 'Dr. Sarah Lindqvist, City Veterinary Clinic',
        notes: 'Comprehensive annual physical, baseline blood chemistry normal, dental check grade 1 tartar.',
      ),
      const ArchivedRecord(
        id: 'rec-2',
        category: 'Injury',
        categoryColor: Color(0xFFFFB4AC),
        icon: Icons.healing,
        title: 'Right Hind Paw — Laceration',
        dateArchived: '2 May 2026',
        attachmentsCount: 4,
        sizeMb: 3.8,
        clinicOrDoctor: 'Nordic Animal Emergency',
        notes: 'Superficial pad laceration on rocky terrain. Cleansed, sutured with 3 stitches, healed cleanly after 10 days.',
      ),
      const ArchivedRecord(
        id: 'rec-3',
        category: 'Vaccination',
        categoryColor: Color(0xFF5D8FAF),
        icon: Icons.vaccines,
        title: 'Rabies Booster — Dr. Amir Hassan',
        dateArchived: '30 Jan 2026',
        attachmentsCount: 0,
        sizeMb: 0.6,
        clinicOrDoctor: 'Dr. Amir Hassan',
        notes: '3-year rabies booster administered. Lot #RB-9982. Next due January 2029. No adverse reaction.',
      ),
      const ArchivedRecord(
        id: 'rec-4',
        category: 'Medication',
        categoryColor: Color(0xFFB1F0D6),
        icon: Icons.medication,
        title: 'Metacam — Post-Surgery Course',
        dateArchived: '11 Dec 2025',
        attachmentsCount: 1,
        sizeMb: 1.1,
        clinicOrDoctor: 'Tierklinik Oslo',
        notes: '0.1 mg/kg suspension daily for anti-inflammatory pain relief following minor tooth extraction.',
      ),
      const ArchivedRecord(
        id: 'rec-5',
        category: 'Surgery',
        categoryColor: Color(0xFFC5B4E3),
        icon: Icons.medical_services,
        title: 'Arthroscopic Elbow Cleanout — Tierklinik',
        dateArchived: '18 Oct 2025',
        attachmentsCount: 6,
        sizeMb: 4.2,
        clinicOrDoctor: 'Dr. Magnus Eklund, Tierklinik Oslo',
        notes: 'Minimally invasive arthroscopy for fragment removal. Full cartilage recovery achieved after 6 weeks rehab.',
      ),
      const ArchivedRecord(
        id: 'rec-6',
        category: 'Test Result',
        categoryColor: Color(0xFFE5A962),
        icon: Icons.science_outlined,
        title: 'Comprehensive Bloodwork & Chem Panel',
        dateArchived: '05 Sep 2025',
        attachmentsCount: 3,
        sizeMb: 1.6,
        clinicOrDoctor: 'BioVet Laboratory Services',
        notes: 'Full CBC, liver enzymes ALT/AST within normal athletic range, kidney values BUN/Creatinine optimal.',
      ),
    ];
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filter and sort records
  List<ArchivedRecord> get _filteredRecords {
    return _records.where((rec) {
      // Category filter: if categories are selected, record must match
      if (_selectedCategories.isNotEmpty) {
        final matchesCat = _selectedCategories.any((cat) {
          if (cat == 'Vet Visits') return rec.category == 'Vet Visit';
          if (cat == 'Injuries') return rec.category == 'Injury';
          if (cat == 'Vaccinations') return rec.category == 'Vaccination';
          if (cat == 'Medications') return rec.category == 'Medication';
          if (cat == 'Surgeries') return rec.category == 'Surgery';
          if (cat == 'Test Results') return rec.category == 'Test Result';
          return false;
        });
        if (!matchesCat) return false;
      }

      // Search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final inTitle = rec.title.toLowerCase().contains(q);
        final inCat = rec.category.toLowerCase().contains(q);
        final inDoc = rec.clinicOrDoctor.toLowerCase().contains(q);
        final inNotes = rec.notes.toLowerCase().contains(q);
        if (!inTitle && !inCat && !inDoc && !inNotes) return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        if (_selectedSort == 'Oldest') {
          return a.id.compareTo(b.id);
        } else if (_selectedSort == 'Size') {
          return b.sizeMb.compareTo(a.sizeMb);
        }
        return b.id.compareTo(a.id); // Default newest
      });
  }

  void _restoreRecord(ArchivedRecord record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _surfaceHigh,
                      borderRadius: BorderRadius.circular(8),
                      border: _hairlineBorder,
                    ),
                    child: const Icon(Icons.settings_backup_restore, color: _mint, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Restore to Active Records?',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _surfaceDeep,
                  borderRadius: BorderRadius.circular(10),
                  border: _hairlineBorder,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${record.category} • Archived on ${record.dateArchived} • ${record.sizeMb} MB',
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'This record will be moved back to active health timeline for Rex and made visible in reports.',
                style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: _muted, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [_forest, Color(0xFF235445)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: _mint.withValues(alpha: 0.2)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            Navigator.pop(ctx);
                            setState(() {
                              _lastRestoredRecord = record;
                              _records.removeWhere((r) => r.id == record.id);
                              if (_records.isEmpty) {
                                _isEmpty = true;
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: _carbon,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                                ),
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: _mint, size: 18),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Restored "${record.title}"',
                                        style: const TextStyle(color: _offWhite, fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  textColor: _mint,
                                  onPressed: () {
                                    if (_lastRestoredRecord != null) {
                                      setState(() {
                                        _records.insert(0, _lastRestoredRecord!);
                                        _isEmpty = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 13),
                            child: Center(
                              child: Text(
                                'Confirm Restore',
                                style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRecordDetails(ArchivedRecord record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: record.categoryColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: record.categoryColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      record.category.toUpperCase(),
                      style: TextStyle(
                        color: record.categoryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Archived ${record.dateArchived}',
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                record.title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                record.clinicOrDoctor,
                style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _surfaceDeep,
                  borderRadius: BorderRadius.circular(10),
                  border: _hairlineBorder,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ARCHIVED CLINICAL NOTES', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                    const SizedBox(height: 6),
                    Text(
                      record.notes,
                      style: const TextStyle(color: _offWhite, fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.attach_file, color: _muted, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        record.attachmentsCount > 0
                            ? '${record.attachmentsCount} Attachments'
                            : 'No attachments',
                        style: const TextStyle(color: _muted, fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    'Size: ${record.sizeMb} MB',
                    style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _restoreRecord(record);
                  },
                  icon: const Icon(Icons.settings_backup_restore, size: 18),
                  label: const Text('Restore to Active Health Records'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _offWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDogSelectorSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Canine Athlete',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(_dogProfiles.length, (idx) {
                final dog = _dogProfiles[idx];
                final isSelected = idx == _selectedDogIndex;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? _surfaceHigh : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected ? Border.all(color: _mint.withValues(alpha: 0.4)) : null,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(dog.avatarUrl),
                      radius: 20,
                    ),
                    title: Text(
                      dog.name,
                      style: TextStyle(
                        color: isSelected ? _mint : _offWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${dog.breed} • ${dog.age}',
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: _mint, size: 20)
                        : (dog.hasRecords
                            ? null
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('No Archive', style: TextStyle(color: _muted, fontSize: 10)),
                              )),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _selectedDogIndex = idx;
                        _isEmpty = !dog.hasRecords;
                        if (!_isEmpty && _records.isEmpty) {
                          // reload default records
                          _records = [
                            const ArchivedRecord(
                              id: 'rec-1',
                              category: 'Vet Visit',
                              categoryColor: _mint,
                              icon: Icons.local_hospital,
                              title: 'Annual Health Check — City Vets',
                              dateArchived: '14 Jun 2026',
                              attachmentsCount: 2,
                              sizeMb: 1.4,
                              clinicOrDoctor: 'Dr. Sarah Lindqvist',
                              notes: 'Baseline checkup normal.',
                            ),
                          ];
                        }
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSortFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Archive Filter & Sort',
                    style: TextStyle(color: _offWhite, fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  const Text('SORT ORDER', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Newest', 'Oldest', 'Size'].map((s) {
                      final sel = _selectedSort == s;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(s),
                          selected: sel,
                          selectedColor: _forest,
                          backgroundColor: _surfaceHigh,
                          labelStyle: TextStyle(
                            color: sel ? _offWhite : _muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) {
                            setSheetState(() => _selectedSort = s);
                            setState(() => _selectedSort = s);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  const Text('CATEGORIES', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableCategories.map((cat) {
                      final isSelected = _selectedCategories.contains(cat);
                      return FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: _forest.withValues(alpha: 0.4),
                        backgroundColor: _surfaceHigh,
                        checkmarkColor: _mint,
                        side: BorderSide(
                          color: isSelected ? _forest : Colors.white.withValues(alpha: 0.08),
                        ),
                        labelStyle: TextStyle(
                          color: isSelected ? _mint : _muted,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        onSelected: (val) {
                          setSheetState(() {
                            if (val) {
                              _selectedCategories.add(cat);
                            } else {
                              _selectedCategories.remove(cat);
                            }
                          });
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setSheetState(() {
                              _selectedCategories.clear();
                              _selectedSort = 'Newest';
                            });
                            setState(() {
                              _selectedCategories.clear();
                              _selectedSort = 'Newest';
                            });
                          },
                          child: const Text('Reset All', style: TextStyle(color: _muted)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _forest,
                            foregroundColor: _offWhite,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _sage),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Health Archive',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Search Records',
            icon: const Icon(Icons.search, color: _sage),
            onPressed: () {
              if (_isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No archived records available to search.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          IconButton(
            tooltip: 'Filter & Sort',
            icon: const Icon(Icons.tune, color: _sage),
            onPressed: _showSortFilterSheet,
          ),
          // State Switcher (Populated vs Empty)
          IconButton(
            tooltip: _isEmpty ? 'Switch to Populated Archive' : 'Switch to Empty Archive',
            icon: Icon(
              _isEmpty ? Icons.inventory_2_outlined : Icons.inventory_2,
              color: _mint,
            ),
            onPressed: () {
              setState(() {
                _isEmpty = !_isEmpty;
                if (!_isEmpty && _records.isEmpty) {
                  // Re-populate if emptied
                  _records = [
                    const ArchivedRecord(
                      id: 'rec-1',
                      category: 'Vet Visit',
                      categoryColor: _mint,
                      icon: Icons.local_hospital,
                      title: 'Annual Health Check — City Vets',
                      dateArchived: '14 Jun 2026',
                      attachmentsCount: 2,
                      sizeMb: 1.4,
                      clinicOrDoctor: 'Dr. Sarah Lindqvist, City Vets',
                      notes: 'Comprehensive annual physical, blood chemistry optimal.',
                    ),
                    const ArchivedRecord(
                      id: 'rec-2',
                      category: 'Injury',
                      categoryColor: Color(0xFFFFB4AC),
                      icon: Icons.healing,
                      title: 'Right Hind Paw — Laceration',
                      dateArchived: '2 May 2026',
                      attachmentsCount: 4,
                      sizeMb: 3.8,
                      clinicOrDoctor: 'Nordic Animal Emergency',
                      notes: 'Pad laceration sutured, full recovery.',
                    ),
                    const ArchivedRecord(
                      id: 'rec-3',
                      category: 'Vaccination',
                      categoryColor: Color(0xFF5D8FAF),
                      icon: Icons.vaccines,
                      title: 'Rabies Booster — Dr. Amir Hassan',
                      dateArchived: '30 Jan 2026',
                      attachmentsCount: 0,
                      sizeMb: 0.6,
                      clinicOrDoctor: 'Dr. Amir Hassan',
                      notes: '3-year rabies booster administered.',
                    ),
                    const ArchivedRecord(
                      id: 'rec-4',
                      category: 'Medication',
                      categoryColor: Color(0xFFB1F0D6),
                      icon: Icons.medication,
                      title: 'Metacam — Post-Surgery Course',
                      dateArchived: '11 Dec 2025',
                      attachmentsCount: 1,
                      sizeMb: 1.1,
                      clinicOrDoctor: 'Tierklinik Oslo',
                      notes: 'Oral anti-inflammatory suspension.',
                    ),
                  ];
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dog Selector Card
              _buildDogSelectorCard(),
              const SizedBox(height: 16),

              if (_isEmpty) ...[
                _buildEmptyStateView(),
              ] else ...[
                _buildPopulatedStateView(),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ==========================================
  // DOG SELECTOR CARD (Matches HTML / Screenshots)
  // ==========================================
  Widget _buildDogSelectorCard() {
    return InkWell(
      onTap: _showDogSelectorSheet,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(10),
          border: _hairlineBorder,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: _hairlineBorder,
                image: DecorationImage(
                  image: NetworkImage(_currentDog.avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentDog.name,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_currentDog.breed} • ${_currentDog.age}',
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: _sage, size: 22),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // POPULATED STATE VIEW
  // ==========================================
  Widget _buildPopulatedStateView() {
    final filtered = _filteredRecords;
    final totalSizeMb = _records.fold<double>(0.0, (acc, r) => acc + r.sizeMb);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Archive Summary Card (2x2 Grid)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(10),
            border: _hairlineBorder,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryMetric(
                      icon: Icons.inventory_2_outlined,
                      label: 'TOTAL ARCHIVED',
                      value: '${_records.length}',
                    ),
                  ),
                  Expanded(
                    child: _buildSummaryMetric(
                      icon: Icons.calendar_today_outlined,
                      label: 'THIS YEAR',
                      value: '8',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryMetric(
                      icon: Icons.category_outlined,
                      label: 'CATEGORIES',
                      value: '6',
                    ),
                  ),
                  Expanded(
                    child: _buildSummaryMetric(
                      icon: Icons.cloud_done_outlined,
                      label: 'STORAGE USED',
                      value: '${totalSizeMb.toStringAsFixed(1)} MB',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Animated & Interactive Archive Growth Chart
        _buildAnimatedArchiveGraph(),
        const SizedBox(height: 16),

        // Search Bar
        _buildSearchBar(),
        const SizedBox(height: 12),

        // Filter Chips Bar
        _buildFilterChipsBar(),
        const SizedBox(height: 18),

        // Archived Records Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'ARCHIVED RECORDS (${filtered.length})',
              style: const TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            InkWell(
              onTap: _showSortFilterSheet,
              child: Row(
                children: [
                  Text(
                    'Sort: $_selectedSort',
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_drop_down, color: _muted, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // List of Record Cards
        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(10),
              border: _hairlineBorder,
            ),
            child: Column(
              children: [
                const Icon(Icons.search_off, color: _muted, size: 36),
                const SizedBox(height: 12),
                const Text(
                  'No Records Match Filters',
                  style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Try clearing active filters or searching a different term.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategories.clear();
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _mint.withValues(alpha: 0.4)),
                    foregroundColor: _mint,
                  ),
                  child: const Text('Clear All Filters', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (ctx, idx) => _buildRecordCard(filtered[idx]),
          ),
      ],
    );
  }

  Widget _buildSummaryMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _sage, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // ANIMATED & INTERACTIVE GRAPH (fl_chart)
  // ==========================================
  Widget _buildAnimatedArchiveGraph() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(10),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ARCHIVE RETENTION & GROWTH',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _chartMetric == 'Records'
                          ? '${_records.length} Total Records Archived'
                          : '12.7 MB Retained Cloud Storage',
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Metric Toggle Pills
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _surfaceDeep,
                  borderRadius: BorderRadius.circular(6),
                  border: _hairlineBorder,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildGraphMetricPill('Records'),
                    _buildGraphMetricPill('Storage'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 130,
            child: AnimatedBuilder(
              animation: _chartAnim,
              builder: (context, child) {
                final progress = _chartAnim.value;
                final isRecords = _chartMetric == 'Records';
                final maxY = isRecords ? 40.0 : 15.0;

                return LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: maxY,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => _surfaceHigh,
                        tooltipBorder: const BorderSide(color: Colors.white12),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final idx = spot.spotIndex;
                            if (idx < 0 || idx >= _monthlyPoints.length) return null;
                            final pt = _monthlyPoints[idx];
                            return LineTooltipItem(
                              '${pt.month} 2026\n',
                              const TextStyle(color: _mint, fontWeight: FontWeight.bold, fontSize: 11),
                              children: [
                                TextSpan(
                                  text: isRecords
                                      ? '${pt.count} records archived'
                                      : '${pt.sizeMb} MB stored',
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                      touchCallback: (event, response) {
                        if (response?.lineBarSpots != null &&
                            response!.lineBarSpots!.isNotEmpty &&
                            event is FlTapUpEvent) {
                          setState(() {
                            _selectedChartIndex = response.lineBarSpots!.first.spotIndex;
                          });
                        }
                      },
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: isRecords ? 10 : 3.0,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.white.withValues(alpha: 0.04),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: isRecords ? 10 : 5.0,
                          getTitlesWidget: (val, meta) => Text(
                            isRecords ? '${val.toInt()}' : '${val.toInt()}M',
                            style: const TextStyle(color: _muted, fontSize: 10),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            if (idx < 0 || idx >= _monthlyPoints.length) return const SizedBox();
                            final isSel = idx == _selectedChartIndex;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _monthlyPoints[idx].month,
                                style: TextStyle(
                                  color: isSel ? _mint : _muted,
                                  fontSize: 11,
                                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _monthlyPoints.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final pt = entry.value;
                          final rawY = isRecords ? pt.count.toDouble() : pt.sizeMb;
                          return FlSpot(idx.toDouble(), rawY * progress);
                        }).toList(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: _mint,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            final isSel = index == _selectedChartIndex;
                            return FlDotCirclePainter(
                              radius: isSel ? 5.5 : 3.5,
                              color: isSel ? _offWhite : _mint,
                              strokeWidth: isSel ? 2.5 : 1.5,
                              strokeColor: _forest,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              _mint.withValues(alpha: 0.28),
                              _forest.withValues(alpha: 0.02),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphMetricPill(String metric) {
    final isSelected = _chartMetric == metric;
    return InkWell(
      onTap: () => setState(() => _chartMetric = metric),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? _forest : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          metric,
          style: TextStyle(
            color: isSelected ? _offWhite : _muted,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SEARCH BAR
  // ==========================================
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(8),
        border: _hairlineBorder,
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: _offWhite, fontSize: 13),
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: 'Search archived records...',
          hintStyle: const TextStyle(color: _muted, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: _muted, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: _muted, size: 16),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  // ==========================================
  // FILTER CHIPS BAR (Matches HTML & Figma)
  // ==========================================
  Widget _buildFilterChipsBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ..._selectedCategories.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _forest),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cat,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => setState(() => _selectedCategories.remove(cat)),
                      child: const Icon(Icons.close, color: _sage, size: 14),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Add filter button
          InkWell(
            onTap: _showSortFilterSheet,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _surfaceDeep,
                borderRadius: BorderRadius.circular(20),
                border: _hairlineBorder,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: _muted, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Add Filter',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // RECORD CARD (Matches HTML / Screenshots)
  // ==========================================
  Widget _buildRecordCard(ArchivedRecord record) {
    return InkWell(
      onTap: () => _showRecordDetails(record),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(10),
          border: _hairlineBorder,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(8),
                      border: _hairlineBorder,
                    ),
                    child: Icon(record.icon, color: _sage, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              record.category.toUpperCase(),
                              style: TextStyle(
                                color: record.categoryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              'Archived ${record.dateArchived}',
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.title,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              record.attachmentsCount > 0 ? Icons.attachment : Icons.attachment,
                              size: 13,
                              color: record.attachmentsCount > 0
                                  ? _muted
                                  : _muted.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              record.attachmentsCount > 0
                                  ? '${record.attachmentsCount} attachments'
                                  : 'No attachments',
                              style: TextStyle(
                                color: record.attachmentsCount > 0
                                    ? _muted
                                    : _muted.withValues(alpha: 0.5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Restore Action Strip
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => _restoreRecord(record),
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.settings_backup_restore, color: _offWhite, size: 15),
                          SizedBox(width: 6),
                          Text(
                            'Restore',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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

  // ==========================================
  // EMPTY STATE VIEW (Matches Screenshot 2)
  // ==========================================
  Widget _buildEmptyStateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Metrics Card (All dashed lines)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(10),
            border: _hairlineBorder,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildEmptyCategoryBox('VET VISITS')),
                  const SizedBox(width: 14),
                  Expanded(child: _buildEmptyCategoryBox('VACCINATIONS')),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildEmptyCategoryBox('MEDICATIONS')),
                  const SizedBox(width: 14),
                  Expanded(child: _buildEmptyCategoryBox('TEST RESULTS')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Search Bar (Disabled / Visual match)
        Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(8),
            border: _hairlineBorder,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: const Row(
            children: [
              Icon(Icons.search, color: _muted, size: 20),
              SizedBox(width: 10),
              Text(
                'Search archived records...',
                style: TextStyle(color: _muted, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 56),

        // Center Empty State Archive Box Illustration
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _surfaceDeep,
              border: _hairlineBorder,
            ),
            child: const Icon(Icons.inventory_2_outlined, color: _mint, size: 36),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'No Archived Records',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _offWhite,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: const Text(
            'Archived health records will appear here for long-term storage.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _muted,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Back to Health Records CTA
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [_forest, Color(0xFF235445)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: _mint.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: _forest.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HealthRecordsScreen()),
                  );
                }
              },
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Back to Health Records',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: _offWhite, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCategoryBox(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 24,
          height: 3,
          decoration: BoxDecoration(
            color: _muted.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildBottomNav() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: _carbon,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Home', false),
          _buildNavItem(Icons.pets, 'Dogs', true),
          _buildNavItem(Icons.fitness_center, 'Training', false),
          _buildNavItem(Icons.event_note_outlined, 'Timeline', false),
          _buildNavItem(Icons.more_horiz, 'More', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          Navigator.of(context).maybePop();
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? _mint : _muted,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _mint : _muted,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
