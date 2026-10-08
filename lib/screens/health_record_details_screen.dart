import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class HealthRecordDetailsScreen extends StatelessWidget {
  const HealthRecordDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Health Record',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.secondaryTextStoneGrey),
            onPressed: () => AppSnackbar.show(context, message: 'Options menu coming soon', type: SnackbarType.info),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle('HEALTH INFORMATION'),
              const SizedBox(height: 12),
              _buildHealthInfoCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('NOTES'),
              const SizedBox(height: 12),
              _buildNotesCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('ATTACHMENTS'),
              const SizedBox(height: 12),
              _buildAttachmentsCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle('RECORD TIMELINE'),
              const SizedBox(height: 12),
              _buildTimelineCard(),
              const SizedBox(height: 24),
              _buildActions(context),
              const SizedBox(height: 48), // Padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.healing_outlined, color: AppColors.secondaryTextStoneGrey, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'INJURY',
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2e6b57).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2e6b57).withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF95d3bb),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Color(0xFF95d3bb),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Left Paw Laceration',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.secondaryTextStoneGrey, size: 14),
              const SizedBox(width: 4),
              const Text(
                '28 Jan 2025',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.location_on_outlined, color: AppColors.secondaryTextStoneGrey, size: 14),
              const SizedBox(width: 4),
              const Text(
                'Training Ground',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Last updated today',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              InkWell(
                onTap: () => AppSnackbar.show(context, message: 'Edit record coming soon', type: SnackbarType.info),
                child: Row(
                  children: [
                    const Icon(Icons.edit_outlined, color: Color(0xFF95d3bb), size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Edit Record',
                      style: TextStyle(color: Color(0xFF95d3bb), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              InkWell(
                onTap: () => AppSnackbar.show(context, message: 'Update status coming soon', type: SnackbarType.info),
                child: Row(
                  children: [
                    const Icon(Icons.update_outlined, color: Color(0xFF95d3bb), size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Update Status',
                      style: TextStyle(color: Color(0xFF95d3bb), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.pets_outlined,
            title: 'Affected Area',
            value: 'Left front paw',
          ),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow(
            icon: Icons.warning_amber_rounded,
            title: 'Severity',
            value: 'Moderate',
          ),
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.list_alt_outlined, color: AppColors.secondaryTextStoneGrey, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Symptoms',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildSymptomChip('Limping'),
                          _buildSymptomChip('Bleeding'),
                          _buildSymptomChip('Swelling'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow(
            icon: Icons.monitor_heart_outlined,
            title: 'Recovery Status',
            value: 'Ongoing - Week 2',
          ),
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.local_hospital_outlined, color: AppColors.secondaryTextStoneGrey, size: 20),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Veterinarian',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Not recorded',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondaryTextStoneGrey, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Koda caught paw on fence post during agility run. Cleaned with saline and applied sterile bandage. Keeping him off it for 3 days minimum. Monitored for signs of infection. Swelling seems to be going down today.',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite, // Text matches on-surface-variant in html, adjusting to offwhite for better read
          fontSize: 15,
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildAttachmentsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF1d201f),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.photo_camera_outlined, color: AppColors.secondaryTextStoneGrey),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Attachments',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No photos, videos or documents\nlinked to this record.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => AppSnackbar.show(context, message: 'Add attachment coming soon', type: SnackbarType.info),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Color(0xFF95d3bb), size: 18),
                const SizedBox(width: 4),
                const Text(
                  'Add Attachment',
                  style: TextStyle(color: Color(0xFF95d3bb), fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8), // Provide room for line
        child: Column(
          children: [
            _buildTimelineItem(
              title: 'Notes Updated',
              time: 'Today, 09:41 AM',
              dotColor: const Color(0xFF95d3bb),
              isFirst: true,
              isLast: false,
            ),
            _buildTimelineItem(
              title: 'Status Updated',
              time: '29 Jan 2025, 14:20 PM',
              dotColor: const Color(0xFFb6ccb5),
              isFirst: false,
              isLast: false,
            ),
            _buildTimelineItem(
              title: 'Record Created',
              time: '28 Jan 2025, 16:30 PM',
              dotColor: const Color(0xFFb6ccb5),
              isFirst: false,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String time,
    required Color dotColor,
    required bool isFirst,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Line
                if (!isFirst)
                  Positioned(
                    top: 0,
                    bottom: 24, // stop at center
                    child: Container(width: 1, color: Colors.white12),
                  ),
                if (!isLast)
                  Positioned(
                    top: 24, // start at center
                    bottom: 0,
                    child: Container(width: 1, color: Colors.white12),
                  ),
                // Dot
                Positioned(
                  top: 18,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cardsCarbon, width: 3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => AppSnackbar.show(context, message: 'Edit record coming soon', type: SnackbarType.info),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2e6b57),
            foregroundColor: const Color(0xFFaae9d0),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
            minimumSize: const Size(double.infinity, 48),
          ),
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text(
            'Edit Record',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => AppSnackbar.show(context, message: 'Delete record coming soon', type: SnackbarType.error),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF8B3A3A),
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text(
            'Delete Record',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
