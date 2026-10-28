import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import 'health_settings_screen.dart';

class DogImportProfile {
  final String name;
  final String breed;
  final String age;
  final String avatarUrl;
  final bool hasBackup;

  const DogImportProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.avatarUrl,
    this.hasBackup = true,
  });
}

class BackupDataPoint {
  final String monthLabel;
  final double sizeMb;
  final int recordCount;
  final String dateText;

  const BackupDataPoint({
    required this.monthLabel,
    required this.sizeMb,
    required this.recordCount,
    required this.dateText,
  });
}

class ImportExportScreen extends StatefulWidget {
  final bool initialEmpty;
  const ImportExportScreen({super.key, this.initialEmpty = false});

  @override
  State<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends State<ImportExportScreen>
    with SingleTickerProviderStateMixin {
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _carbon = Color(0xFF1A1F22);
  static const _obsidian = Color(0xFF101214);
  static const _surfaceHigh = Color(0xFF272B29);

  late bool _isEmpty;
  late AnimationController _anim;

  // Selected Dog Profile
  int _dogIndex = 0;
  final List<DogImportProfile> _dogs = const [
    DogImportProfile(
      name: 'Koda',
      breed: 'Belgian Malinois',
      age: '3yr',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBGBP9T7_zkQu4k6vjCWLlcLpsDOKbkLf_6cXfmfc0oC7Q9Bxd9eZBYBkTM1aIpMNDTEa_-OHUFIlAe38MA9L62SSqcM6leUbS_R6FjRoUR2e7wBuUhHww7BxVAOD1f2lC9pNncGhmXnYJJIJdokEq4cnXV8WhqC7FpGdo013na4wJia4v5hkhNgExBw4WhuVE9fQZ9eTtiEkxFCRPWM2IHulYOTivHUFMIqNBA8clF2kUgsm8rSeM',
      hasBackup: true,
    ),
    DogImportProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDA43LSpqLueVgbV65C1BaUj8KmxU2uKYKkeOe869GPR6xGf7rZKXYqunE1wBNA3oSCOAA6IO77wsbLpg7BoDxBt6fbKNFh7r3Rn3RouJQxRp8-Hq_3F4IODz3kTbyfHFv6A--BsaKYHIF3RBVJYYuof7iNi_Hdc1xgK3cictN40i8cC7BjM-6V0mkqZI8G1GrUnzmduUQqWjvoRs4b0QiEbgtMpLPEF96BWQuexFVl7uRcedhssAc',
      hasBackup: true,
    ),
    DogImportProfile(
      name: 'Fenris',
      breed: 'Working Malinois',
      age: '3 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=500&q=80',
      hasBackup: false,
    ),
    DogImportProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
      hasBackup: true,
    ),
  ];
  DogImportProfile get _dog => _dogs[_dogIndex];

  // Dynamic Backup Status
  String _lastBackupDate = '22 Aug 2026 · 14:32';
  double _backupSizeMb = 2.4;
  int _backupCount = 2;
  int _selectedGraphIndex = -1;

  // Export options checkboxes
  bool _exportVaccinations = true;
  bool _exportWeight = true;
  bool _exportVetVisits = true;
  bool _exportMedications = true;

  // Format: 'PDF' or 'CSV'
  String _selectedFormat = 'PDF';

  // Historical backup points for animated chart
  final List<BackupDataPoint> _backupHistory = const [
    BackupDataPoint(monthLabel: 'Apr', sizeMb: 1.1, recordCount: 54, dateText: '12 Apr 2026'),
    BackupDataPoint(monthLabel: 'May', sizeMb: 1.4, recordCount: 72, dateText: '18 May 2026'),
    BackupDataPoint(monthLabel: 'Jun', sizeMb: 1.7, recordCount: 91, dateText: '24 Jun 2026'),
    BackupDataPoint(monthLabel: 'Jul', sizeMb: 2.0, recordCount: 108, dateText: '20 Jul 2026'),
    BackupDataPoint(monthLabel: 'Aug', sizeMb: 2.4, recordCount: 124, dateText: '22 Aug 2026'),
  ];

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
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
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              ..._dogs.asMap().entries.map((entry) {
                final idx = entry.key;
                final dog = entry.value;
                final isSelected = _dogIndex == idx;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _dogIndex = idx;
                      _isEmpty = !dog.hasBackup;
                      _anim.forward(from: 0);
                    });
                    Navigator.pop(ctx);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? _forest.withValues(alpha: 0.25) : _obsidian,
                      border: Border.all(
                        color: isSelected ? _mint : Colors.white.withValues(alpha: 0.08),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: _surfaceHigh,
                          backgroundImage: NetworkImage(dog.avatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    dog.name,
                                    style: TextStyle(
                                      color: isSelected ? _mint : AppColors.primaryTextOffWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (!dog.hasBackup) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'NO BACKUP',
                                        style: TextStyle(color: Colors.white70, fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                '${dog.breed}, ${dog.age}',
                                style: const TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected) const Icon(Icons.check_circle, color: _mint, size: 20),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Interactive Import Flow
  void _triggerImport() {
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
              const Row(
                children: [
                  Icon(Icons.upload_file, color: _mint, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Import Health Records',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Supported file formats: .PDF (Vet clinic summaries), .CSV (Telemetry/Weights), and .ULV encrypted backup archives.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildImportOption(
                icon: Icons.picture_as_pdf_outlined,
                title: 'Import Clinic PDF Report',
                desc: 'Auto-extract vaccinations, surgeries & diagnoses',
                onTap: () => _simulateImportProcess(ctx, 'Veterinary_Clinic_Report.pdf', 14),
              ),
              const SizedBox(height: 10),
              _buildImportOption(
                icon: Icons.table_chart_outlined,
                title: 'Import CSV Data Sheet',
                desc: 'Bulk upload weights, doses and activities',
                onTap: () => _simulateImportProcess(ctx, 'Weight_Tracker_Export.csv', 48),
              ),
              const SizedBox(height: 10),
              _buildImportOption(
                icon: Icons.archive_outlined,
                title: 'Restore Ulvenik Archive (.ulv)',
                desc: 'Complete encrypted restoration with all attachments',
                onTap: () => _simulateImportProcess(ctx, 'Ulvenik_Backup_2026.ulv', 124),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImportOption({
    required IconData icon,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _obsidian,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _mint, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 18),
          ],
        ),
      ),
    );
  }

  void _simulateImportProcess(BuildContext ctx, String filename, int recordsAdded) {
    Navigator.pop(ctx);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (diagCtx) {
        return AlertDialog(
          backgroundColor: _carbon,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const CircularProgressIndicator(color: _mint),
              const SizedBox(height: 20),
              Text(
                'Parsing $filename...',
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text(
                'Validating cryptographic integrity & dog profile compatibility...',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        if (_isEmpty) _isEmpty = false;
        _backupSizeMb += 0.2;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _forest,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: _mint, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Successfully imported $recordsAdded records into ${_dog.name}\'s profile!'),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Interactive Export Flow
  void _triggerExport() {
    final count = (_exportVaccinations ? 12 : 0) +
        (_exportWeight ? 48 : 0) +
        (_exportVetVisits ? 18 : 0) +
        (_exportMedications ? 14 : 0);

    final estimatedKb = _selectedFormat == 'PDF' ? (count * 18 + 450) : (count * 2 + 12);

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Export ${_dog.name}\'s Records',
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _forest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _selectedFormat,
                      style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _obsidian,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Selected Records:', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                        Text('$count entries', style: const TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Estimated File Size:', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                        Text(
                          _selectedFormat == 'PDF' ? '${(estimatedKb / 1024).toStringAsFixed(2)} MB' : '$estimatedKb KB',
                          style: const TextStyle(color: _mint, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Target Standard:', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                        Text('Scandinavian Canine Health Std', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download, size: 18),
                  label: Text('Download $_selectedFormat File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: _forest,
                        behavior: SnackBarBehavior.floating,
                        content: Text('Generated ${_dog.name}_Health_Export.$_selectedFormat successfully!'),
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
  }

  // Interactive Backup Flow
  void _triggerBackupNow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (diagCtx) {
        return AlertDialog(
          backgroundColor: _carbon,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const CircularProgressIndicator(color: _mint),
              const SizedBox(height: 20),
              const Text(
                'Creating Encrypted Backup...',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                'Compacting records & medical telemetry for ${_dog.name}...',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        _lastBackupDate = 'Just now · ${_currentTime()}';
        _backupSizeMb = 2.5;
        _backupCount += 1;
        _isEmpty = false;
        _anim.forward(from: 0);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: _forest,
          behavior: SnackBarBehavior.floating,
          content: Text('Backup archive created and safely encrypted!'),
        ),
      );
    });
  }

  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  // Interactive Restore Flow
  void _triggerRestore() {
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
                'Restore Backup Archive',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select a verified cryptographic snapshot to restore state:',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _buildBackupSnapshotTile(
                title: 'Backup_2026-08-22_1432.ulv',
                size: '2.4 MB · 124 records',
                date: '22 Aug 2026',
                onRestore: () {
                  Navigator.pop(ctx);
                  _confirmRestore('22 Aug 2026 (2.4 MB)');
                },
              ),
              const SizedBox(height: 10),
              _buildBackupSnapshotTile(
                title: 'Backup_2026-07-15_0910.ulv',
                size: '1.8 MB · 98 records',
                date: '15 Jul 2026',
                onRestore: () {
                  Navigator.pop(ctx);
                  _confirmRestore('15 Jul 2026 (1.8 MB)');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackupSnapshotTile({
    required String title,
    required String size,
    required String date,
    required VoidCallback onRestore,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _obsidian,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_done, color: _mint, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$size • $date',
                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onRestore,
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: AppColors.primaryTextOffWhite,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Restore', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _confirmRestore(String label) {
    showDialog(
      context: context,
      builder: (diagCtx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Restore', style: TextStyle(color: AppColors.primaryTextOffWhite)),
        content: Text(
          'Are you sure you want to restore the snapshot from $label? Any unbacked changes made today will be superseded.',
          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(diagCtx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryTextStoneGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(diagCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: _forest,
                  content: Text('Restore completed successfully! Profile refreshed.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _forest),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showLearnBackupsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.shield_outlined, color: _mint, size: 22),
            SizedBox(width: 10),
            Text('Ulvenik Zero-Knowledge Backup', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16)),
          ],
        ),
        content: const Text(
          'Your canine records, vet discharge notes, surgical histories, and biometric charts are encrypted locally on your device with AES-256 before any backup is generated.\n\nOnly your device holds the private keys, ensuring complete privacy from third parties while allowing seamless exports to certified veterinary clinics.',
          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Understood', style: TextStyle(color: _mint, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildTopAppBar(),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dog Selector Button
              _buildDogSelectorCard(),
              const SizedBox(height: 24),

              // Populated View vs Empty State View
              if (_isEmpty) ...[
                _buildEmptyStateView(),
              ] else ...[
                _buildPopulatedStateView(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.secondaryTextStoneGrey),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'IMPORT & EXPORT',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Toggle empty / populated state',
          icon: Icon(
            _isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on,
            color: _isEmpty ? AppColors.secondaryTextStoneGrey : _mint,
            size: 26,
          ),
          onPressed: () {
            setState(() {
              _isEmpty = !_isEmpty;
              _anim.forward(from: 0);
            });
          },
        ),
        IconButton(
          tooltip: 'Health Settings',
          icon: const Icon(Icons.settings_outlined, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HealthSettingsScreen()),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.white.withValues(alpha: 0.08),
          height: 1,
        ),
      ),
    );
  }

  Widget _buildDogSelectorCard() {
    return InkWell(
      onTap: _showDogSelectorSheet,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    image: DecorationImage(
                      image: NetworkImage(_dog.avatarUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dog.name,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isEmpty ? 'Selected Profile' : '${_dog.breed}, ${_dog.age}',
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              _isEmpty ? Icons.unfold_more : Icons.chevron_right,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // POPULATED STATE VIEW
  // ==========================================

  Widget _buildPopulatedStateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // HEALTH DATA SECTION HEADER
        _buildSectionHeader('HEALTH DATA'),
        const SizedBox(height: 12),

        // 4 Action Bento Grid Cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;
            if (isWide) {
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.45,
                children: [
                  _buildActionCard(
                    icon: Icons.upload,
                    title: 'Import Records',
                    subtitle: 'PDF, CSV or backup files',
                    buttonLabel: 'Import',
                    isOutlined: false,
                    onTap: _triggerImport,
                  ),
                  _buildActionCard(
                    icon: Icons.download,
                    title: 'Export Records',
                    subtitle: 'PDF, CSV or backup',
                    buttonLabel: 'Export',
                    isOutlined: false,
                    onTap: _triggerExport,
                  ),
                  _buildActionCard(
                    icon: Icons.cloud_upload,
                    title: 'Create Backup',
                    subtitle: 'Last backup: 3 days ago',
                    highlightSubtitle: true,
                    buttonLabel: 'Back Up Now',
                    isOutlined: false,
                    onTap: _triggerBackupNow,
                  ),
                  _buildActionCard(
                    icon: Icons.cloud_download,
                    title: 'Restore Backup',
                    subtitle: '$_backupCount backups available',
                    buttonLabel: 'Restore',
                    isOutlined: true,
                    onTap: _triggerRestore,
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildActionCard(
                    icon: Icons.upload,
                    title: 'Import Records',
                    subtitle: 'PDF, CSV or backup files',
                    buttonLabel: 'Import',
                    isOutlined: false,
                    onTap: _triggerImport,
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: Icons.download,
                    title: 'Export Records',
                    subtitle: 'PDF, CSV or backup',
                    buttonLabel: 'Export',
                    isOutlined: false,
                    onTap: _triggerExport,
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: Icons.cloud_upload,
                    title: 'Create Backup',
                    subtitle: 'Last backup: 3 days ago',
                    highlightSubtitle: true,
                    buttonLabel: 'Back Up Now',
                    isOutlined: false,
                    onTap: _triggerBackupNow,
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: Icons.cloud_download,
                    title: 'Restore Backup',
                    subtitle: '$_backupCount backups available',
                    buttonLabel: 'Restore',
                    isOutlined: true,
                    onTap: _triggerRestore,
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 24),

        // ANIMATED DATA GROWTH & BACKUP TELEMETRY GRAPH
        _buildSectionHeader('BACKUP SIZE & DATA GROWTH'),
        const SizedBox(height: 12),
        _buildAnimatedBackupGrowthGraph(),
        const SizedBox(height: 24),

        // BACKUP STATUS SECTION
        _buildSectionHeader('BACKUP STATUS'),
        const SizedBox(height: 12),
        _buildBackupStatusCard(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required bool isOutlined,
    required VoidCallback onTap,
    bool highlightSubtitle = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _surfaceHigh,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Icon(icon, color: AppColors.primaryTextOffWhite, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          if (highlightSubtitle)
            RichText(
              text: const TextSpan(
                text: 'Last backup: ',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12, fontFamily: 'Inter'),
                children: [
                  TextSpan(
                    text: '3 days ago',
                    style: TextStyle(color: _mint, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          else
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 12,
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: isOutlined
                ? OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _forest),
                      foregroundColor: _mint,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      buttonLabel,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  )
                : ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      buttonLabel,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Animated Backup Growth LineChart
  Widget _buildAnimatedBackupGrowthGraph() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
                  children: const [
                    Text(
                      'HISTORICAL ARCHIVE GROWTH',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      '2.4 MB · 124 Synchronized Records',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _forest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield, color: _mint, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'AES-256',
                      style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 130,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                final progress = _anim.value;
                return LineChart(
                  LineChartData(
                    minY: 0.8,
                    maxY: 2.8,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => const Color(0xFF272B29),
                        tooltipBorder: const BorderSide(color: Colors.white12),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final point = _backupHistory[spot.spotIndex];
                            return LineTooltipItem(
                              '${point.dateText}\n',
                              const TextStyle(color: _mint, fontWeight: FontWeight.bold, fontSize: 12),
                              children: [
                                TextSpan(
                                  text: '${point.sizeMb} MB (${point.recordCount} records)',
                                  style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite,
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
                            _selectedGraphIndex = response.lineBarSpots!.first.spotIndex;
                          });
                        }
                      },
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 0.5,
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
                          reservedSize: 34,
                          interval: 0.5,
                          getTitlesWidget: (val, meta) => Text(
                            '${val.toStringAsFixed(1)}M',
                            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            if (idx < 0 || idx >= _backupHistory.length) return const SizedBox();
                            final isSel = idx == _selectedGraphIndex;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _backupHistory[idx].monthLabel,
                                style: TextStyle(
                                  color: isSel ? _mint : AppColors.secondaryTextStoneGrey,
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
                        spots: _backupHistory.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.sizeMb * progress);
                        }).toList(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: _forest,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _mint.withValues(alpha: 0.25),
                              _forest.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, pct, barData, i) {
                            final isLatest = i == _backupHistory.length - 1;
                            return FlDotCirclePainter(
                              radius: isLatest ? 5 : 3.5,
                              color: isLatest ? _mint : _carbon,
                              strokeColor: isLatest ? AppColors.primaryTextOffWhite : _forest,
                              strokeWidth: 2,
                            );
                          },
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

  Widget _buildBackupStatusCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // Row 1: Last Backup
          _buildStatusRow(
            icon: Icons.cloud_outlined,
            label: 'Last Backup',
            valueWidget: Text(
              _lastBackupDate,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13),
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),

          // Row 2: Backup Size
          _buildStatusRow(
            icon: Icons.storage_outlined,
            label: 'Backup Size',
            valueWidget: Text(
              '${_backupSizeMb.toStringAsFixed(1)} MB',
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13),
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),

          // Row 3: Encryption
          _buildStatusRow(
            icon: Icons.shield_outlined,
            label: 'Encryption',
            valueWidget: const Text(
              'Enabled',
              style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),

          // Row 4: Auto Cloud Backup
          _buildStatusRow(
            icon: Icons.wifi,
            label: 'Auto Cloud Backup',
            valueWidget: const Text(
              'Coming Soon',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow({
    required IconData icon,
    required String label,
    required Widget valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.secondaryTextStoneGrey, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          valueWidget,
        ],
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
        // HEALTH DATA SECTION HEADER
        _buildSectionHeader('HEALTH DATA'),
        const SizedBox(height: 12),

        // 2 Side by side cards (Equal height and symmetric alignment)
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: InkWell(
                  onTap: _triggerBackupNow,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.cloud_upload_outlined, color: AppColors.secondaryTextStoneGrey, size: 22),
                        SizedBox(height: 8),
                        Text(
                          'Create Backup',
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'No backup created',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.history, color: AppColors.secondaryTextStoneGrey, size: 22),
                      const SizedBox(height: 8),
                      const Text(
                        'Restore Backup',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'No backups available',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
                      ),
                      const Spacer(),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF191C1B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Text(
                          'Restore',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.35),
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
        const SizedBox(height: 16),

        // Compact Status Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: [
              _buildCompactRow('Last Backup', 'Never'),
              Divider(height: 16, color: Colors.white.withValues(alpha: 0.08)),
              _buildCompactRow('Size', '—'),
              Divider(height: 16, color: Colors.white.withValues(alpha: 0.08)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Encryption', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                  Row(
                    children: [
                      const Icon(Icons.lock, size: 14, color: _mint),
                      const SizedBox(width: 4),
                      Text('Enabled', style: TextStyle(color: _mint.withValues(alpha: 0.9), fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              Divider(height: 16, color: Colors.white.withValues(alpha: 0.08)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Auto Cloud Backup', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Coming Soon', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),

        // Slashed Cloud Graphic & Empty Callout
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _carbon,
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: const Icon(Icons.cloud_off_outlined, color: AppColors.secondaryTextStoneGrey, size: 36),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'No Backup Available',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Create a backup of ${_dog.name}\'s health history to ensure important data is never lost.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.45),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFF2E6B57), Color(0xFF235445)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0xFF95D3BB).withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E6B57).withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _triggerBackupNow,
              child: const Center(
                child: Text(
                  'Create Backup',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: _showLearnBackupsDialog,
            child: const Text(
              'Learn about backups',
              style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // EXPORT OPTIONS SECTION
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('EXPORT OPTIONS'),
            InkWell(
              onTap: () {
                setState(() {
                  final allSelected = _exportVaccinations && _exportWeight && _exportVetVisits && _exportMedications;
                  _exportVaccinations = !allSelected;
                  _exportWeight = !allSelected;
                  _exportVetVisits = !allSelected;
                  _exportMedications = !allSelected;
                });
              },
              child: const Text(
                'Select All',
                style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: [
              _buildExportOptionTile(
                icon: Icons.vaccines_outlined,
                title: 'Vaccination Records',
                value: _exportVaccinations,
                onChanged: (val) => setState(() => _exportVaccinations = val),
              ),
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
              _buildExportOptionTile(
                icon: Icons.monitor_weight_outlined,
                title: 'Weight History',
                value: _exportWeight,
                onChanged: (val) => setState(() => _exportWeight = val),
              ),
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
              _buildExportOptionTile(
                icon: Icons.medical_services_outlined,
                title: 'Vet Visits & Notes',
                value: _exportVetVisits,
                onChanged: (val) => setState(() => _exportVetVisits = val),
              ),
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
              _buildExportOptionTile(
                icon: Icons.medication_outlined,
                title: 'Medications & Prescriptions',
                value: _exportMedications,
                onChanged: (val) => setState(() => _exportMedications = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // FORMAT SECTION (PDF / CSV)
        _buildSectionHeader('FORMAT'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedFormat = 'PDF'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _selectedFormat == 'PDF' ? _forest : _carbon,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedFormat == 'PDF' ? _forest : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    'PDF',
                    style: TextStyle(
                      color: _selectedFormat == 'PDF' ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedFormat = 'CSV'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _selectedFormat == 'CSV' ? _forest : _carbon,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedFormat == 'CSV' ? _forest : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    'CSV',
                    style: TextStyle(
                      color: _selectedFormat == 'CSV' ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Export Health Records Button
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFF2E6B57), Color(0xFF235445)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0xFF95D3BB).withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E6B57).withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _triggerExport,
              child: const Center(
                child: Text(
                  'Export Health Records',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
        Text(value, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
      ],
    );
  }

  Widget _buildExportOptionTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.secondaryTextStoneGrey, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            activeThumbColor: _mint,
            activeTrackColor: _forest,
            inactiveTrackColor: const Color(0xFF272B29),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNav() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: _carbon,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', false),
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
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? _mint : AppColors.secondaryTextStoneGrey,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _mint : AppColors.secondaryTextStoneGrey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
