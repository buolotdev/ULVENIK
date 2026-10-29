import 'package:flutter/material.dart';
import 'homework_details_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class HomeworkItem {
  String title;
  String status; // 'OVERDUE', 'IN PROGRESS', 'NOT STARTED', 'COMPLETED'
  String priority; // 'HIGH', etc.
  List<String> dogs;
  double progress;
  String assignedDate;
  String dueDate;
  bool isFinished;

  HomeworkItem({
    required this.title,
    required this.status,
    this.priority = '',
    required this.dogs,
    required this.progress,
    required this.assignedDate,
    required this.dueDate,
    this.isFinished = false,
  });
}

class ClientHomeworkScreen extends StatefulWidget {
  final String clientName;

  const ClientHomeworkScreen({
    super.key,
    this.clientName = 'Emma Johnson',
  });

  @override
  State<ClientHomeworkScreen> createState() => _ClientHomeworkScreenState();
}

class _ClientHomeworkScreenState extends State<ClientHomeworkScreen> {
  String _activeFilter = 'ACTIVE';
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  final List<HomeworkItem> _homeworkList = [
    HomeworkItem(
      title: 'IGP Scent Pad Precision & Food Steps',
      status: 'OVERDUE',
      priority: 'HIGH',
      dogs: ['Murphy', 'Rex'],
      progress: 0.35,
      assignedDate: 'Assigned 12 Nov',
      dueDate: 'Due 17 Nov',
    ),
    HomeworkItem(
      title: 'Week 4 Focus & Decoy Engagement Reps',
      status: 'IN PROGRESS',
      priority: '',
      dogs: ['Murphy'],
      progress: 0.68,
      assignedDate: 'Assigned 14 Nov',
      dueDate: 'Due 22 Nov',
    ),
    HomeworkItem(
      title: 'Emergency Recall Signal Calibration (2×',
      status: 'NOT STARTED',
      priority: '',
      dogs: ['Murphy'],
      progress: 0.0,
      assignedDate: 'Assigned 16 Nov',
      dueDate: 'Due 25 Nov',
    ),
    HomeworkItem(
      title: 'Baseline A-Frame Descent Pause Work',
      status: 'COMPLETED',
      priority: '',
      dogs: ['Murphy'],
      progress: 1.0,
      assignedDate: 'Assigned 05 Nov',
      dueDate: 'Finished 11 Nov',
      isFinished: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addHomeworkDialog() {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        title: const Text('Assign Homework', style: TextStyle(color: _offWhite)),
        content: TextField(
          controller: titleCtrl,
          style: const TextStyle(color: _offWhite),
          decoration: const InputDecoration(
            labelText: 'Assignment Title',
            labelStyle: TextStyle(color: _stoneGrey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _forest),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _homeworkList.insert(
                    0,
                    HomeworkItem(
                      title: titleCtrl.text.trim(),
                      status: 'IN PROGRESS',
                      dogs: ['Murphy'],
                      progress: 0.1,
                      assignedDate: 'Assigned Today',
                      dueDate: 'Due in 7 days',
                    ),
                  );
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Assign', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _homeworkList.where((h) {
      if (_activeFilter == 'ACTIVE' && (h.status == 'COMPLETED')) return false;
      if (_activeFilter == 'COMPLETED' && h.status != 'COMPLETED') return false;
      if (_activeFilter == 'OVERDUE' && h.status != 'OVERDUE') return false;
      if (_activeFilter == 'HIGH PRIORITY' && h.priority != 'HIGH') return false;
      if (_searchController.text.trim().isNotEmpty) {
        return h.title.toLowerCase().contains(_searchController.text.toLowerCase());
      }
      return true;
    }).toList();

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
          'Homework',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite, size: 22),
            onPressed: () => setState(() => _showSearch = !_showSearch),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: _offWhite, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: _offWhite, size: 24),
            onPressed: _addHomeworkDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _addHomeworkDialog,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            if (_showSearch) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: _offWhite, fontSize: 14),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search homework...',
                    hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: _stoneGrey, size: 20),
                    suffixIcon: TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _showSearch = false);
                      },
                      child: const Text('Cancel', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],

            // Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['ACTIVE', 'COMPLETED', 'OVERDUE', 'HIGH PRIORITY'].map((f) {
                  final isSel = _activeFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _activeFilter = f),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFF14241E) : const Color(0xFF14171A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSel ? const Color(0xFF34D399) : _cardBorder),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: isSel ? const Color(0xFF34D399) : _stoneGrey,
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HOMEWORK (${filtered.length})',
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Text(
                  'Sort: Earliest Due',
                  style: TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Homework Cards
            ...filtered.map((item) {
              final isOverdue = item.status == 'OVERDUE';
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeworkDetailsScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: isOverdue
                            ? const Border(left: BorderSide(color: Color(0xFFEF4444), width: 4))
                            : null,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildStatusBadge(item.status),
                              if (item.priority == 'HIGH') ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0x33EF4444),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'HIGH',
                                    style: TextStyle(
                                      color: Color(0xFFEF4444),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: item.dogs.map((d) {
                              return Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF14171A),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.pets, size: 10, color: _stoneGrey),
                                    const SizedBox(width: 4),
                                    Text(d, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Progress', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                              Text(
                                '${(item.progress * 100).toInt()}%',
                                style: const TextStyle(color: _offWhite, fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: item.progress,
                              backgroundColor: const Color(0xFF262C30),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isOverdue ? const Color(0xFF34D399) : const Color(0xFF34D399),
                              ),
                              minHeight: 5,
                            ),
                          ),
                          const Divider(color: _cardBorder, height: 24),
                          Row(
                            children: [
                              Text(
                                item.assignedDate,
                                style: const TextStyle(color: _stoneGrey, fontSize: 11),
                              ),
                              const SizedBox(width: 6),
                              const Text('•', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                              const SizedBox(width: 6),
                              Text(
                                item.dueDate,
                                style: TextStyle(
                                  color: isOverdue ? const Color(0xFFEF4444) : _stoneGrey,
                                  fontSize: 11,
                                  fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'SWIPE GESTURE PREVIEW',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                Text('swipe left on cards', style: TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 8),

            // Swipe Preview Row
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Hold & swipe item...', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    color: const Color(0xFF1E2B2A),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.visibility_outlined, color: _mint, size: 18),
                        SizedBox(height: 2),
                        Text('VIEW', style: TextStyle(color: _mint, fontSize: 9, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    color: const Color(0xFF183329),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.edit_outlined, color: Color(0xFF34D399), size: 18),
                        SizedBox(height: 2),
                        Text('EDIT', style: TextStyle(color: Color(0xFF34D399), fontSize: 9, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFF342323),
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(14)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.archive_outlined, color: Color(0xFFEF4444), size: 18),
                        SizedBox(height: 2),
                        Text('ARCHIVE', style: TextStyle(color: Color(0xFFEF4444), fontSize: 9, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = const Color(0xFF262C30);
    Color fg = _stoneGrey;

    if (status == 'OVERDUE') {
      bg = const Color(0x33EF4444);
      fg = const Color(0xFFEF4444);
    } else if (status == 'IN PROGRESS') {
      bg = const Color(0x1F34D399);
      fg = const Color(0xFF34D399);
    } else if (status == 'COMPLETED') {
      bg = const Color(0x1F34D399);
      fg = const Color(0xFF34D399);
    } else if (status == 'NOT STARTED') {
      bg = const Color(0xFF262C30);
      fg = _stoneGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
