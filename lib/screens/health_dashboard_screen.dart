import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'add_health_record_screen.dart';
import 'weight_tracker_screen.dart';
import 'medication_manager_screen.dart';
import 'vaccination_manager_screen.dart';
import 'vet_visits_screen.dart';
import 'health_reminders_screen.dart';
import 'injuries_recovery_screen.dart';

class DashboardDogProfile {
  final String name;
  final String breed;
  final String age;
  final String avatarUrl;
  final bool hasData;

  const DashboardDogProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.avatarUrl,
    required this.hasData,
  });
}

class DashboardMetricPoint {
  final String label;
  final double vitality;
  final double weightKg;
  final double activityScore;

  const DashboardMetricPoint({
    required this.label,
    required this.vitality,
    required this.weightKg,
    required this.activityScore,
  });
}

class HealthDashboardScreen extends StatefulWidget {
  final bool initialEmpty;
  const HealthDashboardScreen({super.key, this.initialEmpty = false});

  @override
  State<HealthDashboardScreen> createState() => _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends State<HealthDashboardScreen>
    with SingleTickerProviderStateMixin {
  // Theme Colors
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _surfaceDeep = Color(0xFF15181A);
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _muted = Color(0xFFA7B0AB);
  static const _error = Color(0xFFFFB4AB);
  static const _amber = Color(0xFFF59E0B);

  static final _hairlineBorder = Border.all(color: Colors.white.withValues(alpha: 0.08));

  late bool _isEmpty;
  late AnimationController _chartAnimController;
  late Animation<double> _chartProgress;

  int _selectedDogIndex = 0;
  final List<DashboardDogProfile> _dogs = const [
    DashboardDogProfile(
      name: 'Koda',
      breed: 'Belgian Malinois',
      age: '3yr',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCEEEZqYjnCtyUkkdWFmJD5gjvME_CawWVeC4M8yr3BJHy2pLiY3DrKJnnN4Zj1pW7LTRhRC6tWVlizBZ12z_bZp-gDBmeQ2PuDaOqDosZRxZ6U-nNipgYyvAVBbPYXn0vXvpZc6snv4amyKsgr8upqHDjMfTrO2Rcc5rQWZFywvb_jsZUlIs1plG1tmoIUhKi9niSiK2KAJG2PVpUxFTRskaWF3-D7BB12aCEwhM1NN_dbIyortMQ',
      hasData: true,
    ),
    DashboardDogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDA43LSpqLueVgbV65C1BaUj8KmxU2uKYKkeOe869GPR6xGf7rZKXYqunE1wBNA3oSCOAA6IO77wsbLpg7BoDxBt6fbKNFh7r3Rn3RouJQxRp8-Hq_3F4IODz3kTbyfHFv6A--BsaKYHIF3RBVJYYuof7iNi_Hdc1xgK3cictN40i8cC7BjM-6V0mkqZI8G1GrUnzmduUQqWjvoRs4b0QiEbgtMpLPEF96BWQuexFVl7uRcedhssAc',
      hasData: true,
    ),
    DashboardDogProfile(
      name: 'Fenris',
      breed: 'Working Malinois',
      age: '3 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=500&q=80',
      hasData: false,
    ),
  ];
  DashboardDogProfile get _dog => _dogs[_selectedDogIndex];

  // Interactive Graph Controls
  String _selectedGraphMetric = 'Vitality'; // 'Vitality', 'Weight', 'Activity'
  int _selectedChartSpot = -1;

  final List<DashboardMetricPoint> _trendData = const [
    DashboardMetricPoint(label: 'May', vitality: 88, weightKg: 26.8, activityScore: 82),
    DashboardMetricPoint(label: 'Jun', vitality: 91, weightKg: 27.0, activityScore: 85),
    DashboardMetricPoint(label: 'Jul', vitality: 89, weightKg: 27.2, activityScore: 87),
    DashboardMetricPoint(label: 'Aug', vitality: 94, weightKg: 27.4, activityScore: 92),
    DashboardMetricPoint(label: 'Sep', vitality: 93, weightKg: 27.3, activityScore: 90),
    DashboardMetricPoint(label: 'Oct', vitality: 95, weightKg: 27.4, activityScore: 94),
  ];

