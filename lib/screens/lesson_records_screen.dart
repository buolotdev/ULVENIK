import 'package:flutter/material.dart';
import 'client_homework_screen.dart';

/// Screen: Lesson Records Log (Node / frame lesson_records.png)
/// Detailed historical ledger of all one-to-one coaching sessions,
/// behavioural consultations, and field drills with duration and homework links.
class LessonRecordsScreen extends StatefulWidget {
  final String clientName;
  final String dogsSubtitle;
  final int totalLessons;

  const LessonRecordsScreen({
    super.key,
    this.clientName = 'Emma Johnson',
    this.dogsSubtitle = 'Murphy & Bella',
    this.totalLessons = 12,
  });

  @override
  State<LessonRecordsScreen> createState() => _LessonRecordsScreenState();
}

class _LessonRecordsScreenState extends State<LessonRecordsScreen> {
  // Brand tokens
  static const Color _obsidian = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _cardBorder = Color(0x1FFFFFFF);

  void _showNewLessonSheet() {
    final titleController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Record New Lesson', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              style: const TextStyle(color: _offWhite),
              decoration: InputDecoration(
                labelText: 'Lesson Topic',
                labelStyle: const TextStyle(color: _stoneGrey),
                hintText: 'e.g. Loose Lead Walking — Phase 2',
                hintStyle: const TextStyle(color: _stoneGrey),
                filled: true,
                fillColor: _obsidian,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _cardBorder)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lesson record logged successfully'), backgroundColor: _forest),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Lesson Record'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLessonDetails(String title, String type, String date, String time, String location, String duration, List<String> dogs) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Text(type, style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                Text('$date · $time', style: const TextStyle(color: _stoneGrey, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: _stoneGrey, size: 14),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(color: _stoneGrey, fontSize: 13)),
                const SizedBox(width: 12),
                const Icon(Icons.timer_outlined, color: _stoneGrey, size: 14),
                const SizedBox(width: 4),
                Text(duration, style: const TextStyle(color: _stoneGrey, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: dogs.map((d) => Chip(
                backgroundColor: _obsidian,
                side: const BorderSide(color: _cardBorder),
                label: Text(d, style: const TextStyle(color: _offWhite, fontSize: 12)),
              )).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Close Details'),
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
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Lesson Records',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search lessons...'), backgroundColor: _forest),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: _offWhite),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter lessons...'), backgroundColor: _forest),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _showNewLessonSheet,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── CLIENT HEADER ROW ──────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF263033),
                    shape: BoxShape.circle,
                    border: Border.all(color: _cardBorder),
                  ),
                  child: const Icon(Icons.person_outline, color: _mint, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${widget.clientName} · ${widget.dogsSubtitle}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  '${widget.totalLessons} Lessons Total',
                  style: const TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ─── LESSON 1: 15 SEP ───────────────────────────────────────────
            _buildLessonCard(
              date: '15 Sep',
              time: '09:00',
              typeBadge: 'ONE-TO-ONE',
              title: 'Recall & Distraction Work',
              dogs: ['Murphy'],
              location: 'Chelmsford Training Ground',
              duration: '60 min',
              hasHomework: true,
              onTap: () => _showLessonDetails(
                'Recall & Distraction Work',
                'ONE-TO-ONE',
                '15 Sep 2026',
                '09:00',
                'Chelmsford Training Ground',
                '60 min',
                ['Murphy'],
              ),
            ),
            const SizedBox(height: 12),

            // ─── LESSON 2: 8 SEP ────────────────────────────────────────────
            _buildLessonCard(
              date: '8 Sep',
              time: '09:00',
              typeBadge: 'ONE-TO-ONE',
              title: 'Loose Lead Walking — Advanced',
              dogs: ['Murphy', 'Bella'],
              location: 'Private Session',
              duration: '60 min',
              hasHomework: false,
              onTap: () => _showLessonDetails(
                'Loose Lead Walking — Advanced',
                'ONE-TO-ONE',
                '8 Sep 2026',
                '09:00',
                'Private Session',
                '60 min',
                ['Murphy', 'Bella'],
              ),
            ),
            const SizedBox(height: 12),

            // ─── LESSON 3: 1 SEP ────────────────────────────────────────────
            _buildLessonCard(
              date: '1 Sep',
              time: '09:30',
              typeBadge: 'BEHAVIOUR CONSULTATION',
              title: 'Reactivity Assessment',
              dogs: ['Bella'],
              location: "Client's Home",
              duration: '90 min',
              hasHomework: false,
              onTap: () => _showLessonDetails(
                'Reactivity Assessment',
                'BEHAVIOUR CONSULTATION',
                '1 Sep 2026',
                '09:30',
                "Client's Home",
                '90 min',
                ['Bella'],
              ),
            ),
            const SizedBox(height: 20),

            // ─── MONTH HEADER: AUGUST 2026 ──────────────────────────────────
            const Text(
              'AUGUST 2026',
              style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
            const SizedBox(height: 12),

            // ─── LESSON 4: 28 AUG ───────────────────────────────────────────
            _buildLessonCard(
              date: '28 Aug',
              time: '10:00',
              typeBadge: 'ONE-TO-ONE',
              title: 'Foundation Heelwork',
              dogs: ['Murphy'],
              location: 'Chelmsford Training Ground',
              duration: '60 min',
              hasHomework: false,
              onTap: () => _showLessonDetails(
                'Foundation Heelwork',
                'ONE-TO-ONE',
                '28 Aug 2026',
                '10:00',
                'Chelmsford Training Ground',
                '60 min',
                ['Murphy'],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard({
    required String date,
    required String time,
    required String typeBadge,
    required String title,
    required List<String> dogs,
    required String location,
    required String duration,
    required bool hasHomework,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Date Column
            SizedBox(
              width: 54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(width: 1, height: 75, color: _cardBorder),
            const SizedBox(width: 14),

            // Right Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _obsidian,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: Text(
                          typeBadge,
                          style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...dogs.map((d) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF263033),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          d,
                          style: const TextStyle(color: _stoneGrey, fontSize: 11),
                        ),
                      )),
                      const Icon(Icons.location_on_outlined, color: _stoneGrey, size: 12),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _stoneGrey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        duration,
                        style: const TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                      if (hasHomework)
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClientHomeworkScreen(clientName: widget.clientName),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _forest.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _forest),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.assignment_outlined, color: _mint, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'Homework Assigned',
                                  style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
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
    );
  }
}

