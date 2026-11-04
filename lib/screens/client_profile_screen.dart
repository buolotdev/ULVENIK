import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'client_dog_profile_screen.dart';
import 'client_dogs_screen.dart';
import 'client_homework_screen.dart';
import 'client_notes_screen.dart';
import 'client_permissions_screen.dart';
import 'client_progress_screen.dart';
import 'create_goal_screen.dart';
import 'record_session_screen.dart';
import 'session_records_screen.dart';
import 'shared_records_screen.dart';
import 'edit_client_screen.dart';
import 'trainer_dashboard_screen.dart';

class _TrainerNoteEntry {
  final String id;
  final String title;
  final String dateLabel;
  final String content;
  final bool isPrivate;

  const _TrainerNoteEntry({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.content,
    this.isPrivate = true,
  });
}

class _ClientHomeworkTask {
  final String id;
  String title;
  String dogName;
  String dueText;
  String status; // IN PROGRESS, OVERDUE, COMPLETED

  _ClientHomeworkTask({
    required this.id,
    required this.title,
    required this.dogName,
    required this.dueText,
    required this.status,
  });
}

class ClientProfileScreen extends StatefulWidget {
  final String? clientId;

  const ClientProfileScreen({
    super.key,
    this.clientId,
  });

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _cardBg = AppColors.cardsCarbon; // #1A1F22
  static const Color _tileBg = Color(0xFF22272A);
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _greenText = Color(0xFF479A7B);
  static const Color _mintBright = Color(0xFFB1F0D6);
  static const Color _sage = AppColors.secondarySage; // #7A8F7A
  static const Color _alpineBlue = AppColors.infoAlpineBlue; // #5D8FAF
  static const Color _gold = AppColors.favouriteGold; // #B8920A
  static const Color _destructive = AppColors.errorDestructive; // #8B3A3A
  static const Color _destructiveText = Color(0xFFB45353);
  static const Color _textPrimary = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _textSecondary = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _border = AppColors.cardBorder;

  late final AnimationController _animController;
  late final Animation<double> _curvedAnim;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _dogsSectionKey = GlobalKey();

  bool _isFavourite = true;
  int? _selectedStatIndex;
  int _selectedWeekBar = 5;

  static const List<String> _weekLabels = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6'];
  static const List<double> _weekAdherence = [0.58, 0.66, 0.74, 0.70, 0.84, 0.92];
  static const List<int> _weekSessions = [6, 7, 8, 7, 9, 10];

  final Map<String, bool> _permissions = {
    'Training Sessions': true,
    'Goals': true,
    'Statistics': true,
    'Media': true,
    'Health Records': false,
  };
  final List<_TrainerNoteEntry> _trainerNotes = [];

  late final List<_ClientHomeworkTask> _homeworkItems = [
    _ClientHomeworkTask(
      id: 'hw_1',
      title: 'Recall Foundation Practice',
      dogName: 'Murphy',
      dueText: 'Due Tomorrow',
      status: 'IN PROGRESS',
    ),
    _ClientHomeworkTask(
      id: 'hw_2',
      title: 'Loose Lead Consistency',
      dogName: 'Bella',
      dueText: 'Due in 3 days',
      status: 'IN PROGRESS',
    ),
    _ClientHomeworkTask(
      id: 'hw_3',
      title: 'Place Training',
      dogName: 'Murphy',
      dueText: '2 days overdue',
      status: 'OVERDUE',
    ),
  ];

