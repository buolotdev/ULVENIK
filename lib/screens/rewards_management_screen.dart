import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'add_reward_screen.dart';
import 'edit_reward_screen.dart';
import 'manage_reward_types_screen.dart';

// ─── Shared Models & Live Store for Screens 79–82 ─────────────────────────────

enum RewardIconKind {
  warmFood,
  kibbleFork,
  giftToy,
  heartPraise,
  boltPlay,
  trophyComp,
  circleBolt,
  starCustom,
}

class RewardTypeConfig {
  final String id;
  String name;
  RewardIconKind iconKind;
  bool isActive;
  final int baselineCountOffset;

  RewardTypeConfig({
    required this.id,
    required this.name,
    required this.iconKind,
    this.isActive = true,
    this.baselineCountOffset = 0,
  });

  String get badgeLabel => name.toUpperCase();
}

class RewardItemModel {
  final String id;
  String name;
  String typeId;
  String notes;
  RewardIconKind iconKind;
  bool isFavourite;
  bool isActive;

  RewardItemModel({
    required this.id,
    required this.name,
    required this.typeId,
    required this.notes,
    required this.iconKind,
    this.isFavourite = false,
    this.isActive = true,
  });

  RewardItemModel copyWith({
    String? name,
    String? typeId,
    String? notes,
    RewardIconKind? iconKind,
    bool? isFavourite,
    bool? isActive,
  }) {
    return RewardItemModel(
      id: id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      notes: notes ?? this.notes,
      iconKind: iconKind ?? this.iconKind,
      isFavourite: isFavourite ?? this.isFavourite,
      isActive: isActive ?? this.isActive,
    );
  }
}

class DogRewardProfile {
  final String id;
  final String initials;
  final String name;
  final String breed;
  final String sportBadge;

  const DogRewardProfile({
    required this.id,
    required this.initials,
    required this.name,
    required this.breed,
    required this.sportBadge,
  });
}

class RewardsStore extends ChangeNotifier {
  RewardsStore._internal();
  static final RewardsStore instance = RewardsStore._internal();

  final List<DogRewardProfile> dogs = const [
    DogRewardProfile(
      id: 'rook',
      initials: 'RK',
      name: 'Rook',
      breed: 'Belgian Malinois',
      sportBadge: 'IGP-3 SPORT',
    ),
    DogRewardProfile(
      id: 'murphy',
      initials: 'MP',
      name: 'Murphy',
      breed: 'German Shepherd',
      sportBadge: 'OBEDIENCE',
    ),
    DogRewardProfile(
      id: 'koda',
      initials: 'KD',
      name: 'Koda',
      breed: 'Dutch Shepherd',
      sportBadge: 'MONDIORING',
    ),
  ];

  String selectedDogId = 'rook';

  DogRewardProfile get selectedDog =>
      dogs.firstWhere((d) => d.id == selectedDogId, orElse: () => dogs.first);

  // Optional starter categories — fully editable, reorderable, archivable,
  // and deletable by the user alongside unlimited custom Reward Types.
  final List<RewardTypeConfig> types = [
    RewardTypeConfig(
      id: 'food',
      name: 'Food',
      iconKind: RewardIconKind.warmFood,
    ),
    RewardTypeConfig(
      id: 'toy',
      name: 'Toy',
      iconKind: RewardIconKind.giftToy,
    ),
    RewardTypeConfig(
      id: 'praise',
      name: 'Praise',
      iconKind: RewardIconKind.heartPraise,
    ),
    RewardTypeConfig(
      id: 'play',
      name: 'Play',
      iconKind: RewardIconKind.boltPlay,
    ),
    RewardTypeConfig(
      id: 'other',
      name: 'Other',
      iconKind: RewardIconKind.starCustom,
    ),
  ];

