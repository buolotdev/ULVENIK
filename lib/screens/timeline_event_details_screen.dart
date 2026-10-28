import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'session_details_screen.dart';
import 'vet_visits_screen.dart';

/// Event Variant (Batch 6 - Lines 174 & 175)
enum TimelineEventVariant { training, health }

/// Timeline Event Details Screen
/// Supports both:
/// 1. Training Session variant (Figma Image 1)
/// 2. Health Record variant (Figma Image 2)
class TimelineEventDetailsScreen extends StatefulWidget {
  final TimelineEventVariant initialVariant;
  final String? eventId;
  final String? initialTitle;
  final String? initialDog;

  const TimelineEventDetailsScreen({
    super.key,
    this.initialVariant = TimelineEventVariant.training,
    this.eventId,
    this.initialTitle,
    this.initialDog,
  });

  @override
  State<TimelineEventDetailsScreen> createState() =>
      _TimelineEventDetailsScreenState();
}

class _TimelineEventDetailsScreenState extends State<TimelineEventDetailsScreen>
    with SingleTickerProviderStateMixin {
  // ─── Design Tokens ──────────────────────────────────────────────────────────
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _surfaceVariant = Color(0xFF323533);
  static const Color _surfaceDim = Color(0xFF111412);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _error = Color(0xFFFFB4AB);
  static const Color _secondary = Color(0xFFB6CCB5);

  // ─── Media Assets ──────────────────────────────────────────────────────────
  static const String _trainingPhotoUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBfRWica8I0VhtBqJif-nUVF_6MZJ3WGFOxo1dMzidTjlAdVdTLlSAX-PQH7T5F82bfNi7apHgTweCO0Za_ErsapOuu8HvT7FsZJOrx7nVzLzKpuSc71-PhryHRqK-bNlliqfMl8y84jeCyzHFaIVG8IaHn__2bjEZEazBAPd6wMPW9Urqr76CTIWgepgvjAzjWRuQHSvyXGlhe3CAg6hjQTKGbvGXWPTk9cQcv94RnIoTgnbxLNjU';

  static const String _videoThumbUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAnjeoQVBHcZ-eFnOau_ksTQDnimpI2KGn1mGU_VPi8lsO9kM-8of9b4TVzP4P_cOeDJmT_EQzh1dgernxXmvVZUaTekhrpQoP69ac2ORVDa6Gpuh5hjgRh6K81rkTOzcn5y_g7xWOT8Khj5zS1W1sD4hv0K-F05cls2MhALymi7V-wFMy3SF5Eqx5q58TRZtTfxB-0XAAtJHti3awnvAlGBXJXRhn3AxZRS3PcQW3JYOjLBJ_9wbQ';

  static const String _healthCertPhotoUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAMfj32SNwRKCBsOeBz-RO2mqg-bQbocK9tbF4ZXyZajrofeN4TC6LhkIIsYi-mlg26NjXwLbeoFoRGepPW_8dlyG2v91FCfh8Ig2enAT5CRzTRjoeaEBrGalmozcExgyRqrU2abFKI6n5OX6Kodmm5nCUeCkyeIyyBINn1E55QGgU4nHqMLjh1eIo9MliJTflotG-oZ-xMEncQf0iZiNv10ADDtO0SqNT2ktgidgMtSaa-IUk1MDw';

  // ─── State ─────────────────────────────────────────────────────────────────
  late TimelineEventVariant _variant;
  bool _isStarFavorite = false;
  bool _showGraph = true;
  String _selectedTelemetryMetric = 'HEART RATE'; // 'HEART RATE', 'SPEED', 'WORK LOAD'

  // Chart Animation
  late AnimationController _chartAnimController;
  late Animation<double> _chartAnim;

  @override
  void initState() {
    super.initState();
    _variant = widget.initialVariant;
    if (_variant == TimelineEventVariant.health) {
      _isStarFavorite = true;
    }

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartAnim = CurvedAnimation(
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

  void _toggleVariant() {
    setState(() {
      _variant = _variant == TimelineEventVariant.training
          ? TimelineEventVariant.health
          : TimelineEventVariant.training;
      _chartAnimController.reset();
      _chartAnimController.forward();
    });
  }

  // ─── Full-Screen Image Lightbox ────────────────────────────────────────────

  void _openMediaLightbox(String url, String title) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black.withValues(alpha: 0.92),
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(url, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: _offWhite, size: 24),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
            Positioned(
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  title,
                  style: const TextStyle(color: _offWhite, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build Method ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isTraining = _variant == TimelineEventVariant.training;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          // 1. Event Header Card (Figma Images 1 & 2)
          _buildEventHeaderCard(isTraining),
          const SizedBox(height: 16),

          // 2. Primary Action: View Original Record
          _buildPrimaryActionButton(isTraining),
          const SizedBox(height: 24),

          // 3. Summary Section
          _buildSummarySection(isTraining),
          const SizedBox(height: 20),

          // 4. Interactive Animated Telemetry / Trend Chart
          if (_showGraph) ...[
            _buildAnimatedTelemetryCard(isTraining),
            const SizedBox(height: 20),
          ],

          // 5. Event Details High-Density Grid
          _buildHighDensityDetailsGrid(isTraining),
          const SizedBox(height: 24),

          // 6. Session Notes / Clinical Notes
          _buildNotesSection(isTraining),
          const SizedBox(height: 24),

          // 7. Attachments (2 Files Grid)
          _buildAttachmentsSection(isTraining),
          const SizedBox(height: 24),

          // 8. Related Context (Figma Image 1)
          _buildRelatedContextSection(),
          const SizedBox(height: 24),

          // 9. Timeline Context Navigator (Figma Image 1)
          _buildTimelineNavigator(isTraining),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _secondary),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: GestureDetector(
        onDoubleTap: _toggleVariant,
        child: const Text(
          'Timeline Event Details',
          style: TextStyle(
            color: _offWhite,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, color: _secondary, size: 24),
          color: _carbon,
          onSelected: (val) {
            if (val == 'toggle_variant') {
              _toggleVariant();
            } else if (val == 'toggle_graph') {
              setState(() => _showGraph = !_showGraph);
            } else if (val == 'view_original') {
              _handleViewOriginalRecord(_variant == TimelineEventVariant.training);
            } else if (val == 'star_toggle') {
              setState(() => _isStarFavorite = !_isStarFavorite);
            }
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: 'toggle_variant',
              child: Row(
                children: [
                  Icon(
                    _variant == TimelineEventVariant.training
                        ? Icons.medical_services_outlined
                        : Icons.fitness_center_outlined,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _variant == TimelineEventVariant.training
                        ? 'Switch to Health Record Variant'
                        : 'Switch to Training Session Variant',
                    style: const TextStyle(color: _offWhite, fontSize: 13),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle_graph',
              child: Row(
                children: [
                  Icon(
                    _showGraph ? Icons.timeline : Icons.show_chart,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _showGraph ? 'Hide Trend Chart' : 'Show Trend Chart',
                    style: const TextStyle(color: _offWhite, fontSize: 13),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'star_toggle',
              child: Row(
                children: [
                  Icon(
                    _isStarFavorite ? Icons.star : Icons.star_border,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isStarFavorite ? 'Remove from Favorites' : 'Mark as Favorite',
                    style: const TextStyle(color: _offWhite, fontSize: 13),
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'view_original',
              child: Row(
                children: [
                  Icon(Icons.open_in_new, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('View Original Record',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: const Color(0x14FFFFFF), height: 1),
      ),
    );
  }

  // ─── Event Header Card (Figma Images 1 & 2) ─────────────────────────────────

  Widget _buildEventHeaderCard(bool isTraining) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Category Pill & Status/Time Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _surfaceDim,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x14FFFFFF), width: 1),
                    ),
                    child: Icon(
                      isTraining ? Icons.fitness_center : Icons.medical_services,
                      color: isTraining ? _alpineBlue : _error,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isTraining
                          ? const Color(0xFF1A2533)
                          : _error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isTraining
                            ? _alpineBlue.withValues(alpha: 0.3)
                            : _error.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isTraining ? 'TRAINING' : 'HEALTH',
                      style: TextStyle(
                        color: isTraining ? _alpineBlue : _error,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isTraining ? const Color(0xFF132A21) : _surfaceDim,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isTraining
                            ? _forest.withValues(alpha: 0.4)
                            : const Color(0x14FFFFFF),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'COMPLETED',
                      style: TextStyle(
                        color: isTraining ? _mint : _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isTraining)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _surfaceDim,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
                      ),
                      child: const Text(
                        '45 MIN',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
                  else
                    IconButton(
                      icon: Icon(
                        _isStarFavorite ? Icons.star : Icons.star_border,
                        color: _mint,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() => _isStarFavorite = !_isStarFavorite);
                      },
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            isTraining
                ? 'Obedience — Heel Work & Recall'
                : 'Vet Visit — Annual Health Check',
            style: const TextStyle(
              color: _offWhite,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),

          // Metadata Rows (Date, Time, Dog, Location)
          Row(
            children: [
              const Icon(Icons.calendar_today, color: _secondary, size: 15),
              const SizedBox(width: 6),
              Text(
                isTraining ? 'Aug 21, 2024' : 'Wed 20 Aug',
                style: const TextStyle(color: _stoneGrey, fontSize: 13),
              ),
              const SizedBox(width: 10),
              Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0x38FFFFFF), shape: BoxShape.circle)),
              const SizedBox(width: 10),
              const Icon(Icons.schedule, color: _secondary, size: 15),
              const SizedBox(width: 6),
              Text(
                isTraining ? '07:30 AM' : '09:30 AM',
                style: const TextStyle(color: _stoneGrey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.pets, color: _secondary, size: 15),
              const SizedBox(width: 6),
              Text(
                isTraining ? 'Fenrir' : 'Atlas',
                style: const TextStyle(color: _stoneGrey, fontSize: 13),
              ),
              const SizedBox(width: 10),
              Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0x38FFFFFF), shape: BoxShape.circle)),
              const SizedBox(width: 10),
              const Icon(Icons.location_on, color: _secondary, size: 15),
              const SizedBox(width: 6),
              InkWell(
                onTap: () {},
                child: Text(
                  isTraining ? 'Riverside Park' : 'Barkcroft Veterinary',
                  style: const TextStyle(
                    color: _secondary,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0x66B6CCB5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Primary Action Button (View Original Record) ───────────────────────────

  Widget _buildPrimaryActionButton(bool isTraining) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _forest,
          foregroundColor: _offWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => _handleViewOriginalRecord(isTraining),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.open_in_new, size: 18),
            SizedBox(width: 8),
            Text(
              'View Original Record',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.arrow_forward, size: 16),
          ],
        ),
      ),
    );
  }

  void _handleViewOriginalRecord(bool isTraining) {
    if (isTraining) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SessionDetailsScreen(
            sessionTitle: 'Obedience — Heel Work & Recall',
            dateSubtitle: 'Aug 21, 2024 · 07:30 AM',
            shortDate: 'Aug 21',
            startTime: '07:30 AM',
            endTime: '08:15 AM',
            durationText: '45 mins',
            initialRating: 5,
            distance: '3.2 km',
            sets: '7 Exercises',
            restTime: '15m Total',
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const VetVisitsScreen(),
        ),
      );
    }
  }

  // ─── Summary Section ───────────────────────────────────────────────────────

  Widget _buildSummarySection(bool isTraining) {
    final summaryText = isTraining
        ? 'Focused session on off-leash reliability in medium-distraction environments. Fenrir responded excellently to recall despite the presence of other dogs at a distance. Heel work needs minor adjustment on right turns.'
        : 'Routine annual physical examination. Atlas is in excellent health, maintaining optimal weight for sporting activities. Core vaccinations updated. Joint mobility and muscle tone are exceptional for his age bracket.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'SUMMARY',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x14FFFFFF), width: 1),
          ),
          child: Text(
            summaryText,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Animated Telemetry / Trend Graph Card ─────────────────────────────────

  Widget _buildAnimatedTelemetryCard(bool isTraining) {
    final metrics = isTraining
        ? ['HEART RATE', 'SPEED', 'WORK LOAD']
        : ['WEIGHT', 'VITALITY', 'CONDITION'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isTraining ? Icons.monitor_heart : Icons.show_chart,
                    color: _mint,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isTraining ? 'SESSION TELEMETRY' : 'HEALTH TREND',
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: _stoneGrey, size: 16),
                tooltip: 'Replay Telemetry',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  _chartAnimController.reset();
                  _chartAnimController.forward();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Metric segment tabs
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: _surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: metrics.map((m) {
                final isSel = _selectedTelemetryMetric == m;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTelemetryMetric = m;
                        _chartAnimController.reset();
                        _chartAnimController.forward();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSel ? _mint : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Text(
                        m,
                        style: TextStyle(
                          color: isSel ? _offWhite : _stoneGrey,
                          fontSize: 10,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Animated FL LineChart
          AnimatedBuilder(
            animation: _chartAnim,
            builder: (context, _) {
              final p = _chartAnim.value;
              List<FlSpot> spots;
              double minY;
              double maxY;
              String unit;

              if (isTraining) {
                if (_selectedTelemetryMetric == 'HEART RATE') {
                  minY = 100;
                  maxY = 180;
                  unit = 'bpm';
                  spots = [
                    FlSpot(0, 110 + (10 * p)),
                    FlSpot(1, 110 + (25 * p)),
                    FlSpot(2, 110 + (42 * p)),
                    FlSpot(3, 110 + (58 * p)),
                    FlSpot(4, 110 + (35 * p)),
                    FlSpot(5, 110 + (20 * p)),
                  ];
                } else if (_selectedTelemetryMetric == 'SPEED') {
                  minY = 0;
                  maxY = 30;
                  unit = 'km/h';
                  spots = [
                    FlSpot(0, 4.0 * p),
                    FlSpot(1, 12.0 * p),
                    FlSpot(2, 28.5 * p),
                    FlSpot(3, 24.0 * p),
                    FlSpot(4, 15.0 * p),
                    FlSpot(5, 6.0 * p),
                  ];
                } else {
                  minY = 0;
                  maxY = 100;
                  unit = '%';
                  spots = [
                    FlSpot(0, 30.0 * p),
                    FlSpot(1, 55.0 * p),
                    FlSpot(2, 85.0 * p),
                    FlSpot(3, 92.0 * p),
                    FlSpot(4, 70.0 * p),
                    FlSpot(5, 40.0 * p),
                  ];
                }
              } else {
                // Health Trend (Weight Trajectory)
                minY = 30;
                maxY = 38;
                unit = 'kg';
                spots = [
                  FlSpot(0, 30 + (3.6 * p)),
                  FlSpot(1, 30 + (3.9 * p)),
                  FlSpot(2, 30 + (4.1 * p)),
                  FlSpot(3, 30 + (4.0 * p)),
                  FlSpot(4, 30 + (4.2 * p)),
                  FlSpot(5, 30 + (4.2 * p)),
                ];
              }

              return SizedBox(
                height: 100,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (val, _) {
                            final i = val.toInt();
                            final intervals = isTraining
                                ? ['0m', '9m', '18m', '27m', '36m', '45m']
                                : ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];
                            if (i >= 0 && i < intervals.length) {
                              return Text(
                                intervals[i],
                                style: const TextStyle(color: _stoneGrey, fontSize: 10),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 5,
                    minY: minY,
                    maxY: maxY,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((s) {
                            return LineTooltipItem(
                              '${s.y.toStringAsFixed(1)} $unit',
                              const TextStyle(
                                color: _mint,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: _mint,
                        barWidth: 2.2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 3,
                            color: _obsidian,
                            strokeWidth: 2,
                            strokeColor: _mint,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _mint.withValues(alpha: 0.28),
                              _mint.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Event Details High-Density Grid (Figma Image 1) ───────────────────────

  Widget _buildHighDensityDetailsGrid(bool isTraining) {
    final rows = isTraining
        ? [
            {'icon': Icons.category, 'label': 'SESSION TYPE', 'value': 'Obedience Drill'},
            {'icon': Icons.psychology, 'label': 'SKILLS', 'value': 'Focus, Impulse Control'},
            {
              'icon': Icons.checklist,
              'label': 'EXERCISES',
              'multi': ['Focused Heel (15m)', 'Recall with Distraction (x5)', 'Long Down-Stay (3m)'],
            },
            {'icon': Icons.timer, 'label': 'DURATION', 'value': '45 Minutes (Active)'},
            {'icon': Icons.emoji_events_outlined, 'label': 'REWARDS', 'value': 'High-Value Food, Tug Toy'},
            {'icon': Icons.construction, 'label': 'EQUIPMENT', 'value': 'Long Line, Clicker'},
            {'icon': Icons.wb_cloudy_outlined, 'label': 'WEATHER', 'value': '14°C, Overcast, Dry'},
          ]
        : [
            {'icon': Icons.category, 'label': 'RECORD TYPE', 'value': 'Annual Physical Exam'},
            {'icon': Icons.scale, 'label': 'WEIGHT', 'value': '34.2 kg (Optimal)'},
            {'icon': Icons.health_and_safety, 'label': 'CONDITION SCORE', 'value': '5/9 (Ideal Athletic)'},
            {'icon': Icons.person, 'label': 'VETERINARIAN', 'value': 'Dr. Sarah Jenkins, DVM'},
            {'icon': Icons.local_hospital, 'label': 'CLINIC', 'value': 'Barkcroft Veterinary Hospital'},
            {
              'icon': Icons.vaccines,
              'label': 'VACCINATIONS',
              'multi': ['Rabies (3-Yr Booster)', 'DHPP Core Annual', 'Leptospirosis 4-way'],
            },
            {'icon': Icons.event, 'label': 'NEXT DUE DATE', 'value': 'Aug 20, 2025'},
          ];

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
      ),
      child: Column(
        children: List.generate(rows.length, (index) {
          final item = rows[index];
          final hasBottom = index < rows.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: hasBottom
                    ? const BorderSide(color: Color(0x14FFFFFF), width: 1)
                    : BorderSide.none,
              ),
            ),
            child: Row(
              crossAxisAlignment: item.containsKey('multi')
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(item['icon'] as IconData, color: _secondary, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                if (item.containsKey('multi'))
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: (item['multi'] as List<String>).map((ex) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            ex,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                else
                  Expanded(
                    child: Text(
                      item['value'] as String,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ─── Session Notes / Clinical Notes (Figma Image 1) ─────────────────────────

  Widget _buildNotesSection(bool isTraining) {
    final title = isTraining ? 'SESSION NOTES' : 'CLINICAL NOTES';
    final notes = isTraining
        ? '"Fenrir was unusually alert today, possibly due to the cooler weather. He required a higher rate of reinforcement during the first 10 minutes to lock into the heel position. Recall was flawless. Next session: introduce moving distractions during down-stay."'
        : '"Clear heart and lung sounds. Musculoskeletal palpation shows symmetry and excellent hip mobility. Teeth graded 1/4 tartar, no scaling needed at this time. Recommended continuing current joint supplement regimen."';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x14FFFFFF), width: 1),
          ),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFF3A4E3C), width: 3),
              ),
            ),
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              notes,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                height: 1.55,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Attachments Section (Figma Image 1) ───────────────────────────────────

  Widget _buildAttachmentsSection(bool isTraining) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                'ATTACHMENTS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _surfaceDim,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0x14FFFFFF), width: 1),
              ),
              child: const Text(
                '2 FILES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            // File 1: Photo
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _openMediaLightbox(
                  isTraining ? _trainingPhotoUrl : _healthCertPhotoUrl,
                  isTraining ? 'training_21aug.jpg' : 'exam_record.jpg',
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x14FFFFFF), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.network(
                              isTraining ? _trainingPhotoUrl : _healthCertPhotoUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.photo, color: _offWhite, size: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isTraining ? 'training_21aug.jpg' : 'exam_record.jpg',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // File 2: Video or PDF Report
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _openMediaLightbox(
                  _videoThumbUrl,
                  isTraining ? 'recall_drill.mp4' : 'vaccine_cert.mp4',
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x14FFFFFF), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              _videoThumbUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _obsidian.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0x24FFFFFF)),
                              ),
                              child: const Icon(Icons.play_arrow, color: _offWhite, size: 20),
                            ),
                            Positioned(
                              bottom: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: const Text(
                                  '1:24',
                                  style: TextStyle(
                                    color: _offWhite,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isTraining ? 'recall_drill.mp4' : 'vaccine_cert.mp4',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Related Context Section (Figma Image 1) ───────────────────────────────

  Widget _buildRelatedContextSection() {
    final relatedItems = [
      {
        'icon': Icons.flag,
        'color': _mint,
        'title': 'Goal Progress Updated',
        'sub': 'Advanced Obedience Title',
      },
      {
        'icon': Icons.movie_outlined,
        'color': _alpineBlue,
        'title': 'Video Uploaded',
        'sub': 'Media Library · 2 items',
      },
      {
        'icon': Icons.inventory_2_outlined,
        'color': const Color(0xFFFFB4AC),
        'title': 'Reward Inventory Used',
        'sub': '-1 High Value Treats',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'RELATED CONTEXT',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x14FFFFFF), width: 1),
          ),
          child: Column(
            children: List.generate(relatedItems.length, (index) {
              final it = relatedItems[index];
              final hasBottom = index < relatedItems.length - 1;

              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: hasBottom
                        ? const BorderSide(color: Color(0x14FFFFFF), width: 1)
                        : BorderSide.none,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _surfaceDim,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x14FFFFFF)),
                    ),
                    child: Icon(it['icon'] as IconData, color: it['color'] as Color, size: 16),
                  ),
                  title: Text(
                    it['title'] as String,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    it['sub'] as String,
                    style: const TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                  onTap: () {},
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // ─── Timeline Context Navigator (Figma Image 1) ─────────────────────────────

  Widget _buildTimelineNavigator(bool isTraining) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
      ),
      child: Column(
        children: [
          const Text(
            'TIMELINE NAVIGATION',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Event
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    // Switch to previous event (e.g. Health Record)
                    setState(() {
                      _variant = TimelineEventVariant.health;
                      _isStarFavorite = true;
                      _chartAnimController.reset();
                      _chartAnimController.forward();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.arrow_back, color: _secondary, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Previous Event',
                            style: TextStyle(color: _stoneGrey, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isTraining ? 'Weight Recorded' : 'Sprint Drills',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center Dot with pulse ring
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _forest,
                  border: Border.all(color: _mint, width: 2),
                ),
              ),

              // Next Event
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    // Switch to next event (e.g. Training Session)
                    setState(() {
                      _variant = TimelineEventVariant.training;
                      _isStarFavorite = false;
                      _chartAnimController.reset();
                      _chartAnimController.forward();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Next Event',
                            style: TextStyle(color: _stoneGrey, fontSize: 11),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, color: _secondary, size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isTraining ? 'Goal Completed' : 'Obedience Heel Work',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Bottom Navigation Bar ─────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: _carbon,
        border: Border(top: BorderSide(color: Color(0x14FFFFFF))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(icon: Icons.home_outlined, label: 'Home', isActive: false),
          _buildBottomNavItem(icon: Icons.pets_outlined, label: 'Dogs', isActive: false),
          _buildBottomNavItem(icon: Icons.fitness_center_outlined, label: 'Training', isActive: false),
          _buildBottomNavItem(icon: Icons.event_note, label: 'Timeline', isActive: true),
          _buildBottomNavItem(icon: Icons.more_horiz_outlined, label: 'More', isActive: false),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          Navigator.maybePop(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? _mint : _stoneGrey,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? _mint : _stoneGrey,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
