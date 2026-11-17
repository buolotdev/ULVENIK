import 'package:flutter/material.dart';
import '../data/dogs_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';

/// Archived Dogs: restore a dog hidden via the profile's ⋮ > Archive Dog.
/// Same pattern as Archived Activities / Archived Sports elsewhere in the app.
class ArchivedDogsScreen extends StatelessWidget {
  const ArchivedDogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DogsStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final dogs = store.archivedDogs;
        return HealthScaffold(
          title: 'Archived Dogs',
          body: dogs.isEmpty
              ? const Center(
                  child: EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No Archived Dogs',
                    message: 'Dogs you archive will appear here. All their records are kept.',
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    for (final d in dogs) ...[
                      HealthCard(
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: d.photoProvider == null
                                  ? const ColoredBox(
                                      color: AppColors.cardsCarbon,
                                      child: Center(
                                          child: UlvenikIcon(UlvenikIcons.dogs, size: 20, color: AppColors.secondarySage)),
                                    )
                                  : Image(image: d.photoProvider!, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(d.name,
                                  style: const TextStyle(
                                      color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(d.details,
                                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                            ]),
                          ),
                          TextButton(
                            onPressed: () {
                              store.setArchived(d, false);
                              AppSnackbar.show(context, message: '${d.name} restored', type: SnackbarType.success);
                            },
                            child: const Text('Restore',
                                style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
        );
      },
    );
  }
}
