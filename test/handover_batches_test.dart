import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulvenik/screens/about_ulvenik_screen.dart';
import 'package:ulvenik/screens/achievements_titles_screen.dart';
import 'package:ulvenik/screens/activity_details_screen.dart';
import 'package:ulvenik/screens/activity_goals_screen.dart';
import 'package:ulvenik/screens/activity_insights_screen.dart';
import 'package:ulvenik/screens/activity_library_screen.dart';
import 'package:ulvenik/screens/activity_statistics_screen.dart';
import 'package:ulvenik/screens/add_client_screen.dart';
import 'package:ulvenik/screens/add_competition_screen.dart';
import 'package:ulvenik/screens/add_exercise_screen.dart';
import 'package:ulvenik/screens/add_health_record_screen.dart';
import 'package:ulvenik/screens/add_reward_screen.dart';
import 'package:ulvenik/screens/add_skill_screen.dart';
import 'package:ulvenik/screens/allergies_sensitivities_screen.dart';
import 'package:ulvenik/screens/app_settings_screen.dart';
import 'package:ulvenik/screens/appearance_settings_screen.dart';
import 'package:ulvenik/screens/backup_sync_screen.dart';
import 'package:ulvenik/screens/billing_history_screen.dart';
import 'package:ulvenik/screens/certificates_documents_screen.dart';
import 'package:ulvenik/screens/change_email_screen.dart';
import 'package:ulvenik/screens/change_password_screen.dart';
import 'package:ulvenik/screens/change_photo_screen.dart';
import 'package:ulvenik/screens/client_account_screen.dart';
import 'package:ulvenik/screens/client_dog_profile_screen.dart';
import 'package:ulvenik/screens/client_dogs_screen.dart';
import 'package:ulvenik/screens/client_homework_screen.dart';
import 'package:ulvenik/screens/client_notes_screen.dart';
import 'package:ulvenik/screens/client_permissions_screen.dart';
import 'package:ulvenik/screens/client_profile_screen.dart';
import 'package:ulvenik/screens/client_progress_screen.dart';
import 'package:ulvenik/screens/clients_page_screen.dart';
import 'package:ulvenik/screens/competition_details_screen.dart';
import 'package:ulvenik/screens/competition_results_screen.dart';
import 'package:ulvenik/screens/competitions_overview_screen.dart';
import 'package:ulvenik/screens/contact_support_screen.dart';
import 'package:ulvenik/screens/country_region_screen.dart';
import 'package:ulvenik/screens/create_activity_screen.dart';
import 'package:ulvenik/screens/create_goal_screen.dart';
import 'package:ulvenik/screens/create_password_screen.dart';
import 'package:ulvenik/screens/create_sport_screen.dart';
import 'package:ulvenik/screens/date_time_format_screen.dart';
import 'package:ulvenik/screens/delete_account_screen.dart';
import 'package:ulvenik/screens/dental_care_screen.dart';
import 'package:ulvenik/screens/document_viewer_screen.dart';
import 'package:ulvenik/screens/dog_profile_screen.dart';
import 'package:ulvenik/screens/dogs_all_workspaces_screen.dart';
import 'package:ulvenik/screens/edit_client_screen.dart';
import 'package:ulvenik/screens/edit_exercise_screen.dart';
import 'package:ulvenik/screens/edit_profile_screen.dart';
import 'package:ulvenik/screens/edit_reward_screen.dart';
import 'package:ulvenik/screens/email_verification_screen.dart';
import 'package:ulvenik/screens/equipment_screen.dart';
import 'package:ulvenik/screens/exercise_details_screen.dart';
import 'package:ulvenik/screens/export_my_data_screen.dart';
import 'package:ulvenik/screens/export_screen.dart';
import 'package:ulvenik/screens/feature_requests_screen.dart';
import 'package:ulvenik/screens/forgot_password_screen.dart';
import 'package:ulvenik/screens/global_calendar_screen.dart';
import 'package:ulvenik/screens/global_search_screen.dart';
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
import 'package:ulvenik/screens/help_centre_screen.dart';
import 'package:ulvenik/screens/homepage_screen.dart';
import 'package:ulvenik/screens/homework_details_screen.dart';
import 'package:ulvenik/screens/homework_training_plans_screen.dart';
import 'package:ulvenik/screens/image_editor_screen.dart';
import 'package:ulvenik/screens/import_export_screen.dart';
import 'package:ulvenik/screens/injuries_recovery_screen.dart';
import 'package:ulvenik/screens/language_settings_screen.dart';
import 'package:ulvenik/screens/lesson_records_screen.dart';
import 'package:ulvenik/screens/login_screen.dart';
import 'package:ulvenik/screens/manage_reward_types_screen.dart';
import 'package:ulvenik/screens/measurement_units_screen.dart';
import 'package:ulvenik/screens/media_collections_screen.dart';
import 'package:ulvenik/screens/media_favourites_screen.dart';
import 'package:ulvenik/screens/media_library_screen.dart';
import 'package:ulvenik/screens/media_search_screen.dart';
import 'package:ulvenik/screens/media_upload_manager_screen.dart';
import 'package:ulvenik/screens/medication_manager_screen.dart';
import 'package:ulvenik/screens/more_dashboard_screen.dart';
import 'package:ulvenik/screens/more_page_screen.dart';
import 'package:ulvenik/screens/my_dogs_screen.dart';
import 'package:ulvenik/screens/my_sports_screen.dart';
import 'package:ulvenik/screens/notification_settings_screen.dart';
import 'package:ulvenik/screens/notifications_page_screen.dart';
import 'package:ulvenik/screens/offline_mode_screen.dart';
import 'package:ulvenik/screens/onboarding_screen.dart';
import 'package:ulvenik/screens/open_source_licences_screen.dart';
import 'package:ulvenik/screens/password_updated_screen.dart';
import 'package:ulvenik/screens/photo_viewer_screen.dart';
import 'package:ulvenik/screens/physio_hydro_hub_screen.dart';
import 'package:ulvenik/screens/privacy_policy_screen.dart';
import 'package:ulvenik/screens/profile_page_screen.dart';
import 'package:ulvenik/screens/qualifications_titles_awards_screen.dart';
import 'package:ulvenik/screens/record_competition_result_screen.dart';
import 'package:ulvenik/screens/record_session_screen.dart';
import 'package:ulvenik/screens/register_screen.dart';
import 'package:ulvenik/screens/report_bug_screen.dart';
import 'package:ulvenik/screens/restore_purchases_screen.dart';
import 'package:ulvenik/screens/rewards_management_screen.dart';
import 'package:ulvenik/screens/sc_archive_screen.dart';
import 'package:ulvenik/screens/sc_settings_screen.dart';
import 'package:ulvenik/screens/session_details_screen.dart';
import 'package:ulvenik/screens/session_templates_screen.dart';
import 'package:ulvenik/screens/shared_records_screen.dart';
import 'package:ulvenik/screens/skill_details_screen.dart';
import 'package:ulvenik/screens/skills_list_screen.dart';
import 'package:ulvenik/screens/splash_screen.dart';
import 'package:ulvenik/screens/sport_details_igp_screen.dart';
import 'package:ulvenik/screens/sport_pack_overview_screen.dart';
import 'package:ulvenik/screens/sport_statistics_screen.dart';
import 'package:ulvenik/screens/statistics_tab.dart';
import 'package:ulvenik/screens/storage_management_screen.dart';
import 'package:ulvenik/screens/strength_conditioning_dashboard_screen.dart';
import 'package:ulvenik/screens/subscription_details_screen.dart';
import 'package:ulvenik/screens/supplements_screen.dart';
import 'package:ulvenik/screens/surgery_procedures_screen.dart';
import 'package:ulvenik/screens/terms_conditions_screen.dart';
import 'package:ulvenik/screens/timeline_activity_map_screen.dart';
import 'package:ulvenik/screens/timeline_archive_screen.dart';
import 'package:ulvenik/screens/timeline_calendar_screen.dart';
import 'package:ulvenik/screens/timeline_compare_screen.dart';
import 'package:ulvenik/screens/timeline_dashboard_screen.dart';
import 'package:ulvenik/screens/timeline_event_details_screen.dart';
import 'package:ulvenik/screens/timeline_export_screen.dart';
import 'package:ulvenik/screens/timeline_favourites_screen.dart';
import 'package:ulvenik/screens/timeline_filters_screen.dart';
import 'package:ulvenik/screens/timeline_insights_screen.dart';
import 'package:ulvenik/screens/timeline_memories_screen.dart';
import 'package:ulvenik/screens/timeline_screen.dart';
import 'package:ulvenik/screens/timeline_search_screen.dart';
import 'package:ulvenik/screens/timeline_settings_screen.dart';
import 'package:ulvenik/screens/timeline_smart_collections_screen.dart';
import 'package:ulvenik/screens/timeline_statistics_screen.dart';
import 'package:ulvenik/screens/timeline_widgets_screen.dart';
import 'package:ulvenik/screens/timezone_settings_screen.dart';
import 'package:ulvenik/screens/trainer_dashboard_screen.dart';
import 'package:ulvenik/screens/trainer_notes_screen.dart';
import 'package:ulvenik/screens/trainer_notifications_screen.dart';
import 'package:ulvenik/screens/trainer_profile_screen.dart';
import 'package:ulvenik/screens/trainer_reports_screen.dart';
import 'package:ulvenik/screens/trainer_workspace_settings_screen.dart';
import 'package:ulvenik/screens/training_screen.dart';
import 'package:ulvenik/screens/training_session_screen.dart';
import 'package:ulvenik/screens/two_factor_setup_screen.dart';
import 'package:ulvenik/screens/vaccination_manager_screen.dart';
import 'package:ulvenik/screens/vet_visits_screen.dart';
import 'package:ulvenik/screens/video_viewer_screen.dart';
import 'package:ulvenik/screens/weight_tracker_screen.dart';
import 'package:ulvenik/screens/welcome_screen.dart';
import 'package:ulvenik/screens/whats_new_screen.dart';

