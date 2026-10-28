import 'package:flutter/material.dart';
import 'record_session_screen.dart';
import 'export_screen.dart';
import 'sc_archive_screen.dart';
import 'sc_settings_screen.dart';

/// Session Template Model
class SessionTemplateItem {
  final String id;
  String title;
  String activityName;
  IconData activityIcon;
  int usedCount;
  String lastUsed;
  bool isFavorite;
  int durationMinutes;
  String equipment;
  String? notes;

  SessionTemplateItem({
    required this.id,
    required this.title,
    required this.activityName,
    required this.activityIcon,
    required this.usedCount,
    required this.lastUsed,
    this.isFavorite = false,
    this.durationMinutes = 20,
    this.equipment = 'Standard Gear',
    this.notes,
  });
}

/// Screen representing "Session Templates" covering both:
/// 1. Populated State (Line 157 in Handover Doc)
/// 2. Empty State (Line 156 in Handover Doc)
///
/// Features search bar with voice search simulation, dynamic sorting and filtering,
/// interactive star favorites, one-tap "Start Session", template detail sheet,
/// create new template flow, and dual state toggle.
class SessionTemplatesScreen extends StatefulWidget {
  final bool initialEmpty;

  const SessionTemplatesScreen({
    super.key,
    this.initialEmpty = false,
  });

  @override
  State<SessionTemplatesScreen> createState() => _SessionTemplatesScreenState();
}

class _SessionTemplatesScreenState extends State<SessionTemplatesScreen> {
  // Scandinavian Obsidian / Carbon Dark Theme
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _surfaceVariant = Color(0xFF323533);
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _stoneGrey = Color(0xFFA7B0AB);

