import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Optional handler-chosen session rating, shared by Training, S&C and Sport.
///
/// Approved labels (Training Tab Review v50): Excellent, Good, Mixed and
/// Needs Work. Ulvenik never assigns a rating automatically.
enum SessionRating {
  excellent('Excellent', 'Exceeded expectations'),
  good('Good', 'Met expectations'),
  mixed('Mixed', 'Some areas went well, others need improvement'),
  needsWork('Needs Work', 'Below expectations');

  const SessionRating(this.label, this.description);

  final String label;
  final String description;

  /// Integer form used by older session models: 4 = Excellent … 1 = Needs
  /// Work, 0 = not rated.
  int get score => 4 - index;

  static SessionRating? fromScore(int? score) {
    switch (score) {
      case 4:
        return SessionRating.excellent;
      case 3:
        return SessionRating.good;
      case 2:
        return SessionRating.mixed;
      case 1:
        return SessionRating.needsWork;
      default:
        return null;
    }
  }
}

/// Opens the refined rating bottom sheet. [onChanged] receives the new
/// rating, or null when the user clears it. Dismissing changes nothing.
Future<void> showSessionRatingSheet(
  BuildContext context, {
  required SessionRating? current,
  required ValueChanged<SessionRating?> onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Session rating',
              style: TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Optional. Choose how you felt the session went.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            for (final r in SessionRating.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  r.label,
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  r.description,
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
                ),
                trailing: r == current
                    ? Icon(Icons.check, color: AppColors.primaryForestGreen, size: 22)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  onChanged(r);
                },
              ),
            if (current != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onChanged(null);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondaryTextStoneGrey,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('Clear rating'),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

/// Compact badge showing a saved rating. Render nothing when unrated.
class SessionRatingBadge extends StatelessWidget {
  final SessionRating? rating;
  final VoidCallback? onTap;

  const SessionRatingBadge({super.key, required this.rating, this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = rating;
    if (r == null) return const SizedBox.shrink();
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryForestGreen.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        r.label,
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    if (onTap == null) return badge;
    return Semantics(
      button: true,
      label: 'Rating: ${r.label}. Tap to change',
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: badge,
      ),
    );
  }
}

/// A form row used in recording/details screens: shows the current rating
/// (or "Not rated") and opens [showSessionRatingSheet] on tap.
class SessionRatingField extends StatelessWidget {
  final SessionRating? value;
  final ValueChanged<SessionRating?>? onChanged;
  final String label;

  const SessionRatingField({
    super.key,
    required this.value,
    this.onChanged,
    this.label = 'Session rating (optional)',
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: enabled
          ? () => showSessionRatingSheet(context, current: value, onChanged: onChanged!)
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  const SizedBox(height: 4),
                  Text(
                    value?.label ?? 'Not rated',
                    style: TextStyle(
                      color: value == null ? AppColors.secondaryTextStoneGrey : AppColors.primaryTextOffWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (value != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(value!.description,
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                    ),
                ],
              ),
            ),
            if (enabled)
              Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey),
          ],
        ),
      ),
    );
  }
}
