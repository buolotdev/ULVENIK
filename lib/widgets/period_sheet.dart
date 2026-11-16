import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

const kPeriods = ['Lifetime', 'This Year', 'Last 6 Months', 'This Month'];

/// Start of the chosen period, or null for Lifetime.
DateTime? periodStart(String period) {
  final n = DateTime.now();
  switch (period) {
    case 'This Year':
      return DateTime(n.year);
    case 'Last 6 Months':
      return DateTime(n.year, n.month - 6, n.day);
    case 'This Month':
      return DateTime(n.year, n.month);
    default:
      return null;
  }
}

/// "Select Time Period" bottom sheet used by Training and S&C analytics.
/// Returns the chosen period (selected one shows a green tick).
Future<String?> showPeriodSheet(BuildContext context, String current) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Select Time Period',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          for (final p in kPeriods)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(p, style: const TextStyle(color: AppColors.primaryTextOffWhite)),
              trailing: p == current ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
              onTap: () => Navigator.pop(ctx, p),
            ),
        ]),
      ),
    ),
  );
}
