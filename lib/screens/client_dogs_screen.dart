import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'client_dog_profile_screen.dart';
import 'trainer_dashboard_screen.dart';

class ClientDogsScreen extends StatefulWidget {
  final String? clientId;

  const ClientDogsScreen({
    super.key,
    this.clientId,
  });

  @override
  State<ClientDogsScreen> createState() => _ClientDogsScreenState();
}

class _ClientDogsScreenState extends State<ClientDogsScreen> {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _cardBg = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _greenAccent = Color(0xFF479A7B);
  static const Color _mintBright = Color(0xFFB1F0D6);
  static const Color _sage = AppColors.secondarySage; // #7A8F7A
  static const Color _textPrimary = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _textSecondary = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _border = AppColors.cardBorder;

  void _openDogDetails(TrainerClient client, TrainerClientDog dog) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientDogProfileScreen(
          clientId: client.id,
          dogId: dog.id,
        ),
      ),
    );
  }

  void _showAddDogSheet(TrainerClient client) {
    final nameCtrl = TextEditingController();
    final breedCtrl = TextEditingController();
    final ageCtrl = TextEditingController();

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
            MediaQuery.of(ctx).viewInsets.bottom + 24,
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
                'Add Client Dog',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: _textPrimary, fontSize: 13.5),
                decoration: InputDecoration(
                  labelText: 'Dog Name',
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
                controller: breedCtrl,
                style: const TextStyle(color: _textPrimary, fontSize: 13.5),
                decoration: InputDecoration(
                  labelText: 'Breed',
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
                controller: ageCtrl,
                style: const TextStyle(color: _textPrimary, fontSize: 13.5),
                decoration: InputDecoration(
                  labelText: 'Age / Life Stage',
                  labelStyle: const TextStyle(color: _textSecondary, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF21272A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _border),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isNotEmpty) {
                      final newDog = TrainerClientDog(
                        id: 'd_${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        breed: breedCtrl.text.trim().isEmpty
                            ? 'Crossbreed'
                            : breedCtrl.text.trim(),
                        ageLabel: ageCtrl.text.trim().isEmpty
                            ? 'Adult'
                            : ageCtrl.text.trim(),
                        status: 'Active',
                      );
                      final updatedList = List<TrainerClientDog>.from(client.dogs)..add(newDog);
                      TrainerPackStore.updateClient(client.copyWith(dogs: updatedList));
                      Navigator.pop(ctx);
                      AppSnackbar.show(
                        context,
                        title: 'Dog Added',
                        message: '$name linked to ${client.fullName}.',
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
                  child: const Text('Add Dog'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar: const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      floatingActionButton: ValueListenableBuilder<List<TrainerClient>>(
        valueListenable: TrainerPackStore.clientsNotifier,
        builder: (context, _, _) {
          final client = TrainerPackStore.findClient(widget.clientId);
          return FloatingActionButton(
            backgroundColor: _forest,
            foregroundColor: _textPrimary,
            elevation: 4,
            shape: const CircleBorder(),
            onPressed: () => _showAddDogSheet(client),
            child: const Icon(Icons.add, size: 26),
          );
        },
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<TrainerClient>>(
          valueListenable: TrainerPackStore.clientsNotifier,
          builder: (context, _, _) {
            final client = TrainerPackStore.findClient(widget.clientId);
            final titleName = '${client.firstName}\'s Dogs';

            // Curated dogs for client matching spec
            final dogs = client.dogs.isNotEmpty
                ? client.dogs
                : [
                    const TrainerClientDog(
                      id: 'd_murphy',
                      name: 'Murphy',
                      breed: 'Golden Retriever',
                      ageLabel: '3 Years',
                      focusArea: 'IGP',
                      activeGoals: 2,
                    ),
                    const TrainerClientDog(
                      id: 'd_bella',
                      name: 'Bella',
                      breed: 'Border Collie',
                      ageLabel: '5 Years',
                      focusArea: 'Agility',
                      activeGoals: 1,
                    ),
                  ];

            return Column(
              children: [
                _buildTopBar(titleName, client),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
                    children: [
                      _buildHeaderRow(dogs.length),
                      const SizedBox(height: 14),
                      ...dogs.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final dog = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildDogCard(client, dog, idx),
                        );
                      }),
                      const SizedBox(height: 4),
                      _buildHomeworkAlertCard(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(String title, TrainerClient client) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(bottom: BorderSide(color: _border, width: 1)),
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
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
                fontFamily: 'Inter',
              ),
            ),
          ),
          IconButton(
            tooltip: 'Add Dog',
            visualDensity: VisualDensity.compact,
            onPressed: () => _showAddDogSheet(client),
            icon: const Icon(
              Icons.add_rounded,
              color: _textSecondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$count ${count == 1 ? 'Dog' : 'Dogs'}',
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        const Text(
          'ACTIVE IN WORKSPACE',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildDogCard(TrainerClient client, TrainerClientDog dog, int index) {
    final isMurphy = dog.name.toLowerCase().contains('murphy') || index == 0;
    final ageText = isMurphy ? '3 Years' : '5 Years';
    final streakText = isMurphy ? '12 Day Streak' : '15 Day Streak';
    final lastActivity = isMurphy ? 'Yesterday' : '2 days ago';
    final goalsText = isMurphy ? '2 Goals' : '1 Goal';
    final hasSportBadge = isMurphy;

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dog image banner (without predefined classifications like Primary Athlete or Agility Focus)
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ScenicDogForestPainter(isPrimary: isMurphy),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dog.name,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242B28),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: _border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: _greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            ageText,
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      dog.breed,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (hasSportBadge) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF222927),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _forest.withValues(alpha: 0.4)),
                        ),
                        child: const Text(
                          'IGP',
                          style: TextStyle(
                            color: _mintBright,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.flash_on_rounded, color: _greenAccent, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      streakText,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('•', style: TextStyle(color: _textSecondary, fontSize: 12)),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time_rounded, color: _sage, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      lastActivity,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('•', style: TextStyle(color: _textSecondary, fontSize: 12)),
                    const SizedBox(width: 10),
                    const Icon(Icons.flag_outlined, color: _sage, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      goalsText,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => _openDogDetails(client, dog),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22282B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'SHARED WITH OWNER',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: _textSecondary,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkAlertCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2320),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _forest.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: _greenAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Homework overdue — Murphy',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const Text(
            'Check →',
            style: TextStyle(
              color: _mintBright,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenicDogForestPainter extends CustomPainter {
  final bool isPrimary;
  const _ScenicDogForestPainter({required this.isPrimary});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isPrimary
            ? const [Color(0xFF2C3E37), Color(0xFF141917)]
            : const [Color(0xFF22303A), Color(0xFF12161A)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Forest mist silhouettes
    final hillPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.55);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.35,
      size.width * 0.65,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.75,
      size.width,
      size.height * 0.5,
    );
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, hillPaint);
  }

  @override
  bool shouldRepaint(covariant _ScenicDogForestPainter oldDelegate) =>
      oldDelegate.isPrimary != isPrimary;
}

