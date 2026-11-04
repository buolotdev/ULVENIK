import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulvenik/screens/activity_details_screen.dart';
import 'package:ulvenik/screens/activity_goals_screen.dart';
import 'package:ulvenik/screens/activity_insights_screen.dart';
import 'package:ulvenik/screens/activity_library_screen.dart';
import 'package:ulvenik/screens/activity_statistics_screen.dart';
import 'package:ulvenik/screens/add_exercise_screen.dart';
import 'package:ulvenik/screens/add_health_record_screen.dart';
import 'package:ulvenik/screens/add_skill_screen.dart';
import 'package:ulvenik/screens/allergies_sensitivities_screen.dart';
import 'package:ulvenik/screens/create_activity_screen.dart';
import 'package:ulvenik/screens/create_goal_screen.dart';
import 'package:ulvenik/screens/create_password_screen.dart';
import 'package:ulvenik/screens/dental_care_screen.dart';
import 'package:ulvenik/screens/dog_profile_screen.dart';
import 'package:ulvenik/screens/dogs_all_workspaces_screen.dart';
import 'package:ulvenik/screens/edit_exercise_screen.dart';
import 'package:ulvenik/screens/email_verification_screen.dart';
import 'package:ulvenik/screens/equipment_screen.dart';
import 'package:ulvenik/screens/exercise_details_screen.dart';
import 'package:ulvenik/screens/export_screen.dart';
import 'package:ulvenik/screens/forgot_password_screen.dart';
import 'package:ulvenik/screens/goal_details_screen.dart';
import 'package:ulvenik/screens/goals_list_screen.dart';
import 'package:ulvenik/screens/health_archive_screen.dart';
import 'package:ulvenik/screens/health_dashboard_screen.dart';
import 'package:ulvenik/screens/health_record_details_screen.dart';
import 'package:ulvenik/screens/health_records_screen.dart';
import 'package:ulvenik/screens/health_reminders_screen.dart';
import 'package:ulvenik/screens/health_reports_timeline_screen.dart';
import 'package:ulvenik/screens/health_screen.dart';
import 'package:ulvenik/screens/health_settings_screen.dart';
import 'package:ulvenik/screens/health_statistics_screen.dart';
import 'package:ulvenik/screens/homepage_screen.dart';
import 'package:ulvenik/screens/import_export_screen.dart';
import 'package:ulvenik/screens/injuries_recovery_screen.dart';
import 'package:ulvenik/screens/login_screen.dart';
import 'package:ulvenik/screens/medication_manager_screen.dart';
import 'package:ulvenik/screens/my_dogs_screen.dart';
import 'package:ulvenik/screens/onboarding_screen.dart';
import 'package:ulvenik/screens/password_updated_screen.dart';
import 'package:ulvenik/screens/physio_hydro_hub_screen.dart';
import 'package:ulvenik/screens/record_session_screen.dart';
import 'package:ulvenik/screens/register_screen.dart';
import 'package:ulvenik/screens/sc_archive_screen.dart';
import 'package:ulvenik/screens/sc_settings_screen.dart';
import 'package:ulvenik/screens/session_details_screen.dart';
import 'package:ulvenik/screens/session_templates_screen.dart';
import 'package:ulvenik/screens/skill_details_screen.dart';
import 'package:ulvenik/screens/skills_list_screen.dart';
import 'package:ulvenik/screens/splash_screen.dart';
import 'package:ulvenik/screens/statistics_tab.dart';
import 'package:ulvenik/screens/strength_conditioning_dashboard_screen.dart';
import 'package:ulvenik/screens/supplements_screen.dart';
import 'package:ulvenik/screens/surgery_procedures_screen.dart';
import 'package:ulvenik/screens/timeline_archive_screen.dart';
import 'package:ulvenik/screens/timeline_calendar_screen.dart';
import 'package:ulvenik/screens/timeline_dashboard_screen.dart';
import 'package:ulvenik/screens/timeline_event_details_screen.dart';
import 'package:ulvenik/screens/timeline_export_screen.dart';
import 'package:ulvenik/screens/timeline_favourites_screen.dart';
import 'package:ulvenik/screens/timeline_filters_screen.dart';
import 'package:ulvenik/screens/timeline_insights_screen.dart';
import 'package:ulvenik/screens/timeline_screen.dart';
import 'package:ulvenik/screens/timeline_search_screen.dart';
import 'package:ulvenik/screens/timeline_settings_screen.dart';
import 'package:ulvenik/screens/timeline_statistics_screen.dart';
import 'package:ulvenik/screens/training_screen.dart';
import 'package:ulvenik/screens/training_session_screen.dart';
import 'package:ulvenik/screens/two_factor_setup_screen.dart';
import 'package:ulvenik/screens/vaccination_manager_screen.dart';
import 'package:ulvenik/screens/vet_visits_screen.dart';
import 'package:ulvenik/screens/weight_tracker_screen.dart';
import 'package:ulvenik/screens/welcome_screen.dart';

