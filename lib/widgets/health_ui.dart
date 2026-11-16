import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../data/app_settings.dart';
import 'ulvenik_icon.dart';

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// Dates and times follow the saved Regional Preferences. The stored value is
/// never changed — only how it is shown.
String fmtDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  switch (AppSettings.instance.dateFormat) {
    case 'DD/MM/YYYY':
      return '$dd/$mm/${d.year}';
    case 'MM/DD/YYYY':
      return '$mm/$dd/${d.year}';
    case 'YYYY-MM-DD':
      return '${d.year}-$mm-$dd';
    default:
      return '${d.day} ${_months[d.month - 1]} ${d.year}';
  }
}

String fmtShort(DateTime d) => '${d.day} ${_months[d.month - 1]}';

String fmtTime(DateTime d) {
  final m = d.minute.toString().padLeft(2, '0');
  if (AppSettings.instance.clock24) return '${d.hour.toString().padLeft(2, '0')}:$m';
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  return '$h:$m ${d.hour < 12 ? 'AM' : 'PM'}';
}

/// Weight shown in the preferred unit (kg / lb); the saved entry keeps its own unit.
double toPrefWeight(double kg) => AppSettings.instance.weightUnit == 'lb' ? kg / 0.45359237 : kg;
String prefWeightUnit() => AppSettings.instance.weightUnit;
String fmtKg(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

const kHealthGreen = AppColors.secondarySage;

/// Standard Health screen scaffold: back arrow, centred title, optional ⋮ menu.
class HealthScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottom;
  const HealthScaffold({super.key, required this.title, required this.body, this.actions, this.bottom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(title,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          tooltip: 'Back',
          icon: const UlvenikIcon(UlvenikIcons.back, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: bottom == null
          ? null
          : SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 12), child: bottom)),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final String? icon;
  final VoidCallback onPressed;
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : UlvenikIcon(icon!, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryForestGreen,
          foregroundColor: AppColors.primaryTextOffWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class HealthCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  const HealthCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white12)),
          child: child,
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  const EmptyState(
      {super.key, required this.icon, required this.title, required this.message, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryForestGreen.withValues(alpha: 0.15)),
          child: Icon(icon, color: kHealthGreen, size: 26),
        ),
        const SizedBox(height: 16),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5, height: 1.4)),
        if (actionLabel != null) ...[
          const SizedBox(height: 18),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryForestGreen,
                foregroundColor: AppColors.primaryTextOffWhite,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(actionLabel!, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ]),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionLabel(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Row(children: [
        Expanded(
          child: Text(text,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
        ),
        ?trailing,
      ]),
    );
  }
}

InputDecoration healthDecoration(String hint, {String? error, String? suffix}) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
      errorText: error,
      suffixText: suffix,
      suffixStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
      errorStyle: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5),
      filled: true,
      fillColor: AppColors.cardsCarbon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryForestGreen)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF8B3A3A))),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFB04A4A))),
    );

class FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  const FieldLabel(this.text, {super.key, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 18),
      child: Text(required ? '$text *' : '$text (optional)',
          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, fontWeight: FontWeight.w600)),
    );
  }
}

/// Tappable date field; past dates are allowed (historic records).
class DateField extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String hint;
  final String? error;
  final bool allowFuture;
  const DateField(
      {super.key,
      required this.value,
      required this.onChanged,
      this.hint = 'Select date',
      this.error,
      this.allowFuture = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(1990),
          lastDate: allowFuture ? DateTime(now.year + 10) : now,
          builder: (c, w) => Theme(
            data: Theme.of(c).copyWith(
                colorScheme: const ColorScheme.dark(
                    primary: AppColors.primaryForestGreen, surface: AppColors.cardsCarbon)),
            child: w!,
          ),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: healthDecoration(hint, error: error).copyWith(
          suffixIcon: const UlvenikIcon(UlvenikIcons.calendar, size: 18, color: AppColors.secondaryTextStoneGrey),
          suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 20),
        ),
        child: Text(value == null ? hint : fmtDate(value!),
            style: TextStyle(
                color: value == null ? AppColors.secondaryTextStoneGrey : AppColors.primaryTextOffWhite,
                fontSize: 14.5)),
      ),
    );
  }
}

/// Choice chips for short option lists.
class ChoiceRow extends StatelessWidget {
  final List<String> options;
  final String? value;
  final ValueChanged<String> onChanged;
  const ChoiceRow({super.key, required this.options, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8, children: [
      for (final o in options)
        ChoiceChip(
          label: Text(o),
          selected: o == value,
          onSelected: (_) => onChanged(o),
          showCheckmark: false,
          labelStyle: TextStyle(
              color: o == value ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey, fontSize: 13),
          backgroundColor: AppColors.cardsCarbon,
          selectedColor: AppColors.primaryForestGreen,
          side: const BorderSide(color: Colors.white12),
        ),
    ]);
  }
}

Future<bool> confirmDelete(BuildContext context, {required String title, required String message}) async {
  final r = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(title,
              style: const TextStyle(color: Color(0xFFFFB4AB), fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.4)),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Delete', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.white12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Cancel', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15)),
            ),
          ),
        ]),
      ),
    ),
  );
  return r ?? false;
}

/// ⋮ menu with Edit Record / Delete Record.
class RecordMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const RecordMenu({super.key, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'More',
      icon: const UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                leading: const UlvenikIcon(UlvenikIcons.edit, color: AppColors.primaryTextOffWhite),
                title: const Text('Edit Record', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  onEdit();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                title: const Text('Delete Record', style: TextStyle(color: Color(0xFFFFB4AB))),
                onTap: () {
                  Navigator.pop(ctx);
                  onDelete();
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
