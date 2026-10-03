import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class SkillDetailsScreen extends StatelessWidget {
  final String skillName;

  const SkillDetailsScreen({super.key, required this.skillName});

  void _toast(BuildContext context, String msg) {
    AppSnackbar.show(context, message: msg, type: SnackbarType.info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundObsidian,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AppBar(
              backgroundColor: AppColors.backgroundObsidian.withOpacity(0.7),
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Skill Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primaryTextOffWhite),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primaryTextOffWhite),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeroSection(),
          const SizedBox(height: 24),
          _buildQuickActions(context),
          const SizedBox(height: 32),
          _buildGoalsSection(),
          const SizedBox(height: 32),
          _buildExercisesSection(context),
          const SizedBox(height: 32),
          _buildRecentSessions(),
          const SizedBox(height: 32),
          _buildMediaSection(context),
          const SizedBox(height: 32),
          _buildNotesSection(context),
          const SizedBox(height: 32),
          _buildTimelineSection(),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: 360,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDY3-D7uDa6UVSFWdzwIDiVgIXMfrPq8xUIF00RNYpeYcXHFhC4SIwPHWloidY-mly7XhrzMlw_zKvuxoL8dKgv5lgSNs6NzNoBS3gKFBJOk7eDPxyPazW65y37IPvR7GaJrb1ceoTA7VocVqJbNN_Gj1ovA89vv5JgFL6W3163VK2DHOqk9jLb1SBRLCYOk-z9QQupHmc0yYEvGZzG6vN3p2yszP28oURDUoFUFvvy55R49XWjzv0',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.backgroundObsidian,
                    AppColors.backgroundObsidian.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _tag('FOUNDATION'),
                    const SizedBox(width: 8),
                    _tag('OUTDOOR'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  skillName,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Returning immediately to the handler upon command, regardless of distractions. Essential for safety and advanced off-lead work.',
                  style: TextStyle(fontSize: 14, color: AppColors.secondaryTextStoneGrey, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon.withOpacity(0.5),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _actionBtn(context, Icons.play_arrow, 'Record', true)),
          const SizedBox(width: 12),
          Expanded(child: _actionBtn(context, Icons.add, 'Exercise', false)),
          const SizedBox(width: 12),
          Expanded(child: _actionBtn(context, Icons.edit, 'Edit', false)),
        ],
      ),
    );
  }

  Widget _actionBtn(BuildContext context, IconData icon, String label, bool isPrimary) {
    final color = isPrimary ? AppColors.primaryForestGreen : AppColors.secondarySage;
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _toast(context, '$label tapped'),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Goal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reliable Off-Lead Recall', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                          SizedBox(height: 4),
                          Text('Target: 95% success rate in high-distraction environments.', style: TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryForestGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.primaryForestGreen.withOpacity(0.3)),
                      ),
                      child: const Text('ACTIVE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.primaryForestGreen)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryForestGreen),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PROGRESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.secondaryTextStoneGrey)),
                    Text('70%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.primaryForestGreen)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Exercises', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              TextButton.icon(
                onPressed: () => _toast(context, 'Add Exercise tapped'),
                icon: const Icon(Icons.add, size: 16, color: AppColors.primaryForestGreen),
                label: const Text('Add', style: TextStyle(color: AppColors.primaryForestGreen, fontSize: 13, fontWeight: FontWeight.w500)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _exerciseCard(context, 'Emergency Recall (Whistle)', '24 Sessions total'),
          const SizedBox(height: 8),
          _exerciseCard(context, 'Recall Through Distractions', '12 Sessions total'),
        ],
      ),
    );
  }

  Widget _exerciseCard(BuildContext context, String title, String subtitle) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _toast(context, '$title details'),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
                ],
              ),
              const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSessions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 12),
          _sessionCard('22 JULY 2026', true, 'Emergency Recall', '15m', 'Woods'),
          const SizedBox(height: 12),
          _sessionCard('20 JULY 2026', false, 'Recall Through Distractions', '20m', 'Park'),
        ],
      ),
    );
  }

  Widget _sessionCard(String date, bool isGreat, String title, String time, String location) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.secondaryTextStoneGrey)),
              Row(
                children: [
                  Icon(isGreat ? Icons.star : Icons.remove, size: 14, color: isGreat ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey),
                  const SizedBox(width: 4),
                  Text(isGreat ? 'GREAT' : 'NEUTRAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: isGreat ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 14, color: AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 4),
              Text(time, style: const TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
              const SizedBox(width: 16),
              const Icon(Icons.park_outlined, size: 14, color: AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 4),
              Text(location, style: const TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Media', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _mediaThumb(context, 'https://lh3.googleusercontent.com/aida-public/AB6AXuAWdcOCoMvbNFAGZR3-ZeA-ng9wdnZWH0A8hqEnQjIjOrAESkliugFTkFXqKqK39CxGhYAuWzTV2VXb_IiPYna8RmjZSORcUAmPvLahrByZGKy0RY9SWPUjHKVRoYXUz1ju_UCBPaJCU6BvtvtEqhu3fJ_IHDlLgWjrJxMjuLp1Zg9ShY9djAmSbT3hSnQRZaCayhAw4B44G7dLTyZCa-COeORAJyYehWXnZ4uMWJRhLAtBGqG6HaI', false),
              const SizedBox(width: 12),
              _mediaThumb(context, 'https://lh3.googleusercontent.com/aida-public/AB6AXuCa2aWzuH0UPmHSQgCMt7frfI2jQ_NcJNZ_N0djoUVIoyPvQwYoZBrmOmsTWvPc7_2uRxQyxC6-YAZt_umSvYPQI_9rTFLUSpMem6ipS-l-HiJ6nY6i7uWrEpoD9gpYPLfLDhEHwRoenhR-0B5y2bnL4uPY1Gw7a956QhJsWtIPbFahQCBB3ksytPtlzGWHzi1qQcT6byT5cwpl65EI98dXW75C-dA86xu1NEdp8wInj7BmnBEufAU', true),
              const SizedBox(width: 12),
              _mediaThumb(context, 'https://lh3.googleusercontent.com/aida-public/AB6AXuBO3BowfrjkdK40p267-lzO09xEWnNX0iq90gZVi1s-sTLTUl8bTQyZ4swRy5qcCwmWf_jjlIKI5YxoQrGjIOzMhUiaIczXVfOBdMD6udvDPLdWBnYb1w-BJLCoMll3LqB62JQsHU3_mlJ2uzTxM55WuPojySqEKcNOwRuCUYMRf_HYFKkoJSbdj8NEjHR3EC2zQavX3EIJj0gfFYDLKgWJRLb_Z2pwTvEq79Pr_gez-QZV9vloylo', false),
              const SizedBox(width: 12),
              _mediaThumb(context, 'https://lh3.googleusercontent.com/aida-public/AB6AXuDwH3FVo8zqd_wGLwquwjabB2HTKLkb9X1X7LbiRm6AJIW4iZcpfSMQ2NZQmHM_TkBnOXGlMLXww4yFK947McK_d2iyHDoNou7LvE9QVjnhlUP3pA4AweNpizBGe5ERh4VT5CJxfvoHy6aG4vtb4n1od_t5KsDMn8drswas_caOYspXo1r_l7X7BYplrn5D9GduG79Kq1k9ai0FrRFqas6w_i_txfqJHXSnlf4YkEj5wMipNcUdNP4', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mediaThumb(BuildContext context, String url, bool isVideo) {
    return GestureDetector(
      onTap: () => _toast(context, 'View media'),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(url, fit: BoxFit.cover),
              if (isVideo)
                Container(
                  color: Colors.black38,
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              TextButton.icon(
                onPressed: () => _toast(context, 'Edit notes'),
                icon: const Icon(Icons.edit, size: 16, color: AppColors.secondarySage),
                label: const Text('Edit', style: TextStyle(color: AppColors.secondarySage, fontSize: 13, fontWeight: FontWeight.w500)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: const Text(
              'Currently responding well to the whistle, but environmental distractions (especially other dogs playing) are still causing hesitation. Need to increase reward value in high-distraction scenarios and work more on intermediate distances before pushing range.',
              style: TextStyle(fontSize: 14, color: AppColors.secondaryTextStoneGrey, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Skill History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 16),
          _timelineItem('TODAY', AppColors.primaryForestGreen, 'Training Session', 'Practiced whistle recall in the woods. Solid response.'),
          _timelineItem('15 JULY 2026', AppColors.secondarySage, 'Goal Updated', 'Target adjusted to 95% success rate.'),
          _timelineItem('10 JULY 2026', AppColors.secondaryTextStoneGrey, 'Training Session', 'Struggled with distractions at the park. Shortened distance.', isLast: true),
        ],
      ),
    );
  }

  Widget _timelineItem(String date, Color color, String title, String desc, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: Colors.white12,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: color)),
                  const SizedBox(height: 4),
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