  // Example rewards with optional user-entered personal notes only (never
  // system-rated or classified by Ulvenik).
  final List<RewardItemModel> rewards = [
    RewardItemModel(
      id: 'r1',
      name: 'Freeze-Dried Liver',
      typeId: 'food',
      notes: 'High value — competition only',
      iconKind: RewardIconKind.warmFood,
      isFavourite: true,
    ),
    RewardItemModel(
      id: 'r2',
      name: 'Tug Toy',
      typeId: 'toy',
      notes: 'Ball on rope, preferred',
      iconKind: RewardIconKind.giftToy,
      isFavourite: true,
    ),
    RewardItemModel(
      id: 'r3',
      name: 'Verbal Praise',
      typeId: 'praise',
      notes: '',
      iconKind: RewardIconKind.heartPraise,
    ),
    RewardItemModel(
      id: 'r4',
      name: 'Kibble',
      typeId: 'food',
      notes: 'Low value — everyday use',
      iconKind: RewardIconKind.kibbleFork,
    ),
    RewardItemModel(
      id: 'r5',
      name: 'Tennis Ball',
      typeId: 'toy',
      notes: '',
      iconKind: RewardIconKind.giftToy,
    ),
    RewardItemModel(
      id: 'r6',
      name: 'Chase Game',
      typeId: 'play',
      notes: 'End of session reward',
      iconKind: RewardIconKind.boltPlay,
    ),
  ];

  List<RewardTypeConfig> get activeTypes =>
      types.where((t) => t.isActive).toList();

  RewardTypeConfig? typeById(String id) {
    for (final t in types) {
      if (t.id == id) return t;
    }
    return null;
  }

  String badgeForType(String typeId) {
    return typeById(typeId)?.badgeLabel ?? typeId.toUpperCase();
  }

  RewardIconKind defaultIconForType(String typeId) {
    return typeById(typeId)?.iconKind ?? RewardIconKind.starCustom;
  }

  void selectDog(String dogId) {
    selectedDogId = dogId;
    notifyListeners();
  }

  void addReward(RewardItemModel item) {
    rewards.insert(0, item);
    notifyListeners();
  }

  void updateReward(RewardItemModel updated) {
    final idx = rewards.indexWhere((r) => r.id == updated.id);
    if (idx != -1) {
      rewards[idx] = updated;
      notifyListeners();
    }
  }

  void deleteReward(String id) {
    rewards.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void addRewardType(String name, {RewardIconKind? iconKind}) {
    final clean = name.trim();
    if (clean.isEmpty) return;
    final slug =
        '${clean.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_')}_${DateTime.now().millisecondsSinceEpoch}';
    types.add(
      RewardTypeConfig(
        id: slug,
        name: clean,
        iconKind: iconKind ?? RewardIconKind.starCustom,
      ),
    );
    notifyListeners();
  }

  void renameRewardType(String id, String newName) {
    final clean = newName.trim();
    if (clean.isEmpty) return;
    final t = typeById(id);
    if (t != null) {
      t.name = clean;
      notifyListeners();
    }
  }

  void toggleRewardTypeActive(String id) {
    final t = typeById(id);
    if (t != null) {
      t.isActive = !t.isActive;
      notifyListeners();
    }
  }

  void deleteRewardType(String id) {
    types.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void reorderRewardTypes(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = types.removeAt(oldIndex);
    types.insert(newIndex, item);
    notifyListeners();
  }

  void updateRewardType(
    String id, {
    String? name,
    RewardIconKind? iconKind,
    bool? isActive,
  }) {
    final t = typeById(id);
    if (t == null) return;
    if (name != null && name.trim().isNotEmpty) {
      t.name = name.trim();
    }
    if (iconKind != null) {
      t.iconKind = iconKind;
    }
    if (isActive != null) {
      t.isActive = isActive;
    }
    notifyListeners();
  }

  int countRewardsForType(String typeId) {
    return rewards.where((r) => r.typeId == typeId).length;
  }

  int displayRewardCountForType(RewardTypeConfig type) {
    final total = countRewardsForType(type.id) + type.baselineCountOffset;
    return total < 0 ? 0 : total;
  }
}