Widget testHarness(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: child,
  );
}

void main() {
  group('BATCH 1 — Auth & Onboarding', () {
    testWidgets('1.1 Splash Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(SplashScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('1.2 Onboarding Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(OnboardingScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('1.3 Login Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(LoginScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('1.4 Register / Create Account Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(RegisterScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(RegisterScreen), findsOneWidget);
    });

    testWidgets('1.5 Forgot Password Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(ForgotPasswordScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('1.6 Confirmation / Email Verified Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(EmailVerificationScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(EmailVerificationScreen), findsOneWidget);
    });

    testWidgets('1.7 Set New Password Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(CreatePasswordScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CreatePasswordScreen), findsOneWidget);
    });

    testWidgets('1.8 Password Updated Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(PasswordUpdatedScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(PasswordUpdatedScreen), findsOneWidget);
    });

    testWidgets('1.9 Welcome Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(WelcomeScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('1.10 2FA Setup Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TwoFactorSetupScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TwoFactorSetupScreen), findsOneWidget);
    });

  });

  group('BATCH 2 — Core App Entry', () {
    testWidgets('2.1 Homepage Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(HomepageScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HomepageScreen), findsOneWidget);
    });

    testWidgets('2.2 My Dogs Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(MyDogsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(MyDogsScreen), findsOneWidget);
    });

    testWidgets('2.3 Dogs All Workspaces Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(DogsAllWorkspacesScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(DogsAllWorkspacesScreen), findsOneWidget);
    });

  });

  group('BATCH 3 — Dog Profile', () {
    testWidgets('3.1 Dog Profile Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(DogProfileScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(DogProfileScreen), findsOneWidget);
    });

    testWidgets('3.2 Training Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TrainingScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TrainingScreen), findsOneWidget);
    });

    testWidgets('3.3 Training Session Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TrainingSessionScreen(session: TrainingSession(id: "1", dogName: "Zeus", dogInitial: "Z", title: "Recall", dateLabel: "Today", date: DateTime(2026, 9, 15), status: SessionStatus.draft, dogColor: Colors.teal))));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TrainingSessionScreen), findsOneWidget);
    });

    testWidgets('3.4 Skills List Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(SkillsListScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SkillsListScreen), findsOneWidget);
    });

    testWidgets('3.5 Skill Details Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(SkillDetailsScreen(skillName: "Recall")));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SkillDetailsScreen), findsOneWidget);
    });

    testWidgets('3.6 Add Skill Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(AddSkillScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AddSkillScreen), findsOneWidget);
    });

    testWidgets('3.7 Add Exercise Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(AddExerciseScreen(parentSkill: "Recall")));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AddExerciseScreen), findsOneWidget);
    });

    testWidgets('3.8 Exercise Details Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(ExerciseDetailsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ExerciseDetailsScreen), findsOneWidget);
    });

    testWidgets('3.9 Edit Exercise Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(EditExerciseScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(EditExerciseScreen), findsOneWidget);
    });

    testWidgets('3.10 Goals List Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(GoalsListScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(GoalsListScreen), findsOneWidget);
    });

    testWidgets('3.11 Create Goal Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(CreateGoalScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CreateGoalScreen), findsOneWidget);
    });

    testWidgets('3.12 Goal Details Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(GoalDetailsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(GoalDetailsScreen), findsOneWidget);
    });

    testWidgets('3.13 Statistics Tab (Populated) renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(StatisticsTab(hasData: true)));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(StatisticsTab), findsOneWidget);
    });

    testWidgets('3.14 Statistics Tab (Empty) renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(StatisticsTab(hasData: false)));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(StatisticsTab), findsOneWidget);
    });

    testWidgets('3.15 Dog Timeline Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineScreen), findsOneWidget);
    });

  });

  group('BATCH 4 — Health', () {
    testWidgets('4.1 Health Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(HealthScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HealthScreen), findsOneWidget);
    });

    testWidgets('4.2 Health Records Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(HealthRecordsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HealthRecordsScreen), findsOneWidget);
    });

    testWidgets('4.3 Add Health Record Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(AddHealthRecordScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AddHealthRecordScreen), findsOneWidget);
    });

    testWidgets('4.4 Health Record Details Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(HealthRecordDetailsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HealthRecordDetailsScreen), findsOneWidget);
    });

    testWidgets('4.5 Weight Tracker Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(WeightTrackerScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(WeightTrackerScreen), findsOneWidget);
    });

    testWidgets('4.6 Medication Manager Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(MedicationManagerScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(MedicationManagerScreen), findsOneWidget);
    });

    testWidgets('4.7 Vaccination Manager Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(VaccinationManagerScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(VaccinationManagerScreen), findsOneWidget);
    });

    testWidgets('4.8 Vet Visits Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(VetVisitsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(VetVisitsScreen), findsOneWidget);
    });

    testWidgets('4.9 Injuries & Recovery Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(InjuriesRecoveryScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(InjuriesRecoveryScreen), findsOneWidget);
    });

    testWidgets('4.10 Physiotherapy & Hydrotherapy Hub renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(PhysioHydroHubScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(PhysioHydroHubScreen), findsOneWidget);
    });

    testWidgets('4.11 Supplements Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(SupplementsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SupplementsScreen), findsOneWidget);
    });

    testWidgets('4.12 Allergies & Sensitivities Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(AllergiesSensitivitiesScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AllergiesSensitivitiesScreen), findsOneWidget);
    });

    testWidgets('4.13 Dental Care Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(DentalCareScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(DentalCareScreen), findsOneWidget);
    });

    testWidgets('4.14 Health Reports & Timeline Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(HealthReportsTimelineScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HealthReportsTimelineScreen), findsOneWidget);
    });

    testWidgets('4.15 Surgery & Procedures Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(SurgeryProceduresScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SurgeryProceduresScreen), findsOneWidget);
    });

    testWidgets('4.16 Health Statistics Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(HealthStatisticsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HealthStatisticsScreen), findsOneWidget);
    });

    testWidgets('4.17 Health Reminders Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(HealthRemindersScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HealthRemindersScreen), findsOneWidget);
    });

    testWidgets('4.18 Health Settings Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(HealthSettingsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HealthSettingsScreen), findsOneWidget);
    });

    testWidgets('4.19 Import & Export Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(ImportExportScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ImportExportScreen), findsOneWidget);
    });

    testWidgets('4.20 Health Archive Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(HealthArchiveScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HealthArchiveScreen), findsOneWidget);
    });

    testWidgets('4.21 Health Dashboard Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(HealthDashboardScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HealthDashboardScreen), findsOneWidget);
    });

  });

  group('BATCH 5 — Strength & Conditioning', () {
    testWidgets('5.1 Strength & Conditioning Dashboard renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(StrengthConditioningDashboardScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(StrengthConditioningDashboardScreen), findsOneWidget);
    });

    testWidgets('5.2 Activity Library Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(ActivityLibraryScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ActivityLibraryScreen), findsOneWidget);
    });

    testWidgets('5.3 Activity Details Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(ActivityDetailsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ActivityDetailsScreen), findsOneWidget);
    });

    testWidgets('5.4 Create Activity Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(CreateActivityScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CreateActivityScreen), findsOneWidget);
    });

    testWidgets('5.5 Record Session Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(RecordSessionScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(RecordSessionScreen), findsOneWidget);
    });

    testWidgets('5.6 Session Details Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(SessionDetailsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SessionDetailsScreen), findsOneWidget);
    });

    testWidgets('5.7 Activity Statistics Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(ActivityStatisticsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ActivityStatisticsScreen), findsOneWidget);
    });

    testWidgets('5.8 Activity Goals Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(ActivityGoalsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ActivityGoalsScreen), findsOneWidget);
    });

    testWidgets('5.9 Activity Insights Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(ActivityInsightsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ActivityInsightsScreen), findsOneWidget);
    });

    testWidgets('5.10 Equipment Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(EquipmentScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(EquipmentScreen), findsOneWidget);
    });

    testWidgets('5.11 Session Templates Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(SessionTemplatesScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SessionTemplatesScreen), findsOneWidget);
    });

    testWidgets('5.12 Export Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(ExportScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ExportScreen), findsOneWidget);
    });

    testWidgets('5.13 SC Archive Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(SCArchiveScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SCArchiveScreen), findsOneWidget);
    });

    testWidgets('5.14 SC Settings Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(SCSettingsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SCSettingsScreen), findsOneWidget);
    });

  });

  group('BATCH 6 — Timeline', () {
    testWidgets('6.1 Global Timeline Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineScreen), findsOneWidget);
    });

    testWidgets('6.2 Timeline Dashboard Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineDashboardScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineDashboardScreen), findsOneWidget);
    });

    testWidgets('6.3 Timeline Event Details Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineEventDetailsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineEventDetailsScreen), findsOneWidget);
    });

    testWidgets('6.4 Timeline Filters Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineFiltersScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineFiltersScreen), findsOneWidget);
    });

    testWidgets('6.5 Timeline Search Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineSearchScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineSearchScreen), findsOneWidget);
    });

    testWidgets('6.6 Timeline Calendar Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineCalendarScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineCalendarScreen), findsOneWidget);
    });

    testWidgets('6.7 Timeline Statistics Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineStatisticsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineStatisticsScreen), findsOneWidget);
    });

    testWidgets('6.8 Timeline Export Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineExportScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineExportScreen), findsOneWidget);
    });

    testWidgets('6.9 Timeline Favourites Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineFavouritesScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineFavouritesScreen), findsOneWidget);
    });

    testWidgets('6.10 Timeline Archive Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineArchiveScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineArchiveScreen), findsOneWidget);
    });

    testWidgets('6.11 Timeline Settings Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineSettingsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineSettingsScreen), findsOneWidget);
    });

    testWidgets('6.12 Timeline Insights Screen renders without errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(TimelineInsightsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TimelineInsightsScreen), findsOneWidget);
    });

  });
}
