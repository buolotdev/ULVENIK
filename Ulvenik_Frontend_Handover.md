# Ulvenik — Frontend Development Handover
## Screen Order, Build Instructions & Design Tokens

---

## HOW TO READ THIS DOCUMENT

- **BUILD** = implement this screen
- **SKIP** = do not build as a separate route/screen — this is a Figma design reference only (empty/populated states, alternate states). The developer implements it as a state of the parent screen.
- **REFERENCE** = use this Figma frame only to understand a state, flow or component — not a standalone screen

---

## BATCH 1 — Auth & Onboarding

| Figma Frame | Action | Notes |
|---|---|---|
| Splash Screen | DONE | Implemented in `lib/screens/splash_screen.dart` |
| ONBOARDING SCREEN 1 | DONE | Implemented in `lib/screens/onboarding_screen.dart` |
| ONBOARDING SCREEN 2 | DONE | Implemented in `lib/screens/onboarding_screen.dart` |
| ONBOARDING SCREEN 3 | DONE | Implemented in `lib/screens/onboarding_screen.dart` |
| Login | DONE | Implemented in `lib/screens/login_screen.dart` |
| Create Account | DONE | Implemented in `lib/screens/register_screen.dart` |
| Forgot Password | DONE | Implemented in `lib/screens/forgot_password_screen.dart` |
| Confirmation Screen | DONE | Implemented in `lib/screens/email_verification_screen.dart` |
| Email Verified | DONE | Implemented in `lib/screens/email_verification_screen.dart` |
| Set New Password | DONE | Implemented in `lib/screens/create_password_screen.dart` |
| Password Updated | DONE | Implemented in `lib/screens/password_updated_screen.dart` |
| Welcome | DONE | Implemented in `lib/screens/welcome_screen.dart` |
| 2FA Setup | DONE | Implemented in `lib/screens/two_factor_setup_screen.dart` |
| Disabled State | SKIP | Reference state for 2FA toggle — implement as state of 2FA Setup |
| Enabled State | SKIP | Reference state for 2FA toggle — implement as state of 2FA Setup |
| Dog Profile | SKIP | This is the early Stitch test frame — superseded by Dog Profile - Overview screens below |

---

## BATCH 2 — Core App Entry

| Figma Frame | Action | Notes |
|---|---|---|
| Homepage Empty Data | DONE | Implemented in `lib/screens/homepage_screen.dart` |
| Homepage Populated | DONE | Implemented in `lib/screens/homepage_screen.dart` |
| My Dogs Empty State | DONE | Implemented in `lib/screens/my_dogs_screen.dart` |
| My Dogs Populated | DONE | Implemented in `lib/screens/my_dogs_screen.dart` |
| Dogs All Workspaces | DONE | Implemented in `lib/screens/dogs_all_workspaces_screen.dart` |

---

## BATCH 3 — Dog Profile

| Figma Frame | Action | Notes |
|---|---|---|
| Dog Profile - Overview (New Dog) | DONE | Implemented in `lib/screens/dog_profile_screen.dart` |
| Dog Profile - Overview (Populated) | DONE | Implemented in `lib/screens/dog_profile_screen.dart` |
| Training Page - Empty | DONE | Implemented in `lib/screens/training_screen.dart` |
| Training Page - Populated | DONE | Implemented in `lib/screens/training_screen.dart` |
| Training Session - Draft State | DONE | Implemented in `lib/screens/training_session_screen.dart` |
| Training Session - Completed State | DONE | Implemented in `lib/screens/training_session_screen.dart` |
| Skills List - Empty State | DONE | Implemented in `lib/screens/skills_list_screen.dart` |
| Skills List - Populated State | DONE | Implemented in `lib/screens/skills_list_screen.dart` |
| Skill Details - Recall | DONE | Implemented in `lib/screens/skill_details_screen.dart` |
| Edit Skill - Discard Flow | SKIP | Reference for discard confirmation flow — implement as modal/alert |
| Add Skill - Technical Form | DONE | Implemented in `lib/screens/add_skill_screen.dart` |
| Add Exercise - Technical Form | DONE | Implemented in `lib/screens/add_exercise_screen.dart` |
| Exercise Details - Emergency Recall | DONE | Implemented in `lib/screens/exercise_details_screen.dart` |
| Edit Exercise - Technical Form | DONE | Implemented in `lib/screens/edit_exercise_screen.dart` |
| Archive & Delete Workflows | SKIP | Reference for archive/delete confirmation flows — implement as modals/alerts throughout |
| Goals List - Populated State | DONE | Implemented in `lib/screens/goals_list_screen.dart` |
| Goals List - Empty State | DONE | Implemented in `lib/screens/goals_list_screen.dart` |
| Create Goal - Technical Form | DONE | Implemented in `lib/screens/create_goal_screen.dart` |
| Goal Details - Complete 20 Recall Sessions | DONE | Implemented in `lib/screens/goal_details_screen.dart` |
| Goal Details - Archive & Delete States | SKIP | Reference for goal archive/delete — implement as states/modals of Goal Details |
| Statistics - Empty State | DONE | Implemented in `lib/screens/statistics_tab.dart` |
| Statistics - Populated State | DONE | Implemented in `lib/screens/statistics_tab.dart` |
| Dog Timeline - Empty State | DONE | Implemented in `lib/screens/timeline_screen.dart` |
| Dog Timeline - Populated State | DONE | Implemented in `lib/screens/timeline_screen.dart` |

