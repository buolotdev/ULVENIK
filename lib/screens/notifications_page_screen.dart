import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'app_settings_screen.dart';

class _NotificationItem {
  final String id;
  final String title;
  final String body;
  final String timeLabel;
  final String category; // Health, Training, Goals, System
  final String group; // TODAY, EARLIER
  final IconData icon;
  final bool isUpcoming;
  final bool isOverdue;
  final String primaryActionLabel;
  final String dogContext;
  bool isUnread;
  bool isArchived = false;

  _NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.category,
    required this.group,
    required this.icon,
    required this.primaryActionLabel,
    required this.dogContext,
    this.isUpcoming = false,
    this.isOverdue = false,
    this.isUnread = false,
  });
}

class NotificationsPageScreen extends StatefulWidget {
  const NotificationsPageScreen({super.key});

  @override
  State<NotificationsPageScreen> createState() =>
      _NotificationsPageScreenState();
}

class _NotificationsPageScreenState extends State<NotificationsPageScreen> {
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _mintBright = Color(0xFFB1F0D6);
  static const Color _sageText = Color(0xFFB6CCB5);
  static const Color _unreadDotGreen = Color(0xFF479878);
  static const Color _overdueCrimson = Color(0xFF9E4747);
  static const Color _iconCircleBg = Color(0xFF23282B);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _showSearch = false;
  bool _showCategoryTabs = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String? _kpiFilter; // 'UNREAD', 'TODAY', 'UPCOMING', 'OVERDUE'
  bool _viewingArchive = false;

  static const List<String> _categories = [
    'All',
    'Unread',
    'Health',
    'Training',
    'Goals',
    'System',
  ];