  static final _hairlineSide =
      BorderSide(color: Colors.white.withValues(alpha: 0.08));
  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));

  late bool _isEmpty;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _currentSort = 'Recent'; // 'Recent', 'Most Used', 'A-Z', 'Favorites'
  String _selectedActivityFilter = 'All Activities';

  late List<SessionTemplateItem> _templates;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _initializeTemplates();

    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _initializeTemplates() {
    _templates = [
      SessionTemplateItem(
        id: 'tmpl-1',
        title: 'Treadmill Endurance Block',
        activityName: 'Treadmill Running',
        activityIcon: Icons.directions_run,
        usedCount: 12,
        lastUsed: 'yesterday',
        isFavorite: true,
        durationMinutes: 25,
        equipment: 'Motorized Slatmill, Heart Monitor',
        notes:
            'Warm up 5 min at 4 km/h, 15 min sustained pace at 8 km/h, 5 min cool down walk.',
      ),
      SessionTemplateItem(
        id: 'tmpl-2',
        title: 'Agility Ladder Warm-Up',
        activityName: 'Agility Ladder',
        activityIcon: Icons.format_list_bulleted,
        usedCount: 7,
        lastUsed: '3 days ago',
        isFavorite: true,
        durationMinutes: 15,
        equipment: '10-Rung Ground Agility Ladder',
        notes:
            'Quick two-in two-out footwork drills to activate paw placement and stifle joint mobility.',
      ),
      SessionTemplateItem(
        id: 'tmpl-3',
        title: 'Weighted Drag Session',
        activityName: 'Resistance Drag',
        activityIcon: Icons.fitness_center,
        usedCount: 3,
        lastUsed: '2 weeks ago',
        isFavorite: false,
        durationMinutes: 20,
        equipment: 'Sled Drag Harness, 4kg Weight Plate',
        notes:
            'Posterior chain development. 4x 30m drag pulls with 90s recovery interval between sets.',
      ),
      SessionTemplateItem(
        id: 'tmpl-4',
        title: 'Balance & Proprioception',
        activityName: 'Balance Board',
        activityIcon: Icons.balance,
        usedCount: 1,
        lastUsed: '1 month ago',
        isFavorite: false,
        durationMinutes: 20,
        equipment: 'K9 FitBone, Circular Wobble Board',
        notes:
            'Core stabilization drills. High value treat lures for head turns while maintaining balanced stance.',
      ),
      SessionTemplateItem(
        id: 'tmpl-5',
        title: 'Hydro Sprint Intervals',
        activityName: 'Swimming Fitness',
        activityIcon: Icons.pool,
        usedCount: 16,
        lastUsed: '4 days ago',
        isFavorite: true,
        durationMinutes: 30,
        equipment: 'Canine Floatation Vest & 15m Long Line',
        notes:
            'High-aerobic non-impact sprint intervals in water with structured recovery pauses.',
      ),
      SessionTemplateItem(
        id: 'tmpl-6',
        title: 'Hill Sprints & Acceleration',
        activityName: 'Hill Sprints',
        activityIcon: Icons.terrain,
        usedCount: 5,
        lastUsed: '1 week ago',
        isFavorite: false,
        durationMinutes: 15,
        equipment: 'Tactical Harness, Long Line',
        notes:
            '15-degree incline sprint burst sets with handler recall to develop rear drive power.',
      ),
    ];
  }

  void _toggleState() {
    setState(() {
      _isEmpty = !_isEmpty;
    });
  }

  // Filtered and sorted templates list
  List<SessionTemplateItem> get _filteredTemplates {
    var list = _templates.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery) ||
          item.activityName.toLowerCase().contains(_searchQuery) ||
          (item.notes?.toLowerCase().contains(_searchQuery) ?? false);

      final matchesActivity = _selectedActivityFilter == 'All Activities' ||
          item.activityName == _selectedActivityFilter ||
          (_selectedActivityFilter == 'Favorites' && item.isFavorite);

      return matchesSearch && matchesActivity;
    }).toList();

    switch (_currentSort) {
      case 'Recent':
        // preserve original order or by last used
        break;
      case 'Most Used':
        list.sort((a, b) => b.usedCount.compareTo(a.usedCount));
        break;
      case 'A-Z':
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Favorites':
        list.sort((a, b) => (b.isFavorite ? 1 : 0).compareTo(a.isFavorite ? 1 : 0));
        break;
      default:
        break;
    }

    return list;
  }

  // ===========================================================================
  // INTERACTIVE ACTIONS & MODALS
  // ===========================================================================

  void _toggleFavorite(SessionTemplateItem item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
    });
  }

  void _startSessionWithTemplate(SessionTemplateItem item) {
    setState(() {
      item.usedCount += 1;
      item.lastUsed = 'just now';
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordSessionScreen(
          initialActivityName: item.activityName,
          startWithActivity: true,
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
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
              'SORT TEMPLATES',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.08,
              ),
            ),
            const SizedBox(height: 12),
            ...[
              {'label': 'Recently Used', 'value': 'Recent', 'icon': Icons.schedule},
              {'label': 'Most Frequently Used', 'value': 'Most Used', 'icon': Icons.repeat},
              {'label': 'Alphabetical (A - Z)', 'value': 'A-Z', 'icon': Icons.sort_by_alpha},
              {'label': 'Favorites First', 'value': 'Favorites', 'icon': Icons.star},
            ].map((opt) {
              final isSel = _currentSort == opt['value'];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(opt['icon'] as IconData, color: isSel ? _mint : _stoneGrey),
                title: Text(
                  opt['label'] as String,
                  style: TextStyle(
                    color: isSel ? _mint : _offWhite,
                    fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                trailing: isSel ? const Icon(Icons.check, color: _mint, size: 20) : null,
                onTap: () {
                  setState(() => _currentSort = opt['value'] as String);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    final activities = [
      'All Activities',
      'Favorites',
      'Treadmill Running',
      'Agility Ladder',
      'Resistance Drag',
      'Balance Board',
      'Swimming Fitness',
      'Hill Sprints',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FILTER BY ACTIVITY',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.08,
                  ),
                ),
                if (_selectedActivityFilter != 'All Activities')
                  GestureDetector(
                    onTap: () {
                      setState(() => _selectedActivityFilter = 'All Activities');
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Reset Filter',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: activities.map((act) {
                final isSelected = _selectedActivityFilter == act;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedActivityFilter = act);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? _forest : _surfaceHigh,
                      borderRadius: BorderRadius.circular(9999),
                      border: isSelected
                          ? Border.all(color: _mint)
                          : _hairlineBorder,
                    ),
                    child: Text(
                      act,
                      style: TextStyle(
                        color: isSelected ? _offWhite : _stoneGrey,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showTemplateDetails(SessionTemplateItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: _hairlineBorder,
                      ),
                      child: const Center(
                        child: Icon(Icons.description_outlined, color: _mint, size: 24),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(item.activityIcon, color: _mint, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                item.activityName,
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        item.isFavorite ? Icons.star : Icons.star_border,
                        color: item.isFavorite ? _mint : _stoneGrey,
                        size: 24,
                      ),
                      onPressed: () {
                        _toggleFavorite(item);
                        setModalState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
                const SizedBox(height: 16),

                // Specs Breakdown
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(12),
                    border: _hairlineBorder,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Target Duration', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                          Text('${item.durationMinutes} minutes',
                              style: const TextStyle(color: _offWhite, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Lifetime Usage', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                          Text('${item.usedCount} times',
                              style: const TextStyle(color: _mint, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Default Equipment', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                          Expanded(
                            child: Text(
                              item.equipment,
                              textAlign: TextAlign.end,
                              style: const TextStyle(color: _offWhite, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (item.notes != null) ...[
                  const Text(
                    'PRESCRIPTION & NOTES',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.05,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.notes!,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Action CTAs
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showEditTemplateDialog(item);
                        },
                        child: const Text('Edit Template', style: TextStyle(color: _offWhite)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _startSessionWithTemplate(item);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, size: 16),
                            SizedBox(width: 6),
                            Text('Start Session', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCreateTemplateDialog() {
    final titleCtrl = TextEditingController();
    final durationCtrl = TextEditingController(text: '20');
    final equipCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String activity = 'Treadmill Running';
    bool isFavorite = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
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
                    'CREATE SESSION TEMPLATE',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Template Title
                  const Text('Template Title *', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleCtrl,
                    style: const TextStyle(color: _offWhite),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _obsidian,
                      hintText: 'e.g. Hill Sprints Power Block',
                      hintStyle: const TextStyle(color: _stoneGrey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: _hairlineSide),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Activity Selection
                  const Text('Activity *', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(10),
                      border: _hairlineBorder,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: activity,
                        dropdownColor: _carbon,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: _mint),
                        style: const TextStyle(color: _offWhite, fontSize: 14),
                        items: [
                          'Treadmill Running',
                          'Agility Ladder',
                          'Resistance Drag',
                          'Balance Board',
                          'Swimming Fitness',
                          'Hill Sprints',
                        ].map((act) => DropdownMenuItem(value: act, child: Text(act))).toList(),
                        onChanged: (val) {
                          if (val != null) setSheetState(() => activity = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Target Duration
                  const Text('Target Duration (Minutes)', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: durationCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: _offWhite),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _obsidian,
                      hintText: '20',
                      hintStyle: const TextStyle(color: _stoneGrey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: _hairlineSide),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Equipment
                  const Text('Prescribed Gear / Equipment', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: equipCtrl,
                    style: const TextStyle(color: _offWhite),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _obsidian,
                      hintText: 'e.g. Tactical Harness & Drag Sled',
                      hintStyle: const TextStyle(color: _stoneGrey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: _hairlineSide),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Notes
                  const Text('Workout Protocol / Notes', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: notesCtrl,
                    maxLines: 2,
                    style: const TextStyle(color: _offWhite),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _obsidian,
                      hintText: 'Reps, rest periods, pace instructions...',
                      hintStyle: const TextStyle(color: _stoneGrey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: _hairlineSide),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Favorite
                  Row(
                    children: [
                      Checkbox(
                        value: isFavorite,
                        activeColor: _forest,
                        checkColor: _offWhite,
                        side: _hairlineSide,
                        onChanged: (val) => setSheetState(() => isFavorite = val ?? false),
                      ),
                      const Text('Mark as favorite template', style: TextStyle(color: _offWhite, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Save CTA
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        if (title.isEmpty) return;

                        IconData actIcon = Icons.fitness_center;
                        if (activity.contains('Treadmill')) actIcon = Icons.directions_run;
                        if (activity.contains('Agility')) actIcon = Icons.format_list_bulleted;
                        if (activity.contains('Balance')) actIcon = Icons.balance;
                        if (activity.contains('Swim')) actIcon = Icons.pool;
                        if (activity.contains('Hill')) actIcon = Icons.terrain;

                        final newTemplate = SessionTemplateItem(
                          id: 'tmpl-${DateTime.now().millisecondsSinceEpoch}',
                          title: title,
                          activityName: activity,
                          activityIcon: actIcon,
                          usedCount: 0,
                          lastUsed: 'Never used',
                          isFavorite: isFavorite,
                          durationMinutes: int.tryParse(durationCtrl.text.trim()) ?? 20,
                          equipment: equipCtrl.text.trim().isEmpty ? 'Standard Gear' : equipCtrl.text.trim(),
                          notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                        );

                        setState(() {
                          _templates.insert(0, newTemplate);
                          _isEmpty = false;
                        });

                        Navigator.pop(ctx);
                      },
                      child: const Text('Save Template', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditTemplateDialog(SessionTemplateItem item) {
    final titleCtrl = TextEditingController(text: item.title);
    final notesCtrl = TextEditingController(text: item.notes ?? '');

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('EDIT TEMPLATE', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: _offWhite),
              decoration: InputDecoration(
                filled: true,
                fillColor: _obsidian,
                labelText: 'Template Title',
                labelStyle: const TextStyle(color: _stoneGrey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: _hairlineSide),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesCtrl,
              maxLines: 2,
              style: const TextStyle(color: _offWhite),
              decoration: InputDecoration(
                filled: true,
                fillColor: _obsidian,
                labelText: 'Protocol & Notes',
                labelStyle: const TextStyle(color: _stoneGrey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: _hairlineSide),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFFB4AB),
                      side: const BorderSide(color: Color(0xFF690005)),
                    ),
                    onPressed: () {
                      setState(() {
                        _templates.remove(item);
                        if (_templates.isEmpty) _isEmpty = true;
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _forest, foregroundColor: _offWhite),
                    onPressed: () {
                      setState(() {
                        item.title = titleCtrl.text.trim();
                        item.notes = notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim();
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // BUILD METHOD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      // Seamless dark header matching Figma, no bottom hairline
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _mint),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GestureDetector(
          onDoubleTap: _toggleState,
          child: const Text(
            'Session Templates',
            style: TextStyle(
              color: _offWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: _mint),
            color: _carbon,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: _hairlineSide,
            ),
            onSelected: (val) {
              if (val == 'toggle') {
                _toggleState();
              } else if (val == 'create') {
                _showCreateTemplateDialog();
              } else if (val == 'sort') {
                _showSortSheet();
              } else if (val == 'filter') {
                _showFilterSheet();
              } else if (val == 'export') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ExportScreen(),
                  ),
                );
              } else if (val == 'archive') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SCArchiveScreen(),
                  ),
                );
              } else if (val == 'settings') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SCSettingsScreen(),
                  ),
                );
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      _isEmpty ? Icons.view_list : Icons.hourglass_empty,
                      color: _mint,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isEmpty ? 'Switch to Populated State' : 'Switch to Empty State',
                      style: const TextStyle(color: _offWhite, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'create',
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Create New Template', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Sort Templates', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'filter',
                child: Row(
                  children: [
                    Icon(Icons.filter_list, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Filter by Activity', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Export Templates', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('View Archive', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('S & C Settings', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              // 1. Search Bar with Voice Icon
              _buildSearchBar(),
              const SizedBox(height: 16),

              // 2. Filter Strip
              if (!_isEmpty) _buildPopulatedFilterStrip(),
              if (!_isEmpty) const SizedBox(height: 16),

              // 3. Body: Populated List or Empty State Graphic
              Expanded(
                child: _isEmpty
                    ? _buildEmptyState()
                    : _buildPopulatedList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTemplateDialog,
        backgroundColor: _forest,
        foregroundColor: _offWhite,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // ===========================================================================
  // SECTION 1: SEARCH BAR
  // ===========================================================================

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(10),
        border: _hairlineBorder,
      ),
      child: TextField(
        controller: _searchCtrl,
        style: const TextStyle(color: _offWhite, fontSize: 14),
        cursorColor: _mint,
        decoration: InputDecoration(
          hintText: 'Search templates...',
          hintStyle: const TextStyle(color: _stoneGrey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: _stoneGrey, size: 20),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close, color: _stoneGrey, size: 18),
                  onPressed: () => _searchCtrl.clear(),
                ),
              IconButton(
                icon: const Icon(Icons.mic_none, color: _stoneGrey, size: 20),
                tooltip: 'Voice Search',
                onPressed: () {},
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 2: POPULATED FILTER STRIP
  // ===========================================================================

  Widget _buildPopulatedFilterStrip() {
    final count = _filteredTemplates.length;
    final isFiltered = _selectedActivityFilter != 'All Activities';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TEMPLATES badge
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'TEMPLATES',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.05,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: _surfaceVariant,
                            borderRadius: BorderRadius.circular(9999),
                            border: _hairlineBorder,
                          ),
                          child: Text(
                            '$count ${count == 1 ? "template" : "templates"}',
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),

                    // Sort & Filter buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Sort: Recent ▾
                        InkWell(
                          onTap: _showSortSheet,
                          borderRadius: BorderRadius.circular(9999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _carbon,
                              borderRadius: BorderRadius.circular(9999),
                              border: _hairlineBorder,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Sort: $_currentSort',
                                  style: const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Icon(Icons.arrow_drop_down, color: _stoneGrey, size: 16),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Filter ⚞
                        InkWell(
                          onTap: _showFilterSheet,
                          borderRadius: BorderRadius.circular(9999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isFiltered ? _forest : _carbon,
                              borderRadius: BorderRadius.circular(9999),
                              border: isFiltered
                                  ? Border.all(color: _mint)
                                  : _hairlineBorder,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isFiltered) ...[
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: const BoxDecoration(
                                      color: _mint,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                                Text(
                                  isFiltered ? 'Filtered' : 'Filter',
                                  style: TextStyle(
                                    color: isFiltered ? _offWhite : _stoneGrey,
                                    fontSize: 12,
                                    fontWeight: isFiltered ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.tune,
                                  color: isFiltered ? _mint : _stoneGrey,
                                  size: 14,
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
            );
          },
        ),

        // Active Filter Pill indicator if a filter is active
        if (isFiltered) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _surfaceHigh,
                  borderRadius: BorderRadius.circular(9999),
                  border: _hairlineBorder,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Filter: $_selectedActivityFilter',
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() => _selectedActivityFilter = 'All Activities');
                      },
                      child: const Icon(Icons.close, color: _mint, size: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // ===========================================================================
  // SECTION 3A: POPULATED LIST
  // ===========================================================================

  Widget _buildPopulatedList() {
    final list = _filteredTemplates;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: _stoneGrey, size: 48),
            const SizedBox(height: 12),
            const Text(
              'No templates match search',
              style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'No template found for "$_searchQuery"',
              style: const TextStyle(color: _stoneGrey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 90),
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = list[index];
        return _buildTemplateCard(item);
      },
    );
  }

  Widget _buildTemplateCard(SessionTemplateItem item) {
    return InkWell(
      onTap: () => _showTemplateDetails(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: _hairlineBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Document icon + Title + Star
            Row(
              children: [
                const Icon(
                  Icons.description_outlined,
                  color: _stoneGrey,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => _toggleFavorite(item),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      item.isFavorite ? Icons.star : Icons.star_border,
                      color: item.isFavorite ? _mint : _stoneGrey,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Row 2: Activity Tag Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _surfaceHigh,
                borderRadius: BorderRadius.circular(6),
                border: _hairlineBorder,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.activityIcon, color: _mint, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    item.activityName,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Row 3: Usage metadata
            Text(
              'Used ${item.usedCount} ${item.usedCount == 1 ? "time" : "times"} · Last used ${item.lastUsed}',
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 14),

            // Row 4: Full-width "▶ Start Session" Button
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _startSessionWithTemplate(item),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 18, color: _offWhite),
                    SizedBox(width: 8),
                    Text(
                      'Start Session',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 3B: EMPTY STATE (SCREENSHOT 2)
  // ===========================================================================

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Large Circular Lightning Bolt Icon Container
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: const Color(0xFF1E2825),
            shape: BoxShape.circle,
            border: Border.all(
              color: _forest.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.bolt,
              color: _mint,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Title
        const Text(
          'No Templates Yet',
          style: TextStyle(
            color: _offWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        // Description
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Create your first template to quickly record your regular Strength & Conditioning sessions.',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 14,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 36),

        // Action CTA: + Create Template →
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: _offWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _showCreateTemplateDialog,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18, color: _offWhite),
                SizedBox(width: 8),
                Text(
                  'Create Template',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 16, color: _offWhite),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