---

## BATCH 4 — Health

| Figma Frame | Action | Notes |
|---|---|---|
| Health - Empty State | DONE | Implemented in `lib/screens/health_screen.dart` |
| Health - Populated State | DONE | Implemented in `lib/screens/health_screen.dart` |
| Health Records - Empty State | DONE | Implemented in `lib/screens/health_records_screen.dart` |
| Health Records - Populated State | DONE | Implemented in `lib/screens/health_records_screen.dart` |
| Add Health Record - General Form | DONE | Implemented in `lib/screens/add_health_record_screen.dart` |
| Add Health Record - Medication State | SKIP | Reference for medication variant of Add Health Record form — implement as form state |
| Health Record Details - Injury record with empty state sections | DONE | Implemented in `lib/screens/health_record_details_screen.dart` |
| Health Record Details - Medication record populated with all sections | SKIP | Reference for medication variant — implement as state of Health Record Details |
| Weight Tracker - Empty State | DONE | Implemented in `lib/screens/weight_tracker_screen.dart` |
| Weight Tracker - Populated State | DONE | Implemented in `lib/screens/weight_tracker_screen.dart` |
| Medication Manager - Empty State | DONE | Implemented in `lib/screens/medication_manager_screen.dart` |
| Medication Manager - Populated State | DONE | Implemented in `lib/screens/medication_manager_screen.dart` |
| Vaccination Manager - Populated State | DONE | Implemented in `lib/screens/vaccination_manager_screen.dart` |
| Vaccination Manager - Empty State | DONE | Implemented in `lib/screens/vaccination_manager_screen.dart` |
| Vet Visits - Empty State | DONE | Implemented in `lib/screens/vet_visits_screen.dart` |
| Vet Visits - Populated State | DONE | Implemented in `lib/screens/vet_visits_screen.dart` |
| Injuries & Recovery - Empty State | DONE | Implemented in `lib/screens/injuries_recovery_screen.dart` |
| Injuries & Recovery - Populated State | DONE | Implemented in `lib/screens/injuries_recovery_screen.dart` |
| Physiotherapy & Hydrotherapy - Empty State | DONE | Implemented in `lib/screens/physio_hydro_hub_screen.dart` |
| Physiotherapy & Hydrotherapy Hub | DONE | Implemented in `lib/screens/physio_hydro_hub_screen.dart` |
| Supplements - Empty State | DONE | Implemented in `lib/screens/supplements_screen.dart` |
| Supplements - Populated State | DONE | Implemented in `lib/screens/supplements_screen.dart` |
| Allergies & Sensitivities - Empty State | DONE | Implemented in `lib/screens/allergies_sensitivities_screen.dart` |
| Allergies & Sensitivities - Populated State | DONE | Implemented in `lib/screens/allergies_sensitivities_screen.dart` |
| Dental Care - Empty State | DONE | Implemented in `lib/screens/dental_care_screen.dart` |
| Dental Care - Populated State | DONE | Implemented in `lib/screens/dental_care_screen.dart` |
| Health Reports & Timeline - Empty State | DONE | Implemented in `lib/screens/health_reports_timeline_screen.dart` |
| Health Reports & Timeline - Populated State | DONE | Implemented in `lib/screens/health_reports_timeline_screen.dart` |
| Surgery & Procedures - Empty State | DONE | Implemented in `lib/screens/surgery_procedures_screen.dart` |
| Surgery & Procedures - Populated State | DONE | Implemented in `lib/screens/surgery_procedures_screen.dart` |
| Health Statistics - Empty State | DONE | Implemented in `lib/screens/health_statistics_screen.dart` |
| Health Statistics - Populated State | DONE | Implemented in `lib/screens/health_statistics_screen.dart` |
| Health Reminders - Empty State | DONE | Implemented in `lib/screens/health_reminders_screen.dart` |
| Health Reminders - Populated State | DONE | Implemented in `lib/screens/health_reminders_screen.dart` |
| Health Settings - Default State | DONE | Implemented in `lib/screens/health_settings_screen.dart` |
| Import & Export - Empty State (No Backup) | DONE | Implemented in `lib/screens/import_export_screen.dart` |
| Import & Export - Populated State | DONE | Implemented in `lib/screens/import_export_screen.dart` |
| Health Archive - Empty State | DONE | Implemented in `lib/screens/health_archive_screen.dart` |
| Health Archive - Populated State | DONE | Implemented in `lib/screens/health_archive_screen.dart` |
| Health Dashboard - Empty State | DONE | Implemented in `lib/screens/health_dashboard_screen.dart` |
| Health Dashboard - Populated State | DONE | Implemented in `lib/screens/health_dashboard_screen.dart` |

