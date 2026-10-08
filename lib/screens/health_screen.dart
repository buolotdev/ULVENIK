import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';
import '../theme/app_colors.dart';
import 'health_records_screen.dart';
import 'add_health_record_screen.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  bool _isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.cardsCarbon,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryTextOffWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Health',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primaryTextOffWhite),
            onPressed: () => setState(() => _isEmpty = !_isEmpty),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDogSelector(),
              const SizedBox(height: 24),
              if (_isEmpty) ...[
                _buildEmptyTopMetrics(),
                const SizedBox(height: 24),
                _buildEmptyStateCard(),
                const SizedBox(height: 24),
                _buildEmptyCategoriesGrid(),
              ] else ...[
                _buildHealthSummaryStrip(),
                const SizedBox(height: 24),
                _buildUpcomingItems(),
                const SizedBox(height: 24),
                _buildCategoriesGrid(),
                const SizedBox(height: 24),
                _buildAddRecordCTA(),
              ],
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDogSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF95d3bb)),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1601633512349-2e1d09e51f89?q=80&w=2070&auto=format&fit=crop',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Luna',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.secondaryTextStoneGrey, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      _isEmpty ? 'Female' : 'Belgian Malinois',
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _isEmpty ? '3 yrs • Border Collie' : '3 Years',
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey),
        ],
      ),
    );
  }

  // =====================
  // POPULATED STATE WIDGETS
  // =====================

  Widget _buildHealthSummaryStrip() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.1,
      children: [
        _buildBentoCard(Icons.monitor_weight_outlined, 'LATEST WEIGHT', '34.8 kg'),
        _buildBentoCard(Icons.medication_outlined, 'MEDICATIONS', '2 Active'),
        _buildBentoCard(Icons.vaccines_outlined, 'NEXT VAX', '18 Sep 2026', true),
        _buildBentoCard(Icons.local_hospital_outlined, 'NEXT VET', 'Tomorrow 10:30', true),
        _buildBentoCard(Icons.accessibility_new_outlined, 'REHAB', '1 Active'),
        _buildBentoCard(Icons.update_outlined, 'LAST RECORD', '12 Jul 2026', true),
      ],
    );
  }

  Widget _buildBentoCard(IconData icon, String title, String value, [bool smallValue = false]) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF95d3bb)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: const Color(0xFF95d3bb),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: smallValue ? 13 : 18,
              fontWeight: smallValue ? FontWeight.w500 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'UPCOMING',
          style: TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildUpcomingRow(Icons.medication_outlined, 'Medication', 'Carprofen', true),
        const SizedBox(height: 8),
        _buildUpcomingRow(Icons.vaccines_outlined, 'Vaccination', 'Annual Booster', true),
        const SizedBox(height: 8),
        _buildUpcomingRow(Icons.local_hospital_outlined, 'Vet Visit', 'Eye Examination', false),
      ],
    );
  }

  Widget _buildUpcomingRow(IconData icon, String title, String subtitle, bool isAlert) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              border: Border.all(color: Colors.white12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF95d3bb), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            isAlert ? Icons.notifications_active_outlined : Icons.notifications_outlined,
            color: isAlert ? const Color(0xFF95d3bb) : AppColors.secondaryTextStoneGrey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CATEGORIES',
          style: TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
          children: [
            _buildCategoryItem(Icons.monitor_weight_outlined, 'Weight'),
            _buildCategoryItem(Icons.medication_outlined, 'Medication'),
            _buildCategoryItem(Icons.vaccines_outlined, 'Vaccinations'),
            _buildCategoryItem(Icons.local_hospital_outlined, 'Vet Visits'),
            _buildCategoryItem(Icons.healing_outlined, 'Injuries'),
            _buildCategoryItem(Icons.accessibility_new_outlined, 'Rehabilitation'),
            _buildCategoryItem(Icons.medication_liquid_outlined, 'Supplements'),
            _buildCategoryItem(Icons.folder_outlined, 'Documents'),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthRecordsScreen())),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.note_add_outlined, color: const Color(0xFF95d3bb), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Other Records',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF95d3bb), size: 20),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAddRecordCTA() {
    return ElevatedButton.icon(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHealthRecordScreen())),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2e6b57),
        foregroundColor: AppColors.primaryTextOffWhite,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      icon: const Icon(Icons.add, size: 18),
      label: const Text(
        'Add Health Record',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  // =====================
  // EMPTY STATE WIDGETS
  // =====================

  Widget _buildEmptyTopMetrics() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.0,
      children: [
        _buildEmptyMetricBox('WEIGHT'),
        _buildEmptyMetricBox('BODY COND.'),
        _buildEmptyMetricBox('ACTIVITY'),
        _buildEmptyMetricBox('VACCINES'),
        _buildEmptyMetricBox('MEDS'),
        _buildEmptyMetricBox('VITALS'),
      ],
    );
  }

  Widget _buildEmptyMetricBox(String label) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(width: 16, height: 2, color: AppColors.primaryTextOffWhite),
        ],
      ),
    );
  }

  Widget _buildEmptyStateCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF95d3bb).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.medical_services_outlined, color: const Color(0xFF95d3bb), size: 32),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Health Records Yet',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Start building Luna's health history to track weight, vaccinations, medications, and more.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHealthRecordScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2e6b57),
              foregroundColor: AppColors.primaryTextOffWhite,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text(
              'Add First Health Record',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCategoriesGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.0,
      children: [
        _buildEmptyCategoryIcon(Icons.crop_square),
        _buildEmptyCategoryIcon(Icons.vaccines_outlined),
        _buildEmptyCategoryIcon(Icons.medication_outlined),
        _buildEmptyCategoryIcon(Icons.favorite_outline),
        _buildEmptyCategoryIcon(Icons.content_cut_outlined),
        _buildEmptyCategoryIcon(Icons.medical_information_outlined),
        _buildEmptyCategoryIcon(Icons.sentiment_dissatisfied_outlined),
        _buildEmptyCategoryIcon(Icons.remove_red_eye_outlined),
        _buildEmptyCategoryIcon(Icons.hearing_outlined),
      ],
    );
  }

  Widget _buildEmptyCategoryIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white10, size: 24),
      ),
    );
  }
}
