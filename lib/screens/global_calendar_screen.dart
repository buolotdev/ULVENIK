import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class GlobalCalendarScreen extends StatefulWidget {
  const GlobalCalendarScreen({super.key});

  @override
  State<GlobalCalendarScreen> createState() => _GlobalCalendarScreenState();
}

class _GlobalCalendarScreenState extends State<GlobalCalendarScreen> {
  String _selectedDog = 'Murphy';
  String _currentView = 'Month';
  int _selectedDay = 16;

  void _showNewEventSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Calendar Event', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: _mint),
              title: const Text('Add Training Session', style: TextStyle(color: _offWhite)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Training sheet opened'), backgroundColor: _forest));
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_outline, color: Color(0xFFE5484D)),
              title: const Text('Add Health Record / Vet Visit', style: TextStyle(color: _offWhite)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Health sheet opened'), backgroundColor: _forest));
              },
            ),
            ListTile(
              leading: const Icon(Icons.alarm, color: Color(0xFFE5A84D)),
              title: const Text('Add Reminder', style: TextStyle(color: _offWhite)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Reminder sheet opened'), backgroundColor: _forest));
              },
            ),
          ],
        ),
      ),
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
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Calendar',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Search Calendar...'), backgroundColor: _forest));
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: _offWhite),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calendar filters...'), backgroundColor: _forest));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _showNewEventSheet,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // HERO BANNER WITH SILHOUETTE
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFF14191C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
              gradient: const LinearGradient(
                colors: [Color(0xFF1B2624), Color(0xFF0F1416)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDog == 'All Dogs' ? 'All Dogs' : _selectedDog,
                      style: const TextStyle(color: _offWhite, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text('September 2026', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                  ],
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF263033),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: const Icon(Icons.pets, color: _mint, size: 28),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // FILTER CHIPS ROW
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All Dogs', 'Murphy', 'Monty', 'Minnie'].map((dog) {
                final isSel = _selectedDog == dog;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(dog),
                    selected: isSel,
                    selectedColor: Colors.transparent,
                    backgroundColor: _carbon,
                    checkmarkColor: _mint,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSel ? _forest : _cardBorder, width: isSel ? 1.5 : 1),
                    ),
                    labelStyle: TextStyle(color: isSel ? _offWhite : _stoneGrey, fontSize: 13, fontWeight: isSel ? FontWeight.bold : FontWeight.normal),
                    onSelected: (_) => setState(() => _selectedDog = dog),
                  ),
                );
              }).toList()
                ..add(
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _carbon,
                          shape: BoxShape.circle,
                          border: Border.all(color: _cardBorder),
                        ),
                        child: const Icon(Icons.add, color: _stoneGrey, size: 16),
                      ),
                    ),
                  ),
                ),
            ),
          ),
          const SizedBox(height: 16),

          // MONTH CONTROLLER BAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: _stoneGrey),
                onPressed: () {},
              ),
              const Text(
                'September 2026',
                style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _selectedDay = 16),
                    child: const Text('Today', style: TextStyle(color: _mint, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: _stoneGrey),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // VIEW SELECTOR TABS
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: _cardBorder)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Month', 'Week', 'Day', 'Year', 'Agenda'].map((view) {
                final isSel = _currentView == view;
                return InkWell(
                  onTap: () => setState(() => _currentView = view),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSel ? _mint : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      view,
                      style: TextStyle(
                        color: isSel ? _offWhite : _stoneGrey,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // CALENDAR GRID
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                // Weekday headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'].map((d) {
                    return SizedBox(
                      width: 36,
                      child: Text(
                        d,
                        style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Calendar Rows
                _buildCalendarWeek(['31', '1', '2', '3', '4', '5', '6'], [
                  null,
                  [_mint],
                  null,
                  [_mint, const Color(0xFF5D8FAF)],
                  null,
                  [const Color(0xFFDD6B20)],
                  null,
                ]),
                const SizedBox(height: 8),
                _buildCalendarWeek(['7', '8', '9', '10', '11', '12', '13'], [
                  [_mint],
                  null,
                  [const Color(0xFF5D8FAF)],
                  [const Color(0xFFE5484D)],
                  null,
                  [const Color(0xFFDD6B20), _mint],
                  null,
                ]),
                const SizedBox(height: 8),
                _buildCalendarWeek(['14', '15', '16', '17', '18', '19', '20'], [
                  [_offWhite],
                  [_mint],
                  [_mint, const Color(0xFF5D8FAF), const Color(0xFFE5484D)],
                  null,
                  [_offWhite],
                  [const Color(0xFF5D8FAF)],
                  null,
                ], highlightDay: 16),
                const SizedBox(height: 8),
                _buildCalendarWeek(['21', '22', '23', '24', '25', '26', '27'], [
                  [const Color(0xFFDD6B20)],
                  [_mint],
                  [const Color(0xFFE5484D)],
                  null,
                  [_offWhite],
                  [_mint, const Color(0xFFDD6B20)],
                  null,
                ]),
                const SizedBox(height: 8),
                _buildCalendarWeek(['28', '29', '30', '1', '2', '3', '4'], [
                  [_offWhite],
                  null,
                  [_mint, const Color(0xFF5D8FAF)],
                  null,
                  null,
                  null,
                  null,
                ]),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // TUESDAY, 16 SEPTEMBER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tuesday, $_selectedDay September',
                style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text('3 events', style: TextStyle(color: _stoneGrey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),

          // EVENT 1: Morning Obedience Session
          _buildDayEventCard(
            stripeColor: _forest,
            icon: Icons.fitness_center_outlined,
            title: 'Morning Obedience Session',
            subtitle: 'Murphy • 09:00 • 45 min',
            badge: null,
          ),
          const SizedBox(height: 10),

          // EVENT 2: Vet Check-Up
          _buildDayEventCard(
            stripeColor: const Color(0xFFE5484D),
            icon: Icons.favorite_outline,
            title: 'Vet Check-Up',
            subtitle: 'Murphy • 14:30 • Riverside Vets',
            badge: null,
          ),
          const SizedBox(height: 10),

          // EVENT 3: Complete Recall Goal
          _buildDayEventCard(
            stripeColor: _mint,
            icon: Icons.adjust_outlined,
            title: 'Complete Recall Goal',
            subtitle: 'Murphy • Due today',
            badge: 'PLANNED',
          ),
          const SizedBox(height: 16),

          // QUICK ACTIONS ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAction('+ Add Training'),
              _buildQuickAction('+ Add Health'),
              _buildQuickAction('+ Add Reminder'),
            ],
          ),
          const SizedBox(height: 28),

          // UPCOMING SECTION
          const Text(
            'UPCOMING',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildUpcomingTile(
                  dotColor: const Color(0xFF5D8FAF),
                  icon: Icons.pool_outlined,
                  title: 'Hydrotherapy Session',
                  subtitle: 'Thu 19 Sep • Murphy',
                  badge: null,
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildUpcomingTile(
                  dotColor: const Color(0xFFDD6B20),
                  icon: Icons.emoji_events_outlined,
                  title: 'Competition — IGP Trial',
                  subtitle: 'Sat 21 Sep • Murphy',
                  badge: 'PLANNED',
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildUpcomingTile(
                  dotColor: const Color(0xFFE5484D),
                  icon: Icons.medication_outlined,
                  title: 'Vaccination Due',
                  subtitle: 'Mon 23 Sep • Monty',
                  badge: null,
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildUpcomingTile(
                  dotColor: _offWhite,
                  icon: Icons.monitor_weight_outlined,
                  title: 'Weekly Weight Check',
                  subtitle: 'Wed 25 Sep • Minnie',
                  badge: null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCalendarWeek(List<String> days, List<List<Color>?> dots, {int? highlightDay}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (i) {
        final dayNum = int.tryParse(days[i]);
        final isSelected = dayNum == highlightDay && highlightDay != null;
        final dayDots = dots[i];
        final isDim = (dayNum != null && dayNum > 20 && i < 2) || (dayNum != null && dayNum < 10 && i > 3);

        return GestureDetector(
          onTap: () {
            if (dayNum != null) setState(() => _selectedDay = dayNum);
          },
          child: SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? _forest.withValues(alpha: 0.3) : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: _mint, width: 1.5) : null,
                  ),
                  child: Center(
                    child: Text(
                      days[i],
                      style: TextStyle(
                        color: isSelected ? _mint : (isDim ? _stoneGrey.withValues(alpha: 0.4) : _offWhite),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (dayDots != null)
                      ...dayDots.map((c) => Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                          ))
                    else
                      const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDayEventCard({
    required Color stripeColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required String? badge,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 4, color: stripeColor),
              const SizedBox(width: 14),
              Icon(icon, color: _stoneGrey, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                          if (badge != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF242A2E),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(badge, style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 6),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Action: $label'), backgroundColor: _forest));
      },
      child: Text(
        label,
        style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUpcomingTile({
    required Color dotColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required String? badge,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Icon(icon, color: _stoneGrey, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                    if (badge != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF242A2E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(badge, style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
        ],
      ),
    );
  }
}