---

## BATCH 5 — Strength & Conditioning

| Figma Frame | Action | Notes |
|---|---|---|
| Strength & Conditioning Dashboard - Empty State | DONE | Implemented in `lib/screens/strength_conditioning_dashboard_screen.dart` |
| Strength & Conditioning Dashboard - Populated State | DONE | One screen, both states toggleable via top bar icon or dog profile switch |
| Activity Library - Empty State | DONE | Implemented in `lib/screens/activity_library_screen.dart` |
| Activity Library - Populated State | DONE | One screen, both states toggleable via top bar icon |
| Activity Details - Empty State | DONE | Implemented in `lib/screens/activity_details_screen.dart` |
| Activity Details - Populated State | DONE | One screen, both states toggleable via top bar icon and menu |
| Create Activity - Default State | DONE | Implemented in `lib/screens/create_activity_screen.dart` |
| Record Session - No Activity Selected | DONE | Implemented in `lib/screens/record_session_screen.dart` |
| Record Session - Activity Pre-selected | DONE | One screen, both states toggleable via top bar icon and in-card browse/change |
| Session Details - Populated State | DONE | Implemented in `lib/screens/session_details_screen.dart` |
| Activity Statistics - Empty State | DONE | Implemented in `lib/screens/activity_statistics_screen.dart` |
| Activity Statistics - Populated State | DONE | One screen, both states toggleable via top bar icon and menu |
| Activity Goals - Empty State | DONE | Implemented in `lib/screens/activity_goals_screen.dart` |
| Activity Goals - Populated State | DONE | One screen, both states toggleable via top bar icon and menu |
| Activity Insights - Empty State | DONE | Implemented in `lib/screens/activity_insights_screen.dart` |
| Activity Insights - Populated State | DONE | One screen, both states toggleable via top bar menu and title double-tap |
| Equipment - Empty State | DONE | Implemented in `lib/screens/equipment_screen.dart` |
| Equipment - Populated State | DONE | One screen, both states toggleable via top bar menu and title double-tap |
| Session Templates - Empty State | DONE | Implemented in `lib/screens/session_templates_screen.dart` |
| Session Templates - Populated State | DONE | One screen, both states toggleable via top bar menu and title double-tap |
| Export - Empty History State | DONE | Implemented in `lib/screens/export_screen.dart` |
| Export - Configured State | DONE | One screen, both states toggleable via top bar icon, menu, and title double-tap |
| Archive - Empty State | DONE | Implemented in `lib/screens/sc_archive_screen.dart` |
| Archive - Populated State | DONE | One screen, both states toggleable via top bar icon, menu, and title double-tap |
| Strength & Conditioning Settings | DONE | Implemented in `lib/screens/sc_settings_screen.dart` with custom checkboxes, interactive pickers, and live animated chart preview |

---

## BATCH 6 — Timeline

