import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'dogs_all_workspaces_screen.dart';
import 'dog_profile_screen.dart';

class MyDogsScreen extends StatefulWidget {
  const MyDogsScreen({super.key});

  @override
  State<MyDogsScreen> createState() => _MyDogsScreenState();
}

class _MyDogsScreenState extends State<MyDogsScreen> {
  // Toggle this to test Empty vs Populated states!
  bool _hasData = true;
  int _selectedWorkspace = 0; // 0: My Dogs (Core), 1: Sport Dogs (Sport Pack), 2: Client Dogs (Trainer Pack)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    
                    if (_hasData) ...[
                      // Workspace Pills (Linked to Subscriptions: Core, Sport Pack, Trainer Pack)
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
                      const SizedBox(height: 16),
                      
                      // Search & Actions Row
                      Row(
                        children: [
                          Expanded(child: _buildSearchBar()),
                          const SizedBox(width: 12),
                          _buildIconButton(Icons.tune, onTap: () {
                            AppSnackbar.show(context, message: 'Filter coming soon', type: SnackbarType.info);
                          }),
                          const SizedBox(width: 12),
                          _buildIconButton(Icons.add, isPrimary: true, onTap: () {
                            AppSnackbar.show(context, message: 'Add dog coming soon', type: SnackbarType.info);
                          }),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Populated List
                      Expanded(
                        child: _selectedWorkspace == 1
                            ? _buildSportDogsList()
                            : _selectedWorkspace == 2
                                ? _buildClientDogsList()
                                : ListView(
                                    padding: const EdgeInsets.only(bottom: 100),
                                    children: [
                                      _buildDogCard(
                                        name: 'Murphy',
                                        details: 'Golden Retriever · 4 yrs · Male',
                                        activity: 'Obedience · 2 hrs ago',
                                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAm6Qjx7r8IjMbUPAoPZtLHLuvG0GSyXyqNYoE-0HvkL8R0uhRqzAJo_IppFqkRZBUCIxwx_3DkTS4wwh3N2HO0mGuLtzrdN0LrtKI6IeWju_DR5KZ5RlBnWoTDSUEt2FYMzjNLNcwt6GWeEOnLyHpsSF0KVQmVQ98Mpd5SIk2NoCP5PUwyYhXrhnZdD80Ah582bGM_kFuz7Z7DQoRmDKYzIqnKSgMYx8MPX4YMiDSzEnfyRyHxdQ',
                                      ),
                                      const SizedBox(height: 12),
                                      _buildDogCard(
                                        name: 'Bella',
                                        details: 'Belgian Malinois · 2 yrs · Female',
                                        activity: 'Agility · Yesterday',
                                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA_FGLheOQECXltZJ7TsUvazbqLiSre1yRRKuQezkUBBZQ72U7xo9pc_zOrINWFZo7mLR2Ml-xjS2Z8_yKiR8etkKnpixjmkyGf5DtZF637KRF0kKrTTdiJ8u__KVQnHJ65-PQgSPDIQh8eLlq1BHg9yEN2POU9Xfc1RSkS8yEXEGlkysd7ZGtZLiWvC9iVPdKV30xIgiL3ooXAxC9Z0iLRQxJkidNmE7oJrDOQA7GdhUFY_apTsHQ',
                                      ),
                                      const SizedBox(height: 12),
                                      _buildDogCard(
                                        name: 'Monty',
                                        details: 'Mixed Breed · 1 yr · Male',
                                        activity: 'No activity yet',
                                      ),
                                      const SizedBox(height: 12),
                                      _buildDogCard(
                                        name: 'Luna',
                                        details: 'Border Collie · 5 yrs · Female',
                                        activity: 'Herding · 3 days ago',
                                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD-dBzJ3N-iY9n3LL7Zjg-9n9zNG8t0rH2uPeaa4gsfQeqLIyVQ9EfpR71y6T19BFQFcx2pR9R0b-D2q9nV9zEk-1GGDSB3MyGVoEfUgINo-TBo_H7kxre8TJ3nJtnamMVrZHYDCh3yFMH9hhETUUce8CvddXDdjljTpk4DRmnO7MPoXouW9jaMcJZiL9iR3sPBW056jR8HpE4xVtatKp4IOVIwTtw0dPKosa_kZxvey903ZD03YVA',
                                      ),
                                      const SizedBox(height: 12),
                                      _buildDogCard(
                                        name: 'Axel',
                                        details: 'Dutch Shepherd · 3 yrs · Male',
                                        activity: 'Tracking · 1 week ago',
                                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDvoTz5a9TC8u0P6-Md-scQcGedKfr4MXS6Ie8LAbxJyqbiVSDXuswe5WMfqrcXgK1s_YinkrDcT3cJA9UGsimRU0FgiHrxtMc0wZsYzNUajf_uPPHrYen5iRNaMD4_V7SkMj-abO0YqW5ydXjqfTvaWiimGC222XSr8xkdo8-ZRh9wtLIghLjSVf6OlVKj43jAkmQ98l9R9zgAoO7JzPugZGsSnyF6j8IkQjXebvcBQa3Th9WsTbE',
                                      ),
                                      const SizedBox(height: 12),
                                      _buildDogCard(
                                        name: 'Nova',
                                        details: 'German Shepherd · 6 mos · Female',
                                        activity: 'No activity yet',
                                      ),
                                    ],
                                  ),
                      ),
                    ] else ...[
                      // Search Row (Empty State)
                      GestureDetector(
                        onDoubleTap: () => setState(() => _hasData = !_hasData),
                        child: _buildSearchBar(),
                      ),
                      
                      // Empty State Content
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const UlvenikIcon(UlvenikIcons.dogs,
                              size: 48,
                              color: AppColors.secondarySage, // Light green paw
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'No dogs added yet',
                              style: TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Add your first dog to start recording their\njourney with Ulvenik.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () {
                                AppSnackbar.show(context, message: 'Add dog coming soon', type: SnackbarType.info);
                              },
                              icon: const UlvenikIcon(UlvenikIcons.add, size: 20),
                              label: const Text('Add Dog'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryForestGreen,
                                foregroundColor: AppColors.primaryTextOffWhite,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                            const SizedBox(height: 80), // offset for visual center
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppSnackbar.show(context, message: 'Add dog coming soon', type: SnackbarType.info);
        },
        backgroundColor: AppColors.primaryForestGreen,
        child: const UlvenikIcon(UlvenikIcons.add, color: AppColors.primaryTextOffWhite),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dogs',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.grid_view_rounded, color: AppColors.primaryTextOffWhite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DogsAllWorkspacesScreen(),
                    ),
                  );
                },
              ),
              if (_hasData)
                IconButton(
                  icon: const UlvenikIcon(UlvenikIcons.notifications, color: AppColors.primaryTextOffWhite),
                  onPressed: () {
                    AppSnackbar.show(context, message: 'Notifications coming soon', type: SnackbarType.info);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Search & Actions ────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.search,
            color: AppColors.secondaryTextStoneGrey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search dogs...',
                  hintStyle: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {bool isPrimary = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryForestGreen : AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isPrimary ? AppColors.primaryForestGreen : Colors.white12),
        ),
        child: UlvenikIcon.fromMaterial(
          icon,
          color: isPrimary ? AppColors.primaryTextOffWhite : AppColors.primaryTextOffWhite,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildWorkspacePill(int index, String title, String count, String subscriptionPack) {
    final isSelected = _selectedWorkspace == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedWorkspace = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryForestGreen : AppColors.cardsCarbon,
          border: Border.all(
            color: isSelected ? AppColors.primaryForestGreen : Colors.white12,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFFaae9d0) : AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF95d3bb) : const Color(0xFF272b29),
                borderRadius: BorderRadius.circular(10),
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

  Widget _buildSportDogsList() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        _buildSportDogCard(
          name: 'Murphy',
          breed: 'Belgian Malinois',
          tag: 'IGP',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCCHELrb1zJHxkzvLEcxc5HvIeblV8UqHIBdjT76A_6WiS7ACVJ8wyXhCuRGxZtDdmN-JgvEd9uu4WXCfbHMsH-ksGCxhXA_HSfDFN_V4mUIMU27LdUD2yvii3f4QbZ7AbSPbm1rNUrG-vFPgCB7t11yX4sDO24c8B615vQv6r27CXNpjn7yLJkHf2IbPmze0G4sIBhms3uObq8Fls9KVvr6PmsS78d2O8bsKacSjOvNsLGkPhoLhI',
        ),
        const SizedBox(height: 12),
        _buildSportDogCard(
          name: 'Rex',
          breed: 'German Shepherd',
          tag: 'IPO',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCHv0YwualhgVN8mZm71eYVCiefQjhLohQXvrajAJ2M5WeFJ1ZXvUkS4sE-61zydWeyqo98aMfnZ7OPklTsLqWODP4KAeinU4BpCIaEJPj2phE7Db1D_bcOSXYVcTrDMttNMfRvCeyiKI4FNLGeVxM1Aeg2nPbRTmedNZD7DIqSey3Mtwr3Z7RFmrYCVIQkw6waLI_5VIvF4hOQcqj8pgn3hy8_p-_-HKyS8kZe4EZUcVWsrndz_TY',
        ),
        const SizedBox(height: 12),
        _buildSportDogCard(
          name: 'Koda',
          breed: 'Dutch Shepherd',
          tag: 'Agility',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAFKOO8gb4AWaLg2qLsOdAQTzB6SsCO_QKNqK2eJLTRocSldxOEHALJ8tI9kAqM8ovNBIcPR5h4OVyx0MVW69rlcHCAHDJ8S_S8h2Na2cSVAoXBhMdes4q9GK_Uu_j6kmM_9IBq7Re2k3DIkQz3W0hjLlYDhUC-dJ1cyLwqSc3koHhLeATfkYApJXTGBflU--BJY-uskJ1QD1Vqo-yjQ7_jWWUPV8NPFe_mrxbEGwMdaW1QZn_6F5o',
        ),
      ],
    );
  }

  Widget _buildClientDogsList() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        _buildDogCard(
          name: 'Murphy',
          details: 'Golden Retriever · 4 yrs · Male',
          activity: 'Client: Olivia Reed · Session Tomorrow',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAm6Qjx7r8IjMbUPAoPZtLHLuvG0GSyXyqNYoE-0HvkL8R0uhRqzAJo_IppFqkRZBUCIxwx_3DkTS4wwh3N2HO0mGuLtzrdN0LrtKI6IeWju_DR5KZ5RlBnWoTDSUEt2FYMzjNLNcwt6GWeEOnLyHpsSF0KVQmVQ98Mpd5SIk2NoCP5PUwyYhXrhnZdD80Ah582bGM_kFuz7Z7DQoRmDKYzIqnKSgMYx8MPX4YMiDSzEnfyRyHxdQ',
        ),
      ],
    );
  }

  Widget _buildSportDogCard({required String name, required String breed, required String tag, required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DogProfileScreen()),
        );
      },
      child: Container(
        height: 176,
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

  // ── Dog Card ────────────────────────────────────────────────────────────
  Widget _buildDogCard({
    required String name,
    required String details,
    required String activity,
    String? imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DogProfileScreen()),
        );
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Row(
          children: [
            // Image / Placeholder
            SizedBox(
              width: 100,
              height: double.infinity,
              child: imageUrl != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildDogPlaceholder(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                AppColors.cardsCarbon.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : _buildDogPlaceholder(),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details,
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const UlvenikIcon(UlvenikIcons.trainingTime,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          activity,
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildDogPlaceholder() {
    return Container(
      color: const Color(0xFF2E312F), // inverse-on-surface roughly
      child: const Center(
        child: UlvenikIcon(UlvenikIcons.dogs,
          color: AppColors.secondaryTextStoneGrey,
          size: 40,
        ),
      ),
    );
  }

}
