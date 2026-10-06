import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'dog_profile_screen.dart';
import '../widgets/custom_snackbar.dart';

class DogsAllWorkspacesScreen extends StatefulWidget {
  const DogsAllWorkspacesScreen({super.key});

  @override
  State<DogsAllWorkspacesScreen> createState() => _DogsAllWorkspacesScreenState();
}

class _DogsAllWorkspacesScreenState extends State<DogsAllWorkspacesScreen> {
  int _selectedWorkspace = 1; // 0: My Dogs, 1: Sport Dogs, 2: Client Dogs

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
              child: ListView(
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
        onPressed: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info),
        backgroundColor: AppColors.primaryForestGreen,
        child: const Icon(Icons.add, color: AppColors.primaryTextOffWhite),
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
          style: TextStyle(
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildWorkspacePill(0, 'My Dogs', '6'),
            const SizedBox(width: 8),
            _buildWorkspacePill(1, 'Sport Dogs', '3'),
            const SizedBox(width: 8),
            _buildWorkspacePill(2, 'Client Dogs', '18'),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspacePill(int index, String title, String count) {
    final isSelected = _selectedWorkspace == index;
    
    // Extracted tailored colors matching the HTML spec
    final onPrimaryContainer = const Color(0xFFaae9d0);
    final primaryColor = const Color(0xFF95d3bb);
    final surfaceContainerHigh = const Color(0xFF272b29);

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

  Widget _buildDogCard({required String name, required String breed, required String tag, required String imageUrl}) {
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
                    color: const Color(0xFF5D8FAF).withOpacity(0.1),
                    border: Border.all(color: const Color(0xFF5D8FAF).withOpacity(0.3)),
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
    ));
  }
}
