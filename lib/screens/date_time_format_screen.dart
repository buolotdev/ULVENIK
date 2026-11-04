import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _DateFormatChoice {
  final String id;
  final String label;
  final String? trailingSample;
  final String currentCardDate;
  final String trainingSessionDate;
  final String reminderDate;

  const _DateFormatChoice({
    required this.id,
    required this.label,
    required this.trailingSample,
    required this.currentCardDate,
    required this.trainingSessionDate,
    required this.reminderDate,
  });
}

class DateTimeFormatScreen extends StatefulWidget {
  const DateTimeFormatScreen({super.key});

  @override
  State<DateTimeFormatScreen> createState() => _DateTimeFormatScreenState();
}

class _DateTimeFormatScreenState extends State<DateTimeFormatScreen> {
  // Saved baseline state (defaults match Figma)
  bool _savedUseRegionalFormat = false;
  String _savedDateFormatId = 'long_dmy';
  bool _savedIs24Hour = true;
  bool _savedStartsMonday = true;

  // Working state
  bool _useRegionalFormat = false;
  String _dateFormatId = 'long_dmy';
  bool _is24Hour = true;
  bool _startsMonday = true;

  static const List<_DateFormatChoice> _dateFormats = [
    _DateFormatChoice(
      id: 'long_dmy',
      label: '29 July 2026',
      trailingSample: null,
      currentCardDate: '29 July 2026',
      trainingSessionDate: 'Wednesday 29 July 2026',
      reminderDate: 'Thursday 30 July 2026',
    ),
    _DateFormatChoice(
      id: 'dd_mm_yyyy',
      label: 'DD/MM/YYYY',
      trailingSample: '29/07/2026',
      currentCardDate: '29/07/2026',
      trainingSessionDate: 'Wednesday, 29/07/2026',
      reminderDate: 'Thursday, 30/07/2026',
    ),
    _DateFormatChoice(
      id: 'mm_dd_yyyy',
      label: 'MM/DD/YYYY',
      trailingSample: '07/29/2026',
      currentCardDate: '07/29/2026',
      trainingSessionDate: 'Wednesday, 07/29/2026',
      reminderDate: 'Thursday, 07/30/2026',
    ),
    _DateFormatChoice(
      id: 'yyyy_mm_dd',
      label: 'YYYY-MM-DD',
      trailingSample: '2026-07-29',
      currentCardDate: '2026-07-29',
      trainingSessionDate: 'Wednesday, 2026-07-29',
      reminderDate: 'Thursday, 2026-07-30',
    ),
    _DateFormatChoice(
      id: 'short_dmy',
      label: '29 Jul 2026',
      trailingSample: '29 Jul 2026',
      currentCardDate: '29 Jul 2026',
      trainingSessionDate: 'Wednesday 29 Jul 2026',
      reminderDate: 'Thursday 30 Jul 2026',
    ),
  ];

  _DateFormatChoice get _selectedDate => _dateFormats.firstWhere(
        (d) => d.id == _dateFormatId,
        orElse: () => _dateFormats.first,
      );

  bool get _hasPendingChanges =>
      _useRegionalFormat != _savedUseRegionalFormat ||
      _dateFormatId != _savedDateFormatId ||
      _is24Hour != _savedIs24Hour ||
      _startsMonday != _savedStartsMonday;

  String get _sampleClockSingle => _is24Hour ? '14:35' : '2:35 PM';

  String get _trainingTimeRange =>
      _is24Hour ? '14:35 – 15:20' : '2:35 PM – 3:20 PM';

  String get _reminderTime => _is24Hour ? '09:00' : '9:00 AM';

  String get _weekStartSummary =>
      _startsMonday ? 'Week starts Monday' : 'Week starts Sunday';

  String get _previewWeekHeading =>
      _startsMonday ? 'Week begins Monday' : 'Week begins Sunday';

  String get _previewWeekDays => _startsMonday
      ? 'Mon · Tue · Wed · Thu · Fri · Sat · Sun'
      : 'Sun · Mon · Tue · Wed · Thu · Fri · Sat';

  void _toggleRegionalFormat(bool value) {
    setState(() {
      _useRegionalFormat = value;
      if (value) {
        // United Kingdom regional convention
        _dateFormatId = 'long_dmy';
        _is24Hour = true;
        _startsMonday = true;
      }
    });
  }

  void _selectDateFormat(String id) {
    setState(() {
      _dateFormatId = id;
      if (id != 'long_dmy' && _useRegionalFormat) {
        _useRegionalFormat = false;
      }
    });
  }

  void _selectTimeFormat(bool is24Hour) {
    setState(() {
      _is24Hour = is24Hour;
      if (!is24Hour && _useRegionalFormat) {
        _useRegionalFormat = false;
      }
    });
  }

  void _selectFirstDayOfWeek(bool startsMonday) {
    setState(() {
      _startsMonday = startsMonday;
      if (!startsMonday && _useRegionalFormat) {
        _useRegionalFormat = false;
      }
    });
  }

