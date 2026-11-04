import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _FeatureRequestItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status; // 'Planned', 'Under Review', 'In Development'
  final String submittedDate;
  final bool isMine;
  final bool isPopular;
  int votes;
  bool hasVoted;

  _FeatureRequestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.submittedDate,
    this.isMine = false,
    this.isPopular = false,
    required this.votes,
    required this.hasVoted,
  });
}

class FeatureRequestsScreen extends StatefulWidget {
  const FeatureRequestsScreen({super.key});

  @override
  State<FeatureRequestsScreen> createState() => _FeatureRequestsScreenState();
}

class _FeatureRequestsScreenState extends State<FeatureRequestsScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _votedGreen = Color(0xFF3A876E);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _plannedBlue = Color(0xFF5D8FAF);
  static const Color _reviewAmber = Color(0xFFB4823C);
  static const Color _inDevPurple = Color(0xFF6E50A0);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);

  static const List<String> _filterOptions = [
    'All',
    'Popular',
    'Under Review',
    'Planned',
    'In Development',
  ];

  static const List<String> _requestCategories = [
    'Training',
    'Health',
    'Strength & Conditioning',
    'Timeline',
    'Dogs & Profiles',
    'Export & Sync',
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  late final List<_FeatureRequestItem> _requests = [
    // POPULAR
    _FeatureRequestItem(
      id: 'pop_1',
      title: 'Training Templates',
      description: 'Save and reuse your favourite training session layouts.',
      category: 'Training',
      status: 'Planned',
      submittedDate: '12 Jul',
      isPopular: true,
      votes: 1248,
      hasVoted: true,
    ),
    _FeatureRequestItem(
      id: 'pop_2',
      title: 'Smart Health Insights',
      description:
          'AI-powered suggestions based on your dog\'s health history.',
      category: 'Health',
      status: 'Under Review',
      submittedDate: '3 Aug',
      isPopular: true,
      votes: 847,
      hasVoted: false,
    ),
    _FeatureRequestItem(
      id: 'pop_3',
      title: 'Multi-Dog Training Session',
      description: 'Log a single session across multiple dogs at once.',
      category: 'Dogs & Profiles',
      status: 'In Development',
      submittedDate: '19 Jun',
      isPopular: true,
      votes: 612,
      hasVoted: false,
    ),

    // MY REQUESTS
    _FeatureRequestItem(
      id: 'my_1',
      title: 'Offline Goal Tracking',
      description:
          'Update goal milestone percentages directly while logging sessions offline in remote field venues.',
      category: 'Training',
      status: 'Under Review',
      submittedDate: '2 Sep',
      isMine: true,
      votes: 18,
      hasVoted: true,
    ),
    _FeatureRequestItem(
      id: 'my_2',
      title: 'Custom Reward Icons',
      description:
          'Assign specific toy, tug, scatter, or food reward icons to individual skill drills.',
      category: 'Training',
      status: 'Under Review',
      submittedDate: '28 Aug',
      isMine: true,
      votes: 9,
      hasVoted: true,
    ),
    _FeatureRequestItem(
      id: 'my_3',
      title: 'Export to PDF',
      description:
          'Generate clean printable PDF summaries of health records and training logs for vets and coaches.',
      category: 'Export & Sync',
      status: 'Planned',
      submittedDate: '15 Aug',
      isMine: true,
      votes: 42,
      hasVoted: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatVotes(int count) {
    final s = count.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    return '${buf.toString()} ${count == 1 ? 'vote' : 'votes'}';
  }

  Color _statusBadgeColor(String status) {
    switch (status) {
      case 'Planned':
        return _plannedBlue;
      case 'In Development':
        return _inDevPurple;
      case 'Under Review':
      default:
        return _reviewAmber;
    }
  }

  bool _matchesQueryAndFilter(_FeatureRequestItem item) {
    final q = _searchQuery.trim().toLowerCase();
    if (_selectedFilter == 'Popular' && !item.isPopular) return false;
    if (_selectedFilter != 'All' &&
        _selectedFilter != 'Popular' &&
        item.status != _selectedFilter) {
      return false;
    }
    if (q.isEmpty) return true;
    return item.title.toLowerCase().contains(q) ||
        item.description.toLowerCase().contains(q) ||
        item.category.toLowerCase().contains(q) ||
        item.status.toLowerCase().contains(q);
  }

  void _toggleVote(_FeatureRequestItem item) {
    setState(() {
      if (item.hasVoted) {
        item.hasVoted = false;
        if (item.votes > 0) item.votes -= 1;
      } else {
        item.hasVoted = true;
        item.votes += 1;
      }
    });
  }

  void _openSubmitFeatureSheet() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedCat = _requestCategories.first;
    bool showError = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Container(
                decoration: const BoxDecoration(
                  color: _obsidian,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border(top: BorderSide(color: _cardBorder)),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _stoneGrey.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline_rounded,
                              color: _mint,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Submit New Feature',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: _stoneGrey,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Share how this feature would help you and your dog.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'AREA',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _requestCategories.map((cat) {
                            final active = selectedCat == cat;
                            return GestureDetector(
                              onTap: () =>
                                  setModalState(() => selectedCat = cat),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: active ? _forest : _carbon,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: active
                                        ? _mint.withValues(alpha: 0.45)
                                        : _cardBorder,
                                  ),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    color: active ? _offWhite : _stoneGrey,
                                    fontSize: 12.5,
                                    fontWeight: active
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'FEATURE TITLE',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                          decoration: BoxDecoration(
                            color: _carbon,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: showError && titleCtrl.text.trim().isEmpty
                                  ? const Color(0xFF8B3A3A)
                                  : _cardBorder,
                            ),
                          ),
                          child: TextField(
                            controller: titleCtrl,
                            maxLength: 80,
                            onChanged: (_) => setModalState(() {}),
                            cursorColor: _mint,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 14.5,
                              fontFamily: 'Inter',
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              counterText: '',
                              hintText: 'e.g. Custom Split Lap Timer',
                              hintStyle: TextStyle(
                                color: _stoneGrey.withValues(alpha: 0.55),
                                fontSize: 14.5,
                                fontFamily: 'Inter',
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _stoneGrey.withValues(alpha: 0.22),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _forest,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'DETAILS & USE CASE',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                          decoration: BoxDecoration(
                            color: _carbon,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: showError && descCtrl.text.trim().isEmpty
                                  ? const Color(0xFF8B3A3A)
                                  : _cardBorder,
                            ),
                          ),
                          child: TextField(
                            controller: descCtrl,
                            minLines: 3,
                            maxLines: 5,
                            maxLength: 1000,
                            onChanged: (_) => setModalState(() {}),
                            cursorColor: _mint,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 14,
                              height: 1.45,
                              fontFamily: 'Inter',
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              counterText: '',
                              hintText:
                                  'Explain what problem this solves during training or care...',
                              hintStyle: TextStyle(
                                color: _stoneGrey.withValues(alpha: 0.55),
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _stoneGrey.withValues(alpha: 0.22),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _forest,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (titleCtrl.text.trim().isEmpty ||
                                  descCtrl.text.trim().isEmpty) {
                                setModalState(() => showError = true);
                                return;
                              }
                              final newItem = _FeatureRequestItem(
                                id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                                title: titleCtrl.text.trim(),
                                description: descCtrl.text.trim(),
                                category: selectedCat,
                                status: 'Under Review',
                                submittedDate: 'Just now',
                                isMine: true,
                                isPopular: false,
                                votes: 1,
                                hasVoted: true,
                              );
                              setState(() {
                                _requests.insert(3, newItem);
                                _selectedFilter = 'All';
                              });
                              Navigator.of(ctx).pop();
                              AppSnackbar.show(
                                context,
                                title: 'Feature Idea Submitted',
                                message:
                                    '"${newItem.title}" added to My Requests for product review.',
                                type: SnackbarType.success,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _forest,
                              foregroundColor: _offWhite,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Submit Feature Request',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openRequestDetailSheet(_FeatureRequestItem item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: _obsidian,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(top: BorderSide(color: _cardBorder)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: _stoneGrey.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildStatusPill(item.status),
                          const SizedBox(width: 10),
                          Text(
                            '${item.category} · Submitted ${item.submittedDate}',
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 12.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 14,
                          height: 1.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _toggleVote(item);
                                setModalState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    item.hasVoted ? _forest : _carbon,
                                foregroundColor: _offWhite,
                                elevation: 0,
                                side: const BorderSide(color: _cardBorder),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Icon(
                                Icons.thumb_up_outlined,
                                size: 17,
                                color: item.hasVoted ? _mint : _stoneGrey,
                              ),
                              label: Text(
                                item.hasVoted
                                    ? 'Voted · ${_formatVotes(item.votes)}'
                                    : 'Upvote · ${_formatVotes(item.votes)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final popularList = _requests
        .where((r) => r.isPopular && _matchesQueryAndFilter(r))
        .toList();
    final myRequestsList = _requests
        .where((r) => r.isMine && _matchesQueryAndFilter(r))
        .toList();

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            border: Border(bottom: BorderSide(color: _cardBorder, width: 1)),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: _stoneGrey,
                      size: 26,
                    ),
                    splashRadius: 20,
                  ),
                  const Text(
                    'Feature Requests',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
        children: [
          _buildSectionHeader('FEATURE REQUESTS'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: _stoneGrey,
                  size: 21,
                ),
                SizedBox(height: 14),
                Text(
                  'Have an idea for Ulvenik?',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'We\'re always looking for ways to improve. Share your ideas and help shape future updates.',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13.5,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Search Bar
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              cursorColor: _mint,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                prefixIcon: const Icon(
                  Icons.search,
                  color: _stoneGrey,
                  size: 19,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: _stoneGrey,
                          size: 18,
                        ),
                      )
                    : null,
                hintText: 'Search Feature Requests',
                hintStyle: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),

          // Status Filter Pills
          const SizedBox(height: 12),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filterOptions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, idx) {
                final pill = _filterOptions[idx];
                final active = _selectedFilter == pill;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = pill),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: active ? _forest : _carbon,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: active
                            ? _mint.withValues(alpha: 0.45)
                            : _cardBorder,
                      ),
                    ),
                    child: Text(
                      pill,
                      style: TextStyle(
                        color: active ? _offWhite : _stoneGrey,
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // POPULAR
          if (popularList.isNotEmpty) ...[
            const SizedBox(height: 22),
            _buildSectionHeader('POPULAR'),
            const SizedBox(height: 10),
            ...List.generate(popularList.length, (i) {
              final item = popularList[i];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: i == popularList.length - 1 ? 0 : 12,
                ),
                child: _buildPopularCard(item),
              );
            }),
          ],

          // SUBMIT
          const SizedBox(height: 24),
          _buildSectionHeader('SUBMIT'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openSubmitFeatureSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: _offWhite,
                          size: 19,
                        ),
                        SizedBox(width: 9),
                        Text(
                          'Submit New Feature',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ideas are reviewed before becoming publicly visible.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 12.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),

          // MY REQUESTS
          if (myRequestsList.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('MY REQUESTS'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: List.generate(myRequestsList.length, (i) {
                  final item = myRequestsList[i];
                  final isLast = i == myRequestsList.length - 1;
                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.vertical(
                          top: i == 0 ? const Radius.circular(16) : Radius.zero,
                          bottom: isLast
                              ? const Radius.circular(16)
                              : Radius.zero,
                        ),
                        onTap: () => _openRequestDetailSheet(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.assignment_outlined,
                                color: _stoneGrey,
                                size: 19,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        color: _offWhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Submitted ${item.submittedDate} · ${_formatVotes(item.votes)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: _stoneGrey,
                                        fontSize: 12.5,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusPill(item.status),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.chevron_right,
                                color: _stoneGrey,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isLast)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: _cardBorder,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],

          if (popularList.isEmpty && myRequestsList.isEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    color: _stoneGrey,
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No matching feature requests found',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _selectedFilter = 'All';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _offWhite,
                      side: const BorderSide(color: _cardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
    );
  }

  Widget _buildPopularCard(_FeatureRequestItem item) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openRequestDetailSheet(item),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusPill(item.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13.5,
                  height: 1.45,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, thickness: 1, color: _cardBorder),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _toggleVote(item),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.thumb_up_outlined,
                            size: 16,
                            color: item.hasVoted ? _votedGreen : _stoneGrey,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            item.hasVoted ? 'Voted' : 'Vote',
                            style: TextStyle(
                              color: item.hasVoted ? _votedGreen : _stoneGrey,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                          if (item.hasVoted) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.check_rounded,
                              size: 15,
                              color: _votedGreen,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Text(
                    _formatVotes(item.votes),
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _statusBadgeColor(status),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: _offWhite,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        fontFamily: 'Inter',
      ),
    );
  }
}
