import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ReportItem {
  String title;
  String client;
  String dog;
  String status; // 'SHARED', 'DRAFT', 'ARCHIVED', 'NOT SHARED'
  String dateRange;
  String details;
  String size;

  ReportItem({
    required this.title,
    required this.client,
    required this.dog,
    required this.status,
    required this.dateRange,
    required this.details,
    required this.size,
  });
}

class TrainerReportsScreen extends StatefulWidget {
  const TrainerReportsScreen({super.key});

  @override
  State<TrainerReportsScreen> createState() => _TrainerReportsScreenState();
}

class _TrainerReportsScreenState extends State<TrainerReportsScreen> {
  String _activeTab = 'All Reports';
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  final List<ReportItem> _reports = [
    ReportItem(
      title: 'Murphy — Progress Review',
      client: 'Emma Johnson',
      dog: 'Murphy',
      status: 'SHARED',
      dateRange: 'Last 30 Days • 28 Aug – 28 Sep 2026',
      details: '8 Lessons • 3 Goals Completed • 100% Homework',
      size: '2.4 MB • PDF',
    ),
    ReportItem(
      title: 'Bella — Behaviour Consultation',
      client: 'James Harlow',
      dog: 'Bella',
      status: 'DRAFT',
      dateRange: 'Last 7 Days',
      details: '3 Lessons • 1 Goal In Progress',
      size: '1.8 MB • PDF',
    ),
    ReportItem(
      title: 'Murphy — 3 Month Summary',
      client: 'Emma Johnson',
      dog: 'Murphy',
      status: 'SHARED',
      dateRange: 'Jun – Sep 2026 (90 Days)',
      details: '24 Lessons • 5 Goals Completed',
      size: '3.1 MB • PDF',
    ),
    ReportItem(
      title: 'Murphy — Initial Assessment',
      client: 'Emma Johnson',
      dog: 'Murphy',
      status: 'ARCHIVED',
      dateRange: 'Jul 2026',
      details: 'Baseline profile logged',
      size: '1.2 MB • PDF',
    ),
    ReportItem(
      title: 'IGP Tracking & Protection Review',
      client: 'Marcus Vance',
      dog: 'Luna',
      status: 'NOT SHARED',
      dateRange: 'Jul 2026 – Sep 2026',
      details: 'Competition Progress Report',
      size: '3.1 MB • PDF',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _createNewReport() {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        title: const Text('Create New Report', style: TextStyle(color: _offWhite)),
        content: TextField(
          controller: titleCtrl,
          style: const TextStyle(color: _offWhite),
          decoration: const InputDecoration(
            labelText: 'Report Title',
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
                  _reports.insert(
                    0,
                    ReportItem(
                      title: titleCtrl.text.trim(),
                      client: 'Emma Johnson',
                      dog: 'Murphy',
                      status: 'DRAFT',
                      dateRange: 'Current Month',
                      details: 'Draft Progress Review',
                      size: '1.0 MB • PDF',
                    ),
                  );
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Create', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredReports = _reports.where((r) {
      if (_activeTab == 'Shared' && r.status != 'SHARED') return false;
      if (_activeTab == 'Drafts' && r.status != 'DRAFT') return false;
      if (_activeTab == 'Archived' && r.status != 'ARCHIVED') return false;
      if (_searchController.text.trim().isNotEmpty) {
        final q = _searchController.text.toLowerCase();
        return r.title.toLowerCase().contains(q) ||
            r.client.toLowerCase().contains(q) ||
            r.dog.toLowerCase().contains(q);
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
          'Reports',
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _createNewReport,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Summary 3-col Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  _buildSummaryCol('7', 'Total Reports'),
                  Container(width: 1, height: 32, color: _cardBorder),
                  _buildSummaryCol('4', 'Shared'),
                  Container(width: 1, height: 32, color: _cardBorder),
                  _buildSummaryCol('1', 'Draft'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tab bar
            Row(
              children: ['All Reports', 'Shared', 'Drafts', 'Archived'].map((tab) {
                final isSel = _activeTab == tab;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _activeTab = tab),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSel ? const Color(0xFF34D399) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: isSel ? _offWhite : _stoneGrey,
                          fontSize: 13,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            if (_showSearch) ...[
              const SizedBox(height: 12),
              Container(
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
                    hintText: 'Search reports...',
                    hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: _stoneGrey, size: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, color: _stoneGrey, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _showSearch = false);
                      },
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'RECENT REPORTS',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Sorted by date',
                  style: TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Reports List
            ...filteredReports.map((report) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF14171A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: Icon(
                            report.status == 'DRAFT'
                                ? Icons.edit_note
                                : report.status == 'ARCHIVED'
                                    ? Icons.archive_outlined
                                    : Icons.description_outlined,
                            color: _stoneGrey,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      report.title,
                                      style: const TextStyle(
                                        color: _offWhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  _buildStatusBadge(report.status),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    report.client,
                                    style: const TextStyle(color: _stoneGrey, fontSize: 12),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('•', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF262C30),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      report.dog,
                                      style: const TextStyle(
                                        color: _offWhite,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 12, color: _stoneGrey),
                                  const SizedBox(width: 4),
                                  Text(report.dateRange, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(report.details, style: const TextStyle(color: _offWhite, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                      ],
                    ),
                    const Divider(color: _cardBorder, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          report.size,
                          style: const TextStyle(color: _stoneGrey, fontSize: 11),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Report copied.'), backgroundColor: _forest),
                                );
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.copy, size: 14, color: _mint),
                                  SizedBox(width: 4),
                                  Text('Copy', style: TextStyle(color: _mint, fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            InkWell(
                              onTap: () {
                                setState(() => _reports.remove(report));
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.delete_outline, size: 14, color: Color(0xFFEF4444)),
                                  SizedBox(width: 4),
                                  Text('Delete', style: TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCol(String count, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = const Color(0xFF262C30);
    Color fg = _stoneGrey;

    if (status == 'SHARED') {
      bg = const Color(0x1F34D399);
      fg = const Color(0xFF34D399);
    } else if (status == 'DRAFT') {
      bg = const Color(0xFF1F2937);
      fg = const Color(0xFF9CA3AF);
    } else if (status == 'NOT SHARED') {
      bg = const Color(0xFF262C30);
      fg = _stoneGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: fg,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
