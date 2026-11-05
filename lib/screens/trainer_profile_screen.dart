import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'clients_page_screen.dart';
import 'trainer_dashboard_screen.dart';
import 'trainer_workspace_settings_screen.dart';

class _TrainerQualification {
  final String id;
  String title;
  String body;
  String yearLabel;
  final IconData icon;
  final bool hasCertificate;
  final String certRef;

  _TrainerQualification({
    required this.id,
    required this.title,
    required this.body,
    required this.yearLabel,
    required this.icon,
    required this.hasCertificate,
    required this.certRef,
  });
}

class _TrainerServiceItem {
  final String id;
  String title;
  String subtitle;
  String durationLabel;
  String rateLabel;

  _TrainerServiceItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.durationLabel,
    required this.rateLabel,
  });
}

class TrainerProfileScreen extends StatefulWidget {
  const TrainerProfileScreen({super.key});

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _cardBg = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _sage = AppColors.secondarySage; // #7A8F7A
  static const Color _mintBright = Color(0xFFB1F0D6);
  static const Color _textPrimary = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _textSecondary = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _border = AppColors.cardBorder; // rgba(255,255,255,0.08)

  late final AnimationController _animController;
  late final Animation<double> _curvedAnim;

  int _coverThemeIndex = 0; // 0: Misty Pine, 1: Essex Woodland, 2: Nordic Slate
  String? _selectedExpertiseTag;

