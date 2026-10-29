import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class TrainerProfileScreen extends StatelessWidget {
  const TrainerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const expertiseList = [
      'GUNDOGS',
      'RECALL',
      'LOOSE LEAD',
      'REACTIVITY',
      'PUPPY TRAINING',
      'BEHAVIOUR MODIFICATION',
      'IGP',
    ];

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trainer Profile',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: _offWhite, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile opened.'), backgroundColor: _forest),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Hero Banner Card with Forest Background
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B2A22), Color(0xFF0F1A14)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0x66000000),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.landscape_outlined, color: _stoneGrey, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF14241E),
                            border: Border.all(color: const Color(0xFF34D399), width: 2),
                          ),
                          child: const Icon(Icons.person, color: _mint, size: 32),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Take the Lead Essex',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    'Liv Old',
                                    style: TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0x1F34D399),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0x4D34D399)),
                                    ),
                                    child: const Text(
                                      'TRAINER PACK',
                                      style: TextStyle(
                                        color: Color(0xFF34D399),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Metrics Strip Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  _buildMetric('12', 'Active Clients'),
                  _buildDivider(),
                  _buildMetric('21', 'Client Dogs'),
                  _buildDivider(),
                  _buildMetric('47', 'Sessions'),
                  _buildDivider(),
                  _buildMetric('3 yrs', 'On Ulvenik'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'ABOUT',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // About Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: const Text(
                'Professional dog trainer specialising in gundogs, recall and behaviour modification. Based in Essex, working with dogs of all breeds and abilities since 2021. Committed to force-free, relationship-based training methods that build confidence and reliability in both dog and handler.',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'EXPERTISE',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Expertise Chips Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: expertiseList.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14171A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'QUALIFICATIONS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Qualifications Card
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildQualRow(
                    icon: Icons.military_tech_outlined,
                    title: 'IMDT Member',
                    subtitle: 'Institute of Modern Dog Trainers\nSince 2022',
                    hasCert: true,
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildQualRow(
                    icon: Icons.show_chart,
                    title: 'Canine First Aid',
                    subtitle: 'Canine First Aid UK\nExpires Dec 2025',
                    hasCert: true,
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildQualRow(
                    icon: Icons.shield_outlined,
                    title: 'DBS Checked',
                    subtitle: 'UK Government\n2024',
                    hasCheck: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'SERVICES',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Services Card
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildServiceRow('One-to-One Lessons', 'Tailored to your dog and goals', '60 min'),
                  const Divider(color: _cardBorder, height: 1),
                  _buildServiceRow('Behaviour Consultations', 'In-depth assessment and plan', '90 min'),
                  const Divider(color: _cardBorder, height: 1),
                  _buildServiceRow('Puppy Packages', 'Foundation skills for new puppies', '4 sessions'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'CONTACT',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Contact Card
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildContactRow(
                    Icons.email_outlined,
                    'liv@taketheleadessex.co.uk',
                    false,
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildContactRow(
                    Icons.language_outlined,
                    'taketheleadessex.co.uk',
                    true,
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildContactRow(
                    Icons.camera_alt_outlined,
                    '@taketheleadessex',
                    false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String val, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            val,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 28, color: _cardBorder);
  }

  Widget _buildQualRow({
    required IconData icon,
    required String title,
    required String subtitle,
    bool hasCert = false,
    bool hasCheck = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _stoneGrey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 12, height: 1.3)),
              ],
            ),
          ),
          if (hasCert)
            Row(
              children: const [
                Icon(Icons.description_outlined, color: _mint, size: 13),
                SizedBox(width: 4),
                Text(
                  'Certificate',
                  style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          if (hasCheck)
            const Icon(Icons.check_circle_outline, color: _mint, size: 18),
        ],
      ),
    );
  }

  Widget _buildServiceRow(String title, String desc, String duration) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
              ],
            ),
          ),
          Text(duration, style: const TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, bool isMint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: _stoneGrey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isMint ? _mint : _offWhite,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 13),
        ],
      ),
    );
  }
}
