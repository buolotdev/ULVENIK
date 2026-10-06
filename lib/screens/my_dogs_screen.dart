import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'dogs_all_workspaces_screen.dart';
import 'dog_profile_screen.dart';
import 'homepage_screen.dart';

class MyDogsScreen extends StatefulWidget {
  const MyDogsScreen({super.key});

  @override
  State<MyDogsScreen> createState() => _MyDogsScreenState();
}

class _MyDogsScreenState extends State<MyDogsScreen> {
  // Toggle this to test Empty vs Populated states!
  bool _hasData = true;

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
                      // "My Dogs (6)" Pill
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onDoubleTap: () => setState(() => _hasData = !_hasData),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryForestGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'My Dogs (6)',
                              style: TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: 100),
                          children: [
                            _buildDogCard(
                              name: 'Murphy',
                              details: 'Golden Retriever · 4y · M',
                              activity: 'OBEDIENCE · 2H AGO',
                              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAm6Qjx7r8IjMbUPAoPZtLHLuvG0GSyXyqNYoE-0HvkL8R0uhRqzAJo_IppFqkRZBUCIxwx_3DkTS4wwh3N2HO0mGuLtzrdN0LrtKI6IeWju_DR5KZ5RlBnWoTDSUEt2FYMzjNLNcwt6GWeEOnLyHpsSF0KVQmVQ98Mpd5SIk2NoCP5PUwyYhXrhnZdD80Ah582bGM_kFuz7Z7DQoRmDKYzIqnKSgMYx8MPX4YMiDSzEnfyRyHxdQ',
                            ),
                            const SizedBox(height: 12),
                            _buildDogCard(
                              name: 'Bella',
                              details: 'Belgian Malinois · 2y · F',
                              activity: 'AGILITY · YESTERDAY',
                              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA_FGLheOQECXltZJ7TsUvazbqLiSre1yRRKuQezkUBBZQ72U7xo9pc_zOrINWFZo7mLR2Ml-xjS2Z8_yKiR8etkKnpixjmkyGf5DtZF637KRF0kKrTTdiJ8u__KVQnHJ65-PQgSPDIQh8eLlq1BHg9yEN2POU9Xfc1RSkS8yEXEGlkysd7ZGtZLiWvC9iVPdKV30xIgiL3ooXAxC9Z0iLRQxJkidNmE7oJrDOQA7GdhUFY_apTsHQ',
                            ),
                            const SizedBox(height: 12),
                            _buildDogCard(
                              name: 'Monty',
                              details: 'Mixed Breed · 1y · M',
                              activity: 'NO ACTIVITY YET',
                            ),
                            const SizedBox(height: 12),
                            _buildDogCard(
                              name: 'Luna',
                              details: 'Border Collie · 5y · F',
                              activity: 'HERDING · 3 DAYS AGO',
                              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD-dBzJ3N-iY9n3LL7Zjg-9n9zNG8t0rH2uPeaa4gsfQeqLIyVQ9EfpR71y6T19BFQFcx2pR9R0b-D2q9nV9zEk-1GGDSB3MyGVoEfUgINo-TBo_H7kxre8TJ3nJtnamMVrZHYDCh3yFMH9hhETUUce8CvddXDdjljTpk4DRmnO7MPoXouW9jaMcJZiL9iR3sPBW056jR8HpE4xVtatKp4IOVIwTtw0dPKosa_kZxvey903ZD03YVA',
                            ),
                            const SizedBox(height: 12),
                            _buildDogCard(
                              name: 'Axel',
                              details: 'Dutch Shepherd · 3y · M',
                              activity: 'TRACKING · 1W AGO',
                              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDvoTz5a9TC8u0P6-Md-scQcGedKfr4MXS6Ie8LAbxJyqbiVSDXuswe5WMfqrcXgK1s_YinkrDcT3cJA9UGsimRU0FgiHrxtMc0wZsYzNUajf_uPPHrYen5iRNaMD4_V7SkMj-abO0YqW5ydXjqfTvaWiimGC222XSr8xkdo8-ZRh9wtLIghLjSVf6OlVKj43jAkmQ98l9R9zgAoO7JzPugZGsSnyF6j8IkQjXebvcBQa3Th9WsTbE',
                            ),
                            const SizedBox(height: 12),
                            _buildDogCard(
                              name: 'Nova',
                              details: 'German Shepherd · 6mo · F',
                              activity: 'PUPPY FOUNDATIONS',
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
                            const Icon(
                              Icons.pets,
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
                              'Add your first dog to begin recording its\njourney with Ulvenik.',
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
                              icon: const Icon(Icons.add, size: 20),
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
        child: const Icon(Icons.add, color: AppColors.primaryTextOffWhite),
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
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.primaryTextOffWhite),
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
          const Icon(
            Icons.search,
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
        child: Icon(
          icon,
          color: isPrimary ? AppColors.primaryTextOffWhite : AppColors.primaryTextOffWhite,
          size: 20,
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
                          errorBuilder: (_, __, ___) => _buildDogPlaceholder(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                AppColors.cardsCarbon.withOpacity(0.8),
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
                        const Icon(
                          Icons.schedule,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          activity,
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
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
        child: Icon(
          Icons.pets,
          color: AppColors.secondaryTextStoneGrey,
          size: 40,
        ),
      ),
    );
  }

}
