import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
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
const Color _purple = Color(0xFF9F7AEA);
const Color _blue = Color(0xFF5D8FAF);

class GlobalCalendarScreen extends StatefulWidget {
  const GlobalCalendarScreen({super.key});

  @override
  State<GlobalCalendarScreen> createState() => _GlobalCalendarScreenState();
}

class _GlobalCalendarScreenState extends State<GlobalCalendarScreen> {
  DateTime _selectedDate = DateTime(2026, 10, 28);
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _allEvents = [
    {
      'date': DateTime(2026, 10, 28),
      'time': '07:30 AM',
      'title': 'High-Drive Trail Tracking & Scent',
      'dog': 'Koda (Belgian Malinois)',
      'location': 'Riverside Valley Trail Grid',
      'category': 'S&C',
      'color': _mint,
      'icon': Icons.explore_outlined,
    },
    {
      'date': DateTime(2026, 10, 28),
      'time': '11:00 AM',
      'title': 'Preventative Medication: NexGard',
      'dog': 'Koda (Belgian Malinois)',
      'location': 'Home Kennel',
      'category': 'Health',
      'color': _orange,
      'icon': Icons.medication_outlined,
    },
    {
      'date': DateTime(2026, 10, 28),
      'time': '03:30 PM',
      'title': 'Protection Phase C: Escape & Hold',
      'dog': 'Murphy (German Shepherd)',
      'location': 'Club Training Field #2',
      'category': 'Training',
      'color': _gold,
      'icon': Icons.fitness_center_outlined,
    },
    {
      'date': DateTime(2026, 10, 29),
      'time': '09:00 AM',
      'title': 'Hydrotherapy Muscle Recovery Session',
      'dog': 'Koda',
      'location': 'Canine Rehabilitation Clinic',
      'category': 'Health',
      'color': _blue,
      'icon': Icons.pool_outlined,
    },
    {
      'date': DateTime(2026, 10, 31),
      'time': '08:00 AM',
      'title': 'Pacific Northwest IGP Championship Trial',
      'dog': 'Koda & Murphy',
      'location': 'Highland Park Grounds',
      'category': 'Event',
      'color': _purple,
      'icon': Icons.emoji_events_outlined,
    },
  ];

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  static const _shortMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  static const _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  static const _shortWeekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  String _formatAgendaHeader(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    final month = _shortMonths[date.month - 1];
    return '$weekday, $month ${date.day}'.toUpperCase();
  }

  String _formatMonthHeader(DateTime date) {
    final month = _months[date.month - 1];
    return '$month ${date.year}';
  }

  String _formatDayInitial(DateTime date) {
    return _shortWeekdays[date.weekday - 1];
  }

  List<Map<String, dynamic>> get _filteredEvents {
    return _allEvents.where((e) {
      final isSameDay = e['date'].year == _selectedDate.year &&
          e['date'].month == _selectedDate.month &&
          e['date'].day == _selectedDate.day;

      if (!isSameDay) return false;
      if (_selectedCategory == 'All') return true;
      return e['category'] == _selectedCategory;
    }).toList();
  }

  void _showAddEventSheet() {
    final titleController = TextEditingController();
    String category = 'Training';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
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
                const SizedBox(height: 18),
                const Text(
                  'Schedule New Handler Event',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: _offWhite, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Event Title (e.g. Scent Line #4)',
                    hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF131718),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _cardBorder),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: ['Training', 'Health', 'S&C', 'Event'].map((cat) {
                    final isSel = category == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat, style: TextStyle(color: isSel ? _offWhite : _stoneGrey, fontSize: 12)),
                        selected: isSel,
                        selectedColor: _forest,
                        backgroundColor: const Color(0xFF131718),
                        onSelected: (val) => setModalState(() => category = cat),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty) {
                        setState(() {
                          _allEvents.add({
                            'date': _selectedDate,
                            'time': '02:00 PM',
                            'title': titleController.text.trim(),
                            'dog': 'Koda',
                            'location': 'Training Grounds',
                            'category': category,
                            'color': category == 'Health' ? _orange : (category == 'S&C' ? _mint : _gold),
                            'icon': Icons.event,
                          });
                        });
                      }
                      Navigator.pop(ctx);
                    },
                    child: const Text('Add to Schedule', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEvents;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Handler Calendar',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => _selectedDate = DateTime(2026, 10, 28)),
            child: const Text('Today', style: TextStyle(color: _mint, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. MONTH SELECTOR STRIP
          _buildMonthHeader(),
          const SizedBox(height: 12),

          // 2. HORIZONTAL 7-DAY PICKER
          _buildDayScroller(),
          const SizedBox(height: 16),

          // 3. CATEGORY FILTER PILLS
          _buildCategoryPills(),
          const SizedBox(height: 16),

          // 4. DAY AGENDA LIST
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AGENDA • ${_formatAgendaHeader(_selectedDate)}',
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                '${filtered.length} Events',
                style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: const Column(
                children: [
                  Icon(Icons.event_available, color: _stoneGrey, size: 36),
                  SizedBox(height: 10),
                  Text('No events scheduled for this day', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text('Rest day or unscheduled backcountry training.', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                ],
              ),
            )
          else
            ...filtered.map((evt) => _buildEventCard(evt)),

          const SizedBox(height: 70),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _forest,
        icon: const Icon(Icons.add, color: _offWhite),
        label: const Text('Schedule Event', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        onPressed: _showAddEventSheet,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month, color: _mint, size: 20),
            const SizedBox(width: 8),
            Text(
              _formatMonthHeader(_selectedDate),
              style: const TextStyle(
                color: _offWhite,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: _stoneGrey),
              onPressed: () {
                setState(() {
                  _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: _stoneGrey),
              onPressed: () {
                setState(() {
                  _selectedDate = _selectedDate.add(const Duration(days: 7));
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDayScroller() {
    // Generate 7 days centered on selected date
    final start = _selectedDate.subtract(const Duration(days: 3));
    final days = List.generate(7, (i) => start.add(Duration(days: i)));

    return Row(
      children: days.map((day) {
        final isSelected = day.year == _selectedDate.year &&
            day.month == _selectedDate.month &&
            day.day == _selectedDate.day;
        final hasEvent = _allEvents.any((e) =>
            e['date'].year == day.year &&
            e['date'].month == day.month &&
            e['date'].day == day.day);

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedDate = day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected ? _forest : _carbon,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? _mint : _cardBorder,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _formatDayInitial(day),
                    style: TextStyle(
                      color: isSelected ? _mint : _stoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isSelected ? _offWhite : _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: hasEvent ? (isSelected ? _offWhite : _mint) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryPills() {
    final categories = ['All', 'Training', 'S&C', 'Health', 'Event'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : _carbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? _mint : _cardBorder),
                ),
                child: Text(
                  cat,
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

  Widget _buildEventCard(Map<String, dynamic> evt) {
    final Color color = evt['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(evt['icon'], color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      evt['time'],
                      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        evt['category'],
                        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  evt['title'],
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.pets, color: _stoneGrey, size: 12),
                    const SizedBox(width: 4),
                    Text(evt['dog'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: _stoneGrey, size: 12),
                    const SizedBox(width: 4),
                    Text(evt['location'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
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
              _buildNavItem(Icons.event_note_outlined, 'Timeline', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              }),
              _buildNavItem(Icons.more_horiz, 'More', true, () {
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
