import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../data/health_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'health_log_screen.dart';

/// Reproductive Health: five internal areas (not five extra Health cards).
/// Female dogs see cycles / mating / pregnancy / whelping; male dogs see
/// male reproductive records; both see Spaying & Neutering.
class ReproductiveHealthScreen extends StatelessWidget {
  final String dogName;
  const ReproductiveHealthScreen({super.key, required this.dogName});

  @override
  Widget build(BuildContext context) {
    final sex = SampleData.dogNamed(dogName).sex.toLowerCase();
    final male = sex == 'male';
    final areas = <(LogConfig, String)>[
      if (!male) ...[
        (heatCycleConfig, ''),
        (matingConfig, ''),
        (pregnancyConfig, ''),
        (whelpingConfig, ''),
      ] else
        (maleConfig, ''),
      (spayNeuterConfig, ''),
    ];
    final store = HealthStore.instance;

    return HealthScaffold(
      title: 'Reproductive Health',
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            for (final a in areas) ...[
              HealthCard(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HealthLogScreen(dogName: dogName, title: a.$1.tabTitle, configs: [a.$1])),
                ),
                child: Row(children: [
                  Icon(a.$1.icon, color: kHealthGreen, size: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(a.$1.tabTitle,
                          style: TextStyle(
                              color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(
                        '${store.logs(dogName, a.$1.area).length} ${store.logs(dogName, a.$1.area).length == 1 ? 'record' : 'records'}',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
                      ),
                    ]),
                  ),
                  UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                ]),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
