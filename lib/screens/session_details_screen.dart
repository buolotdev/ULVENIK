import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';
import 'activity_details_screen.dart';
import 'record_session_screen.dart';
import 'activity_statistics_screen.dart';
import 'activity_insights_screen.dart';
import 'equipment_screen.dart';
import 'session_templates_screen.dart';
import 'export_screen.dart';
import 'sc_archive_screen.dart';

/// Screen representing "Session Details - Populated State" (Line 147 in Handover Doc).
/// Follows Figma design strictly: clean header, hero summary card, session information,
/// recorded metrics grid, notes, equipment, media gallery lightbox, and personal best banner.
class SessionDetailsScreen extends StatefulWidget {
  final String sessionTitle;
  final String dateSubtitle;
  final String shortDate;
  final String startTime;
  final String endTime;
  final String durationText;
  final int initialRating;
  final String distance;
  final String sets;
  final String restTime;
  final String intensity;
  final String repetitions;
  final String notes;

  const SessionDetailsScreen({
    super.key,
    this.sessionTitle = 'Swimming Fitness',
    this.dateSubtitle = 'Tuesday, 19 August 2026',
    this.shortDate = '19 Aug 2026',
    this.startTime = '07:15 AM',
    this.endTime = '08:40 AM',
    this.durationText = '1h 25m',
    this.initialRating = 4,
    this.distance = '1.8 km',
    this.sets = '6',
    this.restTime = '45 sec',
    this.intensity = 'High',
    this.repetitions = '12',
    this.notes =
        'Strong performance today. Maintained good form throughout the main sets. Slight fatigue visible during the final repetition, consider increasing rest time slightly next session if repeating this protocol.',
  });

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen>
    with SingleTickerProviderStateMixin {
  // Theme Color Palette
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _stoneGrey = Color(0xFFA7B0AB);
  static const _errorRed = Color(0xFFFF5449);

  static final _hairlineSide =
      BorderSide(color: Colors.white.withValues(alpha: 0.08));
  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));

  // State Variables
  late int _rating;
  late String _currentNotes;
  late String _distance;
  late String _sets;
  late String _restTime;
  late String _intensity;
  late String _repetitions;

  late AnimationController _celebrationController;
  late Animation<double> _glowAnimation;

  // Media items from Figma/Stitch
  final List<_SessionMediaItem> _mediaItems = [
    const _SessionMediaItem(
      url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAA6MpFhgm_ya4naDvk30iHXXw0S4bepNDThgPkAckv3Hc-D2AuLO2x49hfQt16v2C11kr-MPg5WEDxWYAzQ65ps64CBmdg52V3AAzvO6PRetWJc4lHen01H0IHsjCVpS8zhVGDDE_0jqFyakfSuhKSaVuDNhZLSwU5r_TWezJSXfa6W0vxXHDNyOoFNYEjDDh1Q2JW3o-1lDsOMSDDel84xZtJffr0D_Z55DYrzL_6G6JB7tJgHu4',
      caption: 'Nordic lake endurance swim with floatation vest',
      isVideo: false,
    ),
    const _SessionMediaItem(
      url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDtaD_VcUUqG8-da9mao4g5Tx-yY7TwHuvpIs8oTPw-couiKtMUvFiOihlnRpLeuT60Kk5YKVlj0w90w6O7nTd40bNXIW3OwJ-mrDFMCAzYadO0nStnFMO5TCElw5nKsh3xmiKlU8mZsQPeYwroA-90lrF_aFmfPQ9SQdbs7E61NgTBTPD86AJvCJp2J9SlVhfLR6rhy07LYQSkhrKSAHeJpC4guCiB3-FmRdebiz6xb4qGSZOeZdc',
      caption: 'Sprint interval water entry video clip',
      isVideo: true,
    ),
    const _SessionMediaItem(
      url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBgTCj489HAbnhTX_kWdzYawL_TLnu7f6kRayI4YE4uuuCL0T_FkF3voiho_bcLD6WYBq_1EG2eEV8OAX1Yp27PvJIHpCc1CTeUBf8T7JymDOALuzvHyllbsnhgc2drthTedkyrqWwfXQ0R8cGNSMe9tcAihlgH_V8QL2ExBQHTrck54DLL97xb7761FyRVutjPpLn4CpyVogRFiOAIK2OrMzejEcBPhvr4g3Gb4_jboqCWfW3J720',
      caption: 'Misty shoreline retrieval baseline check',
      isVideo: false,
    ),
    const _SessionMediaItem(
      url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCdRqITuDl2EwAEfRCfIJUtzmDw1Z1XpvBs37yBXk1fM6LrCFRzXLWv6aJ3wWAC3SGdmo2xR0PnW8yzpo3xGO-lDNvzB77-s3RWjNmcIw1kOWtz1v4bAMH0cfWBPlwydfhDe_fXRjR4poyt_STQesI6dYm2hfy2aklTlHvMF0MVoMtcbtjwUCZ0lHbtlbXxPSflEQsFmK38lcHB_5mSwYGmMS8Tj4tZzzHUCXcvQ7KK-S7xF3c-aEM',
      caption: 'Heavy duty tactical swim line harness inspection',
      isVideo: false,
    ),
    const _SessionMediaItem(
      url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAqXHtEY_hCzzFHoEkC2xVEiWLVNUwloIl3kCQMGKj9kS6-HDVU_YI_y97kqxSoMuTsXQY0RnpXjOfdM5H1wYyFM_s5CISVK39nXM2GZrt1ePbgz5Nel-t3hyu7bH78SVOsvgJnkrzUjdJquDPrKjOfrYmy5mNj-6P4IyEo83sINeeliKnjJCyr_H9BNgiPxELNIhq67vfZLhxmtfoc5yd9sLMJ16RygZCP5H0-MJ77DMjK2xlgjm8',
      caption: 'Post-session recovery on wet rocks',
      isVideo: false,
    ),
    const _SessionMediaItem(
      url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAqOw44KirkjISZcGrCWmnlh8juTf0G33r_ruLqXQyINau1rGdiazhse2pBHwwzruC0_FRwPy1mIrMfBxjZXCJDnw48fq9QJ4BRdeNN7CsemtsoX6shAaegXIHakojOcyZkCjK22ysnq1ZOpvPVc0PgjAZVuVAlAvyI9q8nHaqb2gLe7y3-tdeff5SCiFj0QZO7l6hD9cW1rAkGG9xkQnt0-bFHp7md9E3uq1PtHOJF40-kboZOipI',
      caption: 'Overhead trajectory and straight-line swim wake',
      isVideo: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _currentNotes = widget.notes;
    _distance = widget.distance;
    _sets = widget.sets;
    _restTime = widget.restTime;
    _intensity = widget.intensity;
    _repetitions = widget.repetitions;

    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // INTERACTIVE ACTION HANDLERS
  // ===========================================================================

  void _handleShareSession() {
    ScaffoldMessenger.of(context).clearSnackBars();
    AppSnackbar.show(
      context,
      message: 'Session summary link copied to clipboard',
      type: SnackbarType.success,
    );
  }

  void _handleDuplicateTemplate() {
    ScaffoldMessenger.of(context).clearSnackBars();
    AppSnackbar.show(
      context,
      message: 'Created new workout template from ${widget.sessionTitle}',
      type: SnackbarType.info,
    );
  }

  void _handleExportData() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ExportScreen(),
      ),
    );
  }

  void _confirmDeleteSession() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: _hairlineSide,
        ),
        title: const Text(
          'Delete Session?',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this recorded training session? This will remove all associated metrics and personal records.',
          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorRed,
              foregroundColor: _offWhite,
            ),
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Pop session details screen
              ScaffoldMessenger.of(context).clearSnackBars();
              AppSnackbar.show(
                context,
                message: 'Training session deleted',
                type: SnackbarType.info,
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openEditSession() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordSessionScreen(
          initialActivityName: widget.sessionTitle,
          initialCategory: 'Strength & Conditioning',
          initialIcon: Icons.pool,
          startWithActivity: true,
        ),
      ),
    );
  }

  void _showMetricBreakdown(String title, String val, String subtitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '+14% vs avg',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              val,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: _stoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _mint,
                      side: BorderSide(color: _mint.withValues(alpha: 0.4)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _editSingleMetric(title, val);
                    },
                    child: const Text('Adjust Value'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editSingleMetric(String metricName, String currentValue) {
    final ctrl = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: _hairlineSide,
        ),
        title: Text(
          'Edit $metricName',
          style: const TextStyle(color: _offWhite, fontSize: 17),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: _offWhite, fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: _obsidian,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: _hairlineSide,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: _offWhite,
            ),
            onPressed: () {
              setState(() {
                final txt = ctrl.text.trim();
                if (txt.isNotEmpty) {
                  if (metricName.contains('DISTANCE')) _distance = txt;
                  if (metricName.contains('SETS')) _sets = txt;
                  if (metricName.contains('REST')) _restTime = txt;
                  if (metricName.contains('INTENSITY')) _intensity = txt;
                  if (metricName.contains('REPETITIONS')) _repetitions = txt;
                }
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).clearSnackBars();
              AppSnackbar.show(
                context,
                message: '$metricName updated to ${ctrl.text.trim()}',
                type: SnackbarType.success,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEquipmentSpecs(String name, String desc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.construction, color: _mint, size: 20),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'High-Performance Conditioning Gear',
                      style: TextStyle(color: _stoneGrey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              desc,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMediaLightbox(int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, anim, secAnim) => _MediaLightboxViewer(
          items: _mediaItems,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  void _showAllMediaGallery() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _obsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SESSION MEDIA (9 ITEMS)',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: _stoneGrey),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  controller: scrollCtrl,
                  itemCount: _mediaItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final item = _mediaItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        _openMediaLightbox(index);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              item.url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: _carbon,
                                child: const Icon(Icons.photo, color: _stoneGrey),
                              ),
                            ),
                            if (item.isVideo)
                              Container(
                                color: Colors.black38,
                                child: const Center(
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    color: _mint,
                                    size: 28,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // BUILD METHOD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      // Strictly follows Figma: seamless dark header, no bottom hairline border
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite, size: 24),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
        title: const Text(
          'TRAINING SESSION',
          style: TextStyle(
            color: _offWhite,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: _stoneGrey, size: 22),
            color: _carbon,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: _hairlineSide,
            ),
            onSelected: (val) {
              if (val == 'edit') _openEditSession();
              if (val == 'stats') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityStatisticsScreen(
                      activityName: widget.sessionTitle,
                    ),
                  ),
                );
              }
              if (val == 'insights') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityInsightsScreen(
                      activityName: widget.sessionTitle,
                    ),
                  ),
                );
              }
              if (val == 'equipment') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const EquipmentScreen(),
                  ),
                );
              }
              if (val == 'templates') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SessionTemplatesScreen(),
                  ),
                );
              }
              if (val == 'share') _handleShareSession();
              if (val == 'duplicate') _handleDuplicateTemplate();
              if (val == 'export') _handleExportData();
              if (val == 'archive') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SCArchiveScreen(),
                  ),
                );
              }
              if (val == 'delete') _confirmDeleteSession();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'templates',
                child: Row(
                  children: [
                    Icon(Icons.description, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('Session Templates', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'equipment',
                child: Row(
                  children: [
                    Icon(Icons.fitness_center, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('Equipment Gear', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'insights',
                child: Row(
                  children: [
                    Icon(Icons.insights, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('Activity Insights', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'stats',
                child: Row(
                  children: [
                    Icon(Icons.analytics, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('Activity Statistics', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('Edit Session', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Share Session', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(Icons.copy, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Save as Template', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Export Data', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('View Archive', style: TextStyle(color: _mint, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 1),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: _errorRed, size: 18),
                    SizedBox(width: 10),
                    Text('Delete Session', style: TextStyle(color: _errorRed)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Hero Summary Card
            _buildHeroSummaryCard(),
            const SizedBox(height: 24),

            // 2. Session Information Card
            _buildSessionInformationCard(),
            const SizedBox(height: 24),

            // 3. Recorded Metrics Grid
            _buildRecordedMetricsGrid(),
            const SizedBox(height: 24),

            // 4. Notes Section
            _buildNotesCard(),
            const SizedBox(height: 24),

            // 5. Equipment Used
            _buildEquipmentCard(),
            const SizedBox(height: 24),

            // 6. Media Grid (3x2 preview)
            _buildMediaGridSection(),
            const SizedBox(height: 24),

            // 7. Personal Best Banner
            _buildPersonalBestCard(),
            const SizedBox(height: 32),

            // 8. Bottom Action CTAs
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 1: HERO SUMMARY CARD
  // ===========================================================================

  Widget _buildHeroSummaryCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(20),
        border: _hairlineBorder,
      ),
      child: Column(
        children: [
          // Session Title
          Text(
            widget.sessionTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),

          // Date Subtitle
          Text(
            widget.dateSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 18),

          // Stopwatch + Big Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_outlined, color: _mint, size: 28),
              const SizedBox(width: 8),
              Text(
                widget.durationText,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 5-Star Rating (Interactive)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) {
                final isFilled = index < _rating;
                return GestureDetector(
                  onTap: () {
                    setState(() => _rating = index + 1);
                    AppSnackbar.show(
                      context,
                      message: 'Session rating updated to $_rating/5',
                      type: SnackbarType.success,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      isFilled ? Icons.star : Icons.star_border,
                      color: isFilled ? _mint : _stoneGrey,
                      size: 20,
                    ),
                  ),
                );
              }),
              const SizedBox(width: 6),
              Text(
                '$_rating/5',
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 2: SESSION INFORMATION CARD
  // ===========================================================================

  Widget _buildSessionInformationCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      child: Column(
        children: [
          _buildInfoRow('DATE', widget.shortDate),
          _buildDivider(),
          _buildInfoRow('START TIME', widget.startTime),
          _buildDivider(),
          _buildInfoRow('END TIME', widget.endTime),
          _buildDivider(),
          _buildInfoRow('DURATION', widget.durationText),
          _buildDivider(),
          // Tappable Activity row navigating to Activity Details
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ActivityDetailsScreen(),
                ),
              );
            },
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ACTIVITY',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.05,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.sessionTitle,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        color: _stoneGrey,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      color: Colors.white.withValues(alpha: 0.08),
      height: 1,
    );
  }

  // ===========================================================================
  // SECTION 3: RECORDED METRICS GRID
  // ===========================================================================

  Widget _buildRecordedMetricsGrid() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      child: Column(
        children: [
          // Row 1: Distance & Sets
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'DISTANCE',
                  value: _distance,
                  onTap: () => _showMetricBreakdown(
                    'DISTANCE',
                    _distance,
                    'Target was 1.5 km. Achieved +300m bonus volume in open water.',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  label: 'SETS',
                  value: _sets,
                  onTap: () => _showMetricBreakdown(
                    'SETS',
                    _sets,
                    '6 total work sets completed with consistent cadence.',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Row 2: Rest Time & Intensity
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'REST TIME',
                  value: _restTime,
                  onTap: () => _showMetricBreakdown(
                    'REST TIME',
                    _restTime,
                    'Strict rest intervals maintained between swimming bouts.',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  label: 'INTENSITY',
                  value: _intensity,
                  onTap: () => _showMetricBreakdown(
                    'INTENSITY',
                    _intensity,
                    'Target rate of perceived exertion: 8.5/10 (High threshold).',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Row 3: Repetitions
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'REPETITIONS',
                  value: _repetitions,
                  onTap: () => _showMetricBreakdown(
                    'REPETITIONS',
                    _repetitions,
                    '12 water entry and retrieve repetitions logged.',
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.05,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 4: NOTES CARD
  // ===========================================================================

  Widget _buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'NOTES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.05,
                ),
              ),
              InkWell(
                onTap: _showEditNotesDialog,
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _currentNotes,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.48,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNotesDialog() {
    final ctrl = TextEditingController(text: _currentNotes);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: _hairlineSide,
        ),
        title: const Text(
          'Edit Session Notes',
          style: TextStyle(color: _offWhite, fontSize: 17),
        ),
        content: TextField(
          controller: ctrl,
          maxLines: 5,
          style: const TextStyle(color: _offWhite, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: _obsidian,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: _hairlineSide,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: _offWhite,
            ),
            onPressed: () {
              setState(() => _currentNotes = ctrl.text.trim());
              Navigator.pop(ctx);
              AppSnackbar.show(
                context,
                message: 'Session notes updated',
                type: SnackbarType.success,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 5: EQUIPMENT USED CARD
  // ===========================================================================

  Widget _buildEquipmentCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'EQUIPMENT',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EquipmentScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: _mint,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, color: _mint, size: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildDivider(),
          _buildEquipmentItem(
            name: 'Flotation Vest',
            onTap: () => _showEquipmentSpecs(
              'Flotation Vest',
              'Non-restrictive ergonomic canine life jacket with dual rescue handle and high-buoyancy foam for heavy swim conditioning.',
            ),
          ),
          _buildDivider(),
          _buildEquipmentItem(
            name: 'Swim Leash',
            onTap: () => _showEquipmentSpecs(
              'Swim Leash',
              'Biothane 10-meter floating tracking line with stainless marine swivel snap for controlled open water towing drills.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentItem({
    required String name,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.construction,
                  color: _stoneGrey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.chevron_right,
              color: _stoneGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 6: MEDIA GRID (3x2)
  // ===========================================================================

  Widget _buildMediaGridSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'MEDIA',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.05,
              ),
            ),
            InkWell(
              onTap: _showAllMediaGallery,
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'View All (9)',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final item = _mediaItems[index];
            return GestureDetector(
              onTap: () => _openMediaLightbox(index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: _hairlineBorder,
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      item.url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: _carbon,
                        child: const Icon(Icons.photo, color: _stoneGrey),
                      ),
                    ),
                    if (item.isVideo)
                      Container(
                        color: Colors.black26,
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: _mint,
                            size: 32,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // SECTION 7: PERSONAL BEST BANNER
  // ===========================================================================

  Widget _buildPersonalBestCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Mint Accent Stripe (Animated glow)
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, _) => Container(
                width: 4,
                color: _mint.withValues(alpha: _glowAnimation.value),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.emoji_events, color: _mint, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'NEW PERSONAL BEST',
                              style: TextStyle(
                                color: _mint,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.05,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Longest Session',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Previous: 1h 15m (12 Jun 2026)',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.durationText,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 8: BOTTOM ACTION CTAS
  // ===========================================================================

  Widget _buildBottomActions() {
    return Column(
      children: [
        // Primary: Edit Session
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: _offWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _openEditSession,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, size: 18),
                SizedBox(width: 8),
                Text(
                  'Edit Session',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Secondary: Delete Session
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: _errorRed,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          ),
          onPressed: _confirmDeleteSession,
          child: const Text(
            'Delete Session',
            style: TextStyle(
              color: _errorRed,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Local Data Model for Media ───────────────────────────────────────────────

class _SessionMediaItem {
  final String url;
  final String caption;
  final bool isVideo;

  const _SessionMediaItem({
    required this.url,
    required this.caption,
    required this.isVideo,
  });
}

// ─── Fullscreen Lightbox Viewer ───────────────────────────────────────────────

class _MediaLightboxViewer extends StatefulWidget {
  final List<_SessionMediaItem> items;
  final int initialIndex;

  const _MediaLightboxViewer({
    required this.items,
    required this.initialIndex,
  });

  @override
  State<_MediaLightboxViewer> createState() => _MediaLightboxViewerState();
}

class _MediaLightboxViewerState extends State<_MediaLightboxViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = widget.items[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.94),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} of ${widget.items.length}',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (idx) {
                setState(() {
                  _currentIndex = idx;
                  _isPlaying = false;
                });
              },
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Center(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 3.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          item.url,
                          fit: BoxFit.contain,
                          loadingBuilder: (ctx, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF95D3BB),
                              ),
                            );
                          },
                        ),
                        if (item.isVideo)
                          GestureDetector(
                            onTap: () {
                              setState(() => _isPlaying = !_isPlaying);
                            },
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill,
                                color: const Color(0xFF95D3BB),
                                size: 52,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Text(
              currentItem.caption,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
