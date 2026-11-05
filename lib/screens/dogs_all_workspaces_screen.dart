import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import 'dog_profile_screen.dart';
import 'image_editor_screen.dart';
import 'subscription_details_screen.dart';
import 'sport_pack_overview_screen.dart';
import 'trainer_workspace_settings_screen.dart';
import '../widgets/custom_snackbar.dart';

class DogsAllWorkspacesScreen extends StatefulWidget {
  const DogsAllWorkspacesScreen({super.key});

  @override
  State<DogsAllWorkspacesScreen> createState() => _DogsAllWorkspacesScreenState();
}

class _DogsAllWorkspacesScreenState extends State<DogsAllWorkspacesScreen> {
  int _selectedWorkspace = 1; // 0: My Dogs (Core), 1: Sport Dogs (Sport Pack), 2: Client Dogs (Trainer Pack)

  // Dog card photo vertical framing alignments (allows custom crop/repositioning per landscape card)
  final Map<String, Alignment> _photoAlignments = {
    'Murphy': const Alignment(0, -0.2),
    'Rex': const Alignment(0, 0.0),
    'Koda': const Alignment(0, -0.1),
  };

  void _repositionDogPhoto(String name, String imageUrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        Alignment currentAlignment = _photoAlignments[name] ?? Alignment.center;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reposition Photo · ',
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Done', style: TextStyle(color: AppColors.primaryForestGreen)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Live Landscape Card Framing Preview
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryForestGreen),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      alignment: currentAlignment,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Vertical Framing',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Slider(
                    value: currentAlignment.y,
                    min: -1.0,
                    max: 1.0,
                    activeColor: AppColors.primaryForestGreen,
                    inactiveColor: Colors.white12,
                    onChanged: (val) {
                      setModalState(() {
                        currentAlignment = Alignment(currentAlignment.x, val);
                      });
                      setState(() {
                        _photoAlignments[name] = currentAlignment;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPresetChip('Top Focus', -0.8, currentAlignment, (val) {
                        setModalState(() => currentAlignment = Alignment(0, val));
                        setState(() => _photoAlignments[name] = currentAlignment);
                      }),
                      _buildPresetChip('Center Focus', 0.0, currentAlignment, (val) {
                        setModalState(() => currentAlignment = Alignment(0, val));
                        setState(() => _photoAlignments[name] = currentAlignment);
                      }),
                      _buildPresetChip('Bottom Focus', 0.8, currentAlignment, (val) {
                        setModalState(() => currentAlignment = Alignment(0, val));
                        setState(() => _photoAlignments[name] = currentAlignment);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ImageEditorScreen(
                            initialCircularCrop: false,
                          ),
                        ),
                      );
                    },
                    icon: const UlvenikIcon(UlvenikIcons.edit, size: 18, color: AppColors.primaryTextOffWhite),
                    label: const Text('Advanced Crop & Zoom Editor', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildPresetChip(String label, double y, Alignment current, ValueChanged<double> onSelect) {
    final isActive = (current.y - y).abs() < 0.25;
    return GestureDetector(
      onTap: () => onSelect(y),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryForestGreen : AppColors.backgroundObsidian,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? AppColors.primaryForestGreen : Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildWorkspaceSelector(),
            Expanded(
              child: _selectedWorkspace == 0
                  ? _buildMyDogsListView()
                  : _selectedWorkspace == 2
                      ? _buildClientDogsListView()
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                          children: [
                            _buildDogCard(
                              name: 'Murphy',
                              breed: 'Belgian Malinois',
                              tag: 'IGP',
                              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCCHELrb1zJHxkzvLEcxc5HvIeblV8UqHIBdjT76A_6WiS7ACVJ8wyXhCuRGxZtDdmN-JgvEd9uu4WXCfbHMsH-ksGCxhXA_HSfDFN_V4mUIMU27LdUD2yvii3f4QbZ7AbSPbm1rNUrG-vFPgCB7t11yX4sDO24c8B615vQv6r27CXNpjn7yLJkHf2IbPmze0G4sIBhms3uObq8Fls9KVvr6PmsS78d2O8bsKacSjOvNsLGkPhoLhI',
                            ),
                            const SizedBox(height: 12),
                            _buildDogCard(
                              name: 'Rex',
                              breed: 'German Shepherd',
                              tag: 'IPO',
                              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCHv0YwualhgVN8mZm71eYVCiefQjhLohQXvrajAJ2M5WeFJ1ZXvUkS4sE-61zydWeyqo98aMfnZ7OPklTsLqWODP4KAeinU4BpCIaEJPj2phE7Db1D_bcOSXYVcTrDMttNMfRvCeyiKI4FNLGeVxM1Aeg2nPbRTmedNZD7DIqSey3Mtwr3Z7RFmrYCVIQkw6waLI_5VIvF4hOQcqj8pgn3hy8_p-_-HKyS8kZe4EZUcVWsrndz_TY',
                            ),
                            const SizedBox(height: 12),
                            _buildDogCard(
                              name: 'Koda',
                              breed: 'Dutch Shepherd',
                              tag: 'Agility',
                              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAFKOO8gb4AWaLg2qLsOdAQTzB6SsCO_QKNqK2eJLTRocSldxOEHALJ8tI9kAqM8ovNBIcPR5h4OVyx0MVW69rlcHCAHDJ8S_S8h2Na2cSVAoXBhMdes4q9GK_Uu_j6kmM_9IBq7Re2k3DIkQz3W0hjLlYDhUC-dJ1cyLwqSc3koHhLeATfkYApJXTGBflU--BJY-uskJ1QD1Vqo-yjQ7_jWWUPV8NPFe_mrxbEGwMdaW1QZn_6F5o',
                            ),
                            const SizedBox(height: 80), // Padding for FAB
                          ],
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppSnackbar.show(context, message: 'Add dog to workspace coming soon', type: SnackbarType.info),
        backgroundColor: AppColors.primaryForestGreen,
        child: const UlvenikIcon(UlvenikIcons.add, color: AppColors.primaryTextOffWhite),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Center(
        child: Text(
          'Ulvenik',
          style: const TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildWorkspaceSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildWorkspacePill(0, 'My Dogs', '6', 'Core'),
                const SizedBox(width: 8),
                _buildWorkspacePill(1, 'Sport Dogs', '3', 'Sport Pack'),
                const SizedBox(width: 8),
                _buildWorkspacePill(2, 'Client Dogs', '1', 'Trainer Pack'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _buildSubscriptionNotice(),
        ],
      ),
    );
  }

  Widget _buildSubscriptionNotice() {
    final packName = _selectedWorkspace == 0
        ? 'Core Subscription'
        : _selectedWorkspace == 1
            ? 'Sport Pack'
            : 'Trainer Pack';
    final desc = _selectedWorkspace == 0
        ? 'Full health, training journals & lifetime milestones'
        : _selectedWorkspace == 1
            ? 'Trial prep, sport scoring, IGP & conditioning logs'
            : 'Client homework, permissions & streamlined health';

    return GestureDetector(
      onTap: () {
        if (_selectedWorkspace == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SportPackOverviewScreen()));
        } else if (_selectedWorkspace == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainerWorkspaceSettingsScreen()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionDetailsScreen()));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            const UlvenikIcon(UlvenikIcons.completed, size: 14, color: Color(0xFF95D3BB)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '$packName · $desc',
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const UlvenikIcon(UlvenikIcons.details, size: 14, color: AppColors.secondaryTextStoneGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspacePill(int index, String title, String count, String pack) {
    final isSelected = _selectedWorkspace == index;
    const onPrimaryContainer = Color(0xFFaae9d0);
    const primaryColor = Color(0xFF95d3bb);
    const surfaceContainerHigh = Color(0xFF272b29);

    return GestureDetector(
      onTap: () => setState(() => _selectedWorkspace = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryForestGreen : AppColors.cardsCarbon,
          border: Border.all(
            color: isSelected ? AppColors.primaryForestGreen : Colors.white12,
          ),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? onPrimaryContainer : AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : surfaceContainerHigh,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                count,
                style: TextStyle(
                  color: isSelected ? AppColors.backgroundObsidian : AppColors.primaryTextOffWhite,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyDogsListView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        _buildDogCard(
          name: 'Murphy',
          breed: 'Golden Retriever · 4 yrs · Male',
          tag: 'Core',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAm6Qjx7r8IjMbUPAoPZtLHLuvG0GSyXyqNYoE-0HvkL8R0uhRqzAJo_IppFqkRZBUCIxwx_3DkTS4wwh3N2HO0mGuLtzrdN0LrtKI6IeWju_DR5KZ5RlBnWoTDSUEt2FYMzjNLNcwt6GWeEOnLyHpsSF0KVQmVQ98Mpd5SIk2NoCP5PUwyYhXrhnZdD80Ah582bGM_kFuz7Z7DQoRmDKYzIqnKSgMYx8MPX4YMiDSzEnfyRyHxdQ',
        ),
        const SizedBox(height: 12),
        _buildDogCard(
          name: 'Bella',
          breed: 'Belgian Malinois · 2 yrs · Female',
          tag: 'Core',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA_FGLheOQECXltZJ7TsUvazbqLiSre1yRRKuQezkUBBZQ72U7xo9pc_zOrINWFZo7mLR2Ml-xjS2Z8_yKiR8etkKnpixjmkyGf5DtZF637KRF0kKrTTdiJ8u__KVQnHJ65-PQgSPDIQh8eLlq1BHg9yEN2POU9Xfc1RSkS8yEXEGlkysd7ZGtZLiWvC9iVPdKV30xIgiL3ooXAxC9Z0iLRQxJkidNmE7oJrDOQA7GdhUFY_apTsHQ',
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildClientDogsListView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        _buildDogCard(
          name: 'Murphy',
          breed: 'Golden Retriever · Olivia Reed',
          tag: 'Client',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAm6Qjx7r8IjMbUPAoPZtLHLuvG0GSyXyqNYoE-0HvkL8R0uhRqzAJo_IppFqkRZBUCIxwx_3DkTS4wwh3N2HO0mGuLtzrdN0LrtKI6IeWju_DR5KZ5RlBnWoTDSUEt2FYMzjNLNcwt6GWeEOnLyHpsSF0KVQmVQ98Mpd5SIk2NoCP5PUwyYhXrhnZdD80Ah582bGM_kFuz7Z7DQoRmDKYzIqnKSgMYx8MPX4YMiDSzEnfyRyHxdQ',
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildDogCard({required String name, required String breed, required String tag, required String imageUrl}) {
    final photoAlignment = _photoAlignments[name] ?? Alignment.center;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DogProfileScreen()),
        );
      },
      child: Container(
        height: 176, // 128px image + 48px text overlap space perfectly matching HTML spec
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 128,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    alignment: photoAlignment,
                    errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF2E312F)),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.backgroundObsidian,
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.8],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Reposition / Crop button for landscape cards
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _repositionDogPhoto(name, imageUrl),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      UlvenikIcon(UlvenikIcons.edit, size: 12, color: AppColors.primaryTextOffWhite),
                      SizedBox(width: 4),
                      Text(
                        'Reposition',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
              bottom: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        breed,
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D8FAF).withValues(alpha: 0.1),
                      border: Border.all(color: const Color(0xFF5D8FAF).withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Color(0xFF5D8FAF),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
