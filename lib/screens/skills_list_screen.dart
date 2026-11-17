import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import 'skill_details_screen.dart';
import 'add_skill_screen.dart';
import 'training_screen.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class _Skill {
  final String name;
  final int exercises;
  final int sessions;
  final int activeGoals;
  final int videos;
  final String lastTrained;
  final int recencyRank; // lower = trained more recently
  final bool needsWork;
  final bool mastered;
  final String? imageUrl;
  final IconData fallbackIcon;

  const _Skill({
    required this.name,
    required this.exercises,
    required this.sessions,
    this.activeGoals = 0,
    this.videos = 0,
    required this.lastTrained,
    required this.recencyRank,
    this.needsWork = false,
    this.mastered = false,
    this.imageUrl,
    this.fallbackIcon = Icons.layers_outlined,
  });
}

class _Dog {
  final String name;
  final String breed;
  final bool hasData;
  const _Dog(this.name, this.breed, this.hasData);
}

/// Names of the Core Training skills, so other areas (Sport) can link to them
/// instead of copying them.
List<String> coreSkillNames() => [for (final s in _skills) s.name];

const _skills = [
  _Skill(
    name: 'Recall',
    exercises: 4,
    sessions: 86,
    activeGoals: 1,
    videos: 3,
    lastTrained: 'Last trained yesterday',
    recencyRank: 0,
    needsWork: true,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBcZbWYwcivMxBfJpfHnCDSuoKrmlOOuGxFfsUTB9l9QlFN5bVAkCDL90pj9_1D1aDaPWRygGnUG0vnm_uYGeEwaVGgRDEnGNmdfeLYwFPJKUK8rrqkJOGgB-7unRteyjmby3BkGj3B6IGTOvJW6zJDjn9zJ9XOXmVtCY-JL9c9GGtipQqzQqjZTNplPRg6jZ4kicsAdKWZZZqDu-Tq7IGzoA-AYqjrDYBK6ecNgcQUV4LPDI1dPcs',
  ),
  _Skill(
    name: 'Heelwork',
    exercises: 3,
    sessions: 42,
    videos: 2,
    lastTrained: 'Last trained 3 days ago',
    recencyRank: 1,
    mastered: true,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuB_VLX90u6eEjBTH3Cb9DyRcVKogcUOqiMXhKrtwWsBTHVIfjvP5OyU1y95LLhrZ_py6xn94xdGWigNeeaU6nDaqpNRyqS4CbmOPtrv4CvBWoIXPh-snFhsAf_0s2IiWjDcKv2Mnqt60qJ2QPCeASIsaq9m_PyBA-ufI0x1T3YcEU3XsGYcHLI_x2rbhorE3jrinW_gRUlQYUhT2GYrMUMUs7oyCwCwYKwDbzjeYMVI24NSevFZBwk',
  ),
  _Skill(
    name: 'Retrieve',
    exercises: 6,
    sessions: 31,
    lastTrained: 'Last trained last week',
    recencyRank: 2,
    needsWork: true,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDA6YM77IUQLPx1wfCK77ajVWSizNv_FtSAeIIqHkzEGnsdioD0-6xOLlNpZLiWQ-11UsTmw50blVtidc_oaZX-DcNOY_iv4UHA5k3ZkEUtssOfq2Wx4KcFhMPDoRCM9RPEKpKhniXx1hzLhWgO9pg7MKU1aJVDQWjk2jxBLqgBeSphlT7Zv2UDU12NsrJrqShtgrVepvuo3Na6OUnNpTp1a_eV2An5BhPAV48pa6ltjSlxLqT6oto',
  ),
  _Skill(
    name: 'Send-away',
    exercises: 3,
    sessions: 23,
    lastTrained: 'Last trained 2 weeks ago',
    recencyRank: 3,
    needsWork: true,
    fallbackIcon: Icons.north_east,
  ),
  _Skill(
    name: 'Tracking',
    exercises: 5,
    sessions: 57,
    videos: 1,
    lastTrained: 'Last trained 3 weeks ago',
    recencyRank: 4,
    mastered: true,
    fallbackIcon: Icons.explore_outlined,
  ),
  _Skill(
    name: 'Stay',
    exercises: 0,
    sessions: 14,
    lastTrained: 'Last trained last month',
    recencyRank: 5,
    fallbackIcon: Icons.pause_circle_outline,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class SkillsListScreen extends StatefulWidget {
  final String dogName;
  final String breed;
  final bool hasData;

  const SkillsListScreen({
    super.key,
    this.dogName = 'Koda',
    this.breed = 'Belgian Malinois',
    this.hasData = true,
  });

  @override
  State<SkillsListScreen> createState() => _SkillsListScreenState();
}

class _SkillsListScreenState extends State<SkillsListScreen> {
  static const _filters = ['All', 'Recent', 'Focus Areas'];
  static const _sortLabels = ['Alphabetical', 'Most recently trained', 'Date created'];

  late List<_Dog> _dogs;
  late _Dog _dog;
  int _filter = 0; // 0 = All (default), 1 = Recent, 2 = Focus Areas
  int _sort = 1; // display order only; never changes records
  // Focus Areas are chosen by the handler, never classified automatically.
  final Set<String> _userMarkedNeedsWork = {'Recall', 'Retrieve', 'Send-away'};
  final List<_Skill> _customSkills = [];

  List<_Skill> get _allSkills => [..._customSkills, ..._skills];
  String _query = '';
  final TextEditingController _search = TextEditingController();

  bool get _hasData => _dog.hasData;

  @override
  void initState() {
    super.initState();
    // The dog the user came from, plus one more of the opposite state so the
    // dog selector can switch between populated and empty.
    final current = _Dog(widget.dogName, widget.breed, widget.hasData);
    final other = widget.hasData
        ? const _Dog('Nova', 'German Shepherd', false)
        : const _Dog('Koda', 'Belgian Malinois', true);
    _dogs = [current, other];
    _dog = current;
    _search.addListener(() => setState(() => _query = _search.text.toLowerCase()));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<_Skill> get _visible {
    if (!_hasData) return const [];
    var list = _allSkills.where((s) {
      if (_query.isNotEmpty && !s.name.toLowerCase().contains(_query)) {
        return false;
      }
      return switch (_filter) {
        2 => _userMarkedNeedsWork.contains(s.name), // based on skills user marked as needing work
        _ => true,
      };
    }).toList();
    if (_filter == 1) list = list.where((s) => s.sessions > 0).toList(); // Recent: trained skills only
    final bySort = _filter == 1 ? 1 : _sort;
    switch (bySort) {
      case 0:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      case 2:
        // Newly created skills first, then the rest in their original order.
        list.sort((a, b) => (a.recencyRank == -1 ? 0 : 1).compareTo(b.recencyRank == -1 ? 0 : 1));
      default:
        list.sort((a, b) => a.recencyRank.compareTo(b.recencyRank));
    }
    return list;
  }

  void _openSkillOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: UlvenikIcon(UlvenikIcons.skills, size: 22, color: AppColors.primaryTextOffWhite),
              title: Text('Manage Skills', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () {
                Navigator.pop(ctx);
                _showManage(exercises: false);
              },
            ),
            ListTile(
              leading: UlvenikIcon(UlvenikIcons.exercises, size: 22, color: AppColors.primaryTextOffWhite),
              title: Text('Manage Exercises', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () {
                Navigator.pop(ctx);
                _showManage(exercises: true);
              },
            ),
            ListTile(
              leading: UlvenikIcon(UlvenikIcons.sort, size: 22, color: AppColors.primaryTextOffWhite),
              title: Text('Sort Skills', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () {
                Navigator.pop(ctx);
                _showSort();
              },
            ),
          ]),
        ),
      ),
    );
  }

  void _showSort() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Sort Skills',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Changes the display order only.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
            for (var i = 0; i < _sortLabels.length; i++)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_sortLabels[i], style: TextStyle(color: AppColors.primaryTextOffWhite)),
                trailing: _sort == i ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                onTap: () {
                  setState(() {
                    _sort = i;
                    if (_filter == 1) _filter = 0;
                  });
                  Navigator.pop(ctx);
                },
              ),
          ]),
        ),
      ),
    );
  }

  /// Lists the dog's skills (or their exercises, grouped by skill). Tapping a
  /// skill opens it, where it can be edited, archived or deleted.
  void _showManage({required bool exercises}) {
    final skills = _allSkills;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.8),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            children: [
              Text(exercises ? 'Manage Exercises' : 'Manage Skills',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                exercises
                    ? '${_dog.name}\'s exercises, grouped by skill. Open a skill to add or edit them.'
                    : 'Open a skill to edit, archive or delete it.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 8),
              for (final s in skills) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(s.name, style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
                  subtitle: Text('${s.exercises} ${s.exercises == 1 ? 'Exercise' : 'Exercises'}',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  trailing: UlvenikIcon(UlvenikIcons.details, size: 18, color: AppColors.secondaryTextStoneGrey),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SkillDetailsScreen(skillName: s.name, dogName: _dog.name)));
                  },
                ),
                if (exercises)
                  for (final e in TrainingSessionStore.exercisesForSkill(s.name))
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 6),
                      child: Text('• $e', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _openCreateSkill() async {
    final created = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AddSkillScreen()),
    );
    if (created != null && created.trim().isNotEmpty) {
      final key = normalizeTrainingKey(created);
      final exists = _allSkills.any((s) => normalizeTrainingKey(s.name) == key);
      if (!exists) {
        setState(() {
          _customSkills.insert(
            0,
            _Skill(
              name: created.trim(),
              exercises: TrainingSessionStore.exercisesForSkill(created).length,
              sessions: 0,
              lastTrained: 'Created just now',
              recencyRank: -1,
            ),
          );
          if (!_hasData) {
            _dog = _Dog(_dog.name, _dog.breed, true);
          }
        });
      }
    }
  }

  void _pickDog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Text('Select dog',
                  style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ..._dogs.map((d) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: _dogAvatar(d.name, 40),
                    title: Text(d.name,
                        style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    subtitle: Text(d.breed,
                        style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12)),
                    trailing: d.name == _dog.name
                        ? Icon(Icons.check,
                            color: AppColors.primaryForestGreen)
                        : null,
                    onTap: () {
                      Navigator.pop(c);
                      setState(() {
                        _dog = d;
                        _filter = 0;
                        _search.clear();
                      });
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;
    final skills = _visible;

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: Stack(
        children: [
          Column(
            children: [
              _buildTopBar(topSafe),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
                      children: [
                        _buildDogSelector(),
                        const SizedBox(height: 16),
                        _buildStatStrip(),
                        const SizedBox(height: 12),
                        _buildAddSkillButton(),
                        const SizedBox(height: 16),
                        _buildSearch(),
                        if (_hasData) ...[
                          const SizedBox(height: 12),
                          _buildFilters(),
                        ],
                        const SizedBox(height: 20),
                        if (!_hasData)
                          _buildEmptyState()
                        else if (skills.isEmpty)
                          _buildNoResults()
                        else
                          ...skills.map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildSkillCard(s),
                              )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Full-width Add Skill under the stat cards; scrolls with the page (no FAB).
  Widget _buildAddSkillButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _openCreateSkill,
        icon: const UlvenikIcon(UlvenikIcons.add, size: 20),
        label: const Text('Add Skill', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryForestGreen,
          foregroundColor: AppColors.onForestGreen,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildTopBar(double topSafe) {
    return Container(
      padding: EdgeInsets.only(top: topSafe),
      decoration: BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: UlvenikIcon(UlvenikIcons.back,
                    color: AppColors.secondaryTextStoneGrey, size: 28),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              // Double tap the title to flip between populated and empty (testing)
              GestureDetector(
                onDoubleTap: () => setState(() {
                  _dog = _hasData
                      ? _Dog(_dog.name, _dog.breed, false)
                      : _Dog(_dog.name, _dog.breed, true);
                }),
                child: Text('Skills & Exercises',
                    style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3)),
              ),
              IconButton(
                tooltip: 'Skill options',
                icon: UlvenikIcon(UlvenikIcons.overflowMenu,
                    color: AppColors.secondaryTextStoneGrey),
                onPressed: _openSkillOptions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dogAvatar(String name, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.secondarySage.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Center(
        child: Text(name.isEmpty ? '?' : name[0],
            style: TextStyle(
                color: AppColors.secondarySage,
                fontSize: size * 0.4,
                fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildDogSelector() {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _pickDog,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              _dogAvatar(_dog.name, 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_dog.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    Text(_dog.breed,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.unfold_more,
                  color: AppColors.secondaryTextStoneGrey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatStrip() {
    // Two equal, tappable cards (no Sessions figure: it lives on the dog profile).
    final skills = _hasData ? _allSkills.length : 0;
    final exercises = _hasData ? _allSkills.fold<int>(0, (a, s) => a + s.exercises) : 0;

    Widget card(String icon, String value, String label, VoidCallback onTap) => Expanded(
          child: Material(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
                child: Column(children: [
                  UlvenikIcon(icon, size: 22, color: AppColors.secondarySage),
                  const SizedBox(height: 8),
                  Text(value,
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(label, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                ]),
              ),
            ),
          ),
        );

    return Row(children: [
      card(UlvenikIcons.skills, '$skills', 'Skills', () => setState(() {
            _filter = 0;
            _search.clear();
          })),
      const SizedBox(width: 12),
      card(UlvenikIcons.exercises, '$exercises', 'Exercises', () => _showManage(exercises: true)),
    ]);
  }

  Widget _buildSearch() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          UlvenikIcon(UlvenikIcons.search,
              color: AppColors.secondaryTextStoneGrey, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _search,
              enabled: _hasData,
              cursorColor: AppColors.primaryForestGreen,
              style: TextStyle(
                  color: AppColors.primaryTextOffWhite, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search skills and exercises...',
                hintStyle: TextStyle(
                    color: AppColors.secondaryTextStoneGrey, fontSize: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: _search.clear,
              child: Icon(Icons.close,
                  size: 18, color: AppColors.secondaryTextStoneGrey),
            ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = _filter == i;
          return GestureDetector(
            onTap: () => setState(() => _filter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primaryForestGreen
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                    color: active
                        ? AppColors.primaryForestGreen
                        : AppColors.cardBorder),
              ),
              child: Text(_filters[i],
                  style: TextStyle(
                      color: active
                          ? AppColors.primaryTextOffWhite
                          : AppColors.secondaryTextStoneGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkillCard(_Skill s) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SkillDetailsScreen(skillName: s.name, dogName: _dog.name),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _thumb(s),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(s.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                        ),
                        // Subtle indicator for handler-chosen Focus Areas.
                        if (_userMarkedNeedsWork.contains(s.name)) ...[
                          const SizedBox(width: 8),
                          Tooltip(
                            message: 'Focus Area',
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: Color(0xFF6FBF8E), shape: BoxShape.circle),
                            ),
                          ),
                        ],
                        const Spacer(),
                        UlvenikIcon(UlvenikIcons.details,
                            size: 20,
                            color: AppColors.secondaryTextStoneGrey),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${s.exercises} ${s.exercises == 1 ? 'Exercise' : 'Exercises'}',
                        style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 13)),
                    // Only when a qualifying session exists; no placeholder wording.
                    if (s.sessions > 0 && s.lastTrained.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(s.lastTrained,
                          style: TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 13)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumb(_Skill s) {
    final fallback = Container(
      color: AppColors.backgroundObsidian,
      child: UlvenikIcon.fromMaterial(s.fallbackIcon,
          size: 28, color: AppColors.secondaryTextStoneGrey),
    );
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: s.imageUrl == null
            ? fallback
            : Image.network(s.imageUrl!,
                fit: BoxFit.cover, errorBuilder: (c, e, st) => fallback),
      ),
    );
  }


  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: UlvenikIcon(UlvenikIcons.skills,
                size: 30, color: AppColors.primaryForestGreen),
          ),
          const SizedBox(height: 20),
          Text('No Skills Yet',
              style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(
            "Create your dog’s skills, add exercises and track their progress over time.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 15,
                height: 1.5),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: AppColors.primaryForestGreen,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _openCreateSkill,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text('Create First Skill',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(width: 8),
                      UlvenikIcon(UlvenikIcons.details,
                          size: 18, color: AppColors.primaryTextOffWhite),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.search_off,
              size: 40,
              color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text('No skills match your filters',
              style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() {
              _filter = 0;
              _search.clear();
            }),
            child: Text('Clear Filters',
                style: TextStyle(color: AppColors.primaryForestGreen)),
          ),
        ],
      ),
    );
  }
}
