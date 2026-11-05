import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'add_client_screen.dart';
import 'client_notes_screen.dart';
import 'client_profile_screen.dart';
import 'edit_client_screen.dart';
import 'trainer_dashboard_screen.dart';

class ClientsPageScreen extends StatefulWidget {
  const ClientsPageScreen({super.key});

  @override
  State<ClientsPageScreen> createState() => _ClientsPageScreenState();
}

class _ClientsPageScreenState extends State<ClientsPageScreen> {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _cardBg = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _sage = Color(0xFFB6CCB5);
  static const Color _sageIcon = AppColors.secondarySage; // #7A8F7A
  static const Color _alpineBlue = AppColors.infoAlpineBlue; // #5D8FAF
  static const Color _gold = AppColors.favouriteGold; // #B8920A
  static const Color _terracotta = Color(0xFF8D504A);
  static const Color _charcoalEdit = Color(0xFF323533);
  static const Color _inactivePillBg = Color(0xFF272B29);
  static const Color _textPrimary = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _textSecondary = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _border = AppColors.cardBorder;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  static const List<String> _allFilterChips = [
    'ACTIVE CLIENTS',
    'UPCOMING SESSIONS',
    'HOMEWORK DUE',
    'TRAINING PLAN',
    'SESSION TODAY',
    'INACTIVE',
    'FAVOURITES',
  ];

  static const List<String> _sortOptions = [
    'Recently Active',
    'Next Session',
    'Name (A–Z)',
    'Most Dogs',
  ];

  final Set<String> _selectedChips = {'ACTIVE CLIENTS', 'HOMEWORK DUE'};
  final Set<String> _favouriteClientIds = {'c_emma', 'c_oliver'};
  final Set<String> _homeworkDueClientIds = {'c_james', 'c_sarah', 'c_nina_paused'};
  final Set<String> _sessionTodayClientIds = {'c_emma', 'c_james'};

  String _sortBy = 'Recently Active';
  bool _showArchived = false;
  String? _openSwipeClientId = 'c_james';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _openAddClient() async {
    final created = await Navigator.of(context).push<TrainerClient>(
      MaterialPageRoute(
        builder: (_) => const AddClientScreen(),
      ),
    );
    if (!mounted || created == null) return;
    setState(() {});
    AppSnackbar.show(
      context,
      title: 'Client Added',
      message: '${created.fullName} added to your client directory.',
      type: SnackbarType.success,
    );
  }