| Figma Frame | Action | Notes |
|---|---|---|
| Global Timeline - Empty State | DONE | Implemented in `lib/screens/timeline_screen.dart` |
| Global Timeline - Populated State | DONE | One screen, both states toggleable via top bar icon, title double-tap, and dog selector |
| Timeline Dashboard - Empty State | DONE | Implemented in `lib/screens/timeline_dashboard_screen.dart` |
| Timeline Dashboard - Populated State | DONE | One screen, both states toggleable via top bar menu, dog chips (Atlas/Nova), and title double-tap |
| Timeline Event - Health Record | DONE | Implemented in `lib/screens/timeline_event_details_screen.dart` |
| Timeline Event - Training Session | DONE | Implemented as dynamic state of `TimelineEventDetailsScreen` with seamless variant switching (menu, bottom timeline navigator, and title double-tap) |
| Timeline Filters - Partially Applied State | DONE | Implemented in `lib/screens/timeline_filters_screen.dart` with active chips, saved presets, 2-column categories, animated breakdown chart, and dynamic apply count |
| Timeline Search - Pre-search State | DONE | Implemented in `lib/screens/timeline_search_screen.dart` with toggles, saved/recent/popular searches |
| Timeline Search - Active Results State | DONE | Implemented as state of `TimelineSearchScreen` with live query highlights, category filter chips, animated match frequency chart, and relevance sort |
| Timeline Calendar - Month View | DONE | Implemented in `lib/screens/timeline_calendar_screen.dart` with interactive month grid, day selection, category indicator dots, 3x2 summary grid, and animated cadence chart |
| Timeline Calendar - Day View | DONE | Implemented as dynamic state of `TimelineCalendarScreen` with continuous vertical timeline track, node rings, photo/video media gallery, and empty state |
| Timeline Calendar - Week View | DONE | Implemented as dynamic state of `TimelineCalendarScreen` with 7-column day strip, date badges, interactive workload chart, and expandable detail cards |
| Timeline Statistics - Empty State | DONE | Implemented as dynamic state of `TimelineStatisticsScreen` (Node `780:6077`) with week navigator, empty state prompt, history CTA, and animated pulse skeleton wireframes |
| Timeline Statistics - Populated State | DONE | Implemented in `lib/screens/timeline_statistics_screen.dart` (Node `780:6164`) with timeframe pills, Bento metric cards, animated curved spline chart with tooltips, and interactive category donut |
| Timeline Export - Empty State | DONE | Implemented as dynamic state of `TimelineExportScreen` (Node `781:6334`) with document prompt, Go to Timeline CTA, and disabled action footer |
| Timeline Export - Populated State | DONE | Implemented in `lib/screens/timeline_export_screen.dart` (Node `781:6362`) with export type radio selector, date range pills, format picker, and interactive compilation modal |
| Timeline Favourites - Empty State | DONE | Implemented as dynamic state of `TimelineFavouritesScreen` (Node `782:6481`) with outline heart prompt, description, and Go to Timeline CTA |
| Timeline Favourites - Populated State | DONE | Implemented in `lib/screens/timeline_favourites_screen.dart` (Node `782:6674`) with live search, 3-metric bento card, category dot telemetry, filter chips, gold heart toggles, and sticky sort/filter bar |
| Timeline Archive - Empty State | DONE | Implemented as dynamic state of `TimelineArchiveScreen` (Node `783:6947`) with archive box icon, description, Return to Timeline CTA, and bottom action bar |
| Timeline Archive - Populated State | DONE | Implemented in `lib/screens/timeline_archive_screen.dart` (Node `783:7019`) with canine profile header, 3-metric summary bento, multi-select checkboxes, restore modal workflow, orphaned record handler, and media attachments |
| Timeline Settings | DONE | Implemented in `lib/screens/timeline_settings_screen.dart` (Node `789:2`) with 9 expandable accordion panels (Display, Grouping, Event Preview, Favourites, Archive, Search, Notifications, Performance, Privacy), interactive modal selectors, and Reset confirmation bottom sheet |
| Timeline Insights - Empty State | DONE | Implemented as dynamic state of `TimelineInsightsScreen` (Node `824:2`) with lightbulb prompt, description, Go to Timeline CTA, and educational modal |
| Timeline Insights - Populated State | DONE | Implemented in `lib/screens/timeline_insights_screen.dart` (Node `824:122`) with 3-metric bento summary card, refresh simulation, recently discovered cards with NEW badges, 7 animated category accordions, and interactive FlChart trend modal |
| Timeline Memories - Empty State | DONE | Implemented as dynamic state of `TimelineMemoriesScreen` (Node `824:465`) with sparkles icon, description prompt, Go to Timeline CTA, and educational modal |
| Timeline Memories - Populated State | DONE | Implemented in `lib/screens/timeline_memories_screen.dart` (Node `825:629`) with 3-metric summary bento, filter pills, 1-Year Ago Today flashback hero card with interactive Story/Reel auto-advancing modal, curated capsules horizontal carousel, and favorite toggles |
| Timeline Activity Map - Empty State | DONE | Implemented as dynamic state of `TimelineActivityMapScreen` (Node `826:1118`) with location off prompt, description, Go to Timeline CTA, and educational modal |
| Timeline Activity Map - Marker Selected | DONE | Implemented as interactive state of `TimelineActivityMapScreen` (Node `826:1288`) with pin focus zoom, distance/elevation/frequency telemetry badges, and direct Timeline session navigator |
| Timeline Activity Map - Default State | DONE | Implemented in `lib/screens/timeline_activity_map_screen.dart` (Node `826:1540`) with dark vector terrain contours, category filter pills, zoom & recenter floating controls, heatmap overlay toggle, and bottom hotspot metrics bento |
| Timeline Compare - Empty State | DONE | Implemented as dynamic state of `TimelineCompareScreen` (Node `827:1767`) with scale icon prompt, description, Go to Timeline CTA, and educational modal |
| Timeline Compare - Populated State | DONE | Implemented in `lib/screens/timeline_compare_screen.dart` (Node `827:1953`) with dual-slot canine/timeframe comparators, comparative metrics bento (+45% events, +24% consistency, +32h volume deltas), dual animated FlChart spline curves, and category focus progress deltas |
| Timeline Smart Collections - Empty State | DONE | Implemented as dynamic state of `TimelineSmartCollectionsScreen` (Node `828:2478`) with folders icon prompt, description, Create First Collection CTA, and educational modal |
| Timeline Smart Collections - Populated State | DONE | Implemented in `lib/screens/timeline_smart_collections_screen.dart` (Node `829:2710`) with 3-metric summary bento, 6 active dynamic rule cards, event counters, star toggles, and modal creation workflow |
| Timeline Widgets - Empty State | DONE | Implemented as dynamic state of `TimelineWidgetsScreen` (Node `830:3094`) with widgets icon prompt, description, Browse Widget Gallery CTA, and educational modal |
| Timeline Widgets - Populated Gallery | DONE | Implemented in `lib/screens/timeline_widgets_screen.dart` (Node `830:3875`) with live Dynamic Island activity simulation, 2x2 Small streak & health cards, 4x2 Medium weekly training matrix & upcoming schedule cards, and interactive OS widget config modal |