// ─── Custom Vector Icons Matching Figma 1:1 ───────────────────────────────────

class RewardGlyphIcon extends StatelessWidget {
  final RewardIconKind kind;
  final Color color;
  final double size;

  const RewardGlyphIcon({
    super.key,
    required this.kind,
    this.color = AppColors.secondarySage,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case RewardIconKind.warmFood:
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _SteamingSpoonPainter(color: color)),
        );
      case RewardIconKind.giftToy:
        return UlvenikIcon(UlvenikIcons.goals, color: color, size: size);
      case RewardIconKind.heartPraise:
        return UlvenikIcon(UlvenikIcons.health, color: color, size: size);
      case RewardIconKind.kibbleFork:
        return UlvenikIcon(UlvenikIcons.overflowMenu, color: color, size: size);
      case RewardIconKind.boltPlay:
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _BoltOutlinePainter(color: color)),
        );
      case RewardIconKind.trophyComp:
        return UlvenikIcon(UlvenikIcons.goals, color: color, size: size);
      case RewardIconKind.circleBolt:
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _CircleBoltPainter(color: color)),
        );
      case RewardIconKind.starCustom:
        return UlvenikIcon(UlvenikIcons.skills, color: color, size: size);
    }
  }
}

class _CircleBoltPainter extends CustomPainter {
  final Color color;
  const _CircleBoltPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final boltPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.43, circlePaint);

    final bolt = Path()
      ..moveTo(w * 0.54, h * 0.24)
      ..lineTo(w * 0.35, h * 0.52)
      ..lineTo(w * 0.50, h * 0.52)
      ..lineTo(w * 0.46, h * 0.76)
      ..lineTo(w * 0.65, h * 0.48)
      ..lineTo(w * 0.50, h * 0.48)
      ..close();
    canvas.drawPath(bolt, boltPaint);
  }

  @override
  bool shouldRepaint(covariant _CircleBoltPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SteamingSpoonPainter extends CustomPainter {
  final Color color;
  const _SteamingSpoonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // 3 gentle steam lines on top-left
    for (int i = 0; i < 3; i++) {
      final x = w * (0.24 + i * 0.16);
      final steam = Path()
        ..moveTo(x, h * 0.36)
        ..quadraticBezierTo(x - w * 0.04, h * 0.25, x + w * 0.03, h * 0.14);
      canvas.drawPath(steam, paint);
    }

    // Bowl of ladle + curved handle rising on the right
    final bowlRect = Rect.fromLTWH(w * 0.14, h * 0.48, w * 0.56, h * 0.28);
    canvas.drawLine(
      Offset(bowlRect.left, bowlRect.top),
      Offset(bowlRect.right, bowlRect.top),
      paint,
    );
    final bowlPath = Path()
      ..moveTo(bowlRect.left, bowlRect.top)
      ..arcToPoint(
        Offset(bowlRect.right, bowlRect.top),
        radius: Radius.circular(w * 0.28),
        clockwise: false,
      );
    canvas.drawPath(bowlPath, paint);

    // Handle extending up-right + subtle base line
    final handle = Path()
      ..moveTo(bowlRect.right, bowlRect.top)
      ..lineTo(w * 0.80, h * 0.18)
      ..quadraticBezierTo(w * 0.86, h * 0.12, w * 0.90, h * 0.18);
    canvas.drawPath(handle, paint);

    canvas.drawLine(
      Offset(w * 0.24, h * 0.86),
      Offset(w * 0.60, h * 0.86),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SteamingSpoonPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _BoltOutlinePainter extends CustomPainter {
  final Color color;
  const _BoltOutlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.65
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.56, h * 0.10)
      ..lineTo(w * 0.22, h * 0.54)
      ..lineTo(w * 0.48, h * 0.54)
      ..lineTo(w * 0.42, h * 0.90)
      ..lineTo(w * 0.78, h * 0.46)
      ..lineTo(w * 0.52, h * 0.46)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BoltOutlinePainter oldDelegate) =>
      oldDelegate.color != color;
}

// ─── Screen 79: Rewards Management ────────────────────────────────────────────

class RewardsManagementScreen extends StatefulWidget {
  const RewardsManagementScreen({super.key});

  @override
  State<RewardsManagementScreen> createState() =>
      _RewardsManagementScreenState();
}

class _RewardsManagementScreenState extends State<RewardsManagementScreen>
    with SingleTickerProviderStateMixin {
  final RewardsStore _store = RewardsStore.instance;
  final TextEditingController _searchController = TextEditingController();

  String _selectedTypeId = 'all';
  bool _isSearching = false;
  bool _showBreakdownBar = false;
  String? _highlightedBreakdownTypeId;

  late final AnimationController _breakdownAnimController;
  late final Animation<double> _breakdownCurve;

  // Hooks populated as Screens 80, 81, 82 are wired
  static Future<void> Function(BuildContext context)? openAddRewardHook;
  static Future<void> Function(BuildContext context, RewardItemModel reward)?
      openEditRewardHook;
  static Future<void> Function(BuildContext context)? openManageTypesHook;

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChanged);
    _breakdownAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _breakdownCurve = CurvedAnimation(
      parent: _breakdownAnimController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    _searchController.dispose();
    _breakdownAnimController.dispose();
    super.dispose();
  }

  void _onStoreChanged() {
    if (!mounted) return;
    if (_selectedTypeId != 'all' &&
        !_store.activeTypes.any((t) => t.id == _selectedTypeId)) {
      _selectedTypeId = 'all';
    }
    setState(() {});
  }

  List<RewardItemModel> get _filteredRewards {
    final query = _searchController.text.trim().toLowerCase();
    return _store.rewards.where((item) {
      if (_selectedTypeId != 'all' && item.typeId != _selectedTypeId) {
        return false;
      }
      if (query.isNotEmpty) {
        final badge = _store.badgeForType(item.typeId).toLowerCase();
        return item.name.toLowerCase().contains(query) ||
            item.notes.toLowerCase().contains(query) ||
            badge.contains(query);
      }
      return true;
    }).toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _toggleBreakdown() {
    setState(() {
      _showBreakdownBar = !_showBreakdownBar;
      if (_showBreakdownBar) {
        _breakdownAnimController.forward(from: 0);
      } else {
        _highlightedBreakdownTypeId = null;
      }
    });
  }

  void _showDogSwitcherSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'SELECT WORKING DOG',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 12),
                ..._store.dogs.map((dog) {
                  final selected = dog.id == _store.selectedDogId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _store.selectDog(dog.id);
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryForestGreen
                                  .withValues(alpha: 0.16)
                              : AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? AppColors.primaryForestGreen
                                : AppColors.cardBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildDogAvatar(dog.initials),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${dog.name} · ${dog.breed}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextOffWhite,
                                ),
                              ),
                            ),
                            Text(
                              dog.sportBadge,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteReward(RewardItemModel reward) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardsCarbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          title: const Text(
            'Delete Reward?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextOffWhite,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete "${reward.name}" from ${_store.selectedDog.name}\'s rewards? This action cannot be undone.',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.secondaryTextStoneGrey,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorDestructive,
                foregroundColor: AppColors.primaryTextOffWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text(
                'Delete Reward',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      _store.deleteReward(reward.id);
      AppSnackbar.show(
        context,
        title: 'Reward Removed',
        message: '"${reward.name}" was deleted from your rewards list.',
        type: SnackbarType.info,
      );
    }
  }

  Future<void> _handleOpenAddReward() async {
    if (openAddRewardHook != null) {
      await openAddRewardHook!(context);
      return;
    }
    await showAddRewardSheet(context);
  }

  Future<void> _handleOpenEditReward(RewardItemModel reward) async {
    if (openEditRewardHook != null) {
      await openEditRewardHook!(context, reward);
      return;
    }
    await showEditRewardSheet(context, reward);
  }

  Future<void> _handleOpenManageTypes() async {
    if (openManageTypesHook != null) {
      await openManageTypesHook!(context);
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ManageRewardTypesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dog = _store.selectedDog;
    final items = _filteredRewards;
    final countLabel =
        items.length == 1 ? '1 item' : '${items.length} items';

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                if (_isSearching) _buildSearchField(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                    children: [
                      _buildDogCard(dog),
                      const SizedBox(height: 24),
                      _buildRewardTypesHeader(),
                      const SizedBox(height: 12),
                      _buildFilterChipsRow(),
                      const SizedBox(height: 24),
                      _buildMyRewardsHeader(countLabel),
                      if (_showBreakdownBar) ...[
                        const SizedBox(height: 12),
                        _buildAnimatedBreakdownCard(),
                      ],
                      const SizedBox(height: 12),
                      if (items.isEmpty)
                        _buildEmptyFilteredState()
                      else
                        ...items.map(
                          (reward) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildRewardCard(reward),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 20,
              bottom: 24,
              child: GestureDetector(
                onTap: _handleOpenAddReward,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryForestGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.38),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: UlvenikIcon(UlvenikIcons.add,
                      color: AppColors.primaryTextOffWhite,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: SizedBox(
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UlvenikIcon(UlvenikIcons.back,
                        size: 18,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Text(
              'Rewards Management',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextOffWhite,
                letterSpacing: -0.2,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _toggleSearch,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: UlvenikIcon.fromMaterial(
                    _isSearching ? Icons.close_rounded : Icons.search_rounded,
                    size: 22,
                    color: _isSearching
                        ? AppColors.primaryTextOffWhite
                        : AppColors.secondaryTextStoneGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const UlvenikIcon(UlvenikIcons.search,
              size: 18,
              color: AppColors.secondaryTextStoneGrey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.primaryTextOffWhite,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search rewards or notes...',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() {});
                },
                child: const UlvenikIcon(UlvenikIcons.back,
                  size: 16,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDogAvatar(String initials) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF191C1B),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryForestGreen,
          width: 1.2,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF95D3BB),
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildDogCard(DogRewardProfile dog) {
    return GestureDetector(
      onTap: _showDogSwitcherSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            _buildDogAvatar(dog.initials),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: dog.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextOffWhite,
                      ),
                    ),
                    const TextSpan(
                      text: '  ·  ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                    TextSpan(
                      text: dog.breed,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const UlvenikIcon(UlvenikIcons.completed,
                  size: 16,
                  color: AppColors.secondaryTextStoneGrey,
                ),
                const SizedBox(width: 5),
                Text(
                  dog.sportBadge,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardTypesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'REWARD TYPES',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
        GestureDetector(
          onTap: _handleOpenManageTypes,
          behavior: HitTestBehavior.opaque,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                UlvenikIcon(UlvenikIcons.sort,
                  size: 15,
                  color: AppColors.primaryForestGreen,
                ),
                SizedBox(width: 5),
                Text(
                  'Manage Types',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryForestGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChipsRow() {
    final activeTypes = _store.activeTypes;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildTypeChip(
            id: 'all',
            label: 'All',
            isSelected: _selectedTypeId == 'all',
          ),
          ...activeTypes.map(
            (type) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildTypeChip(
                id: type.id,
                label: type.name,
                isSelected: _selectedTypeId == type.id,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: _handleOpenManageTypes,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UlvenikIcon(UlvenikIcons.add,
                      size: 15,
                      color: AppColors.primaryForestGreen,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'New Type',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryForestGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip({
    required String id,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTypeId = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryForestGreen.withValues(alpha: 0.16)
              : AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryForestGreen
                : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? AppColors.primaryForestGreen
                : AppColors.secondaryTextStoneGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildMyRewardsHeader(String countLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'MY REWARDS',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
        GestureDetector(
          onTap: _toggleBreakdown,
          behavior: HitTestBehavior.opaque,
          child: Text(
            countLabel,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              fontWeight:
                  _showBreakdownBar ? FontWeight.w600 : FontWeight.w400,
              color: _showBreakdownBar
                  ? const Color(0xFF95D3BB)
                  : AppColors.secondaryTextStoneGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedBreakdownCard() {
    final total = _store.rewards.length;
    if (total == 0) return const SizedBox.shrink();

    final palette = <Color>[
      AppColors.primaryForestGreen,
      AppColors.infoAlpineBlue,
      AppColors.secondarySage,
      AppColors.bronzeAccent,
      const Color(0xFF95D3BB),
    ];

    final activeTypes = _store.activeTypes;
    return AnimatedBuilder(
      animation: _breakdownCurve,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'REINFORCER MIX',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                  Text(
                    'Tap segment to filter',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 10,
                  child: Row(
                    children: List.generate(activeTypes.length, (i) {
                      final t = activeTypes[i];
                      final count = _store.countRewardsForType(t.id);
                      if (count == 0) return const SizedBox.shrink();
                      final color = palette[i % palette.length];
                      final isDimmed = _highlightedBreakdownTypeId != null &&
                          _highlightedBreakdownTypeId != t.id;
                      return Expanded(
                        flex: (count * 100 * _breakdownCurve.value)
                            .round()
                            .clamp(1, 10000),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_highlightedBreakdownTypeId == t.id) {
                                _highlightedBreakdownTypeId = null;
                                _selectedTypeId = 'all';
                              } else {
                                _highlightedBreakdownTypeId = t.id;
                                _selectedTypeId = t.id;
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 2),
                            color: isDimmed
                                ? color.withValues(alpha: 0.28)
                                : color,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: List.generate(activeTypes.length, (i) {
                  final t = activeTypes[i];
                  final count = _store.countRewardsForType(t.id);
                  if (count == 0) return const SizedBox.shrink();
                  final color = palette[i % palette.length];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTypeId =
                            _selectedTypeId == t.id ? 'all' : t.id;
                        _highlightedBreakdownTypeId =
                            _selectedTypeId == 'all' ? null : t.id;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${t.name} ($count)',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardCard(RewardItemModel reward) {
    final badgeText = _store.badgeForType(reward.typeId);
    final hasNotes = reward.notes.trim().isNotEmpty;

    return GestureDetector(
      onTap: () => _handleOpenEditReward(reward),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: hasNotes ? 16 : 18,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          crossAxisAlignment:
              hasNotes ? CrossAxisAlignment.center : CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: hasNotes ? 14 : 0),
              child: RewardGlyphIcon(
                kind: reward.iconKind,
                color: AppColors.secondarySage,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        reward.name,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextOffWhite,
                          letterSpacing: -0.1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (hasNotes) ...[
                    const SizedBox(height: 5),
                    Text(
                      reward.notes,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextStoneGrey,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _handleOpenEditReward(reward),
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: UlvenikIcon(UlvenikIcons.edit,
                      size: 18,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _confirmDeleteReward(reward),
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: UlvenikIcon(UlvenikIcons.back,
                      size: 18,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFilteredState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const UlvenikIcon(UlvenikIcons.exercises,
            size: 32,
            color: AppColors.secondarySage,
          ),
          const SizedBox(height: 12),
          const Text(
            'No matching rewards',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextOffWhite,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try selecting another reward type chip or tap + to add a new reinforcer.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: AppColors.secondaryTextStoneGrey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedTypeId = 'all';
                _searchController.clear();
              });
            },
            child: const Text(
              'Show All Rewards',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: AppColors.primaryForestGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
