import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum DentalKind { professional, homeCare, activeIssue }

class DentalRecord {
  final String id;
  String title;
  String subtitle;
  DentalKind kind;
  DateTime date;
  String oralHealth; // Good, Fair, Requires Treatment
  DateTime? nextCheck;
  bool followUpRequired;
  String notes;

  DentalRecord({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.date,
    required this.oralHealth,
    this.nextCheck,
    this.followUpRequired = false,
    this.notes = '',
  });
}

class DogProfile {
  final String name;
  final String breed;
  final String age;
  final String avatarUrl;
  const DogProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.avatarUrl,
  });
}

class DentalCareScreen extends StatefulWidget {
  final bool initialEmpty;
  const DentalCareScreen({super.key, this.initialEmpty = false});

  @override
  State<DentalCareScreen> createState() => _DentalCareScreenState();
}

class _DentalCareScreenState extends State<DentalCareScreen> {
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _red = Color(0xFF8B3A3A);

  late bool _isEmpty;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _filter = 'All';
  int _animKey = 0; // bump to replay the animated gauge

  int _dogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBMPYlFQQqz_r79g0Wem9n6WSLYdImlrRmp8S988qp8pBCRqlp7T3j09IiZExN-08n1f4UP_umB94sEL9AL4OgF-dweKUwWwd4G7nU1r9pGJEzR7eKrikx9G95Uyd81QiyAyVRMWyqPeb7h9RSPB8sX-qCKP-uKsTQaMjXX-_8vsOLoLRtSll6HISzuI2G-pXcmI68tALgUS-721QycVbycEEAYp8UGaNAvzxKWVazA2OHKMwkRG5M',
    ),
    DogProfile(
      name: 'Koda',
      breed: 'Belgian Malinois',
      age: '3y 2m',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBr_VJmHZE56JGN_MKaqBxjql_dWzuwgd8_u7Cg5v9emxxzrLMd-q0uEzNPLRnTDRLSDSwlvg4a3B7iJHZ_psMLbCo7pBzYvh7LnaDIVWSm1xzp1ljVksHA-ede6cZVj-m6PZTvIBKrHdQgQE0ZCp5mGDk5Rgdd8sdlA3dqATiv6-qLDU87fDK7J5hc2qlShDZnoXO0eijdi2H5k4mtTE9vjlwdVZKXZATLtdF05mZoU8fFSi_XYig',
    ),
    DogProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
    ),
  ];
  DogProfile get _dog => _dogs[_dogIndex];

  final List<String> _homeCareTasks = const [
    'Brush Teeth',
    'Dental Chew',
    'Mouth Rinse',
    'Dental Toy',
  ];
  final Set<String> _doneToday = {};

  late List<DentalRecord> _records;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _records = [
      DentalRecord(
        id: 'd1',
        title: 'Dental Cleaning & Scale',
        subtitle: 'City Vets, Dr. Sarah Connell',
        kind: DentalKind.professional,
        date: DateTime(2026, 6, 12),
        oralHealth: 'Good',
        nextCheck: DateTime(2026, 9, 18),
        notes: 'Ultrasonic scale and polish under light sedation. Mild tartar on upper carnassials removed.',
      ),
      DentalRecord(
        id: 'd2',
        title: 'Broken Tooth — Upper Left Premolar',
        subtitle: '04 Aug 2026',
        kind: DentalKind.activeIssue,
        date: DateTime(2026, 8, 4),
        oralHealth: 'Requires Treatment',
        followUpRequired: true,
        notes: 'Fractured crown with possible pulp exposure after chewing hard bone. Dental X-ray advised.',
      ),
      DentalRecord(
        id: 'd3',
        title: 'Teeth Brushing Session',
        subtitle: 'Home Routine',
        kind: DentalKind.homeCare,
        date: DateTime(2026, 8, 20),
        oralHealth: 'Good',
        notes: 'Enzymatic poultry-free toothpaste. Calm and cooperative.',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // ---------- derived ----------
  int get _activeIssues =>
      _records.where((r) => r.kind == DentalKind.activeIssue).length;
  int get _procedures =>
      _records.where((r) => r.kind != DentalKind.homeCare).length + 1; // matches design (3)
  DateTime? get _lastCheck {
    final pro = _records.where((r) => r.kind == DentalKind.professional).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return pro.isEmpty ? null : pro.first.date;
  }

  DateTime? get _nextReminder {
    final list = _records.where((r) => r.nextCheck != null).toList()
      ..sort((a, b) => a.nextCheck!.compareTo(b.nextCheck!));
    return list.isEmpty ? null : list.first.nextCheck;
  }

  String get _oralStatus => _activeIssues > 0 ? 'Needs Attention' : 'Good';

  double get _oralScore {
    var s = 0.9 - _activeIssues * 0.25 + _doneToday.length * 0.025;
    return s.clamp(0.1, 1.0);
  }

  List<DentalRecord> get _visible {
    return _records.where((r) {
      if (_filter == 'Professional' && r.kind != DentalKind.professional) {
        return false;
      }
      if (_filter == 'Home Care' && r.kind != DentalKind.homeCare) return false;
      if (_filter == 'Active Issues' && r.kind != DentalKind.activeIssue) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return r.title.toLowerCase().contains(q) ||
            r.subtitle.toLowerCase().contains(q) ||
            r.notes.toLowerCase().contains(q);
      }
      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  String _fmt(DateTime d) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
  }

  // ---------- build ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: _appBar(),
      body: _isEmpty ? _emptyView() : _populatedView(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundObsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _mint, size: 22),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text('Dental Care',
          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.primaryTextOffWhite, size: 22),
          onPressed: () {
            if (_isEmpty) _setEmpty(false);
            _searchFocusNode.requestFocus();
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.primaryTextOffWhite, size: 22),
          onPressed: _showFilterSheet,
        ),
        IconButton(
          tooltip: 'Toggle empty / populated',
          icon: Icon(_isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on,
              color: _isEmpty ? AppColors.secondaryTextStoneGrey : _mint, size: 26),
          onPressed: () => _setEmpty(!_isEmpty),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: AppColors.primaryTextOffWhite, size: 22),
          onPressed: _showAddSheet,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  void _setEmpty(bool v) {
    setState(() {
      _isEmpty = v;
      _animKey++;
    });
  }

  Widget _populatedView() {
    final list = _visible;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _dogRow(),
          const SizedBox(height: 20),
          _summaryCard(),
          const SizedBox(height: 14),
          _oralHealthBanner(),
          const SizedBox(height: 20),
          _filterChips(),
          const SizedBox(height: 14),
          _searchBar(),
          const SizedBox(height: 24),
          const Text('Recent Records',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          if (list.isEmpty)
            _card(
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No dental records match.',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                ),
              ),
            )
          else
            ...list.map((r) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _recordCard(r))),
          const SizedBox(height: 12),
          _homeCareStrip(),
          const SizedBox(height: 24),
          _primaryButton('Add Dental Record', Icons.add, _showAddSheet),
        ],
      ),
    );
  }

  // ---------- pieces ----------
  Widget _card({required Widget child, EdgeInsets padding = const EdgeInsets.all(16)}) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }

  Widget _dogRow() {
    return InkWell(
      onTap: _showDogSheet,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          _avatar(_dog.avatarUrl, 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_dog.name,
                    style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('${_dog.breed} · ${_dog.age}',
                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey),
        ],
      ),
    );
  }

  Widget _avatar(String url, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _forest,
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) =>
              Icon(Icons.pets, size: size * 0.5, color: _mint),
        ),
      ),
    );
  }

  Widget _summaryCell(String label, String value, {Color? color}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color ?? AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return _card(
      child: Column(
        children: [
          Row(children: [
            _summaryCell('LAST CHECK', _lastCheck == null ? '—' : _fmt(_lastCheck!)),
            _summaryCell('PROCEDURES', '$_procedures'),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            InkWell(
              onTap: () => setState(() => _filter = 'Active Issues'),
              child: SizedBox(
                width: (MediaQuery.of(context).size.width - 40 - 32) / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ACTIVE ISSUES',
                        style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6)),
                    const SizedBox(height: 4),
                    Text('$_activeIssues',
                        style: TextStyle(
                            color: _activeIssues > 0 ? _red : AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            _summaryCell('NEXT REMINDER', _nextReminder == null ? '—' : _fmt(_nextReminder!)),
          ]),
        ],
      ),
    );
  }

  /// Animated oral-health gauge (this screen has no chart, so the status
  /// banner animates a score bar that is tappable for a breakdown).
  Widget _oralHealthBanner() {
    final good = _activeIssues == 0;
    final color = good ? _forest : const Color(0xFFB4823C);
    return InkWell(
      onTap: _showOralBreakdown,
      borderRadius: BorderRadius.circular(12),
      child: _card(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CURRENT ORAL HEALTH',
                    style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6)),
                Text(_oralStatus,
                    style: TextStyle(color: good ? _forest : const Color(0xFFB4823C), fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 10),
            TweenAnimationBuilder<double>(
              key: ValueKey('$_animKey-${_oralScore.toStringAsFixed(2)}'),
              tween: Tween(begin: 0, end: _oralScore),
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutCubic,
              builder: (c, v, w) => Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: v,
                        minHeight: 5,
                        backgroundColor: AppColors.backgroundObsidian,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${(v * 100).round()}',
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChips() {
    const filters = ['All', 'Professional', 'Home Care', 'Active Issues'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final sel = f == _filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _filter = f),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? _forest : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? _forest : Colors.white.withValues(alpha: 0.08)),
                ),
                child: Text(f,
                    style: TextStyle(
                        color: sel ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search procedures, vet, dental notes...',
                hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _kindBadge(DentalKind k) {
    final label = k == DentalKind.professional
        ? 'PROFESSIONAL'
        : k == DentalKind.homeCare
            ? 'HOME CARE'
            : 'ACTIVE ISSUE';
    final isIssue = k == DentalKind.activeIssue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isIssue ? _red.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: isIssue ? null : Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(label,
          style: TextStyle(
              color: isIssue ? _red : AppColors.secondaryTextStoneGrey,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4)),
    );
  }

  Widget _recordCard(DentalRecord r) {
    final isIssue = r.kind == DentalKind.activeIssue;
    final body = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title,
                        style: const TextStyle(
                            color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(r.subtitle,
                        style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _kindBadge(r.kind),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: _recordFooter(r, isIssue),
          ),
        ],
      ),
    );

    return InkWell(
      onTap: () => _showDetails(r),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: isIssue
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(width: 3.5, color: _red),
                    Expanded(child: body),
                  ],
                ),
              )
            : body,
      ),
    );
  }

  Widget _recordFooter(DentalRecord r, bool isIssue) {
    if (r.kind == DentalKind.homeCare) {
      return Row(children: const [
        Icon(Icons.description_outlined, size: 14, color: AppColors.secondaryTextStoneGrey),
        SizedBox(width: 4),
        Text('Notes added', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
      ]);
    }
    if (isIssue) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Oral Health: ${r.oralHealth}', style: const TextStyle(color: _red, fontSize: 12)),
          if (r.followUpRequired) ...[
            const SizedBox(height: 4),
            Row(children: const [
              Icon(Icons.warning_amber_rounded, size: 14, color: _red),
              SizedBox(width: 4),
              Text('Follow-up required', style: TextStyle(color: _red, fontSize: 12)),
            ]),
          ],
        ],
      );
    }
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 4,
      children: [
        Text.rich(TextSpan(
          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
          children: [
            const TextSpan(text: 'Oral Health: '),
            TextSpan(text: r.oralHealth, style: const TextStyle(color: _mint)),
          ],
        )),
        if (r.nextCheck != null)
          Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.event, size: 14, color: _mint),
            const SizedBox(width: 4),
            Text('Next check: ${_fmt(r.nextCheck!)}', style: const TextStyle(color: _mint, fontSize: 12)),
          ]),
      ],
    );
  }

  Widget _homeCareStrip() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('HOME CARE TODAY',
                  style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              Text('${_doneToday.length}/${_homeCareTasks.length}',
                  style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _homeCareTasks.map((t) {
                final done = _doneToday.contains(t);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => setState(() {
                      done ? _doneToday.remove(t) : _doneToday.add(t);
                      _animKey++;
                    }),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: done ? _forest.withValues(alpha: 0.25) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: done ? _forest : Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        if (done) const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(Icons.check, size: 14, color: _mint),
                        ),
                        Text(t,
                            style: TextStyle(
                                color: done ? _mint : AppColors.primaryTextOffWhite, fontSize: 12)),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: _forest, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryTextOffWhite, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ---------- empty ----------
  Widget _emptyView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: _showDogSheet,
            borderRadius: BorderRadius.circular(12),
            child: _card(
              child: Row(children: [
                _avatar(_dog.avatarUrl, 46),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_dog.name,
                          style: const TextStyle(
                              color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                      Text('${_dog.breed} · ${_dog.age}',
                          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey),
              ]),
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardsCarbon,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: const Icon(Icons.sentiment_satisfied_alt_outlined, color: _mint, size: 44),
            ),
          ),
          const SizedBox(height: 24),
          const Text('No Dental Records',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 20, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Keep a complete record of your dog's dental health — professional procedures, home care, and oral health history all in one place.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.5),
            ),
          ),
          const SizedBox(height: 28),
          InkWell(
            onTap: _showAddSheet,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: _forest, borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: const Text('Add Dental Record',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: GestureDetector(
              onTap: _showLearnSheet,
              child: const Text('Learn about Dental Care Tracking',
                  style: TextStyle(color: _mint, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- sheets (no snackbars) ----------
  Future<T?> _sheet<T>(Widget Function(BuildContext) builder) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: builder,
    );
  }

  Widget _sheetHeader(BuildContext ctx, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => Navigator.pop(ctx),
        ),
      ],
    );
  }

  Widget _field(String label, TextEditingController c, String hint, {int lines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundObsidian,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: TextField(
            controller: c,
            maxLines: lines,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, bool sel, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? (color ?? _forest) : AppColors.backgroundObsidian,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: sel ? (color ?? _forest) : Colors.white.withValues(alpha: 0.08)),
        ),
        child: Text(label,
            style: TextStyle(
                color: sel ? Colors.white : AppColors.secondaryTextStoneGrey,
                fontSize: 12,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
      ),
    );
  }

  void _showAddSheet() {
    final title = TextEditingController();
    final sub = TextEditingController();
    final notes = TextEditingController();
    DentalKind kind = DentalKind.professional;
    bool followUp = false;

    _sheet((ctx) => StatefulBuilder(builder: (ctx, setM) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sheetHeader(ctx, 'Add Dental Record'),
                    const SizedBox(height: 12),
                    const Text('RECORD TYPE',
                        style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      _chip('Professional', kind == DentalKind.professional,
                          () => setM(() => kind = DentalKind.professional)),
                      _chip('Home Care', kind == DentalKind.homeCare,
                          () => setM(() => kind = DentalKind.homeCare)),
                      _chip('Active Issue', kind == DentalKind.activeIssue,
                          () => setM(() => kind = DentalKind.activeIssue), color: _red),
                    ]),
                    const SizedBox(height: 14),
                    _field('TITLE', title, 'e.g. Dental Cleaning & Scale'),
                    const SizedBox(height: 12),
                    _field('VET / CLINIC / ROUTINE', sub, 'e.g. City Vets, Dr. Sarah Connell'),
                    const SizedBox(height: 12),
                    _field('NOTES', notes, 'Findings, treatment, advice...', lines: 3),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Follow-up required',
                            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                        Switch(
                          value: followUp,
                          activeThumbColor: _mint,
                          onChanged: (v) => setM(() => followUp = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _primaryButton('Save Record', Icons.check, () {
                      final isPro = kind == DentalKind.professional;
                      final isIssue = kind == DentalKind.activeIssue;
                      final rec = DentalRecord(
                        id: 'd${DateTime.now().millisecondsSinceEpoch}',
                        title: title.text.trim().isEmpty ? 'Dental Record' : title.text.trim(),
                        subtitle: sub.text.trim().isEmpty
                            ? (kind == DentalKind.homeCare ? 'Home Routine' : _fmt(DateTime.now()))
                            : sub.text.trim(),
                        kind: kind,
                        date: DateTime.now(),
                        oralHealth: isIssue ? 'Requires Treatment' : 'Good',
                        nextCheck: isPro ? DateTime.now().add(const Duration(days: 180)) : null,
                        followUpRequired: followUp || isIssue,
                        notes: notes.text.trim(),
                      );
                      Navigator.pop(ctx);
                      setState(() {
                        _isEmpty = false;
                        _records.insert(0, rec);
                        _animKey++;
                      });
                    }),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  void _showDetails(DentalRecord r) {
    _sheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sheetHeader(ctx, r.title),
                  Text(r.subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                  const SizedBox(height: 12),
                  _kindBadge(r.kind),
                  const SizedBox(height: 16),
                  _row('Date', _fmt(r.date)),
                  _row('Oral Health', r.oralHealth),
                  if (r.nextCheck != null) _row('Next Check', _fmt(r.nextCheck!)),
                  if (r.followUpRequired) _row('Follow-up', 'Required'),
                  const SizedBox(height: 12),
                  const Text('NOTES',
                      style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(r.notes.isEmpty ? 'No notes added.' : r.notes,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _records.removeWhere((x) => x.id == r.id);
                            if (_records.isEmpty) _isEmpty = true;
                            _animKey++;
                          });
                        },
                        child: const Text('Delete', style: TextStyle(color: Color(0xFFFFB4AB))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (r.kind == DentalKind.activeIssue) {
                            setState(() {
                              r.kind = DentalKind.professional;
                              r.oralHealth = 'Good';
                              r.followUpRequired = false;
                              _animKey++;
                            });
                          }
                        },
                        child: Text(
                          r.kind == DentalKind.activeIssue ? 'Mark Resolved' : 'Close',
                          style: const TextStyle(color: AppColors.primaryTextOffWhite),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _row(String l, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
            Text(v, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      );

  void _showOralBreakdown() {
    _sheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetHeader(ctx, 'Oral Health Score'),
                const SizedBox(height: 8),
                _row('Baseline (last professional check)', '90'),
                _row('Active issues', '-${_activeIssues * 25}'),
                _row('Home care today', '+${(_doneToday.length * 2.5).toStringAsFixed(1)}'),
                const Divider(color: Colors.white12),
                _row('Current score', '${(_oralScore * 100).round()}'),
                const SizedBox(height: 8),
                const Text('Complete today\'s home care tasks and resolve active issues to raise the score.',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ));
  }

  void _showFilterSheet() {
    _sheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetHeader(ctx, 'Filter Records'),
                ...['All', 'Professional', 'Home Care', 'Active Issues'].map((f) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(f,
                          style: TextStyle(color: f == _filter ? _mint : AppColors.primaryTextOffWhite, fontSize: 14)),
                      trailing: f == _filter ? const Icon(Icons.check, color: _mint) : null,
                      onTap: () {
                        setState(() => _filter = f);
                        Navigator.pop(ctx);
                      },
                    )),
              ],
            ),
          ),
        ));
  }

  void _showDogSheet() {
    _sheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetHeader(ctx, 'Select Dog Profile'),
                const SizedBox(height: 8),
                ...List.generate(_dogs.length, (i) {
                  final d = _dogs[i];
                  final sel = i == _dogIndex;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _dogIndex = i;
                        _animKey++;
                      });
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: sel ? _forest.withValues(alpha: 0.25) : AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: sel ? _forest : Colors.white.withValues(alpha: 0.06)),
                      ),
                      child: Row(children: [
                        _avatar(d.avatarUrl, 38),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.name,
                                  style: const TextStyle(
                                      color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                              Text('${d.breed} · ${d.age}',
                                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        if (sel) const Icon(Icons.check_circle, color: _mint, size: 20),
                      ]),
                    ),
                  );
                }),
              ],
            ),
          ),
        ));
  }

  void _showLearnSheet() {
    _sheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sheetHeader(ctx, 'Dental Care Tracking'),
                  const SizedBox(height: 8),
                  const Text(
                    'Most dogs show signs of dental disease by age three. Logging professional cleanings, home care and issues like fractured teeth lets you spot trends early and keeps vets informed.',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  const Text('• Professional: scale & polish, extractions, X-rays\n• Home care: brushing, chews, rinses, dental toys\n• Active issues: broken teeth, gum disease, abscesses',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, height: 1.6)),
                  const SizedBox(height: 20),
                  _primaryButton('Got It', Icons.check, () => Navigator.pop(ctx)),
                ],
              ),
            ),
          ),
        ));
  }
}
