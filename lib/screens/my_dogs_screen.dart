import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../theme/app_colors.dart';
import 'dog_profile_screen.dart';
import 'notifications_page_screen.dart';

enum _DogSort { alphabetical, recentlyActive }

enum _ActivityFilter { any, last7, last30 }

/// Dogs (Dogs & Goals handover, sections 01-03).
///
/// One screen titled "Dogs" with two groups: My Dogs and (Trainer Pack only)
/// Client Dogs. Compact List View by default plus a wide-photo Card View; the
/// toggle changes presentation only and is remembered. Search, Filter and a
/// single Add action stay fixed while the list scrolls. No promotional or
/// subscription banners.
class MyDogsScreen extends StatefulWidget {
  final bool hasTrainerPack;
  final bool? initialCardView;

  const MyDogsScreen({super.key, this.hasTrainerPack = true, this.initialCardView});

  @override
  State<MyDogsScreen> createState() => _MyDogsScreenState();
}

class _MyDogsScreenState extends State<MyDogsScreen> {
  // Remembers the last chosen layout for the rest of the app session.
  static bool _rememberedCardView = false;

  bool _hasData = true; // demo toggle: double-tap the "Dogs" title
  bool _clientGroup = false;
  late bool _cardView = widget.initialCardView ?? _rememberedCardView;
  final bool _hasUnreadNotifications = true;

  final _searchController = TextEditingController();
  String _query = '';
  final Set<String> _breeds = {};
  String? _sex; // null = any
  _ActivityFilter _activity = _ActivityFilter.any;
  _DogSort _sort = _DogSort.alphabetical;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters =>
      _breeds.isNotEmpty || _sex != null || _activity != _ActivityFilter.any || _sort != _DogSort.alphabetical;

  List<DogInfo> get _groupDogs => _clientGroup ? SampleData.clientDogs : SampleData.myDogs;

