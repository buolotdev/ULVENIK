import 'package:flutter/material.dart';
import '../data/health_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';
import 'add_health_record_screen.dart';
import 'body_condition_screen.dart';
import 'health_log_screen.dart';
import 'reproductive_health_screen.dart';
import 'weight_records_screen.dart';

/// Health Records: the approved 12 categories, six rows of two, always
/// visible. Scoped to the dog whose profile is open.
class HealthRecordsHubScreen extends StatelessWidget {
  final String dogName;
  const HealthRecordsHubScreen({super.key, required this.dogName});

  void _go(BuildContext context, Widget w) => Navigator.push(context, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    final cats = <(IconData, String, Widget)>[
      (Icons.monitor_weight_outlined, 'Weight', WeightRecordsScreen(dogName: dogName)),
      (Icons.accessibility_new_outlined, 'Body Condition', BodyConditionScreen(dogName: dogName)),
      (Icons.medication_outlined, 'Medications', HealthLogScreen(dogName: dogName, title: 'Medications', configs: [medicationConfig])),
      (Icons.medication_liquid_outlined, 'Supplements', HealthLogScreen(dogName: dogName, title: 'Supplements', configs: [supplementConfig])),
      (Icons.vaccines_outlined, 'Vaccinations', HealthLogScreen(dogName: dogName, title: 'Vaccinations', configs: [vaccinationConfig, titreConfig])),
      (Icons.bug_report_outlined, 'Parasite Prevention', HealthLogScreen(dogName: dogName, title: 'Parasite Prevention', configs: [parasiteConfig])),
      (Icons.local_hospital_outlined, 'Vet Visits', HealthLogScreen(dogName: dogName, title: 'Vet Visits', configs: [vetVisitConfig])),
      (Icons.coronavirus_outlined, 'Allergies & Medical Conditions', HealthLogScreen(dogName: dogName, title: 'Allergies & Medical Conditions', configs: [allergyConfig])),
      (Icons.healing_outlined, 'Injuries & Rehabilitation', HealthLogScreen(dogName: dogName, title: 'Injuries & Rehabilitation', configs: [injuryConfig, rehabConfig])),
      (Icons.favorite_border, 'Reproductive Health', ReproductiveHealthScreen(dogName: dogName)),
      (Icons.folder_outlined, 'Documents', HealthLogScreen(dogName: dogName, title: 'Documents', configs: [documentConfig])),
      (Icons.note_alt_outlined, 'Other Records', HealthLogScreen(dogName: dogName, title: 'Other Records', configs: [otherConfig])),
    ];
    final store = HealthStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final count = store.recordCount(dogName);
        return HealthScaffold(
          title: 'Health Records',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.55,
                children: [
                  for (final c in cats)
                    HealthCard(
                      onTap: () => _go(context, c.$3),
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(c.$1, color: kHealthGreen, size: 22),
                        const Spacer(),
                        Text(c.$2,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                ],
              ),
              if (count == 0)
                EmptyState(
                  icon: Icons.assignment_outlined,
                  title: 'No Health Records Yet',
                  message: 'Start building your dog’s health history by adding their first record.',
                  actionLabel: 'Add Health Record',
                  onAction: () => _go(context, const AddHealthRecordScreen()),
                ),
            ],
          ),
        );
      },
    );
  }
}