  // Dismissible Alerts
  bool _dismissedKennelCough = false;
  bool _dismissedFollowUp = false;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartProgress = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
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
                'Switch Canine Athlete',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(_dogs.length, (idx) {
                final d = _dogs[idx];
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
                      backgroundImage: NetworkImage(d.avatarUrl),
                      radius: 20,
                    ),
                    title: Text(
                      d.name,
                      style: TextStyle(
                        color: isSelected ? _mint : _offWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${d.breed} · ${d.age}',
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: _mint, size: 20)
                        : (d.hasData
                            ? null
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('No Records', style: TextStyle(color: _muted, fontSize: 10)),
                              )),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _selectedDogIndex = idx;
                        _isEmpty = !d.hasData;
                        _chartAnimController.reset();
                        _chartAnimController.forward();
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

  void _showStatusDetailsModal() {
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
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _forest.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite, color: _mint, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Health: Optimal',
                          style: TextStyle(color: _offWhite, fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Continuous athletic tracking & biomarker evaluation',
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildFactorRow('Vitality & Energy Index', '94%', _mint),
              _buildFactorRow('Weight Stability & Target Ratio', '98%', _mint),
              _buildFactorRow('Vaccination & Parasite Compliance', '100%', _mint),
              _buildFactorRow('Post-Op Recovery & Tissue Healing', '88%', _amber),
              _buildFactorRow('Rest & Sleep Quality', '91%', _mint),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _offWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Close Assessment', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFactorRow(String label, String score, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _offWhite, fontSize: 13)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              score,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertActionSheet(String title, String subtitle, String category, Color color) {
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
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: _muted, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: _muted, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() {
                          if (category.contains('VACCINATION')) {
                            _dismissedKennelCough = true;
                          } else {
                            _dismissedFollowUp = true;
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: _carbon,
                            content: Text('Dismissed alert "$title"', style: const TextStyle(color: _offWhite)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Dismiss', style: TextStyle(color: _muted)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        if (category.contains('VACCINATION')) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const VaccinationManagerScreen()));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const VetVisitsScreen()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Manage Event', style: TextStyle(fontWeight: FontWeight.w600)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: _muted, size: 28),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Health Dashboard',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Search Records',
            icon: const Icon(Icons.search, color: _muted),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quick search activated across health records'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          // Toggle State Button (Populated vs Empty)
          IconButton(
            tooltip: _isEmpty ? 'Switch to Populated Dashboard' : 'Switch to Empty Dashboard',
            icon: Icon(
              _isEmpty ? Icons.check_circle_outline : Icons.check_circle,
              color: _mint,
            ),
            onPressed: () {
              setState(() {
                _isEmpty = !_isEmpty;
                _chartAnimController.reset();
                _chartAnimController.forward();
              });
            },
          ),
          IconButton(
            tooltip: 'Options',
            icon: const Icon(Icons.more_horiz, color: _muted),
            onPressed: _showDogSelectorSheet,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dog Selector Row
                  _buildDogSelectorRow(),
                  const SizedBox(height: 20),

                  if (_isEmpty) ...[
                    _buildEmptyStateView(),
                  ] else ...[
                    _buildPopulatedStateView(),
                  ],
                ],
              ),
            ),
          ),

          // Floating Action Button Overlay (Bottom Right above nav bar)
          if (!_isEmpty)
            Positioned(
              right: 16,
              bottom: 80,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [_forest, Color(0xFF225243)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: _mint.withValues(alpha: 0.25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddHealthRecordScreen()),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: _offWhite, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Add Health Record',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ==========================================
  // DOG SELECTOR ROW
  // ==========================================
  Widget _buildDogSelectorRow() {
    return InkWell(
      onTap: _showDogSelectorSheet,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
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
                  image: NetworkImage(_dog.avatarUrl),
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
                    _dog.name,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_dog.breed} · ${_dog.age}',
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: _muted, size: 22),
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
        // HEALTH SUMMARY Section (6-cell grid)
        _buildSectionTitle('HEALTH SUMMARY'),
        const SizedBox(height: 10),
        _buildHealthSummaryGrid(),
        const SizedBox(height: 22),

        // OVERALL STATUS Section
        _buildSectionTitle('OVERALL STATUS'),
        const SizedBox(height: 10),
        _buildOverallStatusCard(),
        const SizedBox(height: 22),

        // INTERACTIVE ANIMATED GRAPH
        _buildSectionTitle('HEALTH INDEX & VITALITY TREND'),
        const SizedBox(height: 10),
        _buildAnimatedGraphCard(),
        const SizedBox(height: 22),

        // ALERTS Section
        if (!_dismissedKennelCough || !_dismissedFollowUp) ...[
          _buildAlertsSection(),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: color ?? _muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // 6-Cell Health Summary Grid (Matches HTML & Screenshot 1)
  Widget _buildHealthSummaryGrid() {
    return Container(
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
                child: _buildSummaryCell(
                  icon: Icons.scale_outlined,
                  value: '27.4 kg',
                  label: 'CURRENT WEIGHT',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeightTrackerScreen())),
                ),
              ),
              Container(width: 1, height: 90, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildSummaryCell(
                  icon: Icons.warning_amber_rounded,
                  value: '1',
                  label: 'ACTIVE ISSUES',
                  valueColor: _error,
                  iconColor: _error,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InjuriesRecoveryScreen())),
                ),
              ),
            ],
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCell(
                  icon: Icons.medication_outlined,
                  value: '2',
                  label: 'ACTIVE MEDICATIONS',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicationManagerScreen())),
                ),
              ),
              Container(width: 1, height: 90, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildSummaryCell(
                  icon: Icons.notifications_outlined,
                  value: '3',
                  label: 'UPCOMING',
                  valueColor: _mint,
                  iconColor: _mint,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthRemindersScreen())),
                ),
              ),
            ],
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCell(
                  icon: Icons.medical_services_outlined,
                  value: '14 Aug',
                  label: 'LAST VET VISIT',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VetVisitsScreen())),
                ),
              ),
              Container(width: 1, height: 90, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildSummaryCell(
                  icon: Icons.vaccines_outlined,
                  value: 'Up to date',
                  label: 'VACCINATIONS',
                  valueColor: _mint,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VaccinationManagerScreen())),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCell({
    required IconData icon,
    required String value,
    required String label,
    Color? valueColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor ?? _muted, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: valueColor ?? _offWhite,
                fontSize: value.length > 8 ? 15 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: valueColor == _error ? _error : _muted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // OVERALL STATUS CARD
  Widget _buildOverallStatusCard() {
    return InkWell(
      onTap: _showStatusDetailsModal,
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
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: _mint, size: 22),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Last updated 2 hours ago',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _mint.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'GOOD',
                style: TextStyle(
                  color: _mint,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ANIMATED GRAPH CARD (fl_chart)
  Widget _buildAnimatedGraphCard() {
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedGraphMetric == 'Vitality'
                          ? '94 / 100 · Optimal Athletic Index'
                          : (_selectedGraphMetric == 'Weight'
                              ? '27.4 kg · Target Stability 98%'
                              : '94 Activity Score · High Stamina'),
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Past 6 Months Biometric Tracking',
                      style: TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Segmented Metric Toggle
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
                    _buildGraphMetricTab('Vitality'),
                    _buildGraphMetricTab('Weight'),
                    _buildGraphMetricTab('Activity'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 130,
            child: AnimatedBuilder(
              animation: _chartProgress,
              builder: (context, child) {
                final progress = _chartProgress.value;
                final isVitality = _selectedGraphMetric == 'Vitality';
                final isWeight = _selectedGraphMetric == 'Weight';

                final minY = isWeight ? 25.0 : 70.0;
                final maxY = isWeight ? 29.0 : 100.0;

                return LineChart(
                  LineChartData(
                    minY: minY,
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
                            if (idx < 0 || idx >= _trendData.length) return null;
                            final pt = _trendData[idx];
                            final valStr = isWeight
                                ? '${pt.weightKg} kg'
                                : (isVitality ? '${pt.vitality.toInt()} pts' : '${pt.activityScore.toInt()} score');
                            return LineTooltipItem(
                              '${pt.label} 2026\n',
                              const TextStyle(color: _mint, fontWeight: FontWeight.bold, fontSize: 11),
                              children: [
                                TextSpan(
                                  text: valStr,
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
                            _selectedChartSpot = response.lineBarSpots!.first.spotIndex;
                          });
                        }
                      },
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: isWeight ? 1.0 : 10.0,
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
                          interval: isWeight ? 1.0 : 10.0,
                          getTitlesWidget: (val, meta) => Text(
                            isWeight ? '${val.toStringAsFixed(0)}k' : '${val.toInt()}',
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
                            if (idx < 0 || idx >= _trendData.length) return const SizedBox();
                            final isSel = idx == _selectedChartSpot;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _trendData[idx].label,
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
                        spots: _trendData.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final pt = entry.value;
                          final rawY = isWeight
                              ? pt.weightKg
                              : (isVitality ? pt.vitality : pt.activityScore);
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
                            final isSel = index == _selectedChartSpot;
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

  Widget _buildGraphMetricTab(String label) {
    final isSelected = _selectedGraphMetric == label;
    return InkWell(
      onTap: () => setState(() => _selectedGraphMetric = label),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? _forest : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? _offWhite : _muted,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ALERTS SECTION (Matches HTML & Screenshot 1)
  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('ALERTS', color: _error),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(10),
            border: _hairlineBorder,
          ),
          child: Column(
            children: [
              if (!_dismissedKennelCough)
                _buildAlertItem(
                  accentColor: _error,
                  icon: Icons.warning_amber_rounded,
                  category: 'VACCINATION DUE',
                  title: 'Kennel Cough — Due in 5 days',
                  subtitle: null,
                  onTap: () => _showAlertActionSheet(
                    'Kennel Cough Booster',
                    'Scheduled preventive immunization due in 5 days at City Vets.',
                    'VACCINATION DUE',
                    _error,
                  ),
                ),
              if (!_dismissedKennelCough && !_dismissedFollowUp)
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
              if (!_dismissedFollowUp)
                _buildAlertItem(
                  accentColor: _amber,
                  icon: Icons.calendar_month_outlined,
                  category: 'FOLLOW-UP DUE',
                  title: 'Post-surgery check — City Vets',
                  subtitle: 'Overdue by 3 days',
                  onTap: () => _showAlertActionSheet(
                    'Post-Surgery Check',
                    'Post-op elbow cleanout wound check overdue by 3 days.',
                    'FOLLOW-UP DUE',
                    _amber,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertItem({
    required Color accentColor,
    required IconData icon,
    required String category,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Accent Bar (3px)
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: accentColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            title,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: _muted, size: 20),
                  ],
                ),
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
        // Welcome Hero Card
        Center(
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _surfaceDeep,
                  border: _hairlineBorder,
                ),
                child: const Icon(Icons.favorite_outline, color: _mint, size: 34),
              ),
              const SizedBox(height: 18),
              const Text(
                'Welcome to Health',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Start recording ${_dog.name}\'s health history to build a complete lifelong medical record.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Add First Health Record CTA
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [_forest, Color(0xFF225243)],
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddHealthRecordScreen()),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: _offWhite, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Add First Health Record',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
          ),
        ),
        const SizedBox(height: 36),

        // HEALTH SUMMARY Section (Dashed metrics)
        _buildSectionTitle('HEALTH SUMMARY'),
        const SizedBox(height: 10),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildEmptyMetricCell('Weight')),
                  Expanded(child: _buildEmptyMetricCell('Diet')),
                  Expanded(child: _buildEmptyMetricCell('BCS')),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildEmptyMetricCell('Heart')),
                  Expanded(child: _buildEmptyMetricCell('Activity')),
                  Expanded(child: _buildEmptyMetricCell('Sleep')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // OVERALL STATUS Section (No Data)
        _buildSectionTitle('OVERALL STATUS'),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHealthRecordScreen()),
          ),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(10),
              border: _hairlineBorder,
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Data',
                        style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Add health records to generate status',
                        style: TextStyle(color: _muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: _muted, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Quick Link Card: Vaccinations
        _buildQuickLinkCard(
          icon: Icons.vaccines_outlined,
          title: 'Vaccinations',
          subtitle: 'No records yet',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VaccinationManagerScreen(initialEmpty: true)),
          ),
        ),
        const SizedBox(height: 10),

        // Quick Link Card: Medications
        _buildQuickLinkCard(
          icon: Icons.medication_outlined,
          title: 'Medications',
          subtitle: 'No records yet',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MedicationManagerScreen(initialEmpty: true)),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyMetricCell(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: _muted, fontSize: 12, fontWeight: FontWeight.w500),
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

  Widget _buildQuickLinkCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(10),
          border: _hairlineBorder,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _surfaceDeep,
                borderRadius: BorderRadius.circular(8),
                border: _hairlineBorder,
              ),
              child: Icon(icon, color: _muted, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _muted, size: 20),
          ],
        ),
      ),
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
