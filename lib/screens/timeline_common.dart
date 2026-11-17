import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../data/timeline_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';
import '../widgets/period_sheet.dart';
import '../widgets/ulvenik_icon.dart';

const kAllDogs = '__all__';
const kAllCategories = 'All Categories';

/// A date scope: one of the shared presets or an inclusive custom range.
class TlPeriod {
  final String kind; // Lifetime | This Year | Last 6 Months | This Month | Custom
  final DateTime? from;
  final DateTime? to;
  const TlPeriod(this.kind, {this.from, this.to});
  static const lifetime = TlPeriod('Lifetime');

  DateTime? get start => kind == 'Custom' ? from : periodStart(kind);
  DateTime? get end => kind == 'Custom' && to != null ? DateTime(to!.year, to!.month, to!.day, 23, 59, 59) : null;

  bool contains(DateTime d) {
    final s = start;
    final e = end;
    return (s == null || !d.isBefore(s)) && (e == null || !d.isAfter(e));
  }

  String get label => kind == 'Custom' && from != null && to != null ? '${fmtDate(from!)} – ${fmtDate(to!)}' : kind;
}

/// Period selector with Custom (labelled Start/End dates, Apply / Cancel).
Future<TlPeriod?> showTlPeriodSheet(BuildContext context, TlPeriod current) async {
  final choice = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Select Time Period',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          for (final p in [...kPeriods, 'Custom'])
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(p, style: const TextStyle(color: AppColors.primaryTextOffWhite)),
              subtitle: p == 'Custom' && current.kind == 'Custom'
                  ? Text(current.label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12))
                  : null,
              trailing: p == current.kind ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
              onTap: () => Navigator.pop(ctx, p),
            ),
        ]),
      ),
    ),
  );
  if (choice == null || !context.mounted) return null;
  if (choice != 'Custom') return TlPeriod(choice);
  return showCustomRangeSheet(context, current.kind == 'Custom' ? current : null);
}

Future<TlPeriod?> showCustomRangeSheet(BuildContext context, TlPeriod? initial) {
  DateTime? from = initial?.from;
  DateTime? to = initial?.to;
  String? error;
  return showModalBottomSheet<TlPeriod>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Custom Dates',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const FieldLabel('Start Date', required: true),
            DateField(value: from, onChanged: (d) => setSheet(() => from = d), allowFuture: false),
            const FieldLabel('End Date', required: true),
            DateField(value: to, onChanged: (d) => setSheet(() => to = d), allowFuture: false),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(error!, style: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
              ),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTextOffWhite,
                      side: const BorderSide(color: Colors.white24),
                      minimumSize: const Size(0, 50)),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryButton(
                  label: 'Apply Dates',
                  onPressed: () {
                    if (from == null || to == null) {
                      setSheet(() => error = 'Choose both a start and an end date.');
                    } else if (to!.isBefore(from!)) {
                      setSheet(() => error = 'The end date can’t be before the start date.');
                    } else {
                      Navigator.pop(ctx, TlPeriod('Custom', from: from, to: to));
                    }
                  },
                ),
              ),
            ]),
          ]),
        ),
      ),
    ),
  );
}

/// Single-choice category picker (immediate apply, green tick).
Future<String?> showCategorySheet(BuildContext context, String current, {List<String>? categories}) =>
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Select Category',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            for (final c in [kAllCategories, ...(categories ?? kTimelineCategories)])
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(c, style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                trailing: c == current ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                onTap: () => Navigator.pop(ctx, c),
              ),
          ]),
        ),
      ),
    );

/// Dog scope picker. Returns [kAllDogs] for All Dogs, a dog name, or null when
/// dismissed (nothing changes).
Future<String?> showDogSheet(BuildContext context, String current, {bool allowAll = true}) =>
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Switch Dog',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            if (allowAll)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('All Dogs', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                trailing: current == kAllDogs ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                onTap: () => Navigator.pop(ctx, kAllDogs),
              ),
            for (final d in SampleData.myDogs)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(d.name, style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                subtitle: Text(d.details, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                trailing: current == d.name ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                onTap: () => Navigator.pop(ctx, d.name),
              ),
          ]),
        ),
      ),
    );

