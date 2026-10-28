import 'package:flutter/material.dart';
import 'timeline_dashboard_screen.dart';
import 'timeline_statistics_screen.dart';
import 'timeline_favourites_screen.dart';
import 'timeline_archive_screen.dart';
import 'record_session_screen.dart';

/// Timeline Export Screen
/// Figma Frames:
/// - Line 184: Timeline Export - Empty State (Node 781:6334)
/// - Line 185: Timeline Export - Populated State (Node 781:6362)
class TimelineExportScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineExportScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Koda',
  });

  @override
  State<TimelineExportScreen> createState() => _TimelineExportScreenState();
}

class _TimelineExportScreenState extends State<TimelineExportScreen>
    with SingleTickerProviderStateMixin {
  // Exact Ulvenik Obsidian & Carbon luxury palette
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _carbonBorder = Color(0xFF272B29);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _forestGreen = Color(0xFF2E6B57);
  static const Color _whiteText = Color(0xFFE1E3E0);
  static const Color _stoneGrey = Color(0xFFA7B0AB);

  late bool _isEmpty;
  late String _currentDog;

  // Form State
  String _exportType = 'date_range'; // 'date_range' | 'specific_events'
  String _selectedDatePreset = 'This Year'; // 'Last 30 Days' | 'This Year' | 'All Time' | 'Custom'
  String _selectedFormat = 'pdf'; // 'pdf' | 'csv'

  DateTime _startDate = DateTime(2026, 1, 1);
  DateTime _endDate = DateTime(2026, 12, 31);
  int _dayCount = 365;

  // Specific events selection state
  final Map<String, bool> _selectedEventCategories = {
    'Training Sessions': true,
    'Health & Vet Records': true,
    'Strength & Conditioning': true,
    'Competitions & Trials': true,
    'Milestones & Media': false,
  };

  // Dog Metadata
  final Map<String, Map<String, String>> _dogsMeta = {
    'Koda': {
      'breed': 'Border Collie',
      'age': '3 Years',
      'avatar':
          'https://images.unsplash.com/photo-1517849845537-4d257902454a?w=150&auto=format&fit=crop&q=80',
    },
    'Atlas': {
      'breed': 'German Shepherd',
      'age': '4 Years',
      'avatar':
          'https://images.unsplash.com/photo-1589941013453-ec89f33b5455?w=150&auto=format&fit=crop&q=80',
    },
    'Nova': {
      'breed': 'Belgian Malinois',
      'age': '2 Years',
      'avatar':
          'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=150&auto=format&fit=crop&q=80',
    },
  };

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _currentDog = widget.initialDog;
    _updateDateRangeByPreset(_selectedDatePreset);
  }

  void _updateDateRangeByPreset(String preset) {
    setState(() {
      _selectedDatePreset = preset;
      final now = DateTime(2026, 10, 26);
      if (preset == 'Last 30 Days') {
        _startDate = now.subtract(const Duration(days: 30));
        _endDate = now;
        _dayCount = 30;
      } else if (preset == 'This Year') {
        _startDate = DateTime(2026, 1, 1);
        _endDate = DateTime(2026, 12, 31);
        _dayCount = 365;
      } else if (preset == 'All Time') {
        _startDate = DateTime(2024, 1, 1);
        _endDate = now;
        _dayCount = now.difference(_startDate).inDays;
      }
    });
  }

  Future<void> _pickCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2027),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _mint,
              onPrimary: _obsidian,
              surface: _carbon,
              onSurface: _whiteText,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: _carbon),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDatePreset = 'Custom';
        _startDate = picked.start;
        _endDate = picked.end;
        _dayCount = picked.duration.inDays + 1;
      });
    }
  }

  void _toggleState() {
    setState(() {
      _isEmpty = !_isEmpty;
    });
  }

  void _showDogSelectorModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Dog for Export',
                    style: TextStyle(
                      color: _whiteText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: _stoneGrey, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._dogsMeta.entries.map((entry) {
                final dog = entry.key;
                final meta = entry.value;
                final isSelected = dog == _currentDog;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? _forestGreen.withValues(alpha: 0.25) : _obsidian,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? _mint : _carbonBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(meta['avatar']!),
                    ),
                    title: Text(
                      dog,
                      style: TextStyle(
                        color: isSelected ? _whiteText : _stoneGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '${meta['breed']} · ${meta['age']}',
                      style: const TextStyle(color: _stoneGrey, fontSize: 12),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: _mint, size: 20)
                        : null,
                    onTap: () {
                      setState(() {
                        _currentDog = dog;
                        // Atlas demonstrates empty state; Koda populated
                        if (dog == 'Atlas') {
                          _isEmpty = true;
                        } else {
                          _isEmpty = false;
                        }
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _startExportProcess() {
    // Show animated exporting bottom sheet with simulated compilation
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return _ExportProgressModal(
          dogName: _currentDog,
          exportType: _exportType,
          format: _selectedFormat,
          dateRangeStr: _formatDateRange(_startDate, _endDate),
          dayCount: _dayCount,
        );
      },
    );
  }


  String _formatDateRange(DateTime start, DateTime end) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[start.month - 1]} ${start.day}, ${start.year} - ${months[end.month - 1]} ${end.day}, ${end.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: _isEmpty ? _buildEmptyState() : _buildPopulatedState(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // -------------------------------------------------------------
  // TOP APP BAR (Figma Header)
  // -------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _whiteText, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Timeline Export',
        style: TextStyle(
          color: _whiteText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: _whiteText, size: 22),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: _carbonBorder),
          ),
          onSelected: (val) {
            if (val == 'toggle_state') {
              _toggleState();
            } else if (val == 'switch_dog') {
              _showDogSelectorModal();
            } else if (val == 'favourites') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineFavouritesScreen()),
              );
            } else if (val == 'archive') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineArchiveScreen()),
              );
            } else if (val == 'statistics') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineStatisticsScreen()),
              );
            }
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: 'toggle_state',
              child: Row(
                children: [
                  Icon(
                    _isEmpty ? Icons.file_download_outlined : Icons.hourglass_empty,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isEmpty ? 'Show Populated State' : 'Show Empty State',
                    style: const TextStyle(color: _whiteText, fontSize: 13),
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'favourites',
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Color(0xFFB8920A), size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Favourites', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'archive',
              child: Row(
                children: [
                  Icon(Icons.archive_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Archive', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'switch_dog',
              child: Row(
                children: [
                  Icon(Icons.pets, color: _stoneGrey, size: 18),
                  SizedBox(width: 10),
                  Text('Switch Dog Profile', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'statistics',
              child: Row(
                children: [
                  Icon(Icons.insights_outlined, color: _stoneGrey, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Statistics', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: _carbonBorder.withValues(alpha: 0.5),
          height: 1,
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // POPULATED STATE (Figma Node 781:6362)
  // -------------------------------------------------------------
  Widget _buildPopulatedState() {
    final meta = _dogsMeta[_currentDog] ?? _dogsMeta['Koda']!;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Canine Profile Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(meta['avatar']!),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentDog,
                            style: const TextStyle(
                              color: _whiteText,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${meta['breed']} · ${meta['age']}',
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _showDogSelectorModal,
                      style: TextButton.styleFrom(
                        foregroundColor: _mint,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      child: const Text('Change', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Section 1: EXPORT TYPE
                _buildSectionHeader('EXPORT TYPE'),
                const SizedBox(height: 8),
                _buildExportTypeCard(),

                const SizedBox(height: 24),

                // Section 2: DATE RANGE or SPECIFIC EVENTS
                if (_exportType == 'date_range') ...[
                  _buildSectionHeader('DATE RANGE'),
                  const SizedBox(height: 8),
                  _buildDateRangeCard(),
                ] else ...[
                  _buildSectionHeader('EVENT CATEGORIES'),
                  const SizedBox(height: 8),
                  _buildSpecificEventsCard(),
                ],

                const SizedBox(height: 24),

                // Section 3: FORMAT
                _buildSectionHeader('FORMAT'),
                const SizedBox(height: 8),
                _buildFormatCard(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Bottom Sticky Action Bar (Cancel + Generate Export)
        _buildBottomActionBar(isEnabled: true),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }

  // -------------------------------------------------------------
  // SECTION 1: EXPORT TYPE CARD (Date Range vs Specific Events)
  // -------------------------------------------------------------
  Widget _buildExportTypeCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _carbonBorder),
      ),
      child: Column(
        children: [
          _buildRadioOptionRow(
            icon: Icons.calendar_month_outlined,
            title: 'Date Range',
            isSelected: _exportType == 'date_range',
            onTap: () {
              setState(() => _exportType = 'date_range');
            },
          ),
          const Divider(height: 1, thickness: 1, color: _carbonBorder),
          _buildRadioOptionRow(
            icon: Icons.checklist_rtl_outlined,
            title: 'Specific Events',
            isSelected: _exportType == 'specific_events',
            onTap: () {
              setState(() => _exportType = 'specific_events');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOptionRow({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? _mint : _stoneGrey, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _whiteText,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildRadioIndicator(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioIndicator(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? _forestGreen : Colors.transparent,
        border: Border.all(
          color: isSelected ? _mint : const Color(0xFF3E4549),
          width: 1.5,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _mint,
                ),
              ),
            )
          : null,
    );
  }

  // -------------------------------------------------------------
  // SECTION 2: DATE RANGE CARD (Pills + Date Box)
  // -------------------------------------------------------------
  Widget _buildDateRangeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _carbonBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Pills Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildDatePill('Last 30 Days'),
                const SizedBox(width: 8),
                _buildDatePill('This Year'),
                const SizedBox(width: 8),
                _buildDatePill('All Time'),
                const SizedBox(width: 8),
                _buildDatePill('Custom', isCustomPicker: true),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Date Display Box
          GestureDetector(
            onTap: _pickCustomDateRange,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: _obsidian,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _carbonBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDateRange(_startDate, _endDate),
                    style: const TextStyle(
                      color: _whiteText,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$_dayCount Days',
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePill(String title, {bool isCustomPicker = false}) {
    final isSelected = _selectedDatePreset == title;
    return GestureDetector(
      onTap: () {
        if (isCustomPicker) {
          _pickCustomDateRange();
        } else {
          _updateDateRangeByPreset(title);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _forestGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _forestGreen : const Color(0xFF2E3438),
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : _stoneGrey,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // SPECIFIC EVENTS MULTI-SELECT CARD
  // -------------------------------------------------------------
  Widget _buildSpecificEventsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _carbonBorder),
      ),
      child: Column(
        children: _selectedEventCategories.entries.map((entry) {
          final label = entry.key;
          final isChecked = entry.value;
          return CheckboxListTile(
            activeColor: _mint,
            checkColor: _obsidian,
            title: Text(
              label,
              style: const TextStyle(color: _whiteText, fontSize: 14),
            ),
            value: isChecked,
            onChanged: (val) {
              setState(() {
                _selectedEventCategories[label] = val ?? false;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  // -------------------------------------------------------------
  // SECTION 3: FORMAT CARD (PDF Document + CSV Option)
  // -------------------------------------------------------------
  Widget _buildFormatCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _carbonBorder),
      ),
      child: Column(
        children: [
          // PDF Document Option
          InkWell(
            onTap: () => setState(() => _selectedFormat = 'pdf'),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _carbonBorder),
                    ),
                    child: const Icon(Icons.picture_as_pdf_outlined, color: _mint, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PDF Document',
                          style: TextStyle(
                            color: _whiteText,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Best for printing & sharing',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildRadioIndicator(_selectedFormat == 'pdf'),
                ],
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1, color: _carbonBorder),

          // CSV Spreadsheet Option
          InkWell(
            onTap: () => setState(() => _selectedFormat = 'csv'),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _carbonBorder),
                    ),
                    child: const Icon(Icons.table_chart_outlined, color: _stoneGrey, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CSV Spreadsheet',
                          style: TextStyle(
                            color: _whiteText,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Raw telemetry data for Excel / Sheets',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildRadioIndicator(_selectedFormat == 'csv'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // EMPTY STATE (Figma Node 781:6334)
  // -------------------------------------------------------------
  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Large Document Outline Icon
                Icon(
                  Icons.article_outlined,
                  size: 58,
                  color: _stoneGrey.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Timeline Data',
                  style: TextStyle(
                    color: _whiteText,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'There aren\'t any Timeline events recorded for $_currentDog yet. Start logging your journey to generate reports.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 28),

                // Go to Timeline -> Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forestGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TimelineDashboardScreen()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Go to Timeline',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Disabled Bottom Action Bar
        _buildBottomActionBar(isEnabled: false),
      ],
    );
  }

  // -------------------------------------------------------------
  // STICKY BOTTOM ACTION BAR (Cancel + Generate Export Button)
  // -------------------------------------------------------------
  Widget _buildBottomActionBar({required bool isEnabled}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: _obsidian,
        border: Border(top: BorderSide(color: _carbonBorder.withValues(alpha: 0.8))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: _whiteText,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Generate Export Button
            ElevatedButton(
              onPressed: isEnabled ? _startExportProcess : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled ? _forestGreen : const Color(0xFF1E2428),
                foregroundColor: isEnabled ? Colors.white : const Color(0xFF5D6468),
                disabledBackgroundColor: const Color(0xFF1E2428),
                disabledForegroundColor: const Color(0xFF5D6468),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Generate Export',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isEnabled ? Colors.white : const Color(0xFF5D6468),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.file_download_outlined,
                    size: 18,
                    color: isEnabled ? Colors.white : const Color(0xFF5D6468),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // UNIFIED 5-TAB BOTTOM NAVIGATION
  // -------------------------------------------------------------
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        border: Border(top: BorderSide(color: _carbonBorder.withValues(alpha: 0.8))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', false, () {
              Navigator.popUntil(context, (r) => r.isFirst);
            }),
            _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
              _showDogSelectorModal();
            }),
            _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecordSessionScreen()),
              );
            }),
            _buildNavItem(Icons.event_note, 'Timeline', true, () {
              // Active
            }),
            _buildNavItem(Icons.more_horiz_outlined, 'More', false, () {
              _showDogSelectorModal();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? _mint : _stoneGrey,
            size: 22,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isActive ? _mint : _stoneGrey,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simulated Export Progress Bottom Sheet
class _ExportProgressModal extends StatefulWidget {
  final String dogName;
  final String exportType;
  final String format;
  final String dateRangeStr;
  final int dayCount;

  const _ExportProgressModal({
    required this.dogName,
    required this.exportType,
    required this.format,
    required this.dateRangeStr,
    required this.dayCount,
  });

  @override
  State<_ExportProgressModal> createState() => _ExportProgressModalState();
}

class _ExportProgressModalState extends State<_ExportProgressModal> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbonBorder = Color(0xFF272B29);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _forestGreen = Color(0xFF2E6B57);
  static const Color _whiteText = Color(0xFFE1E3E0);
  static const Color _stoneGrey = Color(0xFFA7B0AB);

  double _progress = 0.0;
  bool _isComplete = false;
  String _statusText = 'Compiling telemetry data...';

  @override
  void initState() {
    super.initState();
    _startSimulatedExport();
  }

  void _startSimulatedExport() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _progress = 0.35;
      _statusText = 'Formatting ${widget.format.toUpperCase()} layout & typography...';
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() {
      _progress = 0.75;
      _statusText = 'Rendering activity graphs & category charts...';
    });

    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() {
      _progress = 1.0;
      _isComplete = true;
      _statusText = 'Export Ready';
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileName = 'Ulvenik_${widget.dogName}_Report.${widget.format}';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _forestGreen.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _isComplete ? Icons.check_circle_outline : Icons.file_download,
                    color: _mint,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isComplete ? 'Export Complete' : 'Generating Export',
                      style: const TextStyle(
                        color: _whiteText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _statusText,
                      style: const TextStyle(color: _stoneGrey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: _obsidian,
                valueColor: const AlwaysStoppedAnimation<Color>(_mint),
                minHeight: 8,
              ),
            ),

            const SizedBox(height: 20),

            // File Details Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _obsidian,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _carbonBorder),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.format == 'pdf'
                        ? Icons.picture_as_pdf_outlined
                        : Icons.table_chart_outlined,
                    color: _mint,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          style: const TextStyle(
                            color: _whiteText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.dateRangeStr} · ${widget.dayCount} Days',
                          style: const TextStyle(color: _stoneGrey, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  if (_isComplete)
                    const Text(
                      '2.4 MB',
                      style: TextStyle(color: _stoneGrey, fontSize: 12),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            if (_isComplete)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _whiteText,
                        side: const BorderSide(color: _carbonBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Dismiss'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forestGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share File', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel Export', style: TextStyle(color: _stoneGrey)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
