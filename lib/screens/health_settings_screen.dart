import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import 'import_export_screen.dart';
import 'health_archive_screen.dart';
import 'health_dashboard_screen.dart';

class DogSettingProfile {
  final String name;
  final String breed;
  final String age;
  final String avatarUrl;
  final double currentWeightKg;
  final double targetWeightKg;

  const DogSettingProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.avatarUrl,
    required this.currentWeightKg,
    required this.targetWeightKg,
  });
}

class HealthSettingsScreen extends StatefulWidget {
  const HealthSettingsScreen({super.key});

  @override
  State<HealthSettingsScreen> createState() => _HealthSettingsScreenState();
}

class _HealthSettingsScreenState extends State<HealthSettingsScreen>
    with SingleTickerProviderStateMixin {
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _sage = Color(0xFF7A8F7A);
  static const _carbon = Color(0xFF1A1F22);
  static const _obsidian = Color(0xFF101214);

  late AnimationController _anim;

  // Track modified state for the Save button
  bool _hasUnsavedChanges = false;

  // Selected Dog Profile
  int _dogIndex = 0;
  final List<DogSettingProfile> _dogs = const [
    DogSettingProfile(
      name: 'Odin',
      breed: 'Malinois',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBO7dxu8rgEvNHhhhDnIip7Wk7F800MCwuyKoBO3l-FhRWVQPhE0vZiQI6tMJF3zC8tsTUV9020HltiJVp3kwyofzH5GFMF_IeMCwKWYx5sLSBMK9_ji8U9H3pF4r1pxXvIZluPnUyXtk2oukFTGcTe_tJuLw1L70uZXND5aZrr0CTtoc5_-2_4sAg_5wmiIR5AS3UKCo4WTHb-NtK_Q8KUVm5eDxwS4kzmTII4ebQigmHwUDWMl6w',
      currentWeightKg: 29.8,
      targetWeightKg: 30.5,
    ),
    DogSettingProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDA43LSpqLueVgbV65C1BaUj8KmxU2uKYKkeOe869GPR6xGf7rZKXYqunE1wBNA3oSCOAA6IO77wsbLpg7BoDxBt6fbKNFh7r3Rn3RouJQxRp8-Hq_3F4IODz3kTbyfHFv6A--BsaKYHIF3RBVJYYuof7iNi_Hdc1xgK3cictN40i8cC7BjM-6V0mkqZI8G1GrUnzmduUQqWjvoRs4b0QiEbgtMpLPEF96BWQuexFVl7uRcedhssAc',
      currentWeightKg: 28.4,
      targetWeightKg: 29.0,
    ),
    DogSettingProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
      currentWeightKg: 19.2,
      targetWeightKg: 20.0,
    ),
    DogSettingProfile(
      name: 'Fenris',
      breed: 'Working Malinois',
      age: '3 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=500&q=80',
      currentWeightKg: 31.0,
      targetWeightKg: 31.5,
    ),
  ];
  DogSettingProfile get _dog => _dogs[_dogIndex];

  // Settings State
  String _weightUnit = 'kg'; // 'kg' or 'lbs'
  String _tempUnit = '°C'; // '°C' or '°F'
  String _heightUnit = 'cm'; // 'cm' or 'in'
  late double _targetWeight; // in current weight unit
  late double _targetTolerance; // in current weight unit (e.g. +/- 1.5 kg)
  int _selectedChartPointIndex = -1;

  // Reminders & Notifications Preferences
  String _medLeadTime = '15 minutes before';
  String _vaxWarningLead = '30 days before';
  bool _quietHoursEnabled = true;
  bool _soundAlerts = true;
  bool _cloudBackup = true;

  @override
  void initState() {
    super.initState();
    _targetWeight = _dog.targetWeightKg;
    _targetTolerance = 1.5;
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _markChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  // Weight conversions
  double _kgToLbs(double kg) => kg * 2.20462;
  double _lbsToKg(double lbs) => lbs / 2.20462;

  void _setWeightUnit(String unit) {
    if (_weightUnit == unit) return;
    setState(() {
      if (unit == 'lbs') {
        _targetWeight = _kgToLbs(_targetWeight);
        _targetTolerance = _kgToLbs(_targetTolerance);
      } else {
        _targetWeight = _lbsToKg(_targetWeight);
        _targetTolerance = _lbsToKg(_targetTolerance);
      }
      _weightUnit = unit;
      _markChanged();
      _anim.forward(from: 0);
    });
  }

  void _saveSettings() {
    setState(() => _hasUnsavedChanges = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _forest,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: _mint, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Settings saved successfully for ${_dog.name}',
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
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
                'Configure Health Settings For',
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
                      _targetWeight = _weightUnit == 'lbs'
                          ? _kgToLbs(dog.targetWeightKg)
                          : dog.targetWeightKg;
                      _hasUnsavedChanges = false;
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
                          backgroundColor: const Color(0xFF272B29),
                          backgroundImage: NetworkImage(dog.avatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dog.name,
                                style: TextStyle(
                                  color: isSelected ? _mint : AppColors.primaryTextOffWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${dog.breed} · ${dog.age}',
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

  void _showWeightUnitSheet() {
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
                'Select Weight Unit',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              _buildUnitOption(
                title: 'Kilograms (kg)',
                subtitle: 'Standard metric measurement (Default)',
                isSelected: _weightUnit == 'kg',
                onTap: () {
                  Navigator.pop(ctx);
                  _setWeightUnit('kg');
                },
              ),
              const SizedBox(height: 8),
              _buildUnitOption(
                title: 'Pounds (lbs)',
                subtitle: 'Imperial measurement unit (1 kg ≈ 2.20 lbs)',
                isSelected: _weightUnit == 'lbs',
                onTap: () {
                  Navigator.pop(ctx);
                  _setWeightUnit('lbs');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTemperatureUnitSheet() {
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
                'Select Temperature Unit',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              _buildUnitOption(
                title: 'Celsius (°C)',
                subtitle: 'Canine normal baseline: 38.3°C – 39.2°C',
                isSelected: _tempUnit == '°C',
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _tempUnit = '°C');
                  _markChanged();
                },
              ),
              const SizedBox(height: 8),
              _buildUnitOption(
                title: 'Fahrenheit (°F)',
                subtitle: 'Canine normal baseline: 101.0°F – 102.5°F',
                isSelected: _tempUnit == '°F',
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _tempUnit = '°F');
                  _markChanged();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnitOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? _forest.withValues(alpha: 0.25) : _obsidian,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _mint : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? _mint : AppColors.primaryTextOffWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
              // Dog Selector Card
              _buildDogSelectorCard(),
              const SizedBox(height: 24),

              // MEASUREMENT UNITS SECTION
              _buildSectionTitle('MEASUREMENT UNITS'),
              const SizedBox(height: 8),
              _buildMeasurementUnitsCard(),
              const SizedBox(height: 24),

              // TARGET WEIGHT & CORRIDOR ANIMATED GRAPH
              _buildSectionTitle('TARGET WEIGHT & HEALTHY CORRIDOR'),
              const SizedBox(height: 8),
              _buildAnimatedTargetWeightCard(),
              const SizedBox(height: 24),

              // REMINDER & NOTIFICATION PREFERENCES
              _buildSectionTitle('HEALTH REMINDERS & ALERTS'),
              const SizedBox(height: 8),
              _buildReminderPreferencesCard(),
              const SizedBox(height: 24),

              // DATA & CLINIC SYNC PREFERENCES
              _buildSectionTitle('DATA PRIVACY & BACKUP'),
              const SizedBox(height: 8),
              _buildDataSyncCard(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: _carbon,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _sage),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'Health Settings',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Center(
            child: TextButton(
              onPressed: _hasUnsavedChanges ? _saveSettings : null,
              style: TextButton.styleFrom(
                foregroundColor: _hasUnsavedChanges ? _mint : AppColors.secondaryTextStoneGrey,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                backgroundColor: _hasUnsavedChanges
                    ? _forest.withValues(alpha: 0.3)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _hasUnsavedChanges
                      ? _mint
                      : AppColors.secondaryTextStoneGrey.withValues(alpha: 0.5),
                ),
              ),
            ),
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
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          InkWell(
            onTap: _showDogSelectorSheet,
            borderRadius: BorderRadius.circular(10),
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
                        border: Border.all(color: _forest, width: 2),
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
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_dog.breed} · ${_dog.age}',
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.expand_more, color: _sage),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
            child: const Text(
              'Settings apply to this dog only',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMeasurementUnitsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // Weight Unit row (matches screenshot)
          InkWell(
            onTap: _showWeightUnitSheet,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.monitor_weight_outlined, color: _sage, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Weight Unit',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _weightUnit == 'kg' ? 'Kilograms (kg)' : 'Pounds (lbs)',
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: _sage, size: 20),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),

          // Temperature Unit row (matches screenshot)
          InkWell(
            onTap: _showTemperatureUnitSheet,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.thermostat_outlined, color: _sage, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Temperature Unit',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_tempUnit (${_tempUnit == '°C' ? 'Celsius' : 'Fahrenheit'})',
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: _sage, size: 20),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),

          // Stature Unit row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.straighten_outlined, color: _sage, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Height / Wither Stature',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _heightUnit == 'cm' ? 'Centimeters (cm)' : 'Inches (in)',
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownButton<String>(
                  value: _heightUnit,
                  underline: const SizedBox(),
                  dropdownColor: _carbon,
                  style: const TextStyle(color: _mint, fontWeight: FontWeight.w600),
                  items: const [
                    DropdownMenuItem(value: 'cm', child: Text('cm')),
                    DropdownMenuItem(value: 'in', child: Text('in')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _heightUnit = val);
                      _markChanged();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ANIMATED & INTERACTIVE TARGET WEIGHT GRAPH
  // ==========================================

  Widget _buildAnimatedTargetWeightCard() {
    final unit = _weightUnit;
    final currentWeight = unit == 'lbs' ? _kgToLbs(_dog.currentWeightKg) : _dog.currentWeightKg;
    final minSafe = _targetWeight - _targetTolerance;
    final maxSafe = _targetWeight + _targetTolerance;

    // Simulated 6-month projected weight curve
    final List<FlSpot> spots = [
      FlSpot(0, currentWeight - (unit == 'lbs' ? 2.2 : 1.0)),
      FlSpot(1, currentWeight - (unit == 'lbs' ? 1.3 : 0.6)),
      FlSpot(2, currentWeight - (unit == 'lbs' ? 0.4 : 0.2)),
      FlSpot(3, currentWeight),
      FlSpot(4, _targetWeight - (unit == 'lbs' ? 0.4 : 0.2)),
      FlSpot(5, _targetWeight),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'IDEAL BODY CONDITION CORRIDOR',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Target: ${_targetWeight.toStringAsFixed(1)} $unit',
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _forest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '±${_targetTolerance.toStringAsFixed(1)}$unit',
                          style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Quick Stepper
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: _sage, size: 22),
                    onPressed: () {
                      setState(() {
                        _targetWeight -= (unit == 'lbs' ? 0.5 : 0.2);
                        _markChanged();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: _mint, size: 22),
                    onPressed: () {
                      setState(() {
                        _targetWeight += (unit == 'lbs' ? 0.5 : 0.2);
                        _markChanged();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Animated fl_chart LineChart with touch scrubber
          SizedBox(
            height: 140,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                final progress = _anim.value;
                return LineChart(
                  LineChartData(
                    minY: minSafe - (unit == 'lbs' ? 3.0 : 1.5),
                    maxY: maxSafe + (unit == 'lbs' ? 3.0 : 1.5),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => const Color(0xFF272B29),
                        tooltipBorder: const BorderSide(color: Colors.white12),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final month = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'][spot.spotIndex];
                            return LineTooltipItem(
                              '$month\n',
                              const TextStyle(color: _mint, fontWeight: FontWeight.bold, fontSize: 12),
                              children: [
                                TextSpan(
                                  text: '${spot.y.toStringAsFixed(1)} $unit',
                                  style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
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
                            _selectedChartPointIndex = response.lineBarSpots!.first.spotIndex;
                          });
                        }
                      },
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: unit == 'lbs' ? 2 : 1,
                      getDrawingHorizontalLine: (val) {
                        if ((val - _targetWeight).abs() < 0.2) {
                          return FlLine(color: _mint.withValues(alpha: 0.4), strokeWidth: 1, dashArray: [4, 4]);
                        }
                        return FlLine(color: Colors.white.withValues(alpha: 0.04), strokeWidth: 1);
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          interval: unit == 'lbs' ? 4 : 2,
                          getTitlesWidget: (val, meta) => Text(
                            '${val.toInt()}$unit',
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
                            const months = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];
                            if (idx < 0 || idx >= months.length) return const SizedBox();
                            final isSel = idx == _selectedChartPointIndex;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                months[idx],
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
                        spots: spots.map((s) => FlSpot(s.x, s.y * progress)).toList(),
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
                              _mint.withValues(alpha: 0.2),
                              _forest.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, pct, barData, i) {
                            final isTarget = i == spots.length - 1;
                            return FlDotCirclePainter(
                              radius: isTarget ? 5 : 3.5,
                              color: isTarget ? _mint : _carbon,
                              strokeColor: isTarget ? AppColors.primaryTextOffWhite : _forest,
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Min Safe: ${minSafe.toStringAsFixed(1)}$unit',
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
              ),
              Text(
                'Max Healthy: ${maxSafe.toStringAsFixed(1)}$unit',
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReminderPreferencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // Medication Lead Time
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.alarm_on_outlined, color: _sage, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Medication Advance Alert',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _medLeadTime,
                        style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                DropdownButton<String>(
                  value: _medLeadTime,
                  underline: const SizedBox(),
                  dropdownColor: _carbon,
                  style: const TextStyle(color: _mint, fontWeight: FontWeight.w600, fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 'At dose time', child: Text('At dose time')),
                    DropdownMenuItem(value: '15 minutes before', child: Text('15 min before')),
                    DropdownMenuItem(value: '30 minutes before', child: Text('30 min before')),
                    DropdownMenuItem(value: '1 hour before', child: Text('1 hour before')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _medLeadTime = val);
                      _markChanged();
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),

          // Vaccine Warning Lead
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.vaccines_outlined, color: _sage, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vaccine Expiry Warning',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _vaxWarningLead,
                        style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                DropdownButton<String>(
                  value: _vaxWarningLead,
                  underline: const SizedBox(),
                  dropdownColor: _carbon,
                  style: const TextStyle(color: _mint, fontWeight: FontWeight.w600, fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: '7 days before', child: Text('7 days before')),
                    DropdownMenuItem(value: '14 days before', child: Text('14 days before')),
                    DropdownMenuItem(value: '30 days before', child: Text('30 days before')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _vaxWarningLead = val);
                      _markChanged();
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),

          // Quiet Hours Switch
          SwitchListTile(
            activeThumbColor: _mint,
            activeTrackColor: _forest,
            inactiveTrackColor: const Color(0xFF272B29),
            secondary: const Icon(Icons.nightlight_round_outlined, color: _sage, size: 22),
            title: const Text(
              'Quiet Hours (10 PM - 7 AM)',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Mute non-urgent health alarms at night',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
            ),
            value: _quietHoursEnabled,
            onChanged: (val) {
              setState(() => _quietHoursEnabled = val);
              _markChanged();
            },
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),

          // Sound Alert Toggle
          SwitchListTile(
            activeThumbColor: _mint,
            activeTrackColor: _forest,
            inactiveTrackColor: const Color(0xFF272B29),
            secondary: const Icon(Icons.volume_up_outlined, color: _sage, size: 22),
            title: const Text(
              'Audible Health Chimes',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Play custom Nordic chime for dosage alarms',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
            ),
            value: _soundAlerts,
            onChanged: (val) {
              setState(() => _soundAlerts = val);
              _markChanged();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataSyncCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          SwitchListTile(
            activeThumbColor: _mint,
            activeTrackColor: _forest,
            inactiveTrackColor: const Color(0xFF272B29),
            secondary: const Icon(Icons.cloud_sync_outlined, color: _sage, size: 22),
            title: const Text(
              'Automatic Veterinary Cloud Sync',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Sync encrypted records with clinic portal',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
            ),
            value: _cloudBackup,
            onChanged: (val) {
              setState(() => _cloudBackup = val);
              _markChanged();
            },
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          ListTile(
            leading: const Icon(Icons.import_export, color: _mint, size: 22),
            title: const Text(
              'Import & Export Health Records',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Manage backups, PDF/CSV export and restore',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 20),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ImportExportScreen()),
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined, color: _mint, size: 22),
            title: const Text(
              'Health Archive',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Long-term storage and archived clinical records',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 20),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HealthArchiveScreen()),
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          ListTile(
            leading: const Icon(Icons.space_dashboard_outlined, color: _mint, size: 22),
            title: const Text(
              'Health Dashboard',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Biometrics, alerts, and vital athletic trends',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 20),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HealthDashboardScreen()),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar (Matches HTML & Screenshot)
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
          _buildNavItem(Icons.home_outlined, 'Home', false),
          _buildNavItem(Icons.pets, 'Dogs', true),
          _buildNavItem(Icons.fitness_center_outlined, 'Training', false),
          _buildNavItem(Icons.event_note_outlined, 'Timeline', false),
          _buildNavItem(Icons.more_horiz_outlined, 'More', false),
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
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