  String _aboutBio = '';
  String _contactEmail = '';
  String _contactWebsite = '';
  String _contactInstagram = '';
  final List<String> _expertiseTags = [];
  late final List<_TrainerQualification> _qualifications = [];
  late final List<_TrainerServiceItem> _services = [];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _curvedAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _openEditIdentitySheet(TrainerBusinessProfile currentBusiness) {
    final bizCtrl = TextEditingController(text: currentBusiness.businessName);
    final nameCtrl = TextEditingController(text: currentBusiness.trainerName);
    final bioCtrl = TextEditingController(text: _aboutBio);
    final emailCtrl = TextEditingController(text: _contactEmail);
    final webCtrl = TextEditingController(text: _contactWebsite);
    final instaCtrl = TextEditingController(text: _contactInstagram);
    final newTagCtrl = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 22,
              ),
              child: SingleChildScrollView(
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
                      'Edit Trainer & Business Identity',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildSheetField('Business Name', bizCtrl),
                    const SizedBox(height: 12),
                    _buildSheetField('Trainer Name', nameCtrl),
                    const SizedBox(height: 12),
                    _buildSheetField('About Bio', bioCtrl, maxLines: 4),
                    const SizedBox(height: 12),
                    _buildSheetField('Contact Email', emailCtrl),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSheetField('Website', webCtrl),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildSheetField('Instagram', instaCtrl),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSheetField(
                            'Add Expertise Tag (e.g. SCENTWORK)',
                            newTagCtrl,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            final tag = newTagCtrl.text.trim().toUpperCase();
                            if (tag.isEmpty) return;
                            if (!_expertiseTags.contains(tag)) {
                              setState(() => _expertiseTags.add(tag));
                              setModalState(() {});
                            }
                            newTagCtrl.clear();
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: _forest,
                            foregroundColor: _textPrimary,
                          ),
                          icon: const UlvenikIcon(UlvenikIcons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final updatedBiz = currentBusiness.copyWith(
                            businessName: bizCtrl.text.trim().isEmpty
                                ? currentBusiness.businessName
                                : bizCtrl.text.trim(),
                            trainerName: nameCtrl.text.trim().isEmpty
                                ? currentBusiness.trainerName
                                : nameCtrl.text.trim(),
                            email: emailCtrl.text.trim(),
                            website: webCtrl.text.trim(),
                            bio: bioCtrl.text.trim(),
                          );
                          TrainerPackStore.updateBusiness(updatedBiz);
                          setState(() {
                            if (bioCtrl.text.trim().isNotEmpty) {
                              _aboutBio = bioCtrl.text.trim();
                            }
                            if (emailCtrl.text.trim().isNotEmpty) {
                              _contactEmail = emailCtrl.text.trim();
                            }
                            if (webCtrl.text.trim().isNotEmpty) {
                              _contactWebsite = webCtrl.text.trim();
                            }
                            if (instaCtrl.text.trim().isNotEmpty) {
                              _contactInstagram = instaCtrl.text.trim();
                            }
                          });
                          Navigator.pop(ctx);
                          AppSnackbar.show(
                            context,
                            title: 'Identity Saved',
                            message:
                                '${updatedBiz.businessName} updated across Trainer Pack.',
                            type: SnackbarType.success,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _textPrimary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Business Identity',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSheetField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: _textPrimary,
        fontSize: 13.5,
        fontFamily: 'Inter',
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _textSecondary, fontSize: 12),
        filled: true,
        fillColor: const Color(0xFF21272A),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _forest),
        ),
      ),
    );
  }

  void _showAddQualificationSheet() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    final yearCtrl = TextEditingController();

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
            MediaQuery.of(ctx).viewInsets.bottom + 22,
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
                'Add Qualification',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 14),
              _buildSheetField('Qualification Title', titleCtrl),
              const SizedBox(height: 12),
              _buildSheetField('Awarding Body / Organization', bodyCtrl),
              const SizedBox(height: 12),
              _buildSheetField('Year / Validity', yearCtrl),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    final t = titleCtrl.text.trim();
                    if (t.isNotEmpty) {
                      setState(() {
                        _qualifications.add(
                          _TrainerQualification(
                            id: 'q_${DateTime.now().millisecondsSinceEpoch}',
                            title: t,
                            body: bodyCtrl.text.trim().isEmpty ? 'Verified' : bodyCtrl.text.trim(),
                            yearLabel: yearCtrl.text.trim().isEmpty ? 'Current' : yearCtrl.text.trim(),
                            icon: Icons.workspace_premium_outlined,
                            hasCertificate: false,
                            certRef: 'CERT-${DateTime.now().millisecondsSinceEpoch}',
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Qualification'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddServiceSheet() {
    final titleCtrl = TextEditingController();
    final subCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final rateCtrl = TextEditingController();

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
            MediaQuery.of(ctx).viewInsets.bottom + 22,
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
                'Add Service Offering',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 14),
              _buildSheetField('Service Name', titleCtrl),
              const SizedBox(height: 12),
              _buildSheetField('Description', subCtrl),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildSheetField('Duration (e.g. 60 min)', durationCtrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSheetField('Rate (e.g. £65 / session)', rateCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    final t = titleCtrl.text.trim();
                    if (t.isNotEmpty) {
                      setState(() {
                        _services.add(
                          _TrainerServiceItem(
                            id: 's_${DateTime.now().millisecondsSinceEpoch}',
                            title: t,
                            subtitle: subCtrl.text.trim(),
                            durationLabel: durationCtrl.text.trim().isEmpty ? '60 min' : durationCtrl.text.trim(),
                            rateLabel: rateCtrl.text.trim().isEmpty ? 'Inquire' : rateCtrl.text.trim(),
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Service'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQualificationCertificate(_TrainerQualification qual) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
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
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14181B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _forest.withValues(alpha: 0.55)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _forest.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: UlvenikIcon.fromMaterial(qual.icon, color: _mintBright, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  qual.title,
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  qual.body,
                                  style: const TextStyle(
                                    color: _textSecondary,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _forest.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(color: _forest),
                            ),
                            child: const Text(
                              'VERIFIED',
                              style: TextStyle(
                                color: _mintBright,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: _border, height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status: ${qual.yearLabel}',
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Ref: ${qual.certRef}',
                            style: const TextStyle(
                              color: _mintBright,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: qual.certRef));
                      Navigator.pop(ctx);
                      AppSnackbar.show(
                        context,
                        title: 'Reference Copied',
                        message:
                            'Copied ${qual.title} credential reference (${qual.certRef}).',
                        type: SnackbarType.info,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _textPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 17),
                    label: const Text('Copy Verification Reference'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showServiceDetailSheet(_TrainerServiceItem service) {
    final durCtrl = TextEditingController(text: service.durationLabel);
    final subCtrl = TextEditingController(text: service.subtitle);

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
            MediaQuery.of(ctx).viewInsets.bottom + 22,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    service.title,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    service.rateLabel,
                    style: const TextStyle(
                      color: _mintBright,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildSheetField('Service Summary', subCtrl),
              const SizedBox(height: 12),
              _buildSheetField('Duration / Package Format', durCtrl),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (subCtrl.text.trim().isNotEmpty) {
                        service.subtitle = subCtrl.text.trim();
                      }
                      if (durCtrl.text.trim().isNotEmpty) {
                        service.durationLabel = durCtrl.text.trim();
                      }
                    });
                    Navigator.pop(ctx);
                    AppSnackbar.show(
                      context,
                      title: 'Service Updated',
                      message: '${service.title} updated on your public profile.',
                      type: SnackbarType.success,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Update Service'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _copyContactValue(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    AppSnackbar.show(
      context,
      title: '$label Copied',
      message: '$value copied to clipboard.',
      type: SnackbarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      body: SafeArea(
        child: ValueListenableBuilder<TrainerBusinessProfile>(
          valueListenable: TrainerPackStore.businessNotifier,
          builder: (context, business, _) {
            return ValueListenableBuilder<List<TrainerClient>>(
              valueListenable: TrainerPackStore.clientsNotifier,
              builder: (context, clients, _) {
                final activeClients =
                    clients.where((c) => c.status == 'Active').length;
                final activeDogs = clients
                    .where((c) => c.status == 'Active')
                    .fold<int>(0, (s, c) => s + c.dogs.length);

                return AnimatedBuilder(
                  animation: _curvedAnim,
                  builder: (context, _) {
                    return Column(
                      children: [
                        _buildTopBar(business),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeroBannerCard(business),
                                const SizedBox(height: 14),
                                _buildStatsStrip(
                                  activeClients: activeClients,
                                  activeDogs: activeDogs,
                                ),
                                const SizedBox(height: 22),
                                _buildAboutSection(business),
                                const SizedBox(height: 22),
                                _buildExpertiseSection(business),
                                const SizedBox(height: 22),
                                _buildQualificationsSection(),
                                const SizedBox(height: 22),
                                _buildServicesSection(),
                                const SizedBox(height: 22),
                                _buildContactSection(business),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(TrainerBusinessProfile business) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(
          bottom: BorderSide(color: _border, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            visualDensity: VisualDensity.compact,
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _textSecondary,
              size: 26,
            ),
          ),
          const Expanded(
            child: Text(
              'Trainer Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
                fontFamily: 'Inter',
              ),
            ),
          ),
          IconButton(
            tooltip: 'Edit Trainer Profile',
            visualDensity: VisualDensity.compact,
            onPressed: () => _openEditIdentitySheet(business),
            icon: const UlvenikIcon(UlvenikIcons.edit,
              color: _textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBannerCard(TrainerBusinessProfile business) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 232,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _MistyForestBannerPainter(themeIndex: _coverThemeIndex),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _coverThemeIndex = (_coverThemeIndex + 1) % 3;
                  });
                  const themes = [
                    'Misty Pine Forest',
                    'Essex Heathland Dusk',
                    'Nordic Highland',
                  ];
                  AppSnackbar.show(
                    context,
                    title: 'Cover Atmosphere Changed',
                    message: 'Switched banner backdrop to ${themes[_coverThemeIndex]}.',
                    type: SnackbarType.info,
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _cardBg.withValues(alpha: 0.62),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(18, 14),
                      painter: _UlvenikEmblemPainter(color: _sage),
                    ),
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
                children: [
                  GestureDetector(
                    onTap: () => _openEditIdentitySheet(business),
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E1113),
                        shape: BoxShape.circle,
                        border: Border.all(color: _forest, width: 1.8),
                      ),
                      child: const Icon(Icons.person_rounded,
                        color: _sage,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            business.businessName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(
                                business.trainerName,
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _forest.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: _forest.withValues(alpha: 0.85),
                                  ),
                                ),
                                child: const Text(
                                  'TRAINER PACK',
                                  style: TextStyle(
                                    color: Color(0xFF4FA886),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.55,
                                    fontFamily: 'Inter',
                                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildStatsStrip({
    required int activeClients,
    required int activeDogs,
  }) {
    final p = _curvedAnim.value;
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildStatCell(
                value: '${(activeClients * p).round()}',
                label: 'Active Clients',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ClientsPageScreen(),
                    ),
                  );
                },
              ),
            ),
            const VerticalDivider(color: _border, width: 1, indent: 14, endIndent: 14),
            Expanded(
              child: _buildStatCell(
                value: '${(activeDogs * p).round()}',
                label: 'Client Dogs',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ClientsPageScreen(),
                    ),
                  );
                },
              ),
            ),
            const VerticalDivider(color: _border, width: 1, indent: 14, endIndent: 14),
            Expanded(
              child: _buildStatCell(
                value: '${(47 * p).round()}',
                label: 'Sessions',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TrainerWorkspaceSettingsScreen(),
                    ),
                  );
                },
              ),
            ),
            const VerticalDivider(color: _border, width: 1, indent: 14, endIndent: 14),
            Expanded(
              child: _buildStatCell(
                value: '3 yrs',
                label: 'On Ulvenik',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCell({
    required String value,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildAboutSection(TrainerBusinessProfile profile) {
    final hasBio = _aboutBio.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('ABOUT'),
            GestureDetector(
              onTap: () => _openEditIdentitySheet(profile),
              child: Text(
                hasBio ? 'Edit' : 'Add Bio',
                style: const TextStyle(
                  color: _mintBright,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (!hasBio)
          GestureDetector(
            onTap: () => _openEditIdentitySheet(profile),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'No bio added yet',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 13.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Row(
                    children: [
                      UlvenikIcon(UlvenikIcons.add, size: 16, color: _mintBright),
                      SizedBox(width: 4),
                      Text(
                        'Add Bio',
                        style: TextStyle(
                          color: _mintBright,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Text(
              _aboutBio,
              style: const TextStyle(
                color: Color(0xFFB7C0BB),
                fontSize: 13.5,
                height: 1.62,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExpertiseSection(TrainerBusinessProfile profile) {
    final hasTags = _expertiseTags.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('EXPERTISE'),
            GestureDetector(
              onTap: () => _openEditIdentitySheet(profile),
              child: const Text(
                'Add Expertise',
                style: TextStyle(
                  color: _mintBright,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (!hasTags)
          GestureDetector(
            onTap: () => _openEditIdentitySheet(profile),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'No expertise tags added yet',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 13.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Row(
                    children: [
                      UlvenikIcon(UlvenikIcons.add, size: 16, color: _mintBright),
                      SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: _mintBright,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 10,
              children: _expertiseTags.map((tag) {
                final isSelected = _selectedExpertiseTag == tag;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedExpertiseTag = isSelected ? null : tag;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _forest.withValues(alpha: 0.22)
                          : const Color(0xFF212629),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isSelected
                            ? _forest
                            : Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: isSelected ? _mintBright : _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.55,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildQualificationsSection() {
    final hasQualifications = _qualifications.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('QUALIFICATIONS'),
            GestureDetector(
              onTap: _showAddQualificationSheet,
              child: const Text(
                'Add Qualification',
                style: TextStyle(
                  color: _mintBright,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (!hasQualifications)
          GestureDetector(
            onTap: _showAddQualificationSheet,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'No qualifications added yet',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 13.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Row(
                    children: [
                      UlvenikIcon(UlvenikIcons.add, size: 16, color: _mintBright),
                      SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: _mintBright,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Column(
              children: List.generate(_qualifications.length, (i) {
              final q = _qualifications[i];
              return Column(
                children: [
                  InkWell(
                    onTap: () => _showQualificationCertificate(q),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: UlvenikIcon.fromMaterial(q.icon, color: _sage, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  q.title,
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  q.body,
                                  style: const TextStyle(
                                    color: _textSecondary,
                                    fontSize: 12.5,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  q.yearLabel,
                                  style: const TextStyle(
                                    color: _textSecondary,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (q.hasCertificate)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                UlvenikIcon(UlvenikIcons.training,
                                  color: Color(0xFF428E70),
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Certificate',
                                  style: TextStyle(
                                    color: Color(0xFF428E70),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            )
                          else
                            const UlvenikIcon(UlvenikIcons.completed,
                              color: _sage,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (i < _qualifications.length - 1)
                    const Divider(color: _border, height: 1),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    final hasServices = _services.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('SERVICES'),
            GestureDetector(
              onTap: _showAddServiceSheet,
              child: const Text(
                'Add Service',
                style: TextStyle(
                  color: _mintBright,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (!hasServices)
          GestureDetector(
            onTap: _showAddServiceSheet,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'No services added yet',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 13.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Row(
                    children: [
                      UlvenikIcon(UlvenikIcons.add, size: 16, color: _mintBright),
                      SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: _mintBright,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Column(
              children: List.generate(_services.length, (i) {
                final s = _services[i];
                return Column(
                  children: [
                    InkWell(
                      onTap: () => _showServiceDetailSheet(s),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.title,
                                    style: const TextStyle(
                                      color: _textPrimary,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    s.subtitle,
                                    style: const TextStyle(
                                      color: _textSecondary,
                                      fontSize: 12.5,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              s.durationLabel,
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (i < _services.length - 1)
                      const Divider(color: _border, height: 1),
                  ],
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildContactSection(TrainerBusinessProfile profile) {
    final hasContact = _contactEmail.trim().isNotEmpty ||
        _contactWebsite.trim().isNotEmpty ||
        _contactInstagram.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('CONTACT'),
            GestureDetector(
              onTap: () => _openEditIdentitySheet(profile),
              child: Text(
                hasContact ? 'Edit' : 'Add Contact',
                style: const TextStyle(
                  color: _mintBright,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (!hasContact)
          GestureDetector(
            onTap: () => _openEditIdentitySheet(profile),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'No contact details added yet',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 13.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Row(
                    children: [
                      UlvenikIcon(UlvenikIcons.add, size: 16, color: _mintBright),
                      SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: _mintBright,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Column(
              children: [
                if (_contactEmail.trim().isNotEmpty) ...[
                  _buildContactRow(
                    icon: Icons.mail_outline_rounded,
                    text: _contactEmail,
                    textColor: _textPrimary,
                    onTap: () => _copyContactValue('Email', _contactEmail),
                  ),
                  if (_contactWebsite.trim().isNotEmpty || _contactInstagram.trim().isNotEmpty)
                    const Divider(color: _border, height: 1),
                ],
                if (_contactWebsite.trim().isNotEmpty) ...[
                  _buildContactRow(
                    icon: Icons.language_rounded,
                    text: _contactWebsite,
                    textColor: const Color(0xFF428E70),
                    onTap: () => _copyContactValue('Website', _contactWebsite),
                  ),
                  if (_contactInstagram.trim().isNotEmpty)
                    const Divider(color: _border, height: 1),
                ],
                if (_contactInstagram.trim().isNotEmpty)
                  _buildContactRow(
                    icon: Icons.camera_alt_outlined,
                    text: _contactInstagram,
                    textColor: _textSecondary,
                    onTap: () => _copyContactValue('Instagram', _contactInstagram),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String text,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            UlvenikIcon.fromMaterial(icon, color: _sage, size: 19),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const UlvenikIcon(UlvenikIcons.details,
              color: _textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _MistyForestBannerPainter extends CustomPainter {
  final int themeIndex;

  const _MistyForestBannerPainter({required this.themeIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final topColor = switch (themeIndex) {
      1 => const Color(0xFF2B2A26),
      2 => const Color(0xFF1F2B33),
      _ => const Color(0xFF2B3234),
    };
    final midColor = switch (themeIndex) {
      1 => const Color(0xFF1E2221),
      2 => const Color(0xFF182026),
      _ => const Color(0xFF1D2326),
    };

    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          topColor,
          midColor,
          const Color(0xFF1A1F22),
        ],
        stops: const [0.0, 0.58, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, skyPaint);

    // Subtle mist glow near top center
    final mistPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.1, -0.85),
        radius: 0.9,
        colors: [
          Colors.white.withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, mistPaint);

    // Distant pine silhouettes matching the atmospheric dark forest banner
    final treePaintBack = Paint()
      ..color = const Color(0xFF14181A).withValues(alpha: 0.55);
    final treePaintFront = Paint()
      ..color = const Color(0xFF121618).withValues(alpha: 0.78);

    const treePositions = [
      (0.06, 0.14, 26.0),
      (0.16, 0.08, 32.0),
      (0.28, 0.22, 24.0),
      (0.41, 0.16, 28.0),
      (0.55, 0.10, 34.0),
      (0.68, 0.18, 26.0),
      (0.81, 0.06, 36.0),
      (0.93, 0.15, 28.0),
    ];

    for (var i = 0; i < treePositions.length; i++) {
      final (rx, topRatio, halfW) = treePositions[i];
      final cx = size.width * rx;
      final topY = size.height * topRatio;
      final basePaint = i.isEven ? treePaintBack : treePaintFront;

      // Trunk
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(cx, (topY + size.height * 0.75) / 2),
          width: 3.5,
          height: size.height * 0.65,
        ),
        basePaint,
      );

      // Layered spruce boughs
      for (var tier = 0; tier < 5; tier++) {
        final y0 = topY + tier * 18.0;
        final w = halfW * (0.42 + tier * 0.16);
        final path = Path()
          ..moveTo(cx, y0)
          ..lineTo(cx - w, y0 + 26)
          ..lineTo(cx + w, y0 + 26)
          ..close();
        canvas.drawPath(path, basePaint);
      }
    }

    // Bottom dark vignette so text & avatar pop cleanly
    final bottomFade = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF1A1F22).withValues(alpha: 0.86),
          const Color(0xFF1A1F22),
        ],
        stops: const [0.35, 0.75, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bottomFade);
  }

  @override
  bool shouldRepaint(covariant _MistyForestBannerPainter oldDelegate) =>
      oldDelegate.themeIndex != themeIndex;
}

class _UlvenikEmblemPainter extends CustomPainter {
  final Color color;

  const _UlvenikEmblemPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(1, size.height - 1)
      ..lineTo(size.width * 0.28, 2)
      ..lineTo(size.width * 0.50, size.height * 0.52)
      ..lineTo(size.width * 0.72, 2)
      ..lineTo(size.width - 1, size.height - 1)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _UlvenikEmblemPainter oldDelegate) =>
      oldDelegate.color != color;
}