---

## BATCH 7 — More & Settings

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — More Page | DONE | Implemented in `lib/screens/more_page_screen.dart` as canonical 5th tab of `MainLayout` with handler profile card, cloud sync telemetry, grouped hub modules, and active navigation |
| Ulvenik — More Dashboard | DONE | Implemented as integrated state of `MorePageScreen` with empty state toggle, storage and telemetry indicators, and module shortcuts |
| Ulvenik — Notification Settings | DONE | Implemented in `lib/screens/notification_settings_screen.dart` with master push switch, training session advance warning picker, health/vaccine/vet alerts, quiet hours, sound and haptic controls |
| Ulvenik — Appearance Settings | DONE | Implemented in `lib/screens/appearance_settings_screen.dart` with Dark Obsidian/Stealth Frost/AMOLED Black visual theme cards, 5-accent color chooser, font scale factor with live preview, and high-contrast field mode toggle |
| Ulvenik — Backup & Sync | DONE | Implemented in `lib/screens/backup_sync_screen.dart` with live sync simulation progress bar, auto nightly backup switch, Wi-Fi only toggle, historical snapshots restore dialog, and offline zip export |
| Ulvenik — Offline Mode & Downloads | DONE | Implemented in `lib/screens/offline_mode_screen.dart` with Force Offline field toggle, topographic map packs with simulated downloading, auto-cache drill settings, and clear cache modal |
| Ulvenik — Storage Management | DONE | Implemented in `lib/screens/storage_management_screen.dart` with interactive FlChart donut breakdown, 4 storage category rows, cache cleanup, video compression modal, and auto-optimization toggles |
| Ulvenik — Help Centre | DONE | Implemented in `lib/screens/help_centre_screen.dart` with dynamic search bar, 4 topic cards, expandable FAQ accordions, and direct support bridge |
| Ulvenik — Contact Support | DONE | Implemented in `lib/screens/contact_support_screen.dart` with live handler chat shortcut, email link, priority response banner, inquiry submission form with diagnostics checkbox, and ticket confirmation dialog |
| Ulvenik — Report a Bug | DONE | Implemented in `lib/screens/report_bug_screen.dart` with severity & module selectors, reproduction steps inputs, screenshot attachment simulator, auto diagnostic envelope, and ticket submission modal |
| Ulvenik — Feature Requests | DONE | Implemented in `lib/screens/feature_requests_screen.dart` with status filter pills, upvote tally buttons, roadmap cards, and community proposal submission modal |
| Ulvenik — About Ulvenik | DONE | Implemented in `lib/screens/about_ulvenik_screen.dart` with glowing brand emblem, mission manifesto, system architecture specs, field advisory board, and community channels |
| Ulvenik — Privacy Policy | DONE | Implemented in `lib/screens/privacy_policy_screen.dart` with zero-monetization pillars, biometric encryption guarantees, detailed telemetry collection clauses, and data erasure policy |
| Ulvenik — Terms & Conditions | DONE | Implemented in `lib/screens/terms_conditions_screen.dart` with handler safety requirements, veterinary medical disclaimers, subscription quotas, and map licensing clauses |
| Ulvenik — What's New | DONE | Implemented in `lib/screens/whats_new_screen.dart` with v2.4.0 release hero, feature highlight cards (Timeline Compare, Activity Map, Widgets, Smart Collections), and past release notes |
| Ulvenik — Open Source Licences | DONE | Implemented in `lib/screens/open_source_licences_screen.dart` with expandable third-party package license tiles (Flutter, fl_chart, intl, google_fonts) |
| Ulvenik — Settings | DONE | Implemented in `lib/screens/app_settings_screen.dart` with Account, Preferences, Units, Cloud & Offline, and Legal categories with clean grouped cards |
| Ulvenik — Notifications Page | DONE | Implemented in `lib/screens/notifications_page_screen.dart` supporting populated alert inbox and empty state with category filters (Training, Health, Milestone) and mark-all-read capability |
| Ulvenik — Profile Page | DONE | Implemented in `lib/screens/profile_page_screen.dart` with handler hero avatar, Pro badge, career metrics bento (847 sessions, 14d streak), and registered canine workspaces |
| Ulvenik — Edit Profile | DONE | Implemented in `lib/screens/edit_profile_screen.dart` with avatar image change simulator, name, title, email, location, bio inputs, and state synchronization back to profile |

---

