import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'skill_details_screen.dart';
import 'add_skill_screen.dart';

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
  static const _filters = ['Recently Trained', 'All Skills', 'Needs Work', 'Mastered'];

  late List<_Dog> _dogs;
  late _Dog _dog;
  int _filter = 0;
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
    var list = _skills.where((s) {
      if (_query.isNotEmpty && !s.name.toLowerCase().contains(_query)) {
        return false;
      }
      return switch (_filter) {
        2 => s.needsWork,
        3 => s.mastered,
        _ => true,
      };
    }).toList();
    if (_filter == 1) {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else {
      list.sort((a, b) => a.recencyRank.compareTo(b.recencyRank));
    }
    return list;
  }

  void _toast(String m, SnackbarType t) =>
      AppSnackbar.show(context, message: m, type: t);

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
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const Text('Select dog',
                  style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ..._dogs.map((d) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: _dogAvatar(d.name, 40),
                    title: Text(d.name,
                        style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    subtitle: Text(d.breed,
                        style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12)),
                    trailing: d.name == _dog.name
                        ? const Icon(Icons.check,
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
          // FAB: 56x56, Forest Green, no shadow
          Positioned(
            right: 20,
            bottom: 24,
            child: Material(
              color: AppColors.primaryForestGreen,
              shape: const CircleBorder(
                  side: BorderSide(color: Colors.white12)),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddSkillScreen()),
                  );
                },
                child: const SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.add,
                      color: AppColors.primaryTextOffWhite, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(double topSafe) {
    return Container(
      padding: EdgeInsets.only(top: topSafe),
      decoration: const BoxDecoration(
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
                icon: const Icon(Icons.chevron_left,
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
                child: const Text('Skills',
                    style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3)),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz,
                    color: AppColors.secondaryTextStoneGrey),
                onPressed: () =>
                    _toast('Skill options coming soon', SnackbarType.info),
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
        color: AppColors.secondarySage.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white12),
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
            border: Border.all(color: Colors.white12),
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
                        style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    Text(_dog.breed,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.unfold_more,
                  color: AppColors.secondaryTextStoneGrey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatStrip() {
    final skills = _hasData ? _skills.length : 0;
    final exercises =
        _hasData ? _skills.fold<int>(0, (a, s) => a + s.exercises) : 0;
    final sessions =
        _hasData ? _skills.fold<int>(0, (a, s) => a + s.sessions) : 0;

    Widget cell(String value, String label, {bool last = false}) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              border: last
                  ? null
                  : const Border(right: BorderSide(color: Colors.white12)),
            ),
            child: Column(
              children: [
                Text(value,
                    style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(label,
                    style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6)),
              ],
            ),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          cell('$skills', 'SKILLS'),
          cell('$exercises', 'EXERCISES'),
          cell('$sessions', 'SESSIONS', last: true),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search,
              color: AppColors.secondaryTextStoneGrey, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _search,
              enabled: _hasData,
              cursorColor: AppColors.primaryForestGreen,
              style: const TextStyle(
                  color: AppColors.primaryTextOffWhite, fontSize: 14),
              decoration: const InputDecoration(
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
              child: const Icon(Icons.close,
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
        separatorBuilder: (_, __) => const SizedBox(width: 8),
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
                        : Colors.white12),
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
              builder: (context) => SkillDetailsScreen(skillName: s.name),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
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
                        Expanded(
                          child: Text(s.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const Icon(Icons.chevron_right,
                            size: 20,
                            color: AppColors.secondaryTextStoneGrey),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${s.exercises} Exercises · ${s.sessions} Sessions',
                        style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12)),
                    if (s.activeGoals > 0 || s.videos > 0) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (s.activeGoals > 0)
                            _badge(Icons.flag,
                                '${s.activeGoals} ACTIVE GOAL',
                                highlight: true),
                          if (s.videos > 0)
                            _badge(Icons.videocam_outlined,
                                '${s.videos} VIDEOS'),
                        ],
                      ),
                    ],
                    if (s.recencyRank == 0) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 12),
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.white12)),
                        ),
                        child: Text(s.lastTrained,
                            style: const TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 12)),
                      ),
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
      child: Icon(s.fallbackIcon,
          size: 28, color: AppColors.secondaryTextStoneGrey),
    );
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
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

  Widget _badge(IconData icon, String label, {bool highlight = false}) {
    final color =
        highlight ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primaryForestGreen.withOpacity(0.18)
            : AppColors.backgroundObsidian,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: highlight
                ? AppColors.primaryForestGreen.withOpacity(0.4)
                : Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12),
            ),
            child: const Icon(Icons.layers_outlined,
                size: 30, color: AppColors.primaryForestGreen),
          ),
          const SizedBox(height: 20),
          const Text('No Skills Yet',
              style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(
            "Start building ${_dog.name}'s foundation. Add behaviors, track progress, and log training sessions here.",
            textAlign: TextAlign.center,
            style: const TextStyle(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddSkillScreen()),
                  );
                },
                child: const Padding(
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
                      Icon(Icons.arrow_forward,
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
              color: AppColors.secondaryTextStoneGrey.withOpacity(0.5)),
          const SizedBox(height: 12),
          const Text('No skills match your filters',
              style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() {
              _filter = 0;
              _search.clear();
            }),
            child: const Text('Clear Filters',
                style: TextStyle(color: AppColors.primaryForestGreen)),
          ),
        ],
      ),
    );
  }
}