  late final List<_NotificationItem> _items = [
    _NotificationItem(
      id: 'med_1',
      title: 'Medication Reminder',
      body: 'Carprofen is scheduled for 6:00 PM.',
      timeLabel: '5:45 PM',
      category: 'Health',
      group: 'TODAY',
      icon: Icons.medication_outlined,
      primaryActionLabel: 'Log Carprofen Dose (50 mg)',
      dogContext: 'Murphy · Post-Physio Anti-inflammatory',
      isOverdue: true,
      isUnread: true,
    ),
    _NotificationItem(
      id: 'vet_1',
      title: 'Veterinary Appointment',
      body: 'Eye examination tomorrow at 10:30 AM.',
      timeLabel: '9:00 AM',
      category: 'Health',
      group: 'TODAY',
      icon: Icons.calendar_today_outlined,
      primaryActionLabel: 'Confirm Clinic Check-In Reminder',
      dogContext: 'Murphy · Nordic Canine Ophthalmology Clinic',
      isUpcoming: true,
      isUnread: true,
    ),
    _NotificationItem(
      id: 'goal_1',
      title: 'Goal Completed',
      body: 'Complete 20 Recall Sessions has been achieved.',
      timeLabel: '7:32 AM',
      category: 'Goals',
      group: 'TODAY',
      icon: Icons.check_circle_outline_rounded,
      primaryActionLabel: 'Celebrate & Set Next Recall Target',
      dogContext: 'Murphy · Obedience & Long-Line Recall',
      isUnread: false,
    ),
    _NotificationItem(
      id: 'train_1',
      title: 'Training Reminder',
      body: 'Agility session with Murphy starts in 30 minutes.',
      timeLabel: 'Yesterday',
      category: 'Training',
      group: 'EARLIER',
      icon: Icons.fitness_center_rounded,
      primaryActionLabel: 'Open Agility Session Plan',
      dogContext: 'Murphy · Field Arena #2',
      isUpcoming: true,
      isUnread: true,
    ),
    _NotificationItem(
      id: 'sync_1',
      title: 'Backup Complete',
      body: 'Your Ulvenik data has been backed up successfully.',
      timeLabel: '2d ago',
      category: 'System',
      group: 'EARLIER',
      icon: Icons.cloud_done_outlined,
      primaryActionLabel: 'Verify Encrypted Backup Snapshot',
      dogContext: 'Ulvenik Cloud Backup',
      isUnread: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<_NotificationItem> get _activePool =>
      _items.where((item) => item.isArchived == _viewingArchive).toList();

  int get _unreadCount =>
      _items.where((i) => !i.isArchived && i.isUnread).length;
  int get _totalActiveCount => _items.where((i) => !i.isArchived).length;
  int get _upcomingCount =>
      _items.where((i) => !i.isArchived && i.isUpcoming).length;
  int get _overdueCount =>
      _items.where((i) => !i.isArchived && i.isOverdue).length;

  List<_NotificationItem> get _filteredItems {
    final q = _searchQuery.trim().toLowerCase();
    return _activePool.where((item) {
      if (_kpiFilter == 'UNREAD' && !item.isUnread) return false;
      if (_kpiFilter == 'TODAY' && item.group != 'TODAY') return false;
      if (_kpiFilter == 'UPCOMING' && !item.isUpcoming) return false;
      if (_kpiFilter == 'OVERDUE' && !item.isOverdue) return false;

      if (_selectedCategory == 'Unread' && !item.isUnread) return false;
      if (_selectedCategory != 'All' &&
          _selectedCategory != 'Unread' &&
          item.category != _selectedCategory) {
        return false;
      }

      if (q.isEmpty) return true;
      return item.title.toLowerCase().contains(q) ||
          item.body.toLowerCase().contains(q) ||
          item.category.toLowerCase().contains(q) ||
          item.dogContext.toLowerCase().contains(q);
    }).toList();
  }

  void _markAllRead() {
    if (_unreadCount == 0) {
      AppSnackbar.show(
        context,
        title: 'All Caught Up',
        message: 'Every notification is already marked as read.',
        type: SnackbarType.info,
      );
      return;
    }
    setState(() {
      for (final item in _items) {
        if (!item.isArchived) {
          item.isUnread = false;
        }
      }
    });
    AppSnackbar.show(
      context,
      title: 'Marked All Read',
      message: 'All unread notifications have been cleared.',
      type: SnackbarType.success,
    );
  }

  void _toggleReadState(_NotificationItem item) {
    setState(() {
      item.isUnread = !item.isUnread;
    });
  }

  void _archiveOrRestoreItem(_NotificationItem item) {
    final wasArchived = item.isArchived;
    setState(() {
      item.isArchived = !wasArchived;
    });
    AppSnackbar.show(
      context,
      title: wasArchived ? 'Notification Restored' : 'Notification Dismissed',
      message: wasArchived
          ? '"${item.title}" moved back to your inbox.'
          : '"${item.title}" moved to Archive.',
      type: SnackbarType.info,
    );
  }

  void _openNotificationDetail(_NotificationItem item) {
    if (item.isUnread) {
      setState(() {
        item.isUnread = false;
      });
    }

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                border: Border(
                  top: BorderSide(color: AppColors.cardBorder, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryTextStoneGrey
                                .withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: _iconCircleBg,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Icon(
                              item.icon,
                              color: _sageText,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.primaryTextOffWhite,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.category} · ${item.timeLabel}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(sheetCtx).pop(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.secondaryTextStoneGrey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.body,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 14,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.dogContext,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: _mint,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(sheetCtx).pop();
                            AppSnackbar.show(
                              context,
                              title: 'Action Completed',
                              message: '${item.primaryActionLabel} recorded.',
                              type: SnackbarType.success,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryForestGreen,
                            foregroundColor: AppColors.primaryTextOffWhite,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            item.primaryActionLabel,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _toggleReadState(item);
                                setModalState(() {});
                              },
                              icon: Icon(
                                item.isUnread
                                    ? Icons.mark_email_read_outlined
                                    : Icons.mark_email_unread_outlined,
                                size: 16,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                              label: Text(
                                item.isUnread ? 'Mark Read' : 'Mark Unread',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.cardBorder),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(sheetCtx).pop();
                                _archiveOrRestoreItem(item);
                              },
                              icon: Icon(
                                item.isArchived
                                    ? Icons.unarchive_outlined
                                    : Icons.archive_outlined,
                                size: 16,
                                color: _overdueCrimson,
                              ),
                              label: Text(
                                item.isArchived ? 'Restore' : 'Dismiss',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: _overdueCrimson,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.cardBorder),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
    final visible = _filteredItems;
    final todayItems = visible.where((e) => e.group == 'TODAY').toList();
    final earlierItems = visible.where((e) => e.group == 'EARLIER').toList();
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundObsidian,
            border: Border(
              bottom: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 62,
              child: Padding(
                padding: EdgeInsets.fromLTRB(canPop ? 8 : 20, 0, 10, 0),
                child: Row(
                  children: [
                    if (canPop)
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.chevron_left,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 26,
                        ),
                        tooltip: 'Back',
                      ),
                    Expanded(
                      child: Text(
                        _viewingArchive ? 'Archived Alerts' : 'Notifications',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showSearch = !_showSearch;
                          if (!_showSearch) {
                            _searchController.clear();
                            _searchQuery = '';
                          }
                        });
                        if (_showSearch) {
                          _searchFocusNode.requestFocus();
                        }
                      },
                      tooltip: 'Search Notifications',
                      icon: Icon(
                        Icons.search,
                        color: _showSearch
                            ? _mint
                            : AppColors.secondaryTextStoneGrey,
                        size: 21,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showCategoryTabs = !_showCategoryTabs;
                        });
                      },
                      tooltip: 'Filter Categories',
                      icon: Icon(
                        Icons.tune_rounded,
                        color: (_showCategoryTabs || _selectedCategory != 'All')
                            ? _mint
                            : AppColors.secondaryTextStoneGrey,
                        size: 21,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildKpiSummaryBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showSearch) ...[
                    Container(
                      height: 44,
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: AppColors.secondaryTextStoneGrey,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: (v) =>
                                  setState(() => _searchQuery = v),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 14,
                              ),
                              cursorColor: _mint,
                              decoration: const InputDecoration(
                                hintText: 'Search reminders, dogs, or alerts...',
                                hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 13.5,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                              child: const Icon(
                                Icons.close_rounded,
                                color: AppColors.secondaryTextStoneGrey,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  _buildActionPillsRow(),
                  const SizedBox(height: 12),
                  _buildCategoryTabsStrip(),
                  const SizedBox(height: 22),
                  if (visible.isEmpty)
                    _buildEmptyFilteredState()
                  else ...[
                    if (todayItems.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TODAY',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            todayItems.length == 1
                                ? '1 Event'
                                : '${todayItems.length} Events',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: _sageText,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildNotificationsCard(todayItems),
                      const SizedBox(height: 24),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _viewingArchive ? 'ARCHIVED ITEMS' : 'EARLIER',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _viewingArchive = !_viewingArchive;
                              _kpiFilter = null;
                            });
                          },
                          child: Text(
                            _viewingArchive ? 'Back to Inbox' : 'Archive',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: _viewingArchive
                                  ? _mint
                                  : AppColors.secondaryTextStoneGrey
                                      .withValues(alpha: 0.78),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (earlierItems.isNotEmpty)
                      _buildNotificationsCard(earlierItems)
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cardsCarbon,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          _viewingArchive
                              ? 'Swipe left on any notification to move it to Archive.'
                              : 'No earlier notifications match this filter.',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
    );
  }

  Widget _buildKpiSummaryBar() {
    Widget buildCell({
      required String keyName,
      required int count,
      required String label,
      Color? numberColor,
    }) {
      final isSelected = _kpiFilter == keyName;
      return Expanded(
        child: InkWell(
          onTap: () {
            setState(() {
              _viewingArchive = false;
              _kpiFilter = isSelected ? null : keyName;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            color: isSelected
                ? AppColors.primaryForestGreen.withValues(alpha: 0.14)
                : Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: numberColor ??
                        (isSelected ? _mint : AppColors.primaryTextOffWhite),
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color:
                        isSelected ? _mint : AppColors.secondaryTextStoneGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            buildCell(
              keyName: 'UNREAD',
              count: _unreadCount,
              label: 'UNREAD',
            ),
            const VerticalDivider(width: 1, color: AppColors.cardBorder),
            buildCell(
              keyName: 'TODAY',
              count: _totalActiveCount,
              label: 'TODAY',
            ),
            const VerticalDivider(width: 1, color: AppColors.cardBorder),
            buildCell(
              keyName: 'UPCOMING',
              count: _upcomingCount,
              label: 'UPCOMING',
            ),
            const VerticalDivider(width: 1, color: AppColors.cardBorder),
            buildCell(
              keyName: 'OVERDUE',
              count: _overdueCount,
              label: 'OVERDUE',
              numberColor: _overdueCrimson,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionPillsRow() {
    return Row(
      children: [
        InkWell(
          onTap: _markAllRead,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.primaryForestGreen.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primaryForestGreen.withValues(alpha: 0.55),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.done_all_rounded,
                  color: _mintBright,
                  size: 16,
                ),
                const SizedBox(width: 7),
                Text(
                  _unreadCount == 0 ? 'All Read' : 'Mark All Read',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: _mintBright,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AppSettingsScreen()),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.tune_rounded,
                  color: AppColors.secondaryTextStoneGrey,
                  size: 15,
                ),
                SizedBox(width: 7),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabsStrip() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) {
          final selected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = cat;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryForestGreen.withValues(alpha: 0.24)
                      : AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected
                        ? _mint.withValues(alpha: 0.5)
                        : AppColors.cardBorder,
                  ),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: selected ? _mint : AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationsCard(List<_NotificationItem> list) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          for (int i = 0; i < list.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.cardBorder),
            _buildDismissibleRow(list[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildDismissibleRow(_NotificationItem item) {
    return Dismissible(
      key: ValueKey('${item.id}_${item.isArchived}'),
      background: Container(
        color: AppColors.primaryForestGreen.withValues(alpha: 0.35),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(
              item.isUnread
                  ? Icons.mark_email_read_outlined
                  : Icons.mark_email_unread_outlined,
              color: _mint,
              size: 19,
            ),
            const SizedBox(width: 8),
            Text(
              item.isUnread ? 'Mark Read' : 'Mark Unread',
              style: const TextStyle(
                fontFamily: 'Inter',
                color: _mint,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: AppColors.errorDestructive.withValues(alpha: 0.35),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              item.isArchived ? 'Restore' : 'Dismiss',
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.primaryTextOffWhite,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              item.isArchived
                  ? Icons.unarchive_outlined
                  : Icons.archive_outlined,
              color: AppColors.primaryTextOffWhite,
              size: 19,
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _toggleReadState(item);
          return false;
        }
        return true;
      },
      onDismissed: (_) => _archiveOrRestoreItem(item),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openNotificationDetail(item),
          onLongPress: () => _toggleReadState(item),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 14,
                  child: item.isUnread
                      ? Center(
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: _unreadDotGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 6),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _iconCircleBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    color: _sageText,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: item.isUnread
                                    ? AppColors.primaryTextOffWhite
                                    : _sageText.withValues(alpha: 0.88),
                                fontSize: 15,
                                fontWeight: item.isUnread
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.timeLabel,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.secondaryTextStoneGrey,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFilteredState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_paused_outlined,
            color: AppColors.secondaryTextStoneGrey,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            _viewingArchive
                ? 'Archive is currently empty'
                : 'No notifications match your filter',
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.primaryTextOffWhite,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _viewingArchive = false;
                _selectedCategory = 'All';
                _kpiFilter = null;
                _searchController.clear();
                _searchQuery = '';
              });
            },
            child: const Text(
              'Reset filters',
              style: TextStyle(
                fontFamily: 'Inter',
                color: _mint,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