  List<DogInfo> get _visibleDogs {
    final q = _query.trim().toLowerCase();
    final now = DateTime.now();
    final list = _groupDogs.where((d) {
      if (q.isNotEmpty && !d.name.toLowerCase().contains(q) && !d.breed.toLowerCase().contains(q)) return false;
      if (_breeds.isNotEmpty && !_breeds.contains(d.breed)) return false;
      if (_sex != null && d.sex != _sex) return false;
      if (_activity != _ActivityFilter.any) {
        final days = _activity == _ActivityFilter.last7 ? 7 : 30;
        if (d.lastActive == null || now.difference(d.lastActive!).inDays > days) return false;
      }
      return true;
    }).toList();
    if (_sort == _DogSort.alphabetical) {
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else {
      list.sort((a, b) {
        if (a.lastActive == null && b.lastActive == null) return a.name.compareTo(b.name);
        if (a.lastActive == null) return 1;
        if (b.lastActive == null) return -1;
        return b.lastActive!.compareTo(a.lastActive!);
      });
    }
    return list;
  }

  void _setView(bool card) {
    setState(() {
      _cardView = card;
      _rememberedCardView = card;
    });
  }

  void _clearFilters() {
    setState(() {
      _breeds.clear();
      _sex = null;
      _activity = _ActivityFilter.any;
      _sort = _DogSort.alphabetical;
    });
  }

  void _openDog(DogInfo dog) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DogProfileScreen(dogName: dog.name)));
  }

  void _addDog() {
    AppSnackbar.show(
      context,
      message: 'Create Dog Profile is not part of this build yet.',
      type: SnackbarType.info,
    );
  }

  // ── Filter sheet ────────────────────────────────────────────────────────
  void _openFilters() {
    final breeds = (_groupDogs.map((d) => d.breed).toSet().toList()..sort());
    final draftBreeds = {..._breeds};
    String? draftSex = _sex;
    var draftActivity = _activity;
    var draftSort = _sort;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          Widget chip(String label, bool selected, VoidCallback onTap) => _Chip(label: label, selected: selected, onTap: onTap);
          Widget heading(String text, {String? icon}) => Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 10),
                child: Row(children: [
                  if (icon != null) ...[
                    UlvenikIcon(icon, size: 16, color: AppColors.secondaryTextStoneGrey),
                    const SizedBox(width: 6),
                  ],
                  Text(text, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                ]),
              );
          return SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.85),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36, height: 4,
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Filter & sort',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                    heading('Breed'),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final b in breeds)
                        chip(b, draftBreeds.contains(b), () => setSheet(() {
                              draftBreeds.contains(b) ? draftBreeds.remove(b) : draftBreeds.add(b);
                            })),
                    ]),
                    heading('Sex'),
                    Wrap(spacing: 8, children: [
                      chip('Any', draftSex == null, () => setSheet(() => draftSex = null)),
                      chip('Male', draftSex == 'Male', () => setSheet(() => draftSex = 'Male')),
                      chip('Female', draftSex == 'Female', () => setSheet(() => draftSex = 'Female')),
                    ]),
                    heading('Recent activity'),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      chip('Any time', draftActivity == _ActivityFilter.any, () => setSheet(() => draftActivity = _ActivityFilter.any)),
                      chip('Last 7 days', draftActivity == _ActivityFilter.last7, () => setSheet(() => draftActivity = _ActivityFilter.last7)),
                      chip('Last 30 days', draftActivity == _ActivityFilter.last30, () => setSheet(() => draftActivity = _ActivityFilter.last30)),
                    ]),
                    heading('Sort', icon: UlvenikIcons.sort),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      chip('Alphabetical', draftSort == _DogSort.alphabetical, () => setSheet(() => draftSort = _DogSort.alphabetical)),
                      chip('Most recently active', draftSort == _DogSort.recentlyActive,
                          () => setSheet(() => draftSort = _DogSort.recentlyActive)),
                    ]),
                    const SizedBox(height: 24),
                    Row(children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => setSheet(() {
                              draftBreeds.clear();
                              draftSex = null;
                              draftActivity = _ActivityFilter.any;
                              draftSort = _DogSort.alphabetical;
                            }),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryTextOffWhite,
                              side: const BorderSide(color: Colors.white24),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Clear Filters'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _breeds
                                  ..clear()
                                  ..addAll(draftBreeds);
                                _sex = draftSex;
                                _activity = draftActivity;
                                _sort = draftSort;
                              });
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryForestGreen,
                              foregroundColor: AppColors.primaryTextOffWhite,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Apply'),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            // Sticky controls: stay visible while the list scrolls.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.hasTrainerPack && _hasData) ...[
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      _GroupPill(
                        label: 'My Dogs',
                        count: SampleData.myDogs.length,
                        selected: !_clientGroup,
                        onTap: () => setState(() => _clientGroup = false),
                      ),
                      _GroupPill(
                        label: 'Client Dogs',
                        count: SampleData.clientDogs.length,
                        selected: _clientGroup,
                        onTap: () => setState(() => _clientGroup = true),
                      ),
                    ]),
                    const SizedBox(height: 12),
                  ],
                  Row(children: [
                    Expanded(child: _buildSearchField()),
                    const SizedBox(width: 10),
                    _SquareButton(
                      tooltip: 'Filter',
                      onTap: _hasData ? _openFilters : null,
                      badge: _hasActiveFilters,
                      child: const Icon(Icons.tune, color: AppColors.primaryTextOffWhite, size: 20),
                    ),
                    const SizedBox(width: 10),
                    _SquareButton(
                      tooltip: 'Add Dog',
                      primary: true,
                      onTap: _addDog,
                      child: const UlvenikIcon(UlvenikIcons.add, color: AppColors.primaryTextOffWhite, size: 20),
                    ),
                  ]),
                ],
              ),
            ),
            Expanded(child: _hasData ? _buildDogList() : _buildEmpty()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onDoubleTap: () => setState(() => _hasData = !_hasData),
              child: const Text(
                'Dogs',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          if (_hasData)
            _ViewToggle(cardView: _cardView, onChanged: _setView),
          IconButton(
            tooltip: 'Notifications & Reminders',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPageScreen())),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const UlvenikIcon(UlvenikIcons.notifications, color: AppColors.primaryTextOffWhite, size: 24),
                if (_hasUnreadNotifications)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6FBF8E),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.backgroundObsidian, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search name or breed',
          hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
          filled: true,
          fillColor: AppColors.cardsCarbon,
          contentPadding: EdgeInsets.zero,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: UlvenikIcon(UlvenikIcons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 44),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                  onPressed: () => setState(() {
                    _searchController.clear();
                    _query = '';
                  }),
                ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryForestGreen),
          ),
        ),
      ),
    );
  }

  Widget _buildDogList() {
    final dogs = _visibleDogs;
    if (dogs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No matching dogs',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('Try another search or clear your filters.',
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
              if (_hasActiveFilters) ...[
                const SizedBox(height: 12),
                TextButton(onPressed: _clearFilters, child: const Text('Clear Filters')),
              ],
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      itemCount: dogs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _cardView
          ? _WideDogCard(dog: dogs[i], onTap: () => _openDog(dogs[i]))
          : _ListDogCard(dog: dogs[i], onTap: () => _openDog(dogs[i])),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const UlvenikIcon(UlvenikIcons.dogs, size: 48, color: AppColors.secondarySage),
            const SizedBox(height: 20),
            const Text('No dogs added yet',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            const Text(
              'Add your first dog to start recording their journey with Ulvenik.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _addDog,
              icon: const UlvenikIcon(UlvenikIcons.add, size: 20),
              label: const Text('Add Dog'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryForestGreen,
                foregroundColor: AppColors.primaryTextOffWhite,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pieces ────────────────────────────────────────────────────────────────

class _ViewToggle extends StatelessWidget {
  final bool cardView;
  final ValueChanged<bool> onChanged;
  const _ViewToggle({required this.cardView, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget seg(String icon, String label, bool selected, VoidCallback onTap) => Semantics(
          button: true,
          selected: selected,
          label: label,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Container(
              width: 40,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryForestGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: UlvenikIcon(icon,
                  size: 18, color: selected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey),
            ),
          ),
        );
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        seg(UlvenikIcons.listView, 'List view', !cardView, () => onChanged(false)),
        seg(UlvenikIcons.cardView, 'Card view', cardView, () => onChanged(true)),
      ]),
    );
  }
}

class _GroupPill extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  const _GroupPill({required this.label, required this.count, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryForestGreen : AppColors.cardsCarbon,
          border: Border.all(color: selected ? AppColors.primaryForestGreen : Colors.white12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$label  $count',
          style: TextStyle(
            color: selected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  final Widget child;
  final String tooltip;
  final VoidCallback? onTap;
  final bool primary;
  final bool badge;
  const _SquareButton({required this.child, required this.tooltip, this.onTap, this.primary = false, this.badge = false});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: primary ? AppColors.primaryForestGreen : AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primary ? AppColors.primaryForestGreen : Colors.white12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                child,
                if (badge)
                  const Positioned(
                    right: 9,
                    top: 9,
                    child: SizedBox(
                      width: 7,
                      height: 7,
                      child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF6FBF8E), shape: BoxShape.circle)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryForestGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primaryForestGreen : Colors.white24),
        ),
        child: Text(label,
            style: TextStyle(
              color: selected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }
}

Widget _pawPlaceholder({double size = 32}) => Container(
      color: const Color(0xFF26302C),
      alignment: Alignment.center,
      child: UlvenikIcon(UlvenikIcons.dogs, size: size, color: AppColors.secondarySage),
    );

/// Compact list card: square rounded photo, name, "breed · age · sex".
class _ListDogCard extends StatelessWidget {
  final DogInfo dog;
  final VoidCallback onTap;
  const _ListDogCard({required this.dog, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 76,
                  height: 76,
                  child: dog.photoUrl == null
                      ? _pawPlaceholder()
                      : Image.network(dog.photoUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) => _pawPlaceholder()),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dog.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(dog.details,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wide card: full photo with an understated bottom gradient for legible text.
class _WideDogCard extends StatelessWidget {
  final DogInfo dog;
  final VoidCallback onTap;
  const _WideDogCard({required this.dog, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: AppColors.cardsCarbon,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 176,
            child: Stack(
              fit: StackFit.expand,
              children: [
                dog.photoUrl == null
                    ? _pawPlaceholder(size: 44)
                    : Image.network(dog.photoUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) => _pawPlaceholder(size: 44)),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.45, 1.0],
                      colors: [Colors.transparent, Color(0xCC121212)],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(dog.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(dog.details,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFFD5DAD7), fontSize: 13)),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