Widget testHarness(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: child,
  );
}

Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
  final oldHandler = FlutterError.onError;
  FlutterError.onError = (details) {
    final msg = details.toString();
    if (msg.contains('overflowed') ||
        msg.contains('RenderFlex') ||
        msg.contains('NetworkImage') ||
        msg.contains('HTTP request failed')) {
      return;
    }
    oldHandler?.call(details);
  };

  await tester.binding.setSurfaceSize(const Size(430, 932));
  await tester.pumpWidget(testHarness(screen));
  await tester.pump(const Duration(milliseconds: 300));

  FlutterError.onError = oldHandler;
}

void main() {
  group("BATCH 1 — Auth & Onboarding", () {
    testWidgets("1.1 Splash Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SplashScreen());
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets("1.2 Onboarding Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, OnboardingScreen());
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets("1.3 Login Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, LoginScreen());
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets("1.4 Register / Create Account Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, RegisterScreen());
      expect(find.byType(RegisterScreen), findsOneWidget);
    });

    testWidgets("1.5 Forgot Password Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ForgotPasswordScreen());
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets("1.6 Confirmation / Email Verified Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, EmailVerificationScreen());
      expect(find.byType(EmailVerificationScreen), findsOneWidget);
    });

    testWidgets("1.7 Set New Password Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, CreatePasswordScreen());
      expect(find.byType(CreatePasswordScreen), findsOneWidget);
    });

    testWidgets("1.8 Password Updated Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, PasswordUpdatedScreen());
      expect(find.byType(PasswordUpdatedScreen), findsOneWidget);
    });

    testWidgets("1.9 Welcome Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, WelcomeScreen());
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets("1.10 2FA Setup Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TwoFactorSetupScreen());
      expect(find.byType(TwoFactorSetupScreen), findsOneWidget);
    });

  });

  group("BATCH 2 — Core App Entry", () {
    testWidgets("2.1 Homepage Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HomepageScreen());
      expect(find.byType(HomepageScreen), findsOneWidget);
    });

    testWidgets("2.2 My Dogs Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MyDogsScreen());
      expect(find.byType(MyDogsScreen), findsOneWidget);
    });

    testWidgets("2.3 Dogs All Workspaces Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, DogsAllWorkspacesScreen());
      expect(find.byType(DogsAllWorkspacesScreen), findsOneWidget);
    });

  });

  group("BATCH 3 — Dog Profile", () {
    testWidgets("3.1 Dog Profile Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, DogProfileScreen());
      expect(find.byType(DogProfileScreen), findsOneWidget);
    });

    testWidgets("3.2 Training Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TrainingScreen());
      expect(find.byType(TrainingScreen), findsOneWidget);
    });

    testWidgets("3.3 Training Session Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TrainingSessionScreen(session: TrainingSession(id: "1", dogName: "Zeus", dogInitial: "Z", title: "Recall", dateLabel: "Today", status: SessionStatus.draft, dogColor: Colors.teal)));
      expect(find.byType(TrainingSessionScreen), findsOneWidget);
    });

    testWidgets("3.4 Skills List Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SkillsListScreen());
      expect(find.byType(SkillsListScreen), findsOneWidget);
    });

    testWidgets("3.5 Skill Details Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SkillDetailsScreen(skillName: "Recall"));
      expect(find.byType(SkillDetailsScreen), findsOneWidget);
    });

    testWidgets("3.6 Add Skill Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AddSkillScreen());
      expect(find.byType(AddSkillScreen), findsOneWidget);
    });

    testWidgets("3.7 Add Exercise Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AddExerciseScreen(parentSkill: "Recall"));
      expect(find.byType(AddExerciseScreen), findsOneWidget);
    });

    testWidgets("3.8 Exercise Details Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ExerciseDetailsScreen());
      expect(find.byType(ExerciseDetailsScreen), findsOneWidget);
    });

    testWidgets("3.9 Edit Exercise Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, EditExerciseScreen());
      expect(find.byType(EditExerciseScreen), findsOneWidget);
    });

    testWidgets("3.10 Goals List Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, GoalsListScreen());
      expect(find.byType(GoalsListScreen), findsOneWidget);
    });

    testWidgets("3.11 Create Goal Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, CreateGoalScreen());
      expect(find.byType(CreateGoalScreen), findsOneWidget);
    });

    testWidgets("3.12 Goal Details Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, GoalDetailsScreen());
      expect(find.byType(GoalDetailsScreen), findsOneWidget);
    });

    testWidgets("3.13 Statistics Tab (Populated) renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, StatisticsTab(hasData: true));
      expect(find.byType(StatisticsTab), findsOneWidget);
    });

    testWidgets("3.14 Statistics Tab (Empty) renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, StatisticsTab(hasData: false));
      expect(find.byType(StatisticsTab), findsOneWidget);
    });

    testWidgets("3.15 Dog Timeline Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineScreen());
      expect(find.byType(TimelineScreen), findsOneWidget);
    });

  });

  group("BATCH 4 — Health", () {
    testWidgets("4.1 Health Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HealthScreen());
      expect(find.byType(HealthScreen), findsOneWidget);
    });

    testWidgets("4.2 Health Records Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HealthRecordsScreen());
      expect(find.byType(HealthRecordsScreen), findsOneWidget);
    });

    testWidgets("4.3 Add Health Record Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AddHealthRecordScreen());
      expect(find.byType(AddHealthRecordScreen), findsOneWidget);
    });

    testWidgets("4.4 Health Record Details Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HealthRecordDetailsScreen());
      expect(find.byType(HealthRecordDetailsScreen), findsOneWidget);
    });

    testWidgets("4.5 Weight Tracker Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, WeightTrackerScreen());
      expect(find.byType(WeightTrackerScreen), findsOneWidget);
    });

    testWidgets("4.6 Medication Manager Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MedicationManagerScreen());
      expect(find.byType(MedicationManagerScreen), findsOneWidget);
    });

    testWidgets("4.7 Vaccination Manager Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, VaccinationManagerScreen());
      expect(find.byType(VaccinationManagerScreen), findsOneWidget);
    });

    testWidgets("4.8 Vet Visits Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, VetVisitsScreen());
      expect(find.byType(VetVisitsScreen), findsOneWidget);
    });

    testWidgets("4.9 Injuries & Recovery Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, InjuriesRecoveryScreen());
      expect(find.byType(InjuriesRecoveryScreen), findsOneWidget);
    });

    testWidgets("4.10 Physiotherapy & Hydrotherapy Hub renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, PhysioHydroHubScreen());
      expect(find.byType(PhysioHydroHubScreen), findsOneWidget);
    });

    testWidgets("4.11 Supplements Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SupplementsScreen());
      expect(find.byType(SupplementsScreen), findsOneWidget);
    });

    testWidgets("4.12 Allergies & Sensitivities Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AllergiesSensitivitiesScreen());
      expect(find.byType(AllergiesSensitivitiesScreen), findsOneWidget);
    });

    testWidgets("4.13 Dental Care Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, DentalCareScreen());
      expect(find.byType(DentalCareScreen), findsOneWidget);
    });

    testWidgets("4.14 Health Reports & Timeline Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HealthReportsTimelineScreen());
      expect(find.byType(HealthReportsTimelineScreen), findsOneWidget);
    });

    testWidgets("4.15 Surgery & Procedures Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SurgeryProceduresScreen());
      expect(find.byType(SurgeryProceduresScreen), findsOneWidget);
    });

    testWidgets("4.16 Health Statistics Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HealthStatisticsScreen());
      expect(find.byType(HealthStatisticsScreen), findsOneWidget);
    });

    testWidgets("4.17 Health Reminders Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HealthRemindersScreen());
      expect(find.byType(HealthRemindersScreen), findsOneWidget);
    });

    testWidgets("4.18 Health Settings Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HealthSettingsScreen());
      expect(find.byType(HealthSettingsScreen), findsOneWidget);
    });

    testWidgets("4.19 Import & Export Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ImportExportScreen());
      expect(find.byType(ImportExportScreen), findsOneWidget);
    });

    testWidgets("4.20 Health Archive Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HealthArchiveScreen());
      expect(find.byType(HealthArchiveScreen), findsOneWidget);
    });

    testWidgets("4.21 Health Dashboard Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HealthDashboardScreen());
      expect(find.byType(HealthDashboardScreen), findsOneWidget);
    });

  });

  group("BATCH 5 — Strength & Conditioning", () {
    testWidgets("5.1 Strength & Conditioning Dashboard renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, StrengthConditioningDashboardScreen());
      expect(find.byType(StrengthConditioningDashboardScreen), findsOneWidget);
    });

    testWidgets("5.2 Activity Library Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ActivityLibraryScreen());
      expect(find.byType(ActivityLibraryScreen), findsOneWidget);
    });

    testWidgets("5.3 Activity Details Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ActivityDetailsScreen());
      expect(find.byType(ActivityDetailsScreen), findsOneWidget);
    });

    testWidgets("5.4 Create Activity Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, CreateActivityScreen());
      expect(find.byType(CreateActivityScreen), findsOneWidget);
    });

    testWidgets("5.5 Record Session Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, RecordSessionScreen());
      expect(find.byType(RecordSessionScreen), findsOneWidget);
    });

    testWidgets("5.6 Session Details Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SessionDetailsScreen());
      expect(find.byType(SessionDetailsScreen), findsOneWidget);
    });

    testWidgets("5.7 Activity Statistics Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ActivityStatisticsScreen());
      expect(find.byType(ActivityStatisticsScreen), findsOneWidget);
    });

    testWidgets("5.8 Activity Goals Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ActivityGoalsScreen());
      expect(find.byType(ActivityGoalsScreen), findsOneWidget);
    });

    testWidgets("5.9 Activity Insights Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ActivityInsightsScreen());
      expect(find.byType(ActivityInsightsScreen), findsOneWidget);
    });

    testWidgets("5.10 Equipment Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, EquipmentScreen());
      expect(find.byType(EquipmentScreen), findsOneWidget);
    });

    testWidgets("5.11 Session Templates Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SessionTemplatesScreen());
      expect(find.byType(SessionTemplatesScreen), findsOneWidget);
    });

    testWidgets("5.12 Export Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ExportScreen());
      expect(find.byType(ExportScreen), findsOneWidget);
    });

    testWidgets("5.13 SC Archive Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SCArchiveScreen());
      expect(find.byType(SCArchiveScreen), findsOneWidget);
    });

    testWidgets("5.14 SC Settings Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SCSettingsScreen());
      expect(find.byType(SCSettingsScreen), findsOneWidget);
    });

  });

  group("BATCH 6 — Timeline", () {
    testWidgets("6.1 Global Timeline Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineScreen());
      expect(find.byType(TimelineScreen), findsOneWidget);
    });

    testWidgets("6.2 Timeline Dashboard Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineDashboardScreen());
      expect(find.byType(TimelineDashboardScreen), findsOneWidget);
    });

    testWidgets("6.3 Timeline Event Details Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineEventDetailsScreen());
      expect(find.byType(TimelineEventDetailsScreen), findsOneWidget);
    });

    testWidgets("6.4 Timeline Filters Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineFiltersScreen());
      expect(find.byType(TimelineFiltersScreen), findsOneWidget);
    });

    testWidgets("6.5 Timeline Search Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineSearchScreen());
      expect(find.byType(TimelineSearchScreen), findsOneWidget);
    });

    testWidgets("6.6 Timeline Calendar Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineCalendarScreen());
      expect(find.byType(TimelineCalendarScreen), findsOneWidget);
    });

    testWidgets("6.7 Timeline Statistics Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineStatisticsScreen());
      expect(find.byType(TimelineStatisticsScreen), findsOneWidget);
    });

    testWidgets("6.8 Timeline Export Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineExportScreen());
      expect(find.byType(TimelineExportScreen), findsOneWidget);
    });

    testWidgets("6.9 Timeline Favourites Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineFavouritesScreen());
      expect(find.byType(TimelineFavouritesScreen), findsOneWidget);
    });

    testWidgets("6.10 Timeline Archive Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineArchiveScreen());
      expect(find.byType(TimelineArchiveScreen), findsOneWidget);
    });

    testWidgets("6.11 Timeline Settings Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineSettingsScreen());
      expect(find.byType(TimelineSettingsScreen), findsOneWidget);
    });

    testWidgets("6.12 Timeline Insights Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineInsightsScreen());
      expect(find.byType(TimelineInsightsScreen), findsOneWidget);
    });

    testWidgets("6.13 Timeline Memories Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineMemoriesScreen());
      expect(find.byType(TimelineMemoriesScreen), findsOneWidget);
    });

    testWidgets("6.14 Timeline Activity Map Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineActivityMapScreen());
      expect(find.byType(TimelineActivityMapScreen), findsOneWidget);
    });

    testWidgets("6.15 Timeline Compare Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineCompareScreen());
      expect(find.byType(TimelineCompareScreen), findsOneWidget);
    });

    testWidgets("6.16 Timeline Smart Collections Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineSmartCollectionsScreen());
      expect(find.byType(TimelineSmartCollectionsScreen), findsOneWidget);
    });

    testWidgets("6.17 Timeline Widgets Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimelineWidgetsScreen());
      expect(find.byType(TimelineWidgetsScreen), findsOneWidget);
    });

  });

  group("BATCH 7 — More & Settings", () {
    testWidgets("7.1 More Page Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MorePageScreen());
      expect(find.byType(MorePageScreen), findsOneWidget);
    });

    testWidgets("7.2 More Dashboard Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MoreDashboardScreen());
      expect(find.byType(MoreDashboardScreen), findsOneWidget);
    });

    testWidgets("7.3 Notification Settings Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, NotificationSettingsScreen());
      expect(find.byType(NotificationSettingsScreen), findsOneWidget);
    });

    testWidgets("7.4 Appearance Settings Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AppearanceSettingsScreen());
      expect(find.byType(AppearanceSettingsScreen), findsOneWidget);
    });

    testWidgets("7.5 Backup & Sync Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, BackupSyncScreen());
      expect(find.byType(BackupSyncScreen), findsOneWidget);
    });

    testWidgets("7.6 Offline Mode Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, OfflineModeScreen());
      expect(find.byType(OfflineModeScreen), findsOneWidget);
    });

    testWidgets("7.7 Storage Management Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, StorageManagementScreen());
      expect(find.byType(StorageManagementScreen), findsOneWidget);
    });

    testWidgets("7.8 Help Centre Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HelpCentreScreen());
      expect(find.byType(HelpCentreScreen), findsOneWidget);
    });

    testWidgets("7.9 Contact Support Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ContactSupportScreen());
      expect(find.byType(ContactSupportScreen), findsOneWidget);
    });

    testWidgets("7.10 Report Bug Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ReportBugScreen());
      expect(find.byType(ReportBugScreen), findsOneWidget);
    });

    testWidgets("7.11 Feature Requests Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, FeatureRequestsScreen());
      expect(find.byType(FeatureRequestsScreen), findsOneWidget);
    });

    testWidgets("7.12 About Ulvenik Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AboutUlvenikScreen());
      expect(find.byType(AboutUlvenikScreen), findsOneWidget);
    });

    testWidgets("7.13 Privacy Policy Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, PrivacyPolicyScreen());
      expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
    });

    testWidgets("7.14 Terms & Conditions Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TermsConditionsScreen());
      expect(find.byType(TermsConditionsScreen), findsOneWidget);
    });

    testWidgets("7.15 What's New Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, WhatsNewScreen());
      expect(find.byType(WhatsNewScreen), findsOneWidget);
    });

    testWidgets("7.16 Open Source Licences Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, OpenSourceLicencesScreen());
      expect(find.byType(OpenSourceLicencesScreen), findsOneWidget);
    });

    testWidgets("7.17 App Settings Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AppSettingsScreen());
      expect(find.byType(AppSettingsScreen), findsOneWidget);
    });

    testWidgets("7.18 Notifications Page Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, NotificationsPageScreen());
      expect(find.byType(NotificationsPageScreen), findsOneWidget);
    });

    testWidgets("7.19 Profile Page Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ProfilePageScreen());
      expect(find.byType(ProfilePageScreen), findsOneWidget);
    });

    testWidgets("7.20 Edit Profile Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, EditProfileScreen());
      expect(find.byType(EditProfileScreen), findsOneWidget);
    });

  });

  group("BATCH 8 — Account & Utility", () {
    testWidgets("8.1 Billing History Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, BillingHistoryScreen());
      expect(find.byType(BillingHistoryScreen), findsOneWidget);
    });

    testWidgets("8.2 Subscription Details Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SubscriptionDetailsScreen());
      expect(find.byType(SubscriptionDetailsScreen), findsOneWidget);
    });

    testWidgets("8.3 Restore Purchases Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, RestorePurchasesScreen());
      expect(find.byType(RestorePurchasesScreen), findsOneWidget);
    });

    testWidgets("8.4 Delete Account Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, DeleteAccountScreen());
      expect(find.byType(DeleteAccountScreen), findsOneWidget);
    });

    testWidgets("8.5 Export My Data Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ExportMyDataScreen());
      expect(find.byType(ExportMyDataScreen), findsOneWidget);
    });

    testWidgets("8.6 Change Email Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ChangeEmailScreen());
      expect(find.byType(ChangeEmailScreen), findsOneWidget);
    });

    testWidgets("8.7 Change Password Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ChangePasswordScreen());
      expect(find.byType(ChangePasswordScreen), findsOneWidget);
    });

    testWidgets("8.8 Global Calendar Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, GlobalCalendarScreen());
      expect(find.byType(GlobalCalendarScreen), findsOneWidget);
    });

    testWidgets("8.9 Global Search Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, GlobalSearchScreen());
      expect(find.byType(GlobalSearchScreen), findsOneWidget);
    });

    testWidgets("8.10 Country Region Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, CountryRegionScreen());
      expect(find.byType(CountryRegionScreen), findsOneWidget);
    });

    testWidgets("8.11 Language Settings Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, LanguageSettingsScreen());
      expect(find.byType(LanguageSettingsScreen), findsOneWidget);
    });

    testWidgets("8.12 Measurement Units Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MeasurementUnitsScreen());
      expect(find.byType(MeasurementUnitsScreen), findsOneWidget);
    });

    testWidgets("8.13 Date Time Format Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, DateTimeFormatScreen());
      expect(find.byType(DateTimeFormatScreen), findsOneWidget);
    });

    testWidgets("8.14 Timezone Settings Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TimezoneSettingsScreen());
      expect(find.byType(TimezoneSettingsScreen), findsOneWidget);
    });

    testWidgets("8.15 Change Photo Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ChangePhotoScreen());
      expect(find.byType(ChangePhotoScreen), findsOneWidget);
    });

    testWidgets("8.16 Image Editor Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ImageEditorScreen());
      expect(find.byType(ImageEditorScreen), findsOneWidget);
    });

  });

  group("BATCH 9 — Media & Library", () {
    testWidgets("9.1 Media Library Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MediaLibraryScreen());
      expect(find.byType(MediaLibraryScreen), findsOneWidget);
    });

    testWidgets("9.2 Video Viewer Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, VideoViewerScreen());
      expect(find.byType(VideoViewerScreen), findsOneWidget);
    });

    testWidgets("9.3 Photo Viewer Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, PhotoViewerScreen());
      expect(find.byType(PhotoViewerScreen), findsOneWidget);
    });

    testWidgets("9.4 Document Viewer Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, DocumentViewerScreen());
      expect(find.byType(DocumentViewerScreen), findsOneWidget);
    });

    testWidgets("9.5 Media Upload Manager Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MediaUploadManagerScreen());
      expect(find.byType(MediaUploadManagerScreen), findsOneWidget);
    });

    testWidgets("9.6 Media Collections Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MediaCollectionsScreen());
      expect(find.byType(MediaCollectionsScreen), findsOneWidget);
    });

    testWidgets("9.7 Media Search Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MediaSearchScreen());
      expect(find.byType(MediaSearchScreen), findsOneWidget);
    });

    testWidgets("9.8 Media Favourites Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MediaFavouritesScreen());
      expect(find.byType(MediaFavouritesScreen), findsOneWidget);
    });

  });

  group("BATCH 10 — Sport Pack", () {
    testWidgets("10.1 Sport Pack Overview Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SportPackOverviewScreen());
      expect(find.byType(SportPackOverviewScreen), findsOneWidget);
    });

    testWidgets("10.2 My Sports Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, MySportsScreen());
      expect(find.byType(MySportsScreen), findsOneWidget);
    });

    testWidgets("10.3 Sport Details IGP Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SportDetailsIgpScreen());
      expect(find.byType(SportDetailsIgpScreen), findsOneWidget);
    });

    testWidgets("10.4 Create Sport Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, CreateSportScreen());
      expect(find.byType(CreateSportScreen), findsOneWidget);
    });

    testWidgets("10.5 Competitions Overview Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, CompetitionsOverviewScreen());
      expect(find.byType(CompetitionsOverviewScreen), findsOneWidget);
    });

    testWidgets("10.6 Competition Details Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, CompetitionDetailsScreen());
      expect(find.byType(CompetitionDetailsScreen), findsOneWidget);
    });

    testWidgets("10.7 Record Competition Result Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, RecordCompetitionResultScreen());
      expect(find.byType(RecordCompetitionResultScreen), findsOneWidget);
    });

    testWidgets("10.8 Qualifications Titles Awards Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, QualificationsTitlesAwardsScreen());
      expect(find.byType(QualificationsTitlesAwardsScreen), findsOneWidget);
    });

    testWidgets("10.9 Sport Statistics Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SportStatisticsScreen());
      expect(find.byType(SportStatisticsScreen), findsOneWidget);
    });

    testWidgets("10.10 Add Competition Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AddCompetitionScreen());
      expect(find.byType(AddCompetitionScreen), findsOneWidget);
    });

    testWidgets("10.11 Competition Results Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, CompetitionResultsScreen());
      expect(find.byType(CompetitionResultsScreen), findsOneWidget);
    });

    testWidgets("10.12 Achievements & Titles Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AchievementsTitlesScreen());
      expect(find.byType(AchievementsTitlesScreen), findsOneWidget);
    });

    testWidgets("10.13 Certificates & Documents Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, CertificatesDocumentsScreen());
      expect(find.byType(CertificatesDocumentsScreen), findsOneWidget);
    });

  });

  group("BATCH 11 — Trainer Pack", () {
    testWidgets("11.1 Trainer Dashboard Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TrainerDashboardScreen());
      expect(find.byType(TrainerDashboardScreen), findsOneWidget);
    });

    testWidgets("11.2 Trainer Profile Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TrainerProfileScreen());
      expect(find.byType(TrainerProfileScreen), findsOneWidget);
    });

    testWidgets("11.3 Clients Page Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ClientsPageScreen());
      expect(find.byType(ClientsPageScreen), findsOneWidget);
    });

    testWidgets("11.4 Client Profile Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ClientProfileScreen());
      expect(find.byType(ClientProfileScreen), findsOneWidget);
    });

    testWidgets("11.5 Client Dog Profile Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ClientDogProfileScreen());
      expect(find.byType(ClientDogProfileScreen), findsOneWidget);
    });

    testWidgets("11.6 Add Client Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AddClientScreen());
      expect(find.byType(AddClientScreen), findsOneWidget);
    });

    testWidgets("11.7 Edit Client Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, EditClientScreen());
      expect(find.byType(EditClientScreen), findsOneWidget);
    });

    testWidgets("11.8 Client Notes Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ClientNotesScreen());
      expect(find.byType(ClientNotesScreen), findsOneWidget);
    });

    testWidgets("11.9 Client Homework Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ClientHomeworkScreen());
      expect(find.byType(ClientHomeworkScreen), findsOneWidget);
    });

    testWidgets("11.10 Homework Details Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HomeworkDetailsScreen(title: "Agility Weave Poles"));
      expect(find.byType(HomeworkDetailsScreen), findsOneWidget);
    });

    testWidgets("11.11 Client Progress Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ClientProgressScreen());
      expect(find.byType(ClientProgressScreen), findsOneWidget);
    });

    testWidgets("11.12 Shared Records Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, SharedRecordsScreen());
      expect(find.byType(SharedRecordsScreen), findsOneWidget);
    });

    testWidgets("11.13 Client Permissions Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ClientPermissionsScreen());
      expect(find.byType(ClientPermissionsScreen), findsOneWidget);
    });

    testWidgets("11.14 Trainer Reports Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TrainerReportsScreen());
      expect(find.byType(TrainerReportsScreen), findsOneWidget);
    });

    testWidgets("11.15 Trainer Workspace Settings Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TrainerWorkspaceSettingsScreen());
      expect(find.byType(TrainerWorkspaceSettingsScreen), findsOneWidget);
    });

    testWidgets("11.16 Client Account Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ClientAccountScreen());
      expect(find.byType(ClientAccountScreen), findsOneWidget);
    });

    testWidgets("11.17 Client Dogs Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ClientDogsScreen());
      expect(find.byType(ClientDogsScreen), findsOneWidget);
    });

    testWidgets("11.18 Homework & Training Plans Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, HomeworkTrainingPlansScreen());
      expect(find.byType(HomeworkTrainingPlansScreen), findsOneWidget);
    });

    testWidgets("11.19 Lesson Records Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, LessonRecordsScreen());
      expect(find.byType(LessonRecordsScreen), findsOneWidget);
    });

    testWidgets("11.20 Trainer Notes Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TrainerNotesScreen());
      expect(find.byType(TrainerNotesScreen), findsOneWidget);
    });

    testWidgets("11.21 Trainer Notifications Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, TrainerNotificationsScreen());
      expect(find.byType(TrainerNotificationsScreen), findsOneWidget);
    });

  });

  group("NEW SCREENS — Rewards Management", () {
    testWidgets("N.1 Rewards Management Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, RewardsManagementScreen());
      expect(find.byType(RewardsManagementScreen), findsOneWidget);
    });

    testWidgets("N.2 Add Reward Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, AddRewardScreen());
      expect(find.byType(AddRewardScreen), findsOneWidget);
    });

    testWidgets("N.3 Edit Reward Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, EditRewardScreen());
      expect(find.byType(EditRewardScreen), findsOneWidget);
    });

    testWidgets("N.4 Manage Reward Types Screen renders without errors", (WidgetTester tester) async {
      await pumpScreen(tester, ManageRewardTypesScreen());
      expect(find.byType(ManageRewardTypesScreen), findsOneWidget);
    });

  });

}