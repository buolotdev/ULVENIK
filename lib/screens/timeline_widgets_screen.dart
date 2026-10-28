import 'package:flutter/material.dart';
import 'timeline_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';
import 'timeline_memories_screen.dart';
import 'timeline_activity_map_screen.dart';
import 'timeline_compare_screen.dart';
import 'timeline_smart_collections_screen.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'more_page_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);
const Color _orange = Color(0xFFDD6B20);
const Color _blue = Color(0xFF5D8FAF);

class TimelineWidgetsScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineWidgetsScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Koda',
  });

  @override
  State<TimelineWidgetsScreen> createState() => _TimelineWidgetsScreenState();
}

class _TimelineWidgetsScreenState extends State<TimelineWidgetsScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late String _selectedDog;
  String _selectedFilter = 'All';

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _selectedDog = widget.initialDog;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showWidgetConfigModal(String widgetName, String size) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.widgets, color: _mint, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    widgetName,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Size: $size • Dog: $_selectedDog',
                style: const TextStyle(color: _stoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 18),
              const Text(
                'Widget configuration synced with device OS. In iOS / Android, long press your home screen and choose "Ulvenik" from the widget picker.',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  height: 1.5,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Add to Preview', style: TextStyle(color: _offWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEducationalModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.widgets_outlined, color: _mint, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'About Timeline Widgets',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Ulvenik widgets provide at-a-glance training streaks, real-time Live Activities for active sessions in Dynamic Island, and lock screen medication countdowns.',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  height: 1.5,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Got it', style: TextStyle(color: _offWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isEmptyState ? _buildEmptyState() : _buildPopulatedState(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _offWhite),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TimelineScreen()),
            );
          }
        },
      ),
      title: const Text(
        'Timeline Widgets',
        style: TextStyle(
          color: _offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Toggle Empty/Populated State',
          icon: Icon(
            _isEmptyState ? Icons.visibility : Icons.visibility_off_outlined,
            color: _mint,
            size: 20,
          ),
          onPressed: () {
            setState(() => _isEmptyState = !_isEmptyState);
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: _stoneGrey),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF272B29)),
          ),
          onSelected: (val) {
            if (val == 'toggle') {
              setState(() => _isEmptyState = !_isEmptyState);
            } else if (val == 'dog') {
              setState(() {
                _selectedDog = _selectedDog == 'Koda' ? 'Murphy' : 'Koda';
              });
            } else if (val == 'collections') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineSmartCollectionsScreen()),
              );
            } else if (val == 'compare') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineCompareScreen()),
              );
            } else if (val == 'map') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineActivityMapScreen()),
              );
            } else if (val == 'memories') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineMemoriesScreen()),
              );
            } else if (val == 'insights') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineInsightsScreen()),
              );
            } else if (val == 'settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineSettingsScreen()),
              );
            }
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    _isEmptyState ? Icons.check_circle_outline : Icons.highlight_off,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isEmptyState ? 'Switch to Populated' : 'Switch to Empty State',
                    style: const TextStyle(color: _offWhite, fontSize: 13),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'dog',
              child: Row(
                children: [
                  const Icon(Icons.pets, color: _mint, size: 18),
                  const SizedBox(width: 10),
                  Text('Switch Dog ($_selectedDog)',
                      style: const TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            const PopupMenuItem(
              value: 'collections',
              child: Row(
                children: [
                  Icon(Icons.auto_awesome_motion, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Smart Collections', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'compare',
              child: Row(
                children: [
                  Icon(Icons.compare_arrows, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Compare', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'map',
              child: Row(
                children: [
                  Icon(Icons.map_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Activity Map', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'memories',
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Memories', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Settings', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _carbon,
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.widgets_outlined,
                        size: 46,
                        color: _stoneGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'No Active Widgets',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Configure and add Ulvenik widgets to your device home screen to monitor training streaks, live GPS sessions, and health schedules at a glance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 14,
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => setState(() => _isEmptyState = false),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Browse Widget Gallery',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: _offWhite, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: _showEducationalModal,
                    child: const Text(
                      'Learn about Widgets',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom Action Bar for Empty State
        Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_iphone, color: _stoneGrey.withValues(alpha: 0.5), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Device Integration',
                        style: TextStyle(
                          color: _stoneGrey.withValues(alpha: 0.5),
                          fontSize: 13,
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
    );
  }

  Widget _buildPopulatedState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. FILTER PILLS (All, Small, Medium, Live Activity)
        _buildFilterPills(),
        const SizedBox(height: 16),

        // 2. LIVE ACTIVITY / DYNAMIC ISLAND HERO
        _buildSectionHeader('LIVE ACTIVITY (DYNAMIC ISLAND)', 'Active Session'),
        const SizedBox(height: 10),
        _buildLiveActivityWidget(),
        const SizedBox(height: 24),

        // 3. HOME SCREEN WIDGETS GALLERY
        _buildSectionHeader('HOME SCREEN WIDGETS', '5 Designs Available'),
        const SizedBox(height: 12),

        // Row of 2 Small Widgets
        Row(
          children: [
            Expanded(child: _buildStreakWidget()),
            const SizedBox(width: 12),
            Expanded(child: _buildHealthWidget()),
          ],
        ),
        const SizedBox(height: 12),

        // Medium Widget 1: Weekly Matrix
        _buildWeeklyMatrixWidget(),
        const SizedBox(height: 12),

        // Medium Widget 2: Next Scheduled Session
        _buildNextSessionWidget(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFilterPills() {
    final filters = ['All', 'Small', 'Medium', 'Live Activity'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : _carbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? _mint : _cardBorder,
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? _offWhite : _stoneGrey,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          badge,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildLiveActivityWidget() {
    return GestureDetector(
      onTap: () => _showWidgetConfigModal('Live Activity Session', 'Dynamic Island'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _mint.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _mint.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pets, color: _mint, size: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_selectedDog • LIVE SESSION',
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF261D15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.fiber_manual_record, color: _orange, size: 10),
                      SizedBox(width: 4),
                      Text('REC 32:14', style: TextStyle(color: _orange, fontSize: 10, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLiveStat('CURRENT DRILL', 'Field Scent Leg 2'),
                _buildLiveStat('HEART RATE', '164 bpm', isAccent: true),
                _buildLiveStat('DISTANCE', '2.8 km'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStat(String label, String value, {bool isAccent = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: isAccent ? _gold : _offWhite,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStreakWidget() {
    return GestureDetector(
      onTap: () => _showWidgetConfigModal('Training Streak', 'Small 2x2'),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.local_fire_department, color: _orange, size: 22),
                Text(_selectedDog, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '14 Days',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'ACTIVE STREAK',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Text(
              'Today: 45 min S&C Logged',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _mint, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthWidget() {
    return GestureDetector(
      onTap: () => _showWidgetConfigModal('Health & Preventative Care', 'Small 2x2'),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _cardBorder),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.medication_outlined, color: _mint, size: 20),
                Text('HEALTH', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '28.4 kg',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'WEIGHT STABLE',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Text(
              'NexGard: In 3 Days',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _gold, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyMatrixWidget() {
    return GestureDetector(
      onTap: () => _showWidgetConfigModal('Weekly Volume Matrix', 'Medium 4x2'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'WEEKLY TRAINING VOLUME',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  '4.8h Total',
                  style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDayBar('M', 45, true),
                _buildDayBar('T', 60, true),
                _buildDayBar('W', 0, false),
                _buildDayBar('T', 50, true),
                _buildDayBar('F', 75, true),
                _buildDayBar('S', 90, true),
                _buildDayBar('S', 0, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayBar(String day, int mins, bool active) {
    final heightFactor = mins > 0 ? (mins / 90.0).clamp(0.2, 1.0) : 0.1;
    return Column(
      children: [
        Container(
          width: 24,
          height: 48,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: const Color(0xFF131718),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            width: 24,
            height: 48 * heightFactor,
            decoration: BoxDecoration(
              color: active ? _mint : _stoneGrey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: TextStyle(
            color: active ? _offWhite : _stoneGrey,
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildNextSessionWidget() {
    return GestureDetector(
      onTap: () => _showWidgetConfigModal('Upcoming Schedule', 'Medium 4x2'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _blue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.event, color: _blue, size: 22),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tomorrow • 07:30 AM',
                    style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Trail Agility & Weave Practice',
                    style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Readiness: 94% Optimal • Riverside Course',
                    style: TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          top: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomepageScreen()),
                );
              }),
              _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyDogsScreen()),
                );
              }),
              _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainingScreen()),
                );
              }),
              _buildNavItem(Icons.event_note, 'Timeline', true, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              }),
              _buildNavItem(Icons.more_horiz_outlined, 'More', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MorePageScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? _mint : _stoneGrey,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _mint : _stoneGrey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
