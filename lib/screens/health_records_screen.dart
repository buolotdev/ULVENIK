import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'add_health_record_screen.dart';
import 'health_record_details_screen.dart';

class HealthRecordsScreen extends StatefulWidget {
  const HealthRecordsScreen({super.key});

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  bool _isEmpty = false;
  bool _isListView = true;
  String _selectedDog = 'Koda';
  
  final TextEditingController _searchController = TextEditingController();
  final List<String> _activeFilters = ['Vet Visits', 'Current Year'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.secondarySage, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Health Records',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.secondarySage),
            onPressed: () => AppSnackbar.show(context, message: 'Search functionality coming soon', type: SnackbarType.info),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.secondarySage),
            onPressed: () => AppSnackbar.show(context, message: 'Filter options coming soon', type: SnackbarType.info),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: const Color(0xFF2e6b57)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHealthRecordScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.secondarySage),
            onPressed: () {
              setState(() {
                _isEmpty = !_isEmpty;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isEmpty) _buildEmptyDogSelector() else _buildPopulatedDogSelector(),
              const SizedBox(height: 24),
              if (_isEmpty) _buildEmptyStats() else _buildPopulatedStats(),
              const SizedBox(height: 24),
              _buildViewToggle(),
              const SizedBox(height: 16),
              if (!_isEmpty) ...[
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildFilterChips(),
                const SizedBox(height: 24),
                _buildRecordsList(),
              ] else ...[
                const SizedBox(height: 48),
                _buildEmptyStateCard(),
              ],
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: _isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHealthRecordScreen())),
              backgroundColor: const Color(0xFF2e6b57),
              foregroundColor: AppColors.primaryTextOffWhite,
              elevation: 0,
              child: const Icon(Icons.add),
            ),
    );
  }

  // ==========================
  // COMMON WIDGETS
  // ==========================

  Widget _buildViewToggle() {
    return Row(
      children: [
        _buildTogglePill('List View', Icons.list, _isListView, () => setState(() => _isListView = true)),
        const SizedBox(width: 8),
        _buildTogglePill('Timeline', Icons.calendar_today, !_isListView, () => setState(() => _isListView = false)),
      ],
    );
  }

  Widget _buildTogglePill(String text, IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2e6b57) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            if (!isActive) ...[
              Icon(icon, size: 14, color: AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: TextStyle(
                color: isActive ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================
  // POPULATED STATE WIDGETS
  // ==========================

  Widget _buildPopulatedDogSelector() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDog = _selectedDog == 'Koda' ? 'Finn' : 'Koda';
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2e6b57), width: 2),
                image: DecorationImage(
                  image: NetworkImage(
                    _selectedDog == 'Koda' 
                      ? 'https://images.unsplash.com/photo-1601633512349-2e1d09e51f89?q=80&w=2070&auto=format&fit=crop'
                      : 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?q=80&w=600&auto=format&fit=crop',
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
                  Text(
                    _selectedDog,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _selectedDog == 'Koda' ? 'Siberian Husky · 3y 2m' : 'Belgian Malinois · 3 Years',
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
      ),
    );
  }

  Widget _buildPopulatedStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 24,
        crossAxisSpacing: 16,
        childAspectRatio: 3.5,
        children: [
          _buildStatCell(Icons.monitor_weight_outlined, 'Weight', '28.4 kg'),
          _buildStatCell(Icons.medical_services_outlined, 'Active Issues', '1 Active'),
          _buildStatCell(Icons.calendar_month_outlined, 'Vet Visit', '14 Mar'),
          _buildStatCell(Icons.vaccines_outlined, 'Vaccinations', 'Up to Date'),
          _buildStatCell(Icons.medication_outlined, 'Medications', '2 Active'),
          _buildStatCell(Icons.notifications_outlined, 'Reminders', '3 Due'),
        ],
      ),
    );
  }

  Widget _buildStatCell(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.secondarySage, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() {}),
      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Search records...',
        hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
        prefixIcon: const Icon(Icons.search, color: AppColors.secondaryTextStoneGrey),
        suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              )
            : const Icon(Icons.mic, color: AppColors.secondaryTextStoneGrey),
        filled: true,
        fillColor: AppColors.cardsCarbon,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF2e6b57)),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    if (_activeFilters.isEmpty) return const SizedBox.shrink();
    
    return Row(
      children: _activeFilters.map((filter) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _buildFilterChip(filter),
        );
      }).toList(),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 6, bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2e6b57)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2e6b57),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _activeFilters.remove(label);
              });
            },
            child: const Icon(Icons.close, size: 16, color: AppColors.secondarySage),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsList() {
    return Column(
      children: [
        _buildRecordCard(
          icon: Icons.monitor_heart_outlined,
          category: 'VET VISIT · 12 Mar 2025',
          status: 'Resolved',
          statusColor: AppColors.secondaryTextStoneGrey,
          statusBgColor: const Color(0xFF272b29), // surface-container-high
          title: 'Annual Vet Check-up',
          subtitle: 'Dr. Sarah Holt',
          attachments: 3,
        ),
        _buildRecordCard(
          icon: Icons.vaccines_outlined,
          category: 'VACCINATION · 20 Apr 2025',
          status: 'Scheduled',
          statusColor: const Color(0xFF2e6b57),
          statusBgColor: Colors.transparent,
          statusBorderColor: const Color(0xFF2e6b57),
          title: 'Rabies Booster — Due',
        ),
        _buildRecordCard(
          icon: Icons.medication_outlined,
          category: 'MEDICATION · 01 Feb 2025',
          status: 'Active',
          statusColor: AppColors.primaryTextOffWhite,
          statusBgColor: const Color(0xFF2e6b57),
          title: 'Metacam 1.5mg — Daily',
        ),
        _buildRecordCard(
          icon: Icons.healing_outlined,
          category: 'INJURY · 28 Jan 2025',
          status: 'Active',
          statusColor: AppColors.primaryTextOffWhite,
          statusBgColor: const Color(0xFF2e6b57),
          title: 'Left Paw Laceration',
        ),
      ],
    );
  }

  Widget _buildRecordCard({
    required IconData icon,
    required String category,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    Color? statusBorderColor,
    required String title,
    String? subtitle,
    int attachments = 0,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthRecordDetailsScreen())),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.secondarySage, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category,
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              border: statusBorderColor != null ? Border.all(color: statusBorderColor) : null,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      if (attachments > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.attachment, size: 14, color: AppColors.secondaryTextStoneGrey),
                            const SizedBox(width: 4),
                            Text(
                              '$attachments attachments',
                              style: const TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================
  // EMPTY STATE WIDGETS
  // ==========================

  Widget _buildEmptyDogSelector() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _selectedDog = 'Koda'),
          child: _buildAvatarCircle('Koda', 'https://images.unsplash.com/photo-1601633512349-2e1d09e51f89?q=80&w=2070&auto=format&fit=crop', _selectedDog == 'Koda'),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => setState(() => _selectedDog = 'Finn'),
          child: _buildAvatarCircle('Finn', 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?q=80&w=600&auto=format&fit=crop', _selectedDog == 'Finn'),
        ),
      ],
    );
  }

  Widget _buildAvatarCircle(String name, String imgUrl, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFF2e6b57) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imgUrl),
                fit: BoxFit.cover,
                colorFilter: isSelected ? null : ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: isSelected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 32,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          _buildEmptyStatItem(Icons.monitor_weight_outlined, 'Weight'),
          _buildEmptyStatItem(Icons.vaccines_outlined, 'Vaccines'),
          _buildEmptyStatItem(Icons.medication_outlined, 'Meds'),
          _buildEmptyStatItem(Icons.favorite_outline, 'Heart'),
          _buildEmptyStatItem(Icons.healing_outlined, 'Injuries'),
          _buildEmptyStatItem(Icons.calendar_month_outlined, 'Next Vet'),
        ],
      ),
    );
  }

  Widget _buildEmptyStatItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF95d3bb), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Container(width: 16, height: 2, color: AppColors.primaryTextOffWhite),
      ],
    );
  }

  Widget _buildEmptyStateCard() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardsCarbon,
            border: Border.all(color: Colors.white12),
          ),
          child: const Center(
            child: Icon(Icons.medical_services_outlined, color: Color(0xFF95d3bb), size: 32),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'No Health Records Yet',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Start building Koda's complete health history. Track weight, vaccines, medications, and vet visits all in one place.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHealthRecordScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2e6b57),
              foregroundColor: AppColors.primaryTextOffWhite,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text('Add Health Record', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () => AppSnackbar.show(context, message: 'Learn about Health Records coming soon', type: SnackbarType.info),
          child: const Text(
            'Learn about Health Records',
            style: TextStyle(
              color: Color(0xFF2e6b57),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