/// Compact dog header: photo (rounded square), name, breed · sex · age and
/// Switch Dog. "All Dogs" scope shows one clear label.
class TimelineDogHeader extends StatelessWidget {
  final String dog; // kAllDogs or a name
  final VoidCallback onSwitch;
  const TimelineDogHeader({super.key, required this.dog, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    final all = dog == kAllDogs;
    final info = all ? null : SampleData.dogNamed(dog);
    return Row(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 44,
          height: 44,
          child: info?.photoProvider == null
              ? ColoredBox(
                  color: AppColors.cardsCarbon,
                  child: Center(
                    child: Text(all ? 'All' : dog.isEmpty ? '?' : dog[0],
                        style: const TextStyle(color: AppColors.secondarySage, fontWeight: FontWeight.w700)),
                  ),
                )
              : Image(image: info!.photoProvider!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => ColoredBox(
                      color: AppColors.cardsCarbon,
                      child: Center(
                          child: Text(dog[0],
                              style: const TextStyle(color: AppColors.secondarySage, fontWeight: FontWeight.w700))))),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(all ? 'All Dogs' : dog,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
          if (info != null)
            Text(info.details,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
        ]),
      ),
      TextButton(
        onPressed: onSwitch,
        child: const Text('Switch Dog',
            style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
      ),
    ]);
  }
}

IconData timelineCategoryIcon(String category) => switch (category) {
      'Training' => Icons.pets_outlined,
      'S&C' => Icons.fitness_center,
      'Health' => Icons.favorite_border,
      'Sport' => Icons.emoji_events_outlined,
      _ => Icons.flag_outlined,
    };

/// A compact charcoal event card: saved title, neutral type icon and name,
/// original date/time and concise saved details.
class TimelineEventCard extends StatelessWidget {
  final TimelineEvent event;
  final bool showDog;
  final VoidCallback onTap;
  final Widget? trailing;
  final String? extraLine;
  const TimelineEventCard(
      {super.key, required this.event, required this.showDog, required this.onTap, this.trailing, this.extraLine});

  @override
  Widget build(BuildContext context) {
    final e = event;
    final when = fmtDate(e.at) + (e.hasTime ? ' · ${fmtTime(e.at)}' : '');
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HealthCard(
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        child: Row(children: [
          Icon(timelineCategoryIcon(e.category), size: 22, color: AppColors.secondarySage),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.title,
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text([e.typeLabel, if (showDog) e.dog].join(' · '),
                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              Text(when, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              if (e.detail.isNotEmpty)
                Text(e.detail, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
              if (extraLine != null)
                Text(extraLine!, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ]),
          ),
          ?trailing,
        ]),
      ),
    );
  }
}

Widget favouriteHeart(TimelineEvent e) => ListenableBuilder(
      listenable: TimelineStore.instance,
      builder: (context, _) {
        final fav = TimelineStore.instance.isFavourite(e.id);
        return IconButton(
          tooltip: fav ? 'Remove from Favourites' : 'Add to Favourites',
          icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
              color: fav ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey, size: 22),
          onPressed: () => TimelineStore.instance.toggleFavourite(e.id),
        );
      },
    );

void openEvent(BuildContext context, TimelineEvent e) =>
    Navigator.push(context, MaterialPageRoute(builder: e.open));

/// Search match across saved title, notes, detail and type.
bool eventMatches(TimelineEvent e, String q) {
  final s = q.trim().toLowerCase();
  if (s.isEmpty) return true;
  return e.title.toLowerCase().contains(s) ||
      e.notes.toLowerCase().contains(s) ||
      e.detail.toLowerCase().contains(s) ||
      e.typeLabel.toLowerCase().contains(s);
}

/// Dog-scope helper: null means All Dogs.
String? dogScope(String dog) => dog == kAllDogs ? null : dog;

Widget searchField(TextEditingController c, String hint) => TextField(
      controller: c,
      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
      decoration: healthDecoration(hint).copyWith(
        prefixIcon: const Padding(
          padding: EdgeInsets.all(12),
          child: UlvenikIcon(UlvenikIcons.search, size: 20, color: AppColors.secondaryTextStoneGrey),
        ),
        suffixIcon: c.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                onPressed: c.clear,
              ),
      ),
    );