## BATCH 8 — Account & Utility

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — Billing History | DONE | Implemented in `lib/screens/billing_history_screen.dart` with payment method display, past monthly invoices list ($9.99 paid receipts), and PDF download actions |
| Ulvenik — Subscription Details | DONE | Implemented in `lib/screens/subscription_details_screen.dart` with Pro Handler tier hero card, next billing date, cloud quota progress bar, included features checklist, and restore purchases action |
| Ulvenik — Restore Purchases | DONE | Integrated into `SubscriptionDetailsScreen` with App Store / Google Play receipt validation dialog |
| Ulvenik — Delete Account | DONE | Implemented in `lib/screens/delete_account_screen.dart` with severe loss checklist, mandatory confirmation phrase typing validation, and account wiping execution modal |
| Ulvenik — Export My Data | DONE | Implemented in `lib/screens/export_my_data_screen.dart` with multi-category data checklist, ZIP/JSON archive format selectors, live packaging progress indicator, and email delivery dispatch modal |
| Ulvenik — Change Email Address | DONE | Implemented in `lib/screens/change_email_screen.dart` with current verified email indicator, new email validation, password authentication, and 6-digit OTP verification modal |
| Ulvenik — Change Password | DONE | Implemented in `lib/screens/change_password_screen.dart` with real-time dynamic strength meter, requirement checklist validation, current password authentication, and forgot password link |
| Ulvenik — Calendar Page | DONE | Implemented in `lib/screens/global_calendar_screen.dart` with horizontal 7-day picker, category filters (Training, S&C, Health, Event), event agenda cards, and schedule event bottom sheet |
| Ulvenik — Global Search | DONE | Implemented in `lib/screens/global_search_screen.dart` with cross-app unified search engine, scope filter pills (Dogs, Drills, Health, Timeline, Media), recent search chips, and live results |
| Ulvenik — Country or Region | DONE | Implemented in `lib/screens/country_region_screen.dart` with dynamic search bar, active country badge, country code tags, and selection state |
| Ulvenik — Language | DONE | Implemented in `lib/screens/language_settings_screen.dart` with suggested handler languages (including Deutsch for IGP trials, Norsk, Svenska), search filter, and selection state |
| Ulvenik — Measurement Units | DONE | Implemented in `lib/screens/measurement_units_screen.dart` with Metric/Imperial preset switcher, live telemetry preview card, and granular unit pickers for distance, weight, temp, elevation, and speed |
| Ulvenik — Date & Time Format | DONE | Implemented in `lib/screens/date_time_format_screen.dart` with live time/date preview banner, 24h vs 12h notation, DD/MM/YYYY vs MM/DD/YYYY vs ISO 8601 date pickers, and week start day selector |
| Ulvenik — Time Zone | DONE | Implemented in `lib/screens/timezone_settings_screen.dart` with GPS automatic detection switch, timezone search filter, city mapping, UTC offset badges, and selection feedback |
| Ulvenik — Change Photo (Bottom Sheet) | DONE | Implemented in `lib/widgets/change_photo_bottom_sheet.dart` with empty/populated toggle, Camera, Library, Media options, and Remove Photo action |
| Ulvenik — Image Editor (Crop Guide) | DONE | Implemented in `lib/screens/image_editor_screen.dart` with pure black canvas, circular/square crop guide overlays, zoom/pinch/pan gestures, 3x3 gridlines, rotation, and aspect ratio chips |
| Ulvenik — Profile Photo (Empty State) | DONE | Integrated as toggleable reference state inside `ChangePhotoBottomSheet` |

---

## BATCH 9 — Media & Library

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — Media Library | DONE | Implemented in `lib/screens/media_library_screen.dart` with category tabs (All, Videos, Photos, Docs), storage strip, interactive media grid linking to VideoViewer, PhotoViewer, and DocumentViewer, and upload CTA |
| Ulvenik — Video Viewer | DONE | Implemented in `lib/screens/video_viewer_screen.dart` on pure black background without bottom nav, with scrubber, play/pause controls, 10s skip buttons, HUD biometric telemetry overlay, and slow-motion speed selectors |
| Ulvenik — Photo Viewer | DONE | Implemented in `lib/screens/photo_viewer_screen.dart` on pure black background without bottom nav, with InteractiveViewer pinch-to-zoom, EXIF camera metadata toggle, photo counter, and thumbnail navigation strip |
| Ulvenik — Document Viewer | DONE | Implemented in `lib/screens/document_viewer_screen.dart` with interactive page navigation (Page 1 of 3), zoom controls, verified medical certificate rendering, and print/share actions |
| Ulvenik — Media Upload Manager | DONE | Implemented in `lib/screens/media_upload_manager_screen.dart` with live upload speed telemetry, active queue with animated progress bar, completed item verification tags, and pause/resume queue actions |
| Ulvenik — Media Collections | DONE | Implemented in `lib/screens/media_collections_screen.dart` with curated album folders (Bite Work, S&R Scent, Agility, OFA Medical Records, Trial Highlights), and new collection creation dialog |
| Ulvenik — Storage Manager | DONE | Implemented in `lib/screens/storage_management_screen.dart` with 1.24 GB storage breakdown, cache clearing, and 4K media optimization |
| Ulvenik — Media Search | DONE | Implemented in `lib/screens/media_search_screen.dart` with real-time text query filtering, media type tabs (Videos, Photos, Docs), canine tagging, and instant preview navigation |
| Ulvenik — Favourites | DONE | Implemented in `lib/screens/media_favourites_screen.dart` with bookmarked video and photo highlights grid, star toggle actions, and toggleable empty state |