  final int _reportsGenerated = 2;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _curvedAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openEditClient(TrainerClient client) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => EditClientScreen(clientId: client.id),
      ),
    );
    if (mounted) setState(() {});
  }

  void _openClientNotes() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ClientNotesScreen(),
      ),
    );
  }

  void _openDogProfile(TrainerClient client, TrainerClientDog dog) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientDogProfileScreen(
          clientId: client.id,
          dogId: dog.id,
        ),
      ),
    );
  }

  void _toggleHomeworkStatus(_ClientHomeworkTask task) {
    setState(() {
      if (task.status == 'IN PROGRESS') {
        task.status = 'COMPLETED';
        task.dueText = 'Completed today';
      } else if (task.status == 'OVERDUE') {
        task.status = 'IN PROGRESS';
        task.dueText = 'Extended · 2 days';
      } else {
        task.status = 'IN PROGRESS';
        task.dueText = 'Due Tomorrow';
      }
    });
    AppSnackbar.show(
      context,
      title: 'Homework Updated',
      message: '${task.title} marked ${task.status.toLowerCase()}.',
      type: SnackbarType.success,
    );
  }

  void _showHomeworkSheet(TrainerClient client) {
    final titleCtrl = TextEditingController();
    var selectedDog =
        client.dogs.isNotEmpty ? client.dogs.first.name : 'Murphy';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 22,
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
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${client.firstName}\'s Homework (${_homeworkItems.length})',
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._homeworkItems.map((hw) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        _toggleHomeworkStatus(hw);
                        setModalState(() {});
                      },
                      title: Text(
                        hw.title,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${hw.dogName} · ${hw.dueText}',
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      trailing: _buildHomeworkStatusBadge(hw.status),
                    );
                  }),
                  const Divider(color: _border, height: 20),
                  TextField(
                    controller: titleCtrl,
                    style: const TextStyle(color: _textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Assign new homework task...',
                      hintStyle: const TextStyle(color: _textSecondary),
                      filled: true,
                      fillColor: _tileBg,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (client.dogs.length > 1)
                        ...client.dogs.map((d) {
                          final active = selectedDog == d.name;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(d.name),
                              selected: active,
                              selectedColor: _forest.withValues(alpha: 0.25),
                              backgroundColor: _tileBg,
                              labelStyle: TextStyle(
                                color: active ? _mintBright : _textSecondary,
                                fontSize: 12,
                              ),
                              onSelected: (_) {
                                setModalState(() => selectedDog = d.name);
                              },
                            ),
                          );
                        }),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          final txt = titleCtrl.text.trim().isEmpty
                              ? 'Distance Sit-Stay Proofing'
                              : titleCtrl.text.trim();
                          setState(() {
                            _homeworkItems.insert(
                              0,
                              _ClientHomeworkTask(
                                id: 'hw_${DateTime.now().millisecondsSinceEpoch}',
                                title: txt,
                                dogName: selectedDog,
                                dueText: 'Due in 5 days',
                                status: 'IN PROGRESS',
                              ),
                            );
                          });
                          Navigator.pop(ctx);
                          AppSnackbar.show(
                            context,
                            title: 'Homework Assigned',
                            message: 'Added "$txt" for $selectedDog.',
                            type: SnackbarType.success,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Assign Task'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showManagePermissionsSheet(TrainerClient client) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientPermissionsScreen(clientId: client.id),
      ),
    );
  }

  void _showOverflowClientActions(TrainerClient client) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: _buildManagementActionsCard(
              client,
              inBottomSheet: true,
              sheetContext: ctx,
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteClient(TrainerClient client) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: _cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _border),
          ),
          title: Text(
            'Delete ${client.fullName}?',
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'This removes the client from your Trainer Pack directory while preserving dogs on their personal owner accounts.',
            style: TextStyle(color: _textSecondary, fontSize: 13.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(color: _textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                TrainerPackStore.removeClient(client.id);
                Navigator.of(context).maybePop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _destructive,
                foregroundColor: _textPrimary,
                elevation: 0,
              ),
              child: const Text('Delete Client'),
            ),
          ],
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
      body: SafeArea(
        child: ValueListenableBuilder<List<TrainerClient>>(
          valueListenable: TrainerPackStore.clientsNotifier,
          builder: (context, _, _) {
            final client = TrainerPackStore.findClient(widget.clientId);

            return AnimatedBuilder(
              animation: _curvedAnim,
              builder: (context, _) {
                return Column(
                  children: [
                    _buildTopBar(client),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroIdentityCard(client),
                            const SizedBox(height: 14),
                            _buildKpiGrid(client),
                            const SizedBox(height: 14),
                            _buildMetadataGridCard(client),
                            const SizedBox(height: 20),
                            _buildQuickActionsSection(client),
                            const SizedBox(height: 20),
                            _buildStatisticsSection(),
                            const SizedBox(height: 20),
                            _buildDogsSection(client),
                            const SizedBox(height: 20),
                            _buildHomeworkSection(client),
                            const SizedBox(height: 20),
                            _buildNotesSection(),
                            const SizedBox(height: 20),
                            _buildPermissionsSection(client),
                            const SizedBox(height: 20),
                            _buildManagementActionsCard(client),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(TrainerClient client) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: _textSecondary,
              size: 26,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(
                client.fullName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Favourite Client',
            visualDensity: VisualDensity.compact,
            onPressed: () {
              setState(() => _isFavourite = !_isFavourite);
              AppSnackbar.show(
                context,
                title: _isFavourite
                    ? 'Added to Favourites'
                    : 'Removed from Favourites',
                message: '${client.fullName} favourite status updated.',
                type: SnackbarType.info,
              );
            },
            icon: Icon(
              _isFavourite ? Icons.star_rounded : Icons.star_border_rounded,
              color: _isFavourite ? _gold : _textSecondary,
              size: 22,
            ),
          ),
          IconButton(
            tooltip: 'Client Options',
            visualDensity: VisualDensity.compact,
            onPressed: () => _showOverflowClientActions(client),
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: _textSecondary,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  
  void _openClientDogs(TrainerClient client) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientDogsScreen(clientId: client.id),
      ),
    );
  }

  void _openSessionRecords(TrainerClient client) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SessionRecordsScreen(clientId: client.id),
      ),
    );
  }

  void _showAddTrainerNoteSheet() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    var isPrivate = true;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 22,
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
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Add Trainer Note',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: titleCtrl,
                    style: const TextStyle(color: _textPrimary, fontSize: 13.5),
                    decoration: InputDecoration(
                      labelText: 'Note Title',
                      labelStyle: const TextStyle(color: _textSecondary, fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xFF21272A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: bodyCtrl,
                    maxLines: 3,
                    style: const TextStyle(color: _textPrimary, fontSize: 13.5),
                    decoration: InputDecoration(
                      labelText: 'Note Content',
                      labelStyle: const TextStyle(color: _textSecondary, fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xFF21272A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.lock_outline_rounded, color: _sage, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Private Note (trainer only)',
                            style: TextStyle(color: _textSecondary, fontSize: 12.5),
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: isPrivate,
                        activeThumbColor: _forest, activeTrackColor: _forest.withValues(alpha: 0.5),
                        onChanged: (val) => setModalState(() => isPrivate = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        final t = titleCtrl.text.trim();
                        if (t.isNotEmpty) {
                          setState(() {
                            _trainerNotes.add(
                              _TrainerNoteEntry(
                                id: 'tn_${DateTime.now().millisecondsSinceEpoch}',
                                title: t,
                                dateLabel: 'Today',
                                content: bodyCtrl.text.trim(),
                                isPrivate: isPrivate,
                              ),
                            );
                          });
                          Navigator.pop(ctx);
                          AppSnackbar.show(
                            context,
                            title: 'Note Saved',
                            message: 'Private trainer note saved.',
                            type: SnackbarType.success,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save Note'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildKpiGrid(TrainerClient client) {
    final dogCount = client.dogs.isNotEmpty ? client.dogs.length : 2;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildKpiBox(
                value: '$dogCount',
                label: 'LINKED DOGS',
                onTap: () => _openClientDogs(client),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildKpiBox(
                value: '3',
                label: 'ACTIVE GOALS',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreateGoalScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildKpiBox(
                value: '2',
                label: 'HOMEWORK DUE',
                onTap: () => _showHomeworkSheet(client),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildKpiBox(
                value: '8',
                label: 'SESSIONS TOTAL',
                onTap: () => _openSessionRecords(client),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiBox({
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroIdentityCard(TrainerClient client) {
    final displayPhone = client.phone;
    final displayEmail = client.email;
    final statusBadgeText = client.status == 'Active'
        ? 'ACTIVE CLIENT'
        : '${client.status.toUpperCase()} CLIENT';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF282F32),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            alignment: Alignment.center,
            child: Text(
              client.initials,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            client.fullName,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: _greenText,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'Connected to Ulvenik',
                style: TextStyle(
                  color: _greenText,
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Client since  ·  Linked ',
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2421),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _forest.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: _greenText, size: 13.5),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Next Session · ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _greenText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    statusBadgeText,
                    style: const TextStyle(
                      color: _greenText,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone_outlined, color: _sage, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    displayPhone,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 12.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const Text(
                '·',
                style: TextStyle(color: _textSecondary, fontSize: 13),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mail_outline_rounded, color: _sage, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    displayEmail,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 12.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildContactActionBtn(
                  icon: Icons.phone_outlined,
                  label: 'Call',
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: displayPhone));
                    AppSnackbar.show(
                      context,
                      title: 'Calling ${client.firstName}',
                      message: 'Phone number $displayPhone ready to dial.',
                      type: SnackbarType.info,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildContactActionBtn(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: displayEmail));
                    AppSnackbar.show(
                      context,
                      title: 'Email Copied',
                      message: 'Copied $displayEmail to clipboard.',
                      type: SnackbarType.info,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactActionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF262B2E),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _sage, size: 16),
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataGridCard(TrainerClient client) {
    final isEmma = client.id == 'c_emma';
    final memberSince = isEmma
        ? 'Jul 2026'
        : client.joinedLabel.replaceFirst('Joined ', '');
    final nextSess = isEmma ? 'Thu 10:00' : client.nextSessionLabel;
    final lastAct = isEmma ? 'Yesterday' : client.lastActivityLabel;

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildMetaCell('Member Since', memberSince),
                ),
                const VerticalDivider(color: _border, width: 1),
                Expanded(
                  child: _buildMetaCell('Total Dogs', '${client.dogs.length}'),
                ),
                const VerticalDivider(color: _border, width: 1),
                Expanded(
                  child: _buildMetaCell('Last Active', lastAct),
                ),
              ],
            ),
          ),
          const Divider(color: _border, height: 1),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildMetaCell('Next Session', nextSess),
                ),
                const VerticalDivider(color: _border, width: 1),
                Expanded(
                  child: _buildMetaCell(
                    'Emerg. Contact',
                    'On File',
                    onTap: () {
                      AppSnackbar.show(
                        context,
                        title: 'Emergency Contact',
                        message: 'Mark Johnson (Partner) · +44 7700 900455',
                        type: SnackbarType.info,
                      );
                    },
                  ),
                ),
                const VerticalDivider(color: _border, width: 1),
                Expanded(
                  child: _buildMetaCell(
                    'Vet Practice',
                    'On File',
                    onTap: () {
                      AppSnackbar.show(
                        context,
                        title: 'Registered Vet Practice',
                        message: 'Chelmsford Veterinary Referrals · On File',
                        type: SnackbarType.info,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCell(String label, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 13, 10, 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 11,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.05,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildQuickActionsSection(TrainerClient client) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('QUICK ACTIONS'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                icon: Icons.add_rounded,
                label: 'Record Session',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RecordSessionScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionTile(
                icon: Icons.assignment_outlined,
                label: 'Assign HW',
                onTap: () => _showHomeworkSheet(client),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionTile(
                icon: Icons.flag_outlined,
                label: 'Create Goal',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CreateGoalScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionTile(
                icon: Icons.edit_outlined,
                label: 'Add Note',
                onTap: _showAddTrainerNoteSheet,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _tileBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _sage, size: 19),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    final p = _curvedAnim.value;
    final completedHwCount = _homeworkItems
            .where((h) => h.status == 'COMPLETED')
            .length +
        11;
    final stats = [
      ('${(47 * p).round()}', 'Training Sessions'),
      ('${((_homeworkItems.length + 11) * p).round()}', 'Homework Assigned'),
      ('${(completedHwCount * p).round()}', 'Homework Completed'),
      ('${(5 * p).round()}', 'Goals Achieved'),
      ('${(3 * p).round()}', 'Active Goals'),
      ('${(_reportsGenerated * p).round()}', 'Reports Generated'),
    ];

    final adherencePct = (_weekAdherence[_selectedWeekBar] * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('STATISTICS'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              for (var r = 0; r < 3; r++) ...[
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCell(
                          index: r * 2,
                          value: stats[r * 2].$1,
                          label: stats[r * 2].$2,
                        ),
                      ),
                      const VerticalDivider(color: _border, width: 1),
                      Expanded(
                        child: _buildStatCell(
                          index: r * 2 + 1,
                          value: stats[r * 2 + 1].$1,
                          label: stats[r * 2 + 1].$2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: _border, height: 1),
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '6-Week Activity & Adherence',
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          '${_weekLabels[_selectedWeekBar]}: ${_weekSessions[_selectedWeekBar]} logs · $adherencePct%',
                          style: const TextStyle(
                            color: _greenText,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        void handleTouch(double dx) {
                          final idx = ((dx / constraints.maxWidth) *
                                  _weekLabels.length)
                              .floor()
                              .clamp(0, _weekLabels.length - 1);
                          if (_selectedWeekBar != idx) {
                            setState(() => _selectedWeekBar = idx);
                          }
                        }

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (d) => handleTouch(d.localPosition.dx),
                          onHorizontalDragUpdate: (d) =>
                              handleTouch(d.localPosition.dx),
                          child: SizedBox(
                            height: 52,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:
                                  List.generate(_weekLabels.length, (i) {
                                final isSelected = i == _selectedWeekBar;
                                final h = math.max(
                                  6.0,
                                  32.0 * _weekAdherence[i] * p,
                                );
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: i == _weekLabels.length - 1
                                          ? 0
                                          : 8,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          height: h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? _forest
                                                : _forest.withValues(
                                                    alpha: 0.32,
                                                  ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          _weekLabels[i],
                                          style: TextStyle(
                                            color: isSelected
                                                ? _mintBright
                                                : _textSecondary,
                                            fontSize: 10.5,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCell({
    required int index,
    required String value,
    required String label,
  }) {
    final isSelected = _selectedStatIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatIndex = isSelected ? null : index;
        });
      },
      child: Container(
        color: isSelected ? _forest.withValues(alpha: 0.10) : Colors.transparent,
        padding: const EdgeInsets.fromLTRB(16, 15, 14, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _mintBright : _textSecondary,
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDogsSection(TrainerClient client) {
    final isEmma = client.id == 'c_emma';
    final displayDogs = isEmma
        ? const [
            TrainerClientDog(
              id: 'd_murphy',
              name: 'Murphy',
              breed: 'Golden Retr.',
              ageLabel: '3 Yrs',
              focusArea: 'IGP',
            ),
            TrainerClientDog(
              id: 'd_bella_emma',
              name: 'Bella',
              breed: 'Border Collie',
              ageLabel: '5 Yrs',
              focusArea: 'Agility',
            ),
          ]
        : client.dogs;

    return Column(
      key: _dogsSectionKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('LINKED DOGS'),
            GestureDetector(
              onTap: () => _openClientDogs(client),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: _greenText,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (displayDogs.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: const Text(
              'No dogs linked to this client yet.',
              style: TextStyle(color: _textSecondary, fontSize: 13),
            ),
          )
        else
          Row(
            children: List.generate(math.min(2, displayDogs.length), (i) {
              final dog = displayDogs[i];
              final showIgpTag = i == 0;
              final lastText = i == 0 ? 'Last · Yesterday' : 'Last · 2d ago';
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: i == 0 && displayDogs.length > 1 ? 12 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => _openDogProfile(client, dog),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 112,
                              width: double.infinity,
                              child: CustomPaint(
                                painter: _DogScenicCardPainter(isForest: i == 0),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 12, 12, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          dog.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: _textPrimary,
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                      if (showIgpTag)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _tileBg,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border:
                                                Border.all(color: _border),
                                          ),
                                          child: const Text(
                                            'IGP',
                                            style: TextStyle(
                                              color: _textSecondary,
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${dog.breed} · ${dog.ageLabel}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: _textSecondary,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        lastText,
                                        style: const TextStyle(
                                          color: _textSecondary,
                                          fontSize: 11.5,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        color: _textSecondary,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildHomeworkSection(TrainerClient client) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('HOMEWORK'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              ...List.generate(_homeworkItems.length, (i) {
                final hw = _homeworkItems[i];
                final isOverdue = hw.status == 'OVERDUE';
                final dueColor = isOverdue
                    ? _destructiveText
                    : (i == 0 ? _greenText : _textSecondary);

                return Column(
                  children: [
                    InkWell(
                      onTap: () => _toggleHomeworkStatus(hw),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 15, 14, 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          hw.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: _textPrimary,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _tileBg,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(color: _border),
                                        ),
                                        child: Text(
                                          hw.dogName,
                                          style: const TextStyle(
                                            color: _textSecondary,
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        hw.dueText,
                                        style: TextStyle(
                                          color: dueColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      _buildHomeworkStatusBadge(hw.status),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: _textSecondary,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: _border, height: 1),
                  ],
                );
              }),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ClientHomeworkScreen(),
                  ),
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 13, 16, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'View All Homework',
                        style: TextStyle(
                          color: _greenText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: _greenText,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomeworkStatusBadge(String status) {
    final isOverdue = status == 'OVERDUE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOverdue
            ? _destructive.withValues(alpha: 0.22)
            : _forest.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isOverdue
              ? _destructive.withValues(alpha: 0.55)
              : _forest.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isOverdue ? _destructiveText : _greenText,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.45,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('TRAINER NOTES'),
            GestureDetector(
              onTap: _showAddTrainerNoteSheet,
              child: const Text(
                'Add Note',
                style: TextStyle(
                  color: _mintBright,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Column(
              children: [
                if (_trainerNotes.isEmpty)
                  InkWell(
                    onTap: _showAddTrainerNoteSheet,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'No trainer notes added yet',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 13.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.add, size: 16, color: _greenText),
                              SizedBox(width: 4),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: _greenText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._trainerNotes.map((note) => InkWell(
                        onTap: _openClientNotes,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (note.isPrivate) ...[
                                    const Icon(
                                      Icons.lock_outline_rounded,
                                      color: _sage,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Expanded(
                                    child: Text(
                                      note.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: _textPrimary,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (note.isPrivate)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF22282B),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: _border),
                                      ),
                                      child: const Text(
                                        'Private',
                                        style: TextStyle(
                                          color: _textSecondary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (note.content.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                Text(
                                  note.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _textSecondary,
                                    fontSize: 12.5,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )),
                const Divider(color: _border, height: 1),
                InkWell(
                  onTap: _openClientNotes,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'View All Notes',
                          style: TextStyle(
                            color: _greenText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: _greenText,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: _border, height: 1),
                Container(
                  width: double.infinity,
                  color: const Color(0xFF151A1E),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.lock_outline_rounded,
                        color: _alpineBlue,
                        size: 15,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Notes are private and never visible to the client.',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _permissionAccessLabel(String key, bool enabled) {
    if (!enabled) return 'Restricted';
    switch (key) {
      case 'Training Sessions':
      case 'Goals':
        return 'Read / Write';
      case 'Statistics':
        return 'View Only';
      case 'Media':
        return 'View & Upload';
      default:
        return 'Enabled';
    }
  }

  Future<void> _confirmToggleArchiveClient(TrainerClient client) async {
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
              ),
            ),
            content: Text(
              'Are you sure you want to archive ${client.fullName}? Their profile, dogs and session history will move to archived clients and can be restored at any time.',
              style: const TextStyle(color: _textSecondary, fontSize: 13.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: _textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _destructive,
                  foregroundColor: _textPrimary,
                  elevation: 0,
                ),
                child: const Text('Archive Client'),
              ),
            ],
          );
        },
      );
      if (confirmed != true || !mounted) return;
    }

    final next = isArchiving ? 'Archived' : 'Active';
    TrainerPackStore.updateClient(client.copyWith(status: next));
    AppSnackbar.show(
      context,
      title: next == 'Archived' ? 'Client Archived' : 'Client Restored',
      message: '${client.fullName} status changed to $next.',
      type: SnackbarType.info,
    );
  }

  Widget _buildPermissionsSection(TrainerClient client) {
    final entries = _permissions.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('PERMISSIONS'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              ...List.generate(entries.length, (i) {
                final item = entries[i];
                final allowed = item.key == 'Health Records'
                    ? client.canViewHealthRecords
                    : item.value;
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        final nextVal = !allowed;
                        setState(() => _permissions[item.key] = nextVal);
                        if (item.key == 'Health Records') {
                          TrainerPackStore.updateClient(
                            client.copyWith(canViewHealthRecords: nextVal),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              allowed
                                  ? Icons.check_rounded
                                  : Icons.close_rounded,
                              color: allowed ? _greenText : _destructiveText,
                              size: 17,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.key,
                                style: TextStyle(
                                  color:
                                      allowed ? _textPrimary : _textSecondary,
                                  fontSize: 14,
                                  fontWeight: allowed
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            Text(
                              _permissionAccessLabel(item.key, allowed),
                              style: TextStyle(
                                color: allowed ? _textSecondary : const Color(0xFFD97777),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: _border, height: 1),
                  ],
                );
              }),
              InkWell(
                onTap: () => _showManagePermissionsSheet(client),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 13, 16, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'Manage Permissions',
                        style: TextStyle(
                          color: _greenText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: _greenText,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildManagementActionsCard(
    TrainerClient client, {
    bool inBottomSheet = false,
    BuildContext? sheetContext,
  }) {
    void maybeCloseSheet() {
      if (inBottomSheet && sheetContext != null) {
        Navigator.pop(sheetContext);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: inBottomSheet ? Colors.transparent : _border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          _buildActionSheetRow(
            label: 'Edit Client',
            icon: Icons.edit_outlined,
            onTap: () {
              maybeCloseSheet();
              _openEditClient(client);
            },
          ),
          const Divider(color: _border, height: 1),
          _buildActionSheetRow(
            label: client.status == 'Archived'
                ? 'Restore Client'
                : 'Archive Client',
            icon: Icons.inventory_2_outlined,
            onTap: () {
              maybeCloseSheet();
              _confirmToggleArchiveClient(client);
            },
          ),
          const Divider(color: _border, height: 1),
          _buildActionSheetRow(
            label: 'Export Client',
            icon: Icons.download_rounded,
            onTap: () {
              maybeCloseSheet();
              AppSnackbar.show(
                context,
                title: 'Export Ready',
                message:
                    'Exported ${client.fullName} training dossier & session history.',
                type: SnackbarType.success,
              );
            },
          ),
          const Divider(color: _border, height: 1),
          _buildActionSheetRow(
            label: 'Shared Records',
            icon: Icons.folder_shared_outlined,
            onTap: () {
              maybeCloseSheet();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SharedRecordsScreen(),
                ),
              );
            },
          ),
          const Divider(color: _border, height: 1),
          _buildActionSheetRow(
            label: 'Client Analytics',
            icon: Icons.insights_rounded,
            onTap: () {
              maybeCloseSheet();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ClientProgressScreen(),
                ),
              );
            },
          ),
          const Divider(color: _border, height: 1),
          _buildActionSheetRow(
            label: 'Share Client',
            icon: Icons.share_outlined,
            onTap: () {
              maybeCloseSheet();
              AppSnackbar.show(
                context,
                title: 'Share Link Copied',
                message: 'Copied secure invite link for ${client.fullName}.',
                type: SnackbarType.info,
              );
            },
          ),
          const Divider(color: _border, height: 1),
          _buildActionSheetRow(
            label: 'Delete Client',
            icon: Icons.delete_outline_rounded,
            isDestructive: true,
            onTap: () {
              maybeCloseSheet();
              _confirmDeleteClient(client);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionSheetRow({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? _destructiveText : _textPrimary;
    final iconColor = isDestructive ? _destructiveText : _textSecondary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
            Icon(icon, color: iconColor, size: 18),
          ],
        ),
      ),
    );
  }
}

class _DogScenicCardPainter extends CustomPainter {
  final bool isForest;

  const _DogScenicCardPainter({required this.isForest});

  @override
  void paint(Canvas canvas, Size size) {
    if (isForest) {
      final bg = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF334342),
            Color(0xFF1F2B2A),
            Color(0xFF19201F),
          ],
        ).createShader(Offset.zero & size);
      canvas.drawRect(Offset.zero & size, bg);

      // Tall forest trunks
      final trunkPaint = Paint()
        ..color = const Color(0xFF121918).withValues(alpha: 0.72);
      for (final rx in [0.10, 0.22, 0.36, 0.68, 0.82, 0.92]) {
        canvas.drawRect(
          Rect.fromLTWH(size.width * rx, 0, 5, size.height * 0.78),
          trunkPaint,
        );
      }

      // Forest path
      final pathPaint = Paint()..color = const Color(0xFF3A352E);
      final trail = Path()
        ..moveTo(size.width * 0.42, size.height * 0.62)
        ..lineTo(size.width * 0.58, size.height * 0.62)
        ..lineTo(size.width * 0.85, size.height)
        ..lineTo(size.width * 0.15, size.height)
        ..close();
      canvas.drawPath(trail, pathPaint);

      // Golden Retriever silhouette standing attentively center
      _drawDogSilhouette(
        canvas,
        Offset(size.width * 0.50, size.height * 0.62),
        const Color(0xFFC29B6B),
      );
    } else {
      final bg = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF5D5350),
            Color(0xFF2E3C49),
            Color(0xFF1D2824),
          ],
        ).createShader(Offset.zero & size);
      canvas.drawRect(Offset.zero & size, bg);

      // Distant mountain ridge
      final ridge = Path()
        ..moveTo(0, size.height * 0.65)
        ..lineTo(size.width * 0.28, size.height * 0.28)
        ..lineTo(size.width * 0.55, size.height * 0.52)
        ..lineTo(size.width * 0.84, size.height * 0.24)
        ..lineTo(size.width, size.height * 0.45)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(
        ridge,
        Paint()..color = const Color(0xFF1F2A28).withValues(alpha: 0.85),
      );

      // Mossy foreground slope
      final slope = Path()
        ..moveTo(0, size.height * 0.76)
        ..quadraticBezierTo(
          size.width * 0.5,
          size.height * 0.64,
          size.width,
          size.height * 0.78,
        )
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(slope, Paint()..color = const Color(0xFF263524));

      // Border Collie silhouette
      _drawDogSilhouette(
        canvas,
        Offset(size.width * 0.48, size.height * 0.60),
        const Color(0xFFE6EAE8),
        darkCoatAccent: const Color(0xFF181C1E),
      );
    }
  }

  void _drawDogSilhouette(
    Canvas canvas,
    Offset center,
    Color coatColor, {
    Color? darkCoatAccent,
  }) {
    final bodyPaint = Paint()..color = darkCoatAccent ?? coatColor;
    final chestPaint = Paint()..color = coatColor;

    // Torso
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 26, height: 13),
        const Radius.circular(6),
      ),
      bodyPaint,
    );
    // Chest blaze & head
    canvas.drawCircle(center.translate(-10, -8), 6.5, chestPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center.translate(-15, -9),
          width: 8,
          height: 5,
        ),
        const Radius.circular(2.5),
      ),
      bodyPaint,
    );
    // Legs
    for (final dx in [-9.0, -4.0, 6.0, 10.0]) {
      canvas.drawRect(
        Rect.fromLTWH(center.dx + dx, center.dy + 5, 2.6, 13),
        chestPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DogScenicCardPainter oldDelegate) =>
      oldDelegate.isForest != isForest;
}
