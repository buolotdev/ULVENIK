import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class HealthRecordDetailsScreen extends StatefulWidget {
  final String recordType; // 'injury' or 'medication'
  final String recoveryStatus; // 'ONGOING', 'RESOLVED', etc.
  final String medicationStatus; // 'Active', 'Completed', 'Discontinued'
  final bool isOngoingEndDate;

  const HealthRecordDetailsScreen({
    super.key,
    this.recordType = 'injury',
    this.recoveryStatus = 'ONGOING',
    this.medicationStatus = 'Active',
    this.isOngoingEndDate = true,
  });

  @override
  State<HealthRecordDetailsScreen> createState() => _HealthRecordDetailsScreenState();
}

class _HealthRecordDetailsScreenState extends State<HealthRecordDetailsScreen> {
  late String _activeType;

  @override
  void initState() {
    super.initState();
    _activeType = widget.recordType.toLowerCase();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.cardsCarbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Record?',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: Text(
          _activeType == 'medication'
              ? 'Are you sure you want to delete this medication record? All doses, reminders and history will be permanently deleted.'
              : 'Are you sure you want to delete this health record? All updates and timeline history will be permanently deleted.',
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final nav = Navigator.of(context);
              Navigator.of(dialogCtx).pop();
              AppSnackbar.show(context, message: 'Record deleted successfully', type: SnackbarType.success);
              nav.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B3A3A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMed = _activeType == 'medication';

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        leading: IconButton(
          icon: const UlvenikIcon(UlvenikIcons.back, color: AppColors.secondaryTextStoneGrey),
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
          PopupMenuButton<String>(
            icon: const UlvenikIcon(UlvenikIcons.overflowMenu, color: AppColors.secondaryTextStoneGrey),
            color: AppColors.cardsCarbon,
            onSelected: (val) {
              if (val == 'switch') {
                setState(() {
                  _activeType = isMed ? 'injury' : 'medication';
                });
              } else if (val == 'delete') {
                _confirmDelete();
              } else {
                AppSnackbar.show(context, message: 'Option selected', type: SnackbarType.info);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'switch',
                child: Text(
                  isMed ? 'View Injury Record (Image 4)' : 'View Medication Record (Image 5)',
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13),
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete Record',
                  style: TextStyle(color: Color(0xFFE57373), fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isMed) ...[
                _buildMedicationSummaryCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('HEALTH INFORMATION'),
                const SizedBox(height: 12),
                _buildMedicationHealthInfoCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('NOTES'),
                const SizedBox(height: 12),
                _buildMedicationNotesCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('ATTACHMENTS'),
                const SizedBox(height: 12),
                _buildMedicationAttachmentsCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('REMINDERS'),
                const SizedBox(height: 12),
                _buildRemindersCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('RECORD TIMELINE'),
                const SizedBox(height: 12),
                _buildMedicationTimelineCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('LINKED RECORDS'),
                const SizedBox(height: 12),
                _buildLinkedRecordsCard(),
                const SizedBox(height: 24),
                _buildActions(),
                const SizedBox(height: 48),
              ] else ...[
                _buildInjurySummaryCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('HEALTH INFORMATION'),
                const SizedBox(height: 12),
                _buildInjuryHealthInfoCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('NOTES'),
                const SizedBox(height: 12),
                _buildInjuryNotesCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('ATTACHMENTS'),
                const SizedBox(height: 12),
                _buildInjuryAttachmentsCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('RECORD TIMELINE'),
                const SizedBox(height: 12),
                _buildInjuryTimelineCard(),
                const SizedBox(height: 24),
                _buildActions(),
                const SizedBox(height: 48),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
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

  // ==========================================
  // INJURY VIEW (Image 4)
  // Single status system: recovery status ONGOING
  // ==========================================

  Widget _buildInjurySummaryCard() {
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
              const Row(
                children: [
                  UlvenikIcon(UlvenikIcons.health, color: AppColors.secondaryTextStoneGrey, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'INJURY',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
              // Single status system: The badge at top reflects current Recovery Status (e.g. 'ONGOING')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2e6b57).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2e6b57).withValues(alpha: 0.5)),
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
                    Text(
                      widget.recoveryStatus,
                      style: const TextStyle(
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
          const Row(
            children: [
              UlvenikIcon(UlvenikIcons.calendar, color: AppColors.secondaryTextStoneGrey, size: 14),
              SizedBox(width: 4),
              Text(
                '28 Jan 2025',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
              ),
              SizedBox(width: 16),
              UlvenikIcon(UlvenikIcons.timeline, color: AppColors.secondaryTextStoneGrey, size: 14),
              SizedBox(width: 4),
              Text(
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
                child: const Row(
                  children: [
                    UlvenikIcon(UlvenikIcons.edit, color: Color(0xFF95d3bb), size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Edit Record',
                      style: TextStyle(color: Color(0xFF95d3bb), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              InkWell(
                onTap: () => AppSnackbar.show(context, message: 'Update status coming soon', type: SnackbarType.info),
                child: const Row(
                  children: [
                    UlvenikIcon(UlvenikIcons.history, color: Color(0xFF95d3bb), size: 16),
                    SizedBox(width: 4),
                    Text(
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

  Widget _buildInjuryHealthInfoCard() {
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
                const UlvenikIcon(UlvenikIcons.training, color: AppColors.secondaryTextStoneGrey, size: 20),
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
                          _buildChip('Limping'),
                          _buildChip('Bleeding'),
                          _buildChip('Swelling'),
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UlvenikIcon(UlvenikIcons.health, color: AppColors.secondaryTextStoneGrey, size: 20),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

  Widget _buildInjuryNotesCard() {
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
          color: AppColors.primaryTextOffWhite,
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildInjuryAttachmentsCard() {
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
            child: const UlvenikIcon(UlvenikIcons.play, color: AppColors.secondaryTextStoneGrey),
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                UlvenikIcon(UlvenikIcons.add, color: Color(0xFF95d3bb), size: 18),
                SizedBox(width: 4),
                Text(
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

  Widget _buildInjuryTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
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

  // ==========================================
  // MEDICATION VIEW (Image 5)
  // Medication-specific statuses, 'End Date — Ongoing',
  // and Linked Records section
  // ==========================================

  Widget _buildMedicationSummaryCard() {
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
              const Row(
                children: [
                  UlvenikIcon(UlvenikIcons.health, color: AppColors.secondaryTextStoneGrey, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'MEDICATION',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
              // Medication-specific status (Active, Completed, Discontinued)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2e6b57).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2e6b57).withValues(alpha: 0.5)),
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
                    Text(
                      widget.medicationStatus.toUpperCase(),
                      style: const TextStyle(
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
            'Metacam 1.5mg — Daily',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              UlvenikIcon(UlvenikIcons.calendar, color: AppColors.secondaryTextStoneGrey, size: 14),
              SizedBox(width: 4),
              Text(
                '01 Feb 2025',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
              ),
              SizedBox(width: 16),
              UlvenikIcon(UlvenikIcons.trainingTime, color: AppColors.secondaryTextStoneGrey, size: 14),
              SizedBox(width: 4),
              Text(
                '08:00 AM',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Last updated 3 days ago',
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
                child: const Row(
                  children: [
                    UlvenikIcon(UlvenikIcons.edit, color: Color(0xFF95d3bb), size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Edit Record',
                      style: TextStyle(color: Color(0xFF95d3bb), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              InkWell(
                onTap: () => AppSnackbar.show(context, message: 'Update status coming soon', type: SnackbarType.info),
                child: const Row(
                  children: [
                    UlvenikIcon(UlvenikIcons.history, color: Color(0xFF95d3bb), size: 16),
                    SizedBox(width: 4),
                    Text(
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

  Widget _buildMedicationHealthInfoCard() {
    // User requested: change 'End Date — Not set' to 'End Date — Ongoing' where medication is currently active with no end date.
    final String endDateDisplay = widget.isOngoingEndDate ? 'Ongoing' : 'Not set';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.medication_outlined,
            title: 'Medication Name',
            value: 'Metacam',
          ),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow(
            icon: Icons.science_outlined,
            title: 'Dosage',
            value: '1.5mg',
          ),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow(
            icon: Icons.repeat_outlined,
            title: 'Frequency',
            value: 'Once daily',
          ),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow(
            icon: Icons.event_available_outlined,
            title: 'Start Date',
            value: '01 Feb 2025',
          ),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow(
            icon: Icons.event_busy_outlined,
            title: 'End Date',
            value: endDateDisplay,
          ),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow(
            icon: Icons.person_outline,
            title: 'Veterinarian',
            value: 'Dr. Sarah Holt',
          ),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow(
            icon: Icons.info_outline,
            title: 'Instructions',
            value: 'Administer with food to prevent GI upset.',
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationNotesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Started Metacam following soft tissue inflammation diagnosis in left shoulder. Dog is responding well, showing increased mobility after 2 days of treatment. Will monitor for any gastrointestinal side effects.',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildMedicationAttachmentsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 56,
                  height: 56,
                  color: AppColors.backgroundObsidian,
                  child: const UlvenikIcon(UlvenikIcons.training, color: Color(0xFFE57373), size: 28),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prescription_Metacam_Feb2025.pdf',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '1.2 MB · Uploaded 01 Feb 2025',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const UlvenikIcon(UlvenikIcons.details, color: Color(0xFF95d3bb), size: 18),
                onPressed: () => AppSnackbar.show(context, message: 'Opening attachment...', type: SnackbarType.info),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF95d3bb),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Medication Review',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF95d3bb),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Follow-up Vet Appointment',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          children: [
            _buildTimelineItem(
              title: 'Status Updated',
              time: 'Today, 09:15 AM',
              dotColor: const Color(0xFF95d3bb),
              isFirst: true,
              isLast: false,
            ),
            _buildTimelineItem(
              title: 'Attachment Added',
              time: '01 Feb 2025, 14:30 PM',
              dotColor: const Color(0xFFb6ccb5),
              isFirst: false,
              isLast: false,
            ),
            _buildTimelineItem(
              title: 'Record Created',
              time: '01 Feb 2025, 08:00 AM',
              dotColor: const Color(0xFFb6ccb5),
              isFirst: false,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedRecordsCard() {
    // User requested: Connected injuries or vet visits
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Left Shoulder Inflammation',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    border: Border.all(color: Colors.white12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Injury',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Shoulder Assessment',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    border: Border.all(color: Colors.white12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Vet Visit',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SHARED ACTIONS & COMPONENTS
  // ==========================================

  Widget _buildActions() {
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
          icon: const UlvenikIcon(UlvenikIcons.edit, size: 18),
          label: const Text(
            'Edit Record',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 16),
        // User requested: Delete Record requires confirmation before the record is permanently deleted.
        TextButton(
          onPressed: _confirmDelete,
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

  Widget _buildInfoRow({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UlvenikIcon.fromMaterial(icon, color: AppColors.secondaryTextStoneGrey, size: 20),
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

  Widget _buildChip(String label) {
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
                if (!isFirst)
                  Positioned(
                    top: 0,
                    bottom: 24,
                    child: Container(width: 1, color: Colors.white12),
                  ),
                if (!isLast)
                  Positioned(
                    top: 24,
                    bottom: 0,
                    child: Container(width: 1, color: Colors.white12),
                  ),
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
}