---

## BATCH 10 — Sport Pack (Sport Pack subscription required)

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — Sport Pack Overview | DONE | Implemented in `lib/screens/sport_pack_overview_screen.dart` with candidate card, career metrics (14 trials, 93.4 avg, 3 podiums), module directory, and upcoming championship countdown |
| Ulvenik — My Sports | DONE | Implemented in `lib/screens/my_sports_screen.dart` with active canine disciplines (IGP, S&R, Agility, Mondioring), phase breakdowns, session counters, and links to Sport Details and Create Sport |
| Ulvenik — Sport Details (IGP) | DONE | Implemented in `lib/screens/sport_details_igp_screen.dart` with Phase A (Tracking), Phase B (Obedience), Phase C (Protection) performance bar chart, TSB rating, and actions for recording results and trial scheduling |
| Ulvenik — Create Sport | DONE | Implemented in `lib/screens/create_sport_screen.dart` with discipline name, governing organization, assigned canine dropdown, phase selector, and max/passing score inputs |
| Ulvenik — Competitions Overview | DONE | Implemented in `lib/screens/competitions_overview_screen.dart` with Upcoming and Past Trial tabs, registration status, podium placement indicators, and navigation to Competition Details |
| Ulvenik — Competition Details | DONE | Implemented in `lib/screens/competition_details_screen.dart` with trial metadata (judge, location, registration number), candidate scorebook, phase timetable, and action to record official score |
| Ulvenik — Record Competition Result | DONE | Implemented in `lib/screens/record_competition_result_screen.dart` with dynamic 3-phase point score calculator (Phase A, B, C), live V/SG/G rating indicator, TSB assessment chips, and podium placement selector |
| Ulvenik — Qualifications, Titles & Awards | DONE | Implemented in `lib/screens/qualifications_titles_awards_screen.dart` with official certificate records (IGP 2, IGP 1, BH/VT, FH 1) and championship gold awards |
| Ulvenik — Sport Statistics | DONE | Implemented in `lib/screens/sport_statistics_screen.dart` with metric bento cards, animated spline career score curve with interactive touch tooltips, and phase balance pie chart |
| Ulvenik — Sports List | SKIP | Duplicate of My Sports — delete from Figma |
| Ulvenik — Sport Details (IGP) | SKIP | Duplicate — delete from Figma, keep first instance |
| Ulvenik — Competition List | SKIP | Duplicate of Competitions Overview — delete from Figma |
| Ulvenik — Add Competition | DONE | Implemented in `lib/screens/add_competition_screen.dart` with event title, discipline level dropdown, canine selector, venue location, and judge/decoy inputs |
| Ulvenik — Competition Details | SKIP | Duplicate — delete from Figma, keep first instance |
| Ulvenik — Competition Results | DONE | Implemented in `lib/screens/competition_results_screen.dart` with gold podium banner, official V rating, Phase A, B, C breakdown, and judge evaluation notes |
| Ulvenik — Achievements & Title | DONE | Implemented in `lib/screens/achievements_titles_screen.dart` with unlocked career milestone badges (Century Tracker, Iron Grip, Triple Crown), progress bars, and canine status indicators |
| Ulvenik — Certificates & Documents | DONE | Implemented in `lib/screens/certificates_documents_screen.dart` with official verified scorebooks (OFA, USCA, FCI, AKC Pedigree, Rabies Titer) and direct PDF viewing navigation |

---

## BATCH 11 — Trainer Pack (Trainer Pack subscription required)

### Old placeholder screens — DELETE FROM FIGMA, do not build

| Figma Frame | Action |
|---|---|
| Ulvenik — Clients Page (first instance) | DELETE — superseded by branch version below |
| Ulvenik — Client Account | DELETE — superseded by Client Profile |
| Ulvenik — Client Dogs | DELETE — superseded by Client Dog Profile |
| Ulvenik — Homework & Training Plans | DELETE — superseded by Homework Details |
| Ulvenik — Lesson Records | DELETE — superseded by Client Homework |
| Ulvenik — Trainer Notes | DELETE — superseded by Client Notes |
| Ulvenik — Reports & Progress Reviews | DELETE — superseded by Trainer Reports |
| Ulvenik — Trainer Analytics & Business Insights | DELETE — superseded by Client Progress |
| Ulvenik — Permissions & Access Control | DELETE — superseded by Client Permissions |
| Ulvenik — Trainer Notifications Centre | DELETE — superseded by Shared Records |
| Ulvenik — Trainer Workspace Settings | DONE — Built in lib/screens/trainer_workspace_settings_screen.dart |

