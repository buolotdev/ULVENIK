import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'client_permissions_screen.dart';
import 'client_profile_screen.dart';
import 'goals_list_screen.dart';
import 'media_library_screen.dart';
import 'record_session_screen.dart';
import 'strength_conditioning_dashboard_screen.dart';
import 'timeline_screen.dart';
import 'trainer_dashboard_screen.dart';
import 'trainer_workspace_settings_screen.dart';
import 'video_viewer_screen.dart';

class _DogGoalItem {
  final String id;
  String title;
  double progress;
  String dueDate;

  _DogGoalItem({
    required this.id,
    required this.title,
    required this.progress,
    required this.dueDate,
  });
}

class ClientDogProfileScreen extends StatefulWidget {
  final String? clientId;
  final String? dogId;

  const ClientDogProfileScreen({
    super.key,
    this.clientId,
    this.dogId,
  });

  @override
  State<ClientDogProfileScreen> createState() => _ClientDogProfileScreenState();
}

class _ClientDogProfileScreenState extends State<ClientDogProfileScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _cardBg = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _greenAccent = Color(0xFF479A7B);
  static const Color _mintBright = Color(0xFFB1F0D6);
  static const Color _sage = AppColors.secondarySage; // #7A8F7A
  static const Color _alpineBlue = AppColors.infoAlpineBlue; // #5D8FAF
  static const Color _destructiveText = Color(0xFFA84C4C);
  static const Color _textPrimary = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _textSecondary = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _border = AppColors.cardBorder;

  late final AnimationController _animController;
  late final Animation<double> _curvedAnim;

  int? _highlightedQuickStat;
  String _selectedAccessLevel = 'EDITABLE';
  String _dobLabel = '14 May 2023';
  String _weightOverride = '32.4 kg';

  // Client Dog Health & Safety Information (Trainer Reference Only)
  String _healthAllergies = 'Chicken & poultry protein (skin flare); seasonal grass pollen';
  String _healthInjuries = 'Past left stifle strain (2025). Limit repetitive >1m barrier jumps';
  String _healthMedication = 'None active during daily training sessions';
  String _healthConditions = 'Mild bilateral hip laxity; monitor on high-heat days';
  String _healthEmergencyVet = 'Oslo Smådyrklinikk · 24/7 Hotline: +47 22 34 56 78 · Chip: #578098100234190';
  String _healthGeneralNotes = 'Always ensure 10-minute active warm-up before protection/bite work reps. Highly food motivated.';

  static const List<String> _accessLevels = [
    'VIEW ONLY',
    'ADD RECORDS',
    'EDITABLE',
    'FULL ACCESS',
  ];

  late final List<_DogGoalItem> _activeGoals = [
    _DogGoalItem(
      id: 'g_recall',
      title: 'Recall Under High Distraction',
      progress: 0.68,
      dueDate: 'Due 14 Nov',
    ),
    _DogGoalItem(
      id: 'g_track',
      title: 'IGP 1 Scent Pad Tracking',
      progress: 0.45,
      dueDate: 'Due 28 Nov',
    ),
  ];

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
    super.dispose();
  }

  String _accessPermissionSummary(TrainerClient client) {
    final healthClause = client.canViewHealthRecords
        ? 'View Health Records is enabled for owner-shared health information.'
        : 'Health records remain restricted by the dog owner.';
    return switch (_selectedAccessLevel) {
      'VIEW ONLY' =>
        'Read-only trainer access: view training sessions, goals, and shared videos. $healthClause',
      'ADD RECORDS' =>
        'Record new training sessions and upload session media without editing existing owner records. $healthClause',
      'FULL ACCESS' =>
        'Full co-management granted: record sessions, edit dog records, manage goals, and export history. $healthClause',
      _ =>
        'You have permission to record training sessions, assign homework, and manage shared goals. $healthClause',
    };
  }

  void _openEditDogSheet(TrainerClient client, TrainerClientDog dog) {
    if (_selectedAccessLevel == 'VIEW ONLY') {
      AppSnackbar.show(
        context,
        title: 'View-Only Mode',
        message: 'Switch Access Level back to EDITABLE to modify dog details.',
        type: SnackbarType.warning,
      );
      return;
    }

    final nameCtrl = TextEditingController(text: dog.name);
    final breedCtrl = TextEditingController(
      text: dog.id == 'd_murphy' ? 'Golden Retriever' : dog.breed,
    );
    final weightCtrl = TextEditingController(text: _weightOverride);
    final dobCtrl = TextEditingController(text: _dobLabel);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
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
                'Edit ${dog.name}\'s Profile',
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              _buildSheetInput('Dog Name', nameCtrl),
              const SizedBox(height: 10),
              _buildSheetInput('Breed', breedCtrl),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSheetInput('Current Weight', weightCtrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSheetInput('Date of Birth', dobCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final updatedDog = dog.copyWith(
                      name: nameCtrl.text.trim().isEmpty
                          ? dog.name
                          : nameCtrl.text.trim(),
                      breed: breedCtrl.text.trim().isEmpty
                          ? dog.breed
                          : breedCtrl.text.trim(),
                      weightLabel: weightCtrl.text.trim().isEmpty
                          ? _weightOverride
                          : weightCtrl.text.trim(),
                    );
                    final updatedDogs = client.dogs
                        .map((d) => d.id == dog.id ? updatedDog : d)
                        .toList();
                    TrainerPackStore.updateClient(
                      client.copyWith(dogs: updatedDogs),
                    );
                    setState(() {
                      if (weightCtrl.text.trim().isNotEmpty) {
                        _weightOverride = weightCtrl.text.trim();
                      }
                      if (dobCtrl.text.trim().isNotEmpty) {
                        _dobLabel = dobCtrl.text.trim();
                      }
                    });
                    Navigator.pop(ctx);
                    AppSnackbar.show(
                      context,
                      title: 'Dog Profile Updated',
                      message: '${updatedDog.name}\'s trainer record saved.',
                      type: SnackbarType.success,
                    );
                  },
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
                    'Save Dog Changes',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetInput(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: _textPrimary, fontSize: 13.5),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _textSecondary, fontSize: 12),
        filled: true,
        fillColor: const Color(0xFF22272A),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
      ),
    );
  }

  void _showTopContextualSheet(TrainerClient client, TrainerClientDog dog) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: _buildContextualActionsCard(
              client,
              dog,
              inModal: true,
              sheetCtx: ctx,
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
      body: ValueListenableBuilder<List<TrainerClient>>(
        valueListenable: TrainerPackStore.clientsNotifier,
        builder: (context, _, _) {
          final (client, dog) = TrainerPackStore.findClientAndDog(
            clientId: widget.clientId,
            dogId: widget.dogId,
          );

          return AnimatedBuilder(
            animation: _curvedAnim,
            builder: (context, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildScenicHeroSection(client, dog),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),
                          _buildSessionCtaButtons(dog),
                          const SizedBox(height: 22),
                          _buildOverviewSection(client, dog),
                          const SizedBox(height: 22),
                          _buildQuickStatsSection(),
                          const SizedBox(height: 22),
                          _buildActionsGrid(client, dog),
                          const SizedBox(height: 22),
                          _buildRecentActivitySection(dog),
                          const SizedBox(height: 22),
                          _buildActiveGoalsSection(),
                          const SizedBox(height: 22),
                          _buildRecentVideosSection(dog),
                          if (client.canViewHealthRecords) ...[
                            const SizedBox(height: 22),
                            _buildHealthSummarySection(client),
                          ],
                          const SizedBox(height: 22),
                          _buildPermissionsSection(client),
                          const SizedBox(height: 22),
                          _buildSectionHeader('CONTEXTUAL SHEET (PREVIEW)'),
                          const SizedBox(height: 10),
                          _buildContextualActionsCard(client, dog),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildScenicHeroSection(TrainerClient client, TrainerClientDog dog) {
    final isMurphyDefault = dog.id == 'd_murphy';
    final displayBreed = isMurphyDefault ? 'Golden Retriever' : dog.breed;
    final displayAge = isMurphyDefault ? '3 Years' : dog.ageLabel;
    final displaySex = isMurphyDefault ? 'Male (Intact)' : dog.sexLabel;

    return SizedBox(
      height: 360,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _HeroDogForestPainter(),
          ),
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const UlvenikIcon(UlvenikIcons.back,
                        color: _textPrimary,
                        size: 26,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        dog.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'More Options',
                      onPressed: () => _showTopContextualSheet(client, dog),
                      icon: const UlvenikIcon(UlvenikIcons.overflowMenu,
                        color: _textPrimary,
                        size: 21,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        dog.name,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.38),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UlvenikIcon.fromMaterial(
                            _selectedAccessLevel == 'VIEW ONLY'
                                ? Icons.lock_outline_rounded
                                : Icons.lock_open_rounded,
                            color: _sage,
                            size: 12,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _selectedAccessLevel,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.55,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '$displayBreed · $displayAge · $displaySex',
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 13.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ClientProfileScreen(clientId: client.id),
                      ),
                    );
                  },
                  child: Text(
                    'Owner: ${client.fullName}',
                    style: const TextStyle(
                      color: _sage,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: const [
                    _HeroTagChip('IGP 1'),
                    _HeroTagChip('OBEDIENCE'),
                    _HeroTagChip('TRACKING'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCtaButtons(TrainerClientDog dog) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecordSessionScreen(
                    initialActivityName: '${dog.name} · Obedience Session',
                    initialCategory: 'Obedience',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: _textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const UlvenikIcon(UlvenikIcons.play, size: 21),
            label: const Text(
              'Start Training Session',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecordSessionScreen(
                    initialActivityName: '${dog.name} · S&C Conditioning',
                    initialCategory: 'Conditioning',
                  ),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFF121618),
              foregroundColor: _textPrimary,
              side: BorderSide(color: _forest.withValues(alpha: 0.65)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const UlvenikIcon(UlvenikIcons.exercises,
              color: _greenAccent,
              size: 17,
            ),
            label: const Text(
              'Start S&C Session',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
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

  Widget _buildOverviewSection(TrainerClient client, TrainerClientDog dog) {
    final canViewHealth = client.canViewHealthRecords;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'OVERVIEW',
              style: TextStyle(
                color: _greenAccent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.05,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              'TRAINER VIEW',
              style: TextStyle(
                color: _sage,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewItem('Date of Birth', _dobLabel),
                  ),
                  Expanded(
                    child: _buildOverviewItem(
                      'Current Weight',
                      _weightOverride,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewItem('Active Sports', 'IGP, Tracking'),
                  ),
                  Expanded(
                    child: _buildOverviewItem(
                      'Current Goals',
                      '${_activeGoals.length + 1} Active',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (canViewHealth) ...[
                Row(
                  children: [
                    Expanded(
                      child:
                          _buildOverviewItem('Last Session', 'Yesterday 10:30'),
                    ),
                    Expanded(
                      child: _buildOverviewItem(
                        'Last Health Update',
                        '3 days ago',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Training Streak',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '12 Days Active \u{1F525}',
                  style: TextStyle(
                    color: _greenAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child:
                          _buildOverviewItem('Last Session', 'Yesterday 10:30'),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Training Streak',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '12 Days Active \u{1F525}',
                            style: TextStyle(
                              color: _greenAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsSection() {
    final p = _curvedAnim.value;
    final totalSess = (47 * p).round();
    final scSess = (18 * p).round();
    final hours = (38.5 * p).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('QUICK STATS'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildQuickStatCard(
                index: 0,
                icon: Icons.assignment_outlined,
                value: '$totalSess',
                label: 'TOTAL SESSIONS',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickStatCard(
                index: 1,
                icon: Icons.grid_view_rounded,
                value: '$scSess',
                label: 'S&C SESSIONS',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickStatCard(
                index: 2,
                icon: Icons.access_time_rounded,
                value: '${hours}h',
                label: 'HOURS TRAINED',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStatCard({
    required int index,
    required IconData icon,
    required String value,
    required String label,
  }) {
    final selected = _highlightedQuickStat == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _highlightedQuickStat = selected ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(12, 14, 10, 14),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _forest : _border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UlvenikIcon.fromMaterial(icon, color: _sage, size: 17),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? _mintBright : _textSecondary,
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsGrid(TrainerClient client, TrainerClientDog dog) {
    final tiles = <(IconData, String, VoidCallback)>[
      (
        Icons.assignment_outlined,
        'Training',
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecordSessionScreen(
                initialActivityName: '${dog.name} · Training',
              ),
            ),
          );
        }
      ),
      (
        Icons.fitness_center_rounded,
        'S&C',
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const StrengthConditioningDashboardScreen(),
            ),
          );
        }
      ),
      (
        Icons.access_time_rounded,
        'Timeline',
        () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TimelineScreen()),
          );
        }
      ),
      if (client.canViewHealthRecords)
        (
          Icons.favorite_border_rounded,
          'Health',
          () => _openHealthSafetySheet(client),
        ),
      (
        Icons.track_changes_rounded,
        'Goals',
        () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const GoalsListScreen()),
          );
        }
      ),
      (
        Icons.bar_chart_rounded,
        'Statistics',
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const TrainerWorkspaceSettingsScreen(),
            ),
          );
        }
      ),
      (
        Icons.videocam_outlined,
        'Videos',
        () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MediaLibraryScreen()),
          );
        }
      ),
      (
        Icons.description_outlined,
        'Reports',
        () {
          AppSnackbar.show(
            context,
            title: 'Report Generated',
            message: 'Compiled ${dog.name}\'s Trainer Evaluation PDF.',
            type: SnackbarType.success,
          );
        }
      ),
    ];

    final rowCount = (tiles.length / 4).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('ACTIONS'),
        const SizedBox(height: 10),
        for (var row = 0; row < rowCount; row++) ...[
          if (row > 0) const SizedBox(height: 10),
          Row(
            children: List.generate(4, (col) {
              final idx = row * 4 + col;
              if (idx >= tiles.length) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: col == 3 ? 0 : 10),
                    child: const SizedBox(height: 74),
                  ),
                );
              }
              final item = tiles[idx];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: col == 3 ? 0 : 10),
                  child: Material(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: item.$3,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: 74,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UlvenikIcon.fromMaterial(item.$1, color: _sage, size: 20),
                            const SizedBox(height: 7),
                            Text(
                              item.$2,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
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
      ],
    );
  }

  Widget _buildRecentActivitySection(TrainerClientDog dog) {
    final items = [
      (
        Icons.assignment_outlined,
        false,
        'Recall Foundation Practice',
        'Training Session · Yesterday 10:30',
      ),
      (
        Icons.check_rounded,
        true,
        'Goal Completed: 10m Sit-Stay',
        'Goal Milestone · 2 days ago',
      ),
      (
        Icons.videocam_outlined,
        false,
        'Session Video: Long Line Work',
        'Uploaded by Emma · 3 days ago',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('RECENT ACTIVITY'),
        const SizedBox(height: 10),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: item.$2
                            ? _forest.withValues(alpha: 0.20)
                            : const Color(0xFF22272A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: UlvenikIcon.fromMaterial(
                        item.$1,
                        color: item.$2 ? _greenAccent : _sage,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.$3,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.$4,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const UlvenikIcon(UlvenikIcons.details,
                      color: _textSecondary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TimelineScreen()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'View All Activity',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(width: 4),
                UlvenikIcon(UlvenikIcons.details,
                  color: _textSecondary,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveGoalsSection() {
    final p = _curvedAnim.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('ACTIVE GOALS'),
        const SizedBox(height: 10),
        ..._activeGoals.map((goal) {
          final animatedRatio = (goal.progress * p).clamp(0.0, 1.0);
          final pctInt = (goal.progress * 100).round();

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        final next = goal.progress + 0.10;
                        goal.progress = next > 1.0 ? 0.35 : next;
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            goal.title,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const UlvenikIcon(UlvenikIcons.details,
                          color: _textSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      void updateProgress(double dx) {
                        final next =
                            (dx / constraints.maxWidth).clamp(0.05, 1.0);
                        setState(() => goal.progress = next);
                      }

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (d) => updateProgress(d.localPosition.dx),
                        onHorizontalDragUpdate: (d) =>
                            updateProgress(d.localPosition.dx),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: SizedBox(
                              height: 5,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Container(color: const Color(0xFF262D30)),
                                  FractionallySizedBox(
                                    widthFactor: animatedRatio,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _greenAccent,
                                        borderRadius: BorderRadius.circular(99),
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
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$pctInt% complete',
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        goal.dueDate,
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GoalsListScreen()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'View All Goals',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(width: 4),
                UlvenikIcon(UlvenikIcons.details,
                  color: _textSecondary,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentVideosSection(TrainerClientDog dog) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('RECENT VIDEOS'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildVideoThumbnailCard(
                dogName: dog.name,
                title: 'Recall Drill',
                subtitle: 'Yesterday',
                durationLabel: '01:45',
                durationSeconds: 105,
                isMeadow: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildVideoThumbnailCard(
                dogName: dog.name,
                title: 'Heelwork Focus',
                subtitle: '3 days ago',
                durationLabel: '03:12',
                durationSeconds: 192,
                isMeadow: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MediaLibraryScreen()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'View All Videos',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(width: 4),
                UlvenikIcon(UlvenikIcons.details,
                  color: _textSecondary,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoThumbnailCard({
    required String dogName,
    required String title,
    required String subtitle,
    required String durationLabel,
    required int durationSeconds,
    required bool isMeadow,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VideoViewerScreen(
              title: title,
              dogName: dogName,
              activity: 'Obedience',
              durationSeconds: durationSeconds,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 102,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: _VideoScenePainter(isMeadow: isMeadow),
                    ),
                    if (isMeadow)
                      const Positioned(
                        left: 8,
                        top: 8,
                        child: Text(
                          'RECALL DRILL!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    Center(
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                        ),
                        child: const UlvenikIcon(UlvenikIcons.play,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          durationLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 11.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openHealthSafetySheet(TrainerClient client) {
    if (!client.canViewHealthRecords) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.82,
              minChildSize: 0.50,
              maxChildSize: 0.94,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _forest.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: _forest.withValues(alpha: 0.4)),
                                ),
                                child: const UlvenikIcon(UlvenikIcons.health,
                                  color: _mintBright,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Health & Safety',
                                    style: TextStyle(
                                      color: _textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    'Client Dog Reference · Care & Training',
                                    style: TextStyle(
                                      color: _textSecondary.withValues(alpha: 0.85),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const UlvenikIcon(UlvenikIcons.edit, color: _mintBright),
                            tooltip: 'Edit Safety Information',
                            onPressed: () {
                              Navigator.pop(ctx);
                              _openEditHealthSafetySheet();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const UlvenikIcon(UlvenikIcons.notifications,
                              color: _alpineBlue,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Recorded strictly for trainer reference while the dog is in your care. Client dogs do not use the handler\'s full veterinary medical system.',
                                style: TextStyle(
                                  color: _textSecondary.withValues(alpha: 0.9),
                                  fontSize: 12,
                                  height: 1.4,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildSafetyItemCard(
                        icon: Icons.warning_amber_rounded,
                        iconColor: const Color(0xFFE5A84B),
                        title: 'Allergies & Sensitivities',
                        content: _healthAllergies,
                      ),
                      const SizedBox(height: 12),
                      _buildSafetyItemCard(
                        icon: Icons.accessibility_new_rounded,
                        iconColor: const Color(0xFF7A8F7A),
                        title: 'Existing Injuries / Physical Limitations',
                        content: _healthInjuries,
                      ),
                      const SizedBox(height: 12),
                      _buildSafetyItemCard(
                        icon: Icons.medication_outlined,
                        iconColor: const Color(0xFF5D8FAF),
                        title: 'Current Medication (Training/Care)',
                        content: _healthMedication,
                      ),
                      const SizedBox(height: 12),
                      _buildSafetyItemCard(
                        icon: Icons.local_hospital_outlined,
                        iconColor: const Color(0xFF3E8C6F),
                        title: 'Important Medical Conditions',
                        content: _healthConditions,
                      ),
                      const SizedBox(height: 12),
                      _buildSafetyItemCard(
                        icon: Icons.emergency_outlined,
                        iconColor: const Color(0xFFB85050),
                        title: 'Emergency / Vet Information',
                        content: _healthEmergencyVet,
                      ),
                      const SizedBox(height: 12),
                      _buildSafetyItemCard(
                        icon: Icons.notes_rounded,
                        iconColor: _textSecondary,
                        title: 'General Health Notes',
                        content: _healthGeneralNotes,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _forest),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _openEditHealthSafetySheet();
                          },
                          icon: const UlvenikIcon(UlvenikIcons.edit, color: _mintBright, size: 18),
                          label: const Text(
                            'Edit Health & Safety Notes',
                            style: TextStyle(
                              color: _mintBright,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _openEditHealthSafetySheet() {
    final allergiesCtrl = TextEditingController(text: _healthAllergies);
    final injuriesCtrl = TextEditingController(text: _healthInjuries);
    final medCtrl = TextEditingController(text: _healthMedication);
    final condCtrl = TextEditingController(text: _healthConditions);
    final vetCtrl = TextEditingController(text: _healthEmergencyVet);
    final notesCtrl = TextEditingController(text: _healthGeneralNotes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Health & Safety Info',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    IconButton(
                      icon: const UlvenikIcon(UlvenikIcons.back, color: _textSecondary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSafetyInputField(label: 'Allergies & Sensitivities', controller: allergiesCtrl),
                const SizedBox(height: 14),
                _buildSafetyInputField(label: 'Existing Injuries / Limitations', controller: injuriesCtrl),
                const SizedBox(height: 14),
                _buildSafetyInputField(label: 'Current Medication', controller: medCtrl),
                const SizedBox(height: 14),
                _buildSafetyInputField(label: 'Important Medical Conditions', controller: condCtrl),
                const SizedBox(height: 14),
                _buildSafetyInputField(label: 'Emergency / Vet Information', controller: vetCtrl),
                const SizedBox(height: 14),
                _buildSafetyInputField(label: 'General Health Notes', controller: notesCtrl, maxLines: 3),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _healthAllergies = allergiesCtrl.text.trim();
                        _healthInjuries = injuriesCtrl.text.trim();
                        _healthMedication = medCtrl.text.trim();
                        _healthConditions = condCtrl.text.trim();
                        _healthEmergencyVet = vetCtrl.text.trim();
                        _healthGeneralNotes = notesCtrl.text.trim();
                      });
                      Navigator.pop(ctx);
                      AppSnackbar.show(
                        context,
                        title: 'Health & Safety Updated',
                        message: 'Client dog health and safety references saved.',
                        type: SnackbarType.success,
                      );
                    },
                    child: const Text(
                      'Save Health & Safety Info',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSafetyInputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: _bg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _forest),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyItemCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UlvenikIcon.fromMaterial(icon, color: iconColor, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content.isEmpty ? 'None recorded' : content,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 13.5,
              height: 1.4,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSummarySection(TrainerClient client) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('HEALTH SUMMARY'),
            Text(
              'SHARED BY ${client.firstName.toUpperCase()}',
              style: const TextStyle(
                color: _sage,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.9,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              _buildHealthRow(
                icon: Icons.warning_amber_rounded,
                label: 'Allergies',
                value: _healthAllergies.split(';')[0],
                valueColor: const Color(0xFFE5A84B),
              ),
              const SizedBox(height: 14),
              _buildHealthRow(
                icon: Icons.accessibility_new_rounded,
                label: 'Physical Limits',
                value: _healthInjuries.split('.')[0],
                valueColor: _sage,
              ),
              const SizedBox(height: 14),
              _buildHealthRow(
                icon: Icons.medication_outlined,
                label: 'Medications',
                value: _healthMedication,
                valueColor: _textPrimary,
              ),
              const SizedBox(height: 14),
              _buildHealthRow(
                icon: Icons.emergency_outlined,
                label: 'Emergency Vet',
                value: 'On File (24/7)',
                valueColor: _greenAccent,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => _openHealthSafetySheet(client),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'View Shared Health Information',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(width: 4),
                UlvenikIcon(UlvenikIcons.details,
                  color: _textSecondary,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        UlvenikIcon.fromMaterial(icon, color: _sage, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 13.5,
              fontFamily: 'Inter',
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsSection(TrainerClient client) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('PERMISSIONS (TRAINER ACCESS)'),
        const SizedBox(height: 10),
        Container(
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
                children: [
                  const UlvenikIcon(UlvenikIcons.overflowMenu,
                    color: _sage,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Access Level',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  Text(
                    'Granted by ${client.firstName}',
                    style: const TextStyle(
                      color: _sage,
                      fontSize: 11.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _accessLevels.map((lvl) {
                  final active = _selectedAccessLevel == lvl;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAccessLevel = lvl),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? _forest.withValues(alpha: 0.18)
                            : const Color(0xFF22272A),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: active ? _forest : _border,
                        ),
                      ),
                      child: Text(
                        lvl,
                        style: TextStyle(
                          color: active ? _greenAccent : _textSecondary,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              const Text(
                'Editing is enabled by the dog owner. Changes to permissions must be configured from the owner\'s account.',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12.5,
                  height: 1.48,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF151C20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _alpineBlue.withValues(alpha: 0.28),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: UlvenikIcon(UlvenikIcons.notifications,
                        color: _alpineBlue,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _accessPermissionSummary(client),
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                          height: 1.45,
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
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ClientPermissionsScreen(
                    clientId: client.id,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'View Detailed Permissions',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(width: 4),
                UlvenikIcon(UlvenikIcons.details,
                  color: _textSecondary,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContextualActionsCard(
    TrainerClient client,
    TrainerClientDog dog, {
    bool inModal = false,
    BuildContext? sheetCtx,
  }) {
    void closeIfNeeded() {
      if (inModal && sheetCtx != null) {
        Navigator.pop(sheetCtx);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: inModal ? Colors.transparent : _border),
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
          _buildContextRow(
            icon: Icons.edit_square,
            label: 'Edit Dog Profile',
            showChevron: true,
            onTap: () {
              closeIfNeeded();
              _openEditDogSheet(client, dog);
            },
          ),
          _buildContextRow(
            icon: Icons.share_outlined,
            label: 'Share Progress Report',
            showChevron: true,
            onTap: () {
              closeIfNeeded();
              AppSnackbar.show(
                context,
                title: 'Progress Report Shared',
                message:
                    'Sent ${dog.name}\'s progress summary to ${client.fullName}.',
                type: SnackbarType.success,
              );
            },
          ),
          _buildContextRow(
            icon: Icons.download_rounded,
            label: 'Export Dog Records',
            showChevron: true,
            onTap: () {
              closeIfNeeded();
              AppSnackbar.show(
                context,
                title: 'Dog Records Exported',
                message: 'Downloaded ${dog.name}\'s training & S&C archive.',
                type: SnackbarType.info,
              );
            },
          ),
          _buildContextRow(
            icon: Icons.lock_outline_rounded,
            label: 'Archive Dog (Owner Permission Required)',
            isLockedRed: true,
            showChevron: false,
            onTap: () {
              closeIfNeeded();
              AppSnackbar.show(
                context,
                title: 'Owner Permission Required',
                message:
                    'Only ${client.fullName} can archive ${dog.name} from their personal dog profile.',
                type: SnackbarType.warning,
              );
            },
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildContextRow({
    required IconData icon,
    required String label,
    required bool showChevron,
    required VoidCallback onTap,
    bool isLockedRed = false,
  }) {
    final fg = isLockedRed ? _destructiveText : _textPrimary;
    final ic = isLockedRed ? _destructiveText : _sage;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            UlvenikIcon.fromMaterial(icon, color: ic, size: 18),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            if (showChevron)
              const UlvenikIcon(UlvenikIcons.details,
                color: _textSecondary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

class _HeroTagChip extends StatelessWidget {
  final String label;

  const _HeroTagChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF181D20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.55,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

class _HeroDogForestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF394A4A),
          Color(0xFF233030),
          Color(0xFF141A1B),
          Color(0xFF101214),
        ],
        stops: [0.0, 0.45, 0.78, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    // Misty background glow
    final mist = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.05, -0.35),
        radius: 0.65,
        colors: [
          const Color(0xFF8EA5A2).withValues(alpha: 0.22),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, mist);

    // Tall misty pine trunks
    final trunkPaint = Paint()
      ..color = const Color(0xFF121919).withValues(alpha: 0.72);
    for (final (rx, w) in [
      (0.06, 12.0),
      (0.18, 9.0),
      (0.30, 7.0),
      (0.70, 8.0),
      (0.81, 13.0),
      (0.92, 10.0),
    ]) {
      canvas.drawRect(
        Rect.fromLTWH(size.width * rx, 0, w, size.height * 0.68),
        trunkPaint,
      );
    }

    // Winding woodland trail
    final trail = Path()
      ..moveTo(size.width * 0.46, size.height * 0.42)
      ..lineTo(size.width * 0.58, size.height * 0.42)
      ..lineTo(size.width * 0.78, size.height * 0.74)
      ..lineTo(size.width * 0.24, size.height * 0.74)
      ..close();
    canvas.drawPath(
      trail,
      Paint()..color = const Color(0xFF332E28).withValues(alpha: 0.75),
    );

    // Dignified Golden Retriever figure standing on trail
    final dogCenter = Offset(size.width * 0.52, size.height * 0.47);
    final coatMain = Paint()..color = const Color(0xFFAB875B);
    final coatLight = Paint()..color = const Color(0xFFC8A679);
    final collarPaint = Paint()..color = const Color(0xFF28464B);

    // Body & chest
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: dogCenter.translate(8, 12),
          width: 48,
          height: 30,
        ),
        const Radius.circular(14),
      ),
      coatMain,
    );
    // Neck ruff
    canvas.drawCircle(dogCenter.translate(-6, -2), 16, coatLight);
    // Head & muzzle
    canvas.drawCircle(dogCenter.translate(-12, -20), 13, coatLight);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: dogCenter.translate(-22, -18),
          width: 14,
          height: 9,
        ),
        const Radius.circular(4),
      ),
      coatMain,
    );
    // Ear
    canvas.drawOval(
      Rect.fromCenter(
        center: dogCenter.translate(-5, -18),
        width: 9,
        height: 15,
      ),
      coatMain,
    );
    // Collar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: dogCenter.translate(-9, -9),
          width: 18,
          height: 4,
        ),
        const Radius.circular(2),
      ),
      collarPaint,
    );
    // Front & hind legs
    for (final dx in [-10.0, -2.0, 16.0, 24.0]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(dogCenter.dx + dx, dogCenter.dy + 22, 5.5, 32),
          const Radius.circular(2.5),
        ),
        coatMain,
      );
    }

    // Smooth bottom gradient fade into obsidian #101214 for crisp typography
    final fade = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF101214).withValues(alpha: 0.78),
          const Color(0xFF101214),
        ],
        stops: const [0.42, 0.72, 0.96],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, fade);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VideoScenePainter extends CustomPainter {
  final bool isMeadow;

  const _VideoScenePainter({required this.isMeadow});

  @override
  void paint(Canvas canvas, Size size) {
    if (isMeadow) {
      final bg = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3E4C2E),
            Color(0xFF566B36),
            Color(0xFF2B381E),
          ],
        ).createShader(Offset.zero & size);
      canvas.drawRect(Offset.zero & size, bg);

      // Running golden dog accent
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width * 0.62, size.height * 0.58),
            width: 44,
            height: 20,
          ),
          const Radius.circular(9),
        ),
        Paint()..color = const Color(0xFFD29E5C),
      );
    } else {
      final bg = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3A4B4E),
            Color(0xFF202C2E),
            Color(0xFF161D1E),
          ],
        ).createShader(Offset.zero & size);
      canvas.drawRect(Offset.zero & size, bg);

      final trunk = Paint()
        ..color = const Color(0xFF101718).withValues(alpha: 0.7);
      for (final rx in [0.14, 0.28, 0.72, 0.86]) {
        canvas.drawRect(
          Rect.fromLTWH(size.width * rx, 0, 5, size.height),
          trunk,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VideoScenePainter oldDelegate) =>
      oldDelegate.isMeadow != isMeadow;
}
