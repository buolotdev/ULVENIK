import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';
import 'record_session_screen.dart';
import 'sc_archive_screen.dart';

/// Equipment Model representing gear used in training sessions.
class EquipmentItem {
  final String id;
  String name;
  String? subtitle;
  String category;
  IconData icon;
  int usedCount;
  String lastUsed;
  bool isFavorite;
  String? notes;

  EquipmentItem({
    required this.id,
    required this.name,
    this.subtitle,
    required this.category,
    required this.icon,
    required this.usedCount,
    required this.lastUsed,
    this.isFavorite = false,
    this.notes,
  });
}

/// Screen representing "Equipment" covering both:
/// 1. Populated State (Line 155 in Handover Doc)
/// 2. Empty State (Line 154 in Handover Doc)
///
/// Features search bar, filter strip, dynamic sort (A-Z, Most Used, Recent),
/// category filtering, interactive favorite stars, equipment detail sheets,
/// add equipment dialog, empty state with CTA, and state toggle.
class EquipmentScreen extends StatefulWidget {
  final bool initialEmpty;

  const EquipmentScreen({
    super.key,
    this.initialEmpty = false,
  });

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  // Theme Color Palette
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _surfaceVariant = Color(0xFF323533);
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _stoneGrey = Color(0xFFA7B0AB);
  static const _outline = Color(0xFF89938E);