  void _saveFormat() {
    if (!_hasPendingChanges) {
      AppSnackbar.show(
        context,
        title: 'Format Active',
        message:
            '${_selectedDate.currentCardDate} · ${_is24Hour ? '24-Hour' : '12-Hour'} is already active.',
        type: SnackbarType.info,
      );
      return;
    }

    setState(() {
      _savedUseRegionalFormat = _useRegionalFormat;
      _savedDateFormatId = _dateFormatId;
      _savedIs24Hour = _is24Hour;
      _savedStartsMonday = _startsMonday;
    });

    AppSnackbar.show(
      context,
      title: 'Date & Time Saved',
      message:
          'Displaying ${_selectedDate.currentCardDate} · $_sampleClockSingle · $_weekStartSummary.',
      type: SnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Container(height: 1, color: AppColors.cardBorder),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('CURRENT FORMAT'),
                    const SizedBox(height: 10),
                    _buildCurrentFormatCard(),
                    const SizedBox(height: 14),
                    _buildRegionalFormatCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('DATE FORMAT'),
                    const SizedBox(height: 10),
                    _buildDateFormatCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('TIME FORMAT'),
                    const SizedBox(height: 10),
                    _buildTimeFormatCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('FIRST DAY OF WEEK'),
                    const SizedBox(height: 10),
                    _buildFirstDayOfWeekCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('PREVIEW'),
                    const SizedBox(height: 10),
                    _buildPreviewCard(),
                  ],
                ),
              ),
            ),
            _buildBottomSaveDock(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final savedChoice = _dateFormats.firstWhere(
      (d) => d.id == _savedDateFormatId,
      orElse: () => _dateFormats.first,
    );
    final returnSummary =
        '${savedChoice.label} · ${_savedIs24Hour ? '24-hour' : '12-hour'}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(returnSummary),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.secondaryTextStoneGrey,
              size: 26,
            ),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 2),
          const Expanded(
            child: Text(
              'Date & Time Format',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextOffWhite,
              ),
            ),
          ),
          GestureDetector(
            onTap: _saveFormat,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _hasPendingChanges
                      ? const Color(0xFF4CA384)
                      : AppColors.primaryForestGreen.withValues(alpha: 0.48),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
          color: AppColors.secondaryTextStoneGrey,
        ),
      ),
    );
  }

  Widget _buildCurrentFormatCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.calendar_month_outlined,
              size: 22,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedDate.currentCardDate,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: AppColors.primaryTextOffWhite,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _sampleClockSingle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _weekStartSummary,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionalFormatCard() {
    return GestureDetector(
      onTap: () => _toggleRegionalFormat(!_useRegionalFormat),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.language_rounded,
              size: 20,
              color: AppColors.secondaryTextStoneGrey,
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use Regional Format',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextOffWhite,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Follows date and time conventions for your selected country',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      height: 1.35,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _UlvenikPillSwitch(
              value: _useRegionalFormat,
              onChanged: _toggleRegionalFormat,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFormatCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          children: [
            for (int i = 0; i < _dateFormats.length; i++) ...[
              if (i > 0) Container(height: 1, color: AppColors.cardBorder),
              _buildSelectableOptionRow(
                title: _dateFormats[i].label,
                trailingText: _dateFormats[i].trailingSample,
                isSelected: _dateFormatId == _dateFormats[i].id,
                onTap: () => _selectDateFormat(_dateFormats[i].id),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFormatCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          children: [
            _buildSelectableOptionRow(
              title: '24-Hour',
              trailingText: '14:35',
              isSelected: _is24Hour,
              onTap: () => _selectTimeFormat(true),
            ),
            Container(height: 1, color: AppColors.cardBorder),
            _buildSelectableOptionRow(
              title: '12-Hour',
              trailingText: '2:35 PM',
              isSelected: !_is24Hour,
              onTap: () => _selectTimeFormat(false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstDayOfWeekCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          children: [
            _buildSelectableOptionRow(
              title: 'Monday',
              trailingText: 'Mon · Tue · Wed...',
              isSelected: _startsMonday,
              onTap: () => _selectFirstDayOfWeek(true),
            ),
            Container(height: 1, color: AppColors.cardBorder),
            _buildSelectableOptionRow(
              title: 'Sunday',
              trailingText: 'Sun · Mon · Tue...',
              isSelected: !_startsMonday,
              onTap: () => _selectFirstDayOfWeek(false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableOptionRow({
    required String title,
    required String? trailingText,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected
          ? AppColors.primaryForestGreen.withValues(alpha: 0.14)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 3,
                color: isSelected
                    ? AppColors.primaryForestGreen
                    : Colors.transparent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 16, 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryTextOffWhite,
                          ),
                        ),
                      ),
                      if (trailingText != null)
                        Text(
                          trailingText,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                        ),
                      if (isSelected) ...[
                        if (trailingText != null) const SizedBox(width: 10),
                        const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: AppColors.primaryForestGreen,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPreviewBlock(
            overline: 'TRAINING SESSION',
            primaryText: _selectedDate.trainingSessionDate,
            secondaryText: _trainingTimeRange,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Container(height: 1, color: AppColors.cardBorder),
          ),
          _buildPreviewBlock(
            overline: 'REMINDER',
            primaryText: _selectedDate.reminderDate,
            secondaryText: _reminderTime,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Container(height: 1, color: AppColors.cardBorder),
          ),
          _buildPreviewBlock(
            overline: 'CALENDAR WEEK',
            primaryText: _previewWeekHeading,
            secondaryText: _previewWeekDays,
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'Historical records remain unchanged. Only how they\nare displayed will change.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                height: 1.45,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewBlock({
    required String overline,
    required String primaryText,
    required String secondaryText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          overline,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.25,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          primaryText,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextOffWhite,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          secondaryText,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.5,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSaveDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _saveFormat,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasPendingChanges
                ? AppColors.primaryForestGreen
                : const Color(0xFF1A332B),
            foregroundColor: _hasPendingChanges
                ? AppColors.primaryTextOffWhite
                : AppColors.secondarySage,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Save Date & Time Format',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _UlvenikPillSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _UlvenikPillSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 46,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? AppColors.primaryForestGreen : const Color(0xFF343A3D),
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value
                  ? AppColors.primaryTextOffWhite
                  : const Color(0xFFB7BFBA),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