  Future<void> _openClientProfile(TrainerClient client) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ClientProfileScreen(clientId: client.id),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openEditClient(TrainerClient client) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => EditClientScreen(clientId: client.id),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _toggleArchiveClient(TrainerClient client) async {
    final isArchiving = client.status != 'Archived';
    if (isArchiving) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: _cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: _border),
            ),
            title: Text(
              'Archive ${client.fullName}?',
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            content: Text(
              'Are you sure you want to archive ${client.fullName}? Their profile, dogs and session history will be moved to archived clients and can be restored at any time.',
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 13.5,
                height: 1.45,
                fontFamily: 'Inter',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: _textSecondary, fontFamily: 'Inter'),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _terracotta,
                  foregroundColor: _textPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Archive Client',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          );
        },
      );
      if (confirmed != true || !mounted) {
        if (mounted && _openSwipeClientId == client.id) {
          setState(() => _openSwipeClientId = null);
        }
        return;
      }
    }

    final nextStatus = isArchiving ? 'Archived' : 'Active';
    TrainerPackStore.updateClient(client.copyWith(status: nextStatus));
    setState(() {
      if (_openSwipeClientId == client.id) {
        _openSwipeClientId = null;
      }
    });
    AppSnackbar.show(
      context,
      title: nextStatus == 'Archived' ? 'Client Archived' : 'Client Restored',
      message: nextStatus == 'Archived'
          ? '${client.fullName} moved to archived clients.'
          : '${client.fullName} restored to active clients.',
      type: SnackbarType.info,
    );
  }

  bool _isClientActive(TrainerClient c) => c.status == 'Active';
  bool _isClientInactive(TrainerClient c) =>
      c.status == 'Paused' || c.status == 'Inactive' || c.status == 'Pending';

  List<TrainerClient> _filterAndSort(List<TrainerClient> rawClients) {
    final q = _searchController.text.trim().toLowerCase();

    var list = rawClients.where((c) {
      if (!_showArchived && c.status == 'Archived') return false;

      if (q.isNotEmpty) {
        final matchName = c.fullName.toLowerCase().contains(q);
        final matchEmail = c.email.toLowerCase().contains(q);
        final matchProg = c.programme.toLowerCase().contains(q);
        final matchDog = c.dogs.any(
          (d) =>
              d.name.toLowerCase().contains(q) ||
              d.breed.toLowerCase().contains(q),
        );
        if (!matchName && !matchEmail && !matchProg && !matchDog) return false;
      }

      if (_selectedChips.isEmpty) return true;

      // Match any selected chip when Active + Homework Due are combined,
      // or narrow cleanly when specific filters are toggled
      var matchesAny = false;
      if (_selectedChips.contains('ACTIVE CLIENTS') && _isClientActive(c)) {
        matchesAny = true;
      }
      if (_selectedChips.contains('UPCOMING SESSIONS') &&
          !_isClientInactive(c) &&
          c.nextSessionLabel.isNotEmpty &&
          !c.nextSessionLabel.toLowerCase().contains('paused')) {
        matchesAny = true;
      }
      if (_selectedChips.contains('HOMEWORK DUE') &&
          _homeworkDueClientIds.contains(c.id)) {
        matchesAny = true;
      }
      if (_selectedChips.contains('TRAINING PLAN') &&
          c.programme.trim().isNotEmpty) {
        matchesAny = true;
      }
      if (_selectedChips.contains('SESSION TODAY') &&
          _sessionTodayClientIds.contains(c.id)) {
        matchesAny = true;
      }
      if (_selectedChips.contains('INACTIVE') && _isClientInactive(c)) {
        matchesAny = true;
      }
      if (_selectedChips.contains('FAVOURITES') &&
          _favouriteClientIds.contains(c.id)) {
        matchesAny = true;
      }
      return matchesAny;
    }).toList();

    switch (_sortBy) {
      case 'Name (A–Z)':
        list.sort((a, b) => a.fullName.compareTo(b.fullName));
        break;
      case 'Most Dogs':
        list.sort((a, b) => b.dogs.length.compareTo(a.dogs.length));
        break;
      case 'Next Session':
        list.sort((a, b) {
          final aToday = _sessionTodayClientIds.contains(a.id) ? 0 : 1;
          final bToday = _sessionTodayClientIds.contains(b.id) ? 0 : 1;
          if (aToday != bToday) return aToday.compareTo(bToday);
          return a.nextSessionLabel.compareTo(b.nextSessionLabel);
        });
        break;
      case 'Recently Active':
      default:
        // Keep curated order placing Emma, James, Sarah Mitchell/Bella up top
        break;
    }

    return list;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Clients',
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedChips.clear();
                              _showArchived = false;
                            });
                            setModalState(() {});
                          },
                          child: const Text(
                            'Reset All',
                            style: TextStyle(
                              color: _mint,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allFilterChips.map((chip) {
                        final active = _selectedChips.contains(chip);
                        return FilterChip(
                          selected: active,
                          showCheckmark: false,
                          backgroundColor: const Color(0xFF212629),
                          selectedColor: _forest.withValues(alpha: 0.24),
                          side: BorderSide(
                            color: active ? _forest : _border,
                          ),
                          label: Text(
                            chip,
                            style: TextStyle(
                              color: active ? _mint : _textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _selectedChips.add(chip);
                              } else {
                                _selectedChips.remove(chip);
                              }
                            });
                            setModalState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: const Text(
                        'Include Archived Clients',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: const Text(
                        'Show former or archived client profiles in directory',
                        style: TextStyle(color: _textSecondary, fontSize: 12),
                      ),
                      value: _showArchived,
                      onChanged: (val) {
                        setState(() => _showArchived = val);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _textPrimary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
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
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sort Clients By',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                ..._sortOptions.map((option) {
                  final selected = _sortBy == option;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      setState(() => _sortBy = option);
                      Navigator.pop(ctx);
                    },
                    title: Text(
                      option,
                      style: TextStyle(
                        color: selected ? _mint : _textPrimary,
                        fontSize: 14,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_rounded,
                            color: _mint, size: 20)
                        : null,
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showClientMoreMenu(TrainerClient client) {
    final isFav = _favouriteClientIds.contains(client.id);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.visibility_outlined,
                      color: _textPrimary),
                  title: Text(
                    'View ${client.fullName}',
                    style: const TextStyle(color: _textPrimary),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openClientProfile(client);
                  },
                ),
                ListTile(
                  leading: const UlvenikIcon(UlvenikIcons.edit, color: _mint),
                  title: const Text(
                    'Edit Client Details',
                    style: TextStyle(color: _textPrimary),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openEditClient(client);
                  },
                ),
                ListTile(
                  leading: UlvenikIcon.fromMaterial(
                    isFav ? Icons.star_rounded : Icons.star_border_rounded,
                    color: _gold,
                  ),
                  title: Text(
                    isFav ? 'Remove from Favourites' : 'Mark as Favourite',
                    style: const TextStyle(color: _textPrimary),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      if (isFav) {
                        _favouriteClientIds.remove(client.id);
                      } else {
                        _favouriteClientIds.add(client.id);
                      }
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.sticky_note_2_outlined,
                      color: _textSecondary),
                  title: const Text(
                    'Open Client Notes',
                    style: TextStyle(color: _textPrimary),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ClientNotesScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.archive_outlined,
                      color: _terracotta),
                  title: Text(
                    client.status == 'Archived'
                        ? 'Restore Client'
                        : 'Archive Client',
                    style: const TextStyle(color: _terracotta),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _toggleArchiveClient(client);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddClient,
        backgroundColor: _forest,
        foregroundColor: _textPrimary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const UlvenikIcon(UlvenikIcons.add, size: 28),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<TrainerClient>>(
          valueListenable: TrainerPackStore.clientsNotifier,
          builder: (context, allClients, _) {
            final filtered = _filterAndSort(allClients);

            return Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 92),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchBox(),
                        const SizedBox(height: 14),
                        _buildFilterChipsRow(),
                        const SizedBox(height: 16),
                        _buildCountAndSortRow(filtered.length),
                        const SizedBox(height: 14),
                        if (filtered.isEmpty)
                          _buildEmptyStateCard(
                            isSpecReference: allClients.isEmpty,
                          )
                        else ...[
                          ...filtered.map(
                            (client) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _buildSwipeableClientCard(client),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSpecEmptyReferenceHeader(),
                          const SizedBox(height: 8),
                          _buildEmptyStateCard(isSpecReference: true),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final badgeCount = _selectedChips.length + (_showArchived ? 1 : 0);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(
          bottom: BorderSide(color: _border, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            visualDensity: VisualDensity.compact,
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _textSecondary,
              size: 26,
            ),
          ),
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 28),
                child: Text(
                  'Clients',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Search clients',
            visualDensity: VisualDensity.compact,
            onPressed: () => _searchFocusNode.requestFocus(),
            icon: const UlvenikIcon(UlvenikIcons.search,
              color: _textSecondary,
              size: 21,
            ),
          ),
          IconButton(
            tooltip: 'Filter clients',
            visualDensity: VisualDensity.compact,
            onPressed: _showFilterBottomSheet,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.tune_rounded,
                  color: _textSecondary,
                  size: 21,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.5,
                        vertical: 1,
                      ),
                      decoration: const BoxDecoration(
                        color: _forest,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Sort clients',
            visualDensity: VisualDensity.compact,
            onPressed: _showSortBottomSheet,
            icon: const UlvenikIcon(UlvenikIcons.sort,
              color: _textSecondary,
              size: 21,
            ),
          ),
          IconButton(
            tooltip: 'Add Client',
            visualDensity: VisualDensity.compact,
            onPressed: _openAddClient,
            icon: const UlvenikIcon(UlvenikIcons.add,
              color: _textSecondary,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.search, color: _textSecondary, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                hintText: 'Search clients, dogs or email...',
                hintStyle: TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_searchController.text.isNotEmpty) {
                _searchController.clear();
                setState(() {});
              } else {
                _searchFocusNode.unfocus();
              }
            },
            child: const Icon(Icons.close_rounded,
              color: _textSecondary,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChipsRow() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _allFilterChips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = _allFilterChips[index];
          final active = _selectedChips.contains(chip);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (active) {
                  _selectedChips.remove(chip);
                } else {
                  _selectedChips.add(chip);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: active
                    ? _forest.withValues(alpha: 0.16)
                    : _cardBg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active ? _forest : _border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    chip,
                    style: TextStyle(
                      color: active ? _mint : _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.45,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (active) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.close_rounded,
                      color: _mint,
                      size: 13,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCountAndSortRow(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$count ${count == 1 ? 'Client' : 'Clients'}',
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        GestureDetector(
          onTap: _showSortBottomSheet,
          behavior: HitTestBehavior.opaque,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Inter',
              ),
              children: [
                const TextSpan(
                  text: 'Sorted by: ',
                  style: TextStyle(color: _textSecondary),
                ),
                TextSpan(
                  text: _sortBy,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeableClientCard(TrainerClient client) {
    final isSwipedOpen = _openSwipeClientId == client.id;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final vx = details.primaryVelocity ?? 0;
        if (vx < -100) {
          setState(() => _openSwipeClientId = client.id);
        } else if (vx > 100 && isSwipedOpen) {
          setState(() => _openSwipeClientId = null);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildSwipeTrayButton(
                    width: 64,
                    bg: _sage,
                    icon: Icons.visibility_outlined,
                    label: 'VIEW',
                    fg: const Color(0xFF1D201F),
                    onTap: () {
                      setState(() => _openSwipeClientId = null);
                      _openClientProfile(client);
                    },
                  ),
                  _buildSwipeTrayButton(
                    width: 64,
                    bg: _charcoalEdit,
                    icon: Icons.edit_outlined,
                    label: 'EDIT',
                    fg: _textPrimary,
                    onTap: () {
                      setState(() => _openSwipeClientId = null);
                      _openEditClient(client);
                    },
                  ),
                  _buildSwipeTrayButton(
                    width: 68,
                    bg: _terracotta,
                    icon: Icons.archive_outlined,
                    label: client.status == 'Archived' ? 'RESTORE' : 'ARCHIVE',
                    fg: _textPrimary,
                    onTap: () => _toggleArchiveClient(client),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(
                isSwipedOpen ? -196 : 0,
                0,
                0,
              ),
              child: _buildClientCardFront(client, isSwipedOpen: isSwipedOpen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeTrayButton({
    required double width,
    required Color bg,
    required IconData icon,
    required String label,
    required Color fg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        color: bg,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UlvenikIcon.fromMaterial(icon, color: fg, size: 19),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.45,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientCardFront(
    TrainerClient client, {
    required bool isSwipedOpen,
  }) {
    final isFav = _favouriteClientIds.contains(client.id);
    final isInactive = _isClientInactive(client);
    final hasSessionToday = _sessionTodayClientIds.contains(client.id);
    final hasHomeworkDue = _homeworkDueClientIds.contains(client.id);
    final dogCount = client.dogs.length;
    final dogSummary = dogCount == 0
        ? 'No dogs linked'
        : '$dogCount ${dogCount == 1 ? 'Dog' : 'Dogs'} (${client.dogNamesSummary})';

    return GestureDetector(
      onTap: () {
        if (isSwipedOpen) {
          setState(() => _openSwipeClientId = null);
        } else {
          _openClientProfile(client);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isFav) {
                        _favouriteClientIds.remove(client.id);
                      } else {
                        _favouriteClientIds.add(client.id);
                      }
                    });
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isInactive
                              ? const Color(0xFF15191C)
                              : const Color(0xFF1F2F29),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isInactive
                                ? _border
                                : _forest.withValues(alpha: 0.5),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: isInactive
                            ? const Icon(Icons.person_outline_rounded,
                                color: _textSecondary,
                                size: 22,
                              )
                            : Text(
                                client.initials,
                                style: const TextStyle(
                                  color: _mint,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                      ),
                      if (isFav)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0xFF232826),
                              shape: BoxShape.circle,
                              border: Border.all(color: _border),
                            ),
                            child: const Icon(Icons.star_rounded,
                              color: _gold,
                              size: 11.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.fullName,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const UlvenikIcon(UlvenikIcons.dogs,
                            color: _sage,
                            size: 13,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              dogSummary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 13,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showClientMoreMenu(client),
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                    child: UlvenikIcon(UlvenikIcons.more,
                      color: _textSecondary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: _border, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                UlvenikIcon.fromMaterial(
                  isInactive
                      ? Icons.event_busy_outlined
                      : Icons.calendar_today_outlined,
                  color: _sageIcon,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: isInactive
                      ? const Text(
                          'No upcoming session',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 12.5,
                            fontFamily: 'Inter',
                          ),
                        )
                      : RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontFamily: 'Inter',
                            ),
                            children: [
                              const TextSpan(
                                text: 'Next Session · ',
                                style: TextStyle(color: _textSecondary),
                              ),
                              TextSpan(
                                text: client.nextSessionLabel,
                                style: const TextStyle(
                                  color: _textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const UlvenikIcon(UlvenikIcons.trainingTime,
                  color: _sageIcon,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  'Last Active · ${client.lastActivityLabel}',
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 12.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildStatusBadge(client.status),
                      if (hasSessionToday && !isInactive)
                        _buildSessionTodayBadge(),
                      if (hasHomeworkDue) _buildHomeworkDueBadge(),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _openSwipeClientId = isSwipedOpen ? null : client.id;
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: UlvenikIcon.fromMaterial(
                    isSwipedOpen
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    color: _textSecondary,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final upper = status.toUpperCase();
    if (status == 'Active') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
        decoration: BoxDecoration(
          color: const Color(0xFF223524),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _forest.withValues(alpha: 0.7)),
        ),
        child: const Text(
          'ACTIVE',
          style: TextStyle(
            color: _mint,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.55,
            fontFamily: 'Inter',
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
      decoration: BoxDecoration(
        color: _inactivePillBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _border),
      ),
      child: Text(
        upper == 'PAUSED' ? 'INACTIVE' : upper,
        style: const TextStyle(
          color: _textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.55,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildSessionTodayBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
      decoration: BoxDecoration(
        color: _alpineBlue.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _alpineBlue.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.5,
            height: 5.5,
            decoration: const BoxDecoration(
              color: _alpineBlue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'SESSION TODAY',
            style: TextStyle(
              color: Color(0xFF8BB8D6),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkDueBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
      decoration: BoxDecoration(
        color: _terracotta.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _terracotta.withValues(alpha: 0.65)),
      ),
      child: const Text(
        'HOMEWORK DUE',
        style: TextStyle(
          color: Color(0xFFE5B5AF),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildSpecEmptyReferenceHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'DIRECTORY REFERENCE (EMPTY STATE)',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.85,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          'SPEC PREVIEW',
          style: TextStyle(
            color: _sageIcon,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStateCard({required bool isSpecReference}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _MountainWireframePainter(),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF212628),
                    shape: BoxShape.circle,
                    border: Border.all(color: _border),
                  ),
                  child: const Icon(Icons.group_add_outlined,
                    color: _sage,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  isSpecReference ? 'No Clients Yet' : 'No Matching Clients',
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isSpecReference
                      ? 'Add your first client to start managing their dogs, sessions, goals and progress.'
                      : 'No clients match your current search or filter chips. Add a new client or reset filters.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 13,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _openAddClient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.person_add_alt_1_outlined, size: 17),
                  label: const Text(
                    'Add Client',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
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
}

class _MountainWireframePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final leftPeak = Path()
      ..moveTo(size.width * 0.08, size.height * 0.82)
      ..lineTo(size.width * 0.35, size.height * 0.38)
      ..lineTo(size.width * 0.60, size.height * 0.82)
      ..close();

    final rightPeak = Path()
      ..moveTo(size.width * 0.36, size.height * 0.82)
      ..lineTo(size.width * 0.66, size.height * 0.28)
      ..lineTo(size.width * 0.92, size.height * 0.82)
      ..close();

    canvas.drawPath(leftPeak, paint);
    canvas.drawPath(rightPeak, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