### Branch screens — Trainer Pack (DONE)

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — Trainer Dashboard | DONE | Built in lib/screens/trainer_dashboard_screen.dart |
| Ulvenik — Trainer Profile & Business Identity | DONE | Built in lib/screens/trainer_profile_screen.dart |
| Ulvenik — Clients Page (second instance) | DONE | Built in lib/screens/clients_page_screen.dart |
| Ulvenik — Client Profile | DONE | Built in lib/screens/client_profile_screen.dart |
| Ulvenik — Client Dog Profile | DONE | Built in lib/screens/client_dog_profile_screen.dart |
| Ulvenik — Add Client | DONE | Built in lib/screens/add_client_screen.dart |
| Ulvenik — Edit Client | DONE | Built in lib/screens/edit_client_screen.dart |
| Ulvenik — Client Notes | DONE | Built in lib/screens/client_notes_screen.dart |
| Ulvenik — Client Homework | DONE | Built in lib/screens/client_homework_screen.dart |
| Ulvenik — Homework Details | DONE | Built in lib/screens/homework_details_screen.dart |
| Ulvenik — Client Progress | DONE | Built in lib/screens/client_progress_screen.dart |
| Ulvenik — Shared Records | DONE | Built in lib/screens/shared_records_screen.dart |
| Ulvenik — Client Permissions | DONE | Built in lib/screens/client_permissions_screen.dart |
| Ulvenik — Trainer Reports | DONE | Built in lib/screens/trainer_reports_screen.dart |

---

## NEW SCREENS (added during final review)

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — Rewards Management | DONE | Built in lib/screens/rewards_management_screen.dart |
| Ulvenik — Add Reward | DONE | Built as bottom sheet in lib/screens/rewards_management_screen.dart |
| Ulvenik — Edit Reward | DONE | Built as bottom sheet in lib/screens/rewards_management_screen.dart |
| Ulvenik — Manage Reward Types | DONE | Built in lib/screens/manage_reward_types_screen.dart |

---

## SCREENS WITH NO BOTTOM NAV BAR

These are modal screens. Bottom nav must NOT appear on them:

- Global Search
- Change Photo (Bottom Sheet)
- Image Editor (Crop Guide)
- Video Viewer
- Photo Viewer
- Add Reward (bottom sheet)
- Edit Reward (bottom sheet)
- All confirmation/discard bottom sheets throughout the app

---

## BOTTOM NAV BAR — ACTIVE TAB RULES

| Section | Active Tab |
|---|---|
| Home | Home |
| Dogs, Dog Profile and all branches (Training, Health, S&C, Timeline, Goals, Skills, Statistics, Rewards) | Dogs |
| Training Session (recording) | Training |
| Global Timeline | Timeline |
| More, Settings, Profile, Account, Media, Notifications | More |
| Sport Pack | Dogs |
| Trainer Pack | More |

---

## WELCOME & HOME MESSAGES

Do NOT hardcode greeting messages or Home Dashboard subheadings. These must rotate through a curated pre-written bank of messages. Implement as a randomised or sequenced string array — not AI-generated, not static.

---

## ROTATING DECORATIVE IMAGERY

Hero, background and decorative images throughout the app must rotate through a curated image bank — not a single hardcoded image. Applies to decorative contexts only. Dog profile photos and user-uploaded media are always fixed and never rotate.

---

## DESIGN TOKENS (for developer reference)

### Colours

| Token | Hex |
|---|---|
| Background / Obsidian | `#101214` |
| Cards / Carbon | `#1A1F22` |
| Primary / Forest Green | `#2E6B57` |
| Secondary / Sage | `#7A8F7A` |
| Info / Alpine Blue | `#5D8FAF` |
| Primary Text / Off White | `#F5F6F2` |
| Secondary Text / Stone Grey | `#A7B0AB` |
| Card border | `rgba(255,255,255,0.08)` |
| Error / Destructive | `#8B3A3A` |
| Destructive muted | `rgba(139,58,58,0.85)` |
| Bronze Accent | `#9B6B3D` |
| Favourite gold | `#B8920A` |
| Media viewer background | `#000000` |

### Typography

- **Font:** Inter — all weights, all screens, no exceptions
- No serif fonts, no display fonts

### Corner Radius

- Cards: 16–20px
- Inputs / small buttons: 12px
- Pills / tags: 9999px
- FAB: 50% (circle)

### Input Fields

- Flat bottom-border only — no rounded input box backgrounds
- 1px Stone Grey at rest, 1px Forest Green on focus

### FAB

- 56×56px circle, Forest Green background, Off White plus icon, no shadow

---

## WHAT NOT TO BUILD (skip entirely)

- Timeline Branch 17 — Developer & Diagnostic Tools (dev-only, not a user screen)
- All backend/database/architecture PDFs — not UI
- All project delivery/handover docs — not UI
- Any Figma frame marked SKIP or DELETE in the tables above