  static final _hairlineSide =
      BorderSide(color: Colors.white.withValues(alpha: 0.08));
  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));

  late bool _isEmpty;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All Types';
  String _currentSort = 'A-Z'; // 'A-Z', 'Z-A', 'Most Used', 'Recent'

  // Master Equipment List (Initial 12 items to match badge '12' in Figma)
  late List<EquipmentItem> _equipmentList;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _initializeEquipment();

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

  void _initializeEquipment() {
    _equipmentList = [
      EquipmentItem(
        id: 'eq-1',
        name: 'Tactical Harness',
        subtitle: 'Heavy-duty modular vest',
        category: 'Harnesses & Vests',
        icon: Icons.checkroom,
        usedCount: 8,
        lastUsed: '2 days ago',
        isFavorite: true,
        notes:
            'Cordura 1000D tactical vest with load distribution panels, dual leash clips, and MOLLE webbing for conditioning pack weights.',
      ),
      EquipmentItem(
        id: 'eq-2',
        name: '15m Long Line',
        subtitle: 'Biothane training lead',
        category: 'Leads & Lines',
        icon: Icons.linear_scale,
        usedCount: 14,
        lastUsed: 'yesterday',
        isFavorite: true,
        notes:
            'Waterproof Biothane tracking lead, 15 meters long, tangle-free with marine brass swivel bolt snap.',
      ),
      EquipmentItem(
        id: 'eq-3',
        name: 'Agility Tunnel',
        category: 'Agility & Obstacles',
        icon: Icons.radio_button_unchecked,
        usedCount: 3,
        lastUsed: '1 week ago',
        isFavorite: false,
        notes:
            'FCI-regulation 5-meter heavy duty vinyl agility chute with weighted sandbag cradles.',
      ),
      EquipmentItem(
        id: 'eq-4',
        name: 'Weight Vest',
        subtitle: '5kg professional conditioning vest',
        category: 'Weights & Conditioning',
        icon: Icons.fitness_center,
        usedCount: 1,
        lastUsed: '3 weeks ago',
        isFavorite: false,
        notes:
            'Padded ergonomic conditioning harness loaded with individual 250g steel shot weights for gradual posterior strength training.',
      ),
      EquipmentItem(
        id: 'eq-5',
        name: 'Resistance Band',
        category: 'Bands & Resistance',
        icon: Icons.gesture,
        usedCount: 0,
        lastUsed: 'Never used',
        isFavorite: false,
        notes:
            'Heavy-gauge latex-free canine exercise band for isometric hip joint and gait rehabilitation.',
      ),
      EquipmentItem(
        id: 'eq-6',
        name: 'Canine Floatation Vest',
        subtitle: 'High-buoyancy swim conditioning vest',
        category: 'Harnesses & Vests',
        icon: Icons.safety_check,
        usedCount: 18,
        lastUsed: '3 days ago',
        isFavorite: true,
        notes:
            'Ergonomic canine life jacket with dual rescue handle and high-buoyancy foam for heavy swim conditioning.',
      ),
      EquipmentItem(
        id: 'eq-7',
        name: 'Motorized Slatmill',
        subtitle: 'Low-friction canine treadmill',
        category: 'Weights & Conditioning',
        icon: Icons.speed,
        usedCount: 22,
        lastUsed: '4 days ago',
        isFavorite: true,
        notes:
            'Free-spinning aluminum slat running surface with digital tachometer and magnetic resistance dial.',
      ),
      EquipmentItem(
        id: 'eq-8',
        name: 'Agility Weave Poles',
        subtitle: '12-pole competition spacing set',
        category: 'Agility & Obstacles',
        icon: Icons.alt_route,
        usedCount: 6,
        lastUsed: '5 days ago',
        isFavorite: false,
        notes:
            'Steel base plate with flexible composite upright poles for precision stride and spinal flexion work.',
      ),
      EquipmentItem(
        id: 'eq-9',
        name: 'Weighted Saddlebags',
        subtitle: '2.5kg balance pack',
        category: 'Weights & Conditioning',
        icon: Icons.backpack,
        usedCount: 5,
        lastUsed: '2 weeks ago',
        isFavorite: false,
        notes:
            'Bilateral canine rucksack with water-resistant compartments and padded sternum yoke.',
      ),
      EquipmentItem(
        id: 'eq-10',
        name: 'K9 Balance Disc',
        subtitle: 'Inflatable core stability cushion',
        category: 'Weights & Conditioning',
        icon: Icons.lens_blur,
        usedCount: 9,
        lastUsed: '6 days ago',
        isFavorite: false,
        notes:
            'Dual textured surface balance dome for canine proprioceptive core loading and limb balance.',
      ),
      EquipmentItem(
        id: 'eq-11',
        name: 'Bite Sleeve Pro',
        subtitle: 'Intermediate wedge sleeve',
        category: 'Harnesses & Vests',
        icon: Icons.shield,
        usedCount: 11,
        lastUsed: '1 week ago',
        isFavorite: true,
        notes:
            'Heavy French linen bite wedge with protective forearm shield for drive and grip conditioning.',
      ),
      EquipmentItem(
        id: 'eq-12',
        name: 'Target Touch Mat',
        subtitle: 'Non-slip paw placement station',
        category: 'Agility & Obstacles',
        icon: Icons.crop_landscape,
        usedCount: 4,
        lastUsed: '2 weeks ago',
        isFavorite: false,
        notes:
            'Rubberized textured target pad for precise two-on/two-off contact zone conditioning.',
      ),
    ];
  }

  void _toggleState() {
    setState(() {
      _isEmpty = !_isEmpty;
    });
  }

  // Filtered and sorted equipment list
  List<EquipmentItem> get _filteredEquipment {
    var list = _equipmentList.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery) ||
          (item.subtitle?.toLowerCase().contains(_searchQuery) ?? false) ||
          item.category.toLowerCase().contains(_searchQuery);

      final matchesCategory = _selectedCategory == 'All Types' ||
          item.category == _selectedCategory ||
          (_selectedCategory == 'Favorites' && item.isFavorite) ||
          (_selectedCategory == 'Active' && item.usedCount > 0);

      return matchesSearch && matchesCategory;
    }).toList();

    // Apply Sorting
    switch (_currentSort) {
      case 'A-Z':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Z-A':
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Most Used':
        list.sort((a, b) => b.usedCount.compareTo(a.usedCount));
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
  // INTERACTIVE SHEETS & MODALS
  // ===========================================================================

  void _toggleFavorite(EquipmentItem item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    AppSnackbar.show(
      context,
      message: item.isFavorite
          ? '${item.name} added to favorites'
          : '${item.name} removed from favorites',
      type: item.isFavorite ? SnackbarType.success : SnackbarType.info,
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
              'SORT EQUIPMENT',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.08,
              ),
            ),
            const SizedBox(height: 12),
            ...[
              {'label': 'Alphabetical (A - Z)', 'value': 'A-Z', 'icon': Icons.sort_by_alpha},
              {'label': 'Alphabetical (Z - A)', 'value': 'Z-A', 'icon': Icons.sort_by_alpha},
              {'label': 'Most Frequently Used', 'value': 'Most Used', 'icon': Icons.repeat},
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
                trailing: isSel
                    ? const Icon(Icons.check, color: _mint, size: 20)
                    : null,
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
    final categories = [
      'All Types',
      'Favorites',
      'Active',
      'Harnesses & Vests',
      'Leads & Lines',
      'Agility & Obstacles',
      'Weights & Conditioning',
      'Bands & Resistance',
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
            const Text(
              'FILTER BY CATEGORY',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.08,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCategory = cat);
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
                      cat,
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

  void _showEquipmentDetails(EquipmentItem item) {
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
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: _hairlineBorder,
                      ),
                      child: Center(
                        child: Icon(item.icon, color: _mint, size: 26),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (item.subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle!,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _surfaceHigh,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(
                                color: _mint,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        item.isFavorite ? Icons.star : Icons.star_border,
                        color: item.isFavorite ? _mint : _stoneGrey,
                        size: 26,
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

                // Usage Statistics Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(12),
                    border: _hairlineBorder,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'TOTAL USED',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.05,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.usedCount} times',
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      Column(
                        children: [
                          const Text(
                            'LAST USED',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.05,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.lastUsed,
                            style: const TextStyle(
                              color: _mint,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
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
                    'SPECIFICATIONS & NOTES',
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showEditEquipmentDialog(item);
                        },
                        child: const Text('Edit Details', style: TextStyle(color: _offWhite)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RecordSessionScreen(
                                startWithActivity: true,
                              ),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, size: 16),
                            SizedBox(width: 4),
                            Text('Use in Session', style: TextStyle(fontWeight: FontWeight.w600)),
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

  void _showAddEquipmentDialog() {
    final nameCtrl = TextEditingController();
    final subtitleCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String category = 'Harnesses & Vests';
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
                    'ADD NEW EQUIPMENT',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Equipment Name Field
                  const Text(
                    'Equipment Name *',
                    style: TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(color: _offWhite),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _obsidian,
                      hintText: 'e.g. Weighted Pulling Harness',
                      hintStyle: const TextStyle(color: _stoneGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: _hairlineSide,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: _hairlineSide,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _mint),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Subtitle / Brief Description
                  const Text(
                    'Short Description / Model',
                    style: TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: subtitleCtrl,
                    style: const TextStyle(color: _offWhite),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _obsidian,
                      hintText: 'e.g. 5kg professional conditioning vest',
                      hintStyle: const TextStyle(color: _stoneGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: _hairlineSide,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: _hairlineSide,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _mint),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Category Picker
                  const Text(
                    'Category',
                    style: TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
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
                        value: category,
                        dropdownColor: _carbon,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: _mint),
                        style: const TextStyle(color: _offWhite, fontSize: 14),
                        items: [
                          'Harnesses & Vests',
                          'Leads & Lines',
                          'Agility & Obstacles',
                          'Weights & Conditioning',
                          'Bands & Resistance',
                          'Recovery & Care',
                        ].map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setSheetState(() => category = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Notes / Specs
                  const Text(
                    'Detailed Specifications (Optional)',
                    style: TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: notesCtrl,
                    maxLines: 2,
                    style: const TextStyle(color: _offWhite),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _obsidian,
                      hintText: 'Material, dimensions, weight capacity, maintenance...',
                      hintStyle: const TextStyle(color: _stoneGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: _hairlineSide,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: _hairlineSide,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _mint),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Favorite Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: isFavorite,
                        activeColor: _forest,
                        checkColor: _offWhite,
                        side: _hairlineSide,
                        onChanged: (val) {
                          setSheetState(() => isFavorite = val ?? false);
                        },
                      ),
                      const Text(
                        'Mark as favorite gear',
                        style: TextStyle(color: _offWhite, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) {
                          AppSnackbar.show(
                            context,
                            message: 'Please enter an equipment name',
                            type: SnackbarType.warning,
                          );
                          return;
                        }

                        // Determine Icon
                        IconData iconData = Icons.fitness_center;
                        if (category.contains('Harness')) iconData = Icons.checkroom;
                        if (category.contains('Lead')) iconData = Icons.linear_scale;
                        if (category.contains('Agility')) iconData = Icons.radio_button_unchecked;
                        if (category.contains('Band')) iconData = Icons.gesture;

                        final newItem = EquipmentItem(
                          id: 'eq-${DateTime.now().millisecondsSinceEpoch}',
                          name: name,
                          subtitle: subtitleCtrl.text.trim().isEmpty ? null : subtitleCtrl.text.trim(),
                          category: category,
                          icon: iconData,
                          usedCount: 0,
                          lastUsed: 'Never used',
                          isFavorite: isFavorite,
                          notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                        );

                        setState(() {
                          _equipmentList.insert(0, newItem);
                          _isEmpty = false;
                        });

                        Navigator.pop(ctx);
                        AppSnackbar.show(
                          context,
                          message: 'Created equipment: $name',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Text('Save Equipment', style: TextStyle(fontWeight: FontWeight.w600)),
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

  void _showEditEquipmentDialog(EquipmentItem item) {
    final nameCtrl = TextEditingController(text: item.name);
    final subtitleCtrl = TextEditingController(text: item.subtitle ?? '');
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
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'EDIT EQUIPMENT',
              style: TextStyle(
                color: _offWhite,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: _offWhite),
              decoration: InputDecoration(
                filled: true,
                fillColor: _obsidian,
                labelText: 'Name',
                labelStyle: const TextStyle(color: _stoneGrey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: _hairlineSide),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: subtitleCtrl,
              style: const TextStyle(color: _offWhite),
              decoration: InputDecoration(
                filled: true,
                fillColor: _obsidian,
                labelText: 'Subtitle',
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
                labelText: 'Specifications & Notes',
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
                        _equipmentList.remove(item);
                        if (_equipmentList.isEmpty) _isEmpty = true;
                      });
                      Navigator.pop(ctx);
                      AppSnackbar.show(
                        context,
                        message: 'Deleted ${item.name}',
                        type: SnackbarType.info,
                      );
                    },
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                    ),
                    onPressed: () {
                      setState(() {
                        item.name = nameCtrl.text.trim();
                        item.subtitle = subtitleCtrl.text.trim().isEmpty ? null : subtitleCtrl.text.trim();
                        item.notes = notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim();
                      });
                      Navigator.pop(ctx);
                      AppSnackbar.show(
                        context,
                        message: 'Updated ${item.name}',
                        type: SnackbarType.success,
                      );
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
            'Equipment',
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
            icon: const Icon(Icons.more_vert, color: _mint),
            color: _carbon,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: _hairlineSide,
            ),
            onSelected: (val) {
              if (val == 'toggle') {
                _toggleState();
              } else if (val == 'add') {
                _showAddEquipmentDialog();
              } else if (val == 'sort') {
                _showSortSheet();
              } else if (val == 'filter') {
                _showFilterSheet();
              } else if (val == 'export') {
                AppSnackbar.show(
                  context,
                  message: 'Equipment inventory exported to PDF/CSV',
                  type: SnackbarType.success,
                );
              } else if (val == 'archive') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SCArchiveScreen(),
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
                      _isEmpty ? Icons.inventory_2 : Icons.hourglass_empty,
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
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Add New Equipment', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Sort Equipment', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'filter',
                child: Row(
                  children: [
                    Icon(Icons.filter_list, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Filter by Category', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Export Inventory', style: TextStyle(color: _offWhite, fontSize: 13)),
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

              // 1. Search Bar
              _buildSearchBar(),
              const SizedBox(height: 16),

              // 2. Filter Strip
              _isEmpty ? _buildEmptyFilterStrip() : _buildPopulatedFilterStrip(),
              const SizedBox(height: 16),

              // 3. Main Content: Populated List or Empty State Graphic
              Expanded(
                child: _isEmpty
                    ? _buildEmptyState()
                    : _buildPopulatedList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _showAddEquipmentDialog,
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
          hintText: 'Search equipment...',
          hintStyle: const TextStyle(color: _stoneGrey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: _stoneGrey, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: _stoneGrey, size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 2A: FILTER STRIP (POPULATED)
  // ===========================================================================

  Widget _buildPopulatedFilterStrip() {
    final count = _filteredEquipment.length;
    final isFiltered = _selectedCategory != 'All Types';

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
                    // EQUIPMENT badge
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'EQUIPMENT',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.05,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _surfaceVariant,
                            borderRadius: BorderRadius.circular(9999),
                            border: _hairlineBorder,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
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
                        // Sort Button
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
                                const Icon(Icons.sort, color: _stoneGrey, size: 15),
                                const SizedBox(width: 4),
                                Text(
                                  _currentSort,
                                  style: const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Filter Button
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
                                Icon(
                                  Icons.filter_list,
                                  color: isFiltered ? _offWhite : _stoneGrey,
                                  size: 15,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isFiltered ? 'Filtered' : 'Filter',
                                  style: TextStyle(
                                    color: isFiltered ? _offWhite : _stoneGrey,
                                    fontSize: 12,
                                    fontWeight: isFiltered ? FontWeight.w600 : FontWeight.w500,
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
              ),
            );
          },
        ),

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
                      'Filter: $_selectedCategory',
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = 'All Types');
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
  // SECTION 2B: FILTER STRIP (EMPTY STATE)
  // ===========================================================================

  Widget _buildEmptyFilterStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // All Types ▾ Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: _forest),
              ),
              child: const Row(
                children: [
                  Text(
                    'All Types',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: _mint, size: 16),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Active Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(9999),
                border: _hairlineBorder,
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        // 0 items
        const Text(
          '0 items',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // SECTION 3A: POPULATED LIST
  // ===========================================================================

  Widget _buildPopulatedList() {
    final list = _filteredEquipment;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: _stoneGrey, size: 48),
            const SizedBox(height: 12),
            const Text(
              'No equipment found',
              style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'No gear matches "$_searchQuery"',
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
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];
        return _buildEquipmentCard(item);
      },
    );
  }

  Widget _buildEquipmentCard(EquipmentItem item) {
    return InkWell(
      onTap: () => _showEquipmentDetails(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: _hairlineBorder,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Square Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: _hairlineBorder,
              ),
              child: Center(
                child: Icon(
                  item.icon,
                  color: _mint,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Middle: Name, Subtitle, Usage info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Used ${item.usedCount} ${item.usedCount == 1 ? "time" : "times"} · Last used ${item.lastUsed}',
                    style: const TextStyle(
                      color: _outline,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Right: Star Favorite Button + Chevron Right
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _toggleFavorite(item),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      item.isFavorite ? Icons.star : Icons.star_border,
                      color: item.isFavorite ? _mint : _stoneGrey,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.chevron_right,
                  color: _mint,
                  size: 20,
                ),
              ],
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
        // Large Circular Dumbbell Icon Container
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
              Icons.fitness_center,
              color: _mint,
              size: 38,
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Title
        const Text(
          'No Equipment Yet',
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
            'Create your first equipment item to keep track of what you use during your Strength & Conditioning sessions.',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 14,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 36),

        // Action CTA: + Create Equipment →
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
            onPressed: _showAddEquipmentDialog,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18, color: _offWhite),
                SizedBox(width: 8),
                Text(
                  'Create Equipment',
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
