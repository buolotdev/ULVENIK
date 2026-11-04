# Client Feedback & Screen Implementation Changelog

This document provides a comprehensive record of all client feedback from Figma and messages implemented across the Ulvenik application codebase, tracking the exact files modified, visual/copy requirements, and implementation details.

---

## Batch 1: Onboarding, Client Dog Profile, Email Verification & Password Setup

### 1. `lib/screens/onboarding_screen.dart`
* **Client Request**:
  * Consistent dark overlay/gradient across all three onboarding screens to ensure readability while allowing background images to show through.
  * Image 1 copy: *“Your dog’s training journey, all in one place. Build your own training system, record every session and follow your progress over time.”*
  * Image 2 copy: *“Every dog is different. Every handler is different. That’s why Ulvenik doesn’t define how you train. Create your own skills, exercises, sports, rewards and equipment, and build a training system around you and your dog.”*
  * Image 3 heading: *“Track What Matters”* (changed from *“Every Session Builds Your Journey”*).
  * Image 3 copy: *“Bring training, health, strength & conditioning and competition records together with your videos, notes, goals and progress — building a complete history of your dog’s journey over time.”*
* **Implementation**:
  * Applied identical 7-stop multi-stop dark gradient overlay across all three slides.
  * Updated slide 1, slide 2, and slide 3 headline and body copy to 100% exact match.

### 2. `lib/screens/client_dog_profile_screen.dart`
* **Client Request**:
  * Client Dogs do not need access to the full Health system that owners have for their own dogs.
  * Keep Health streamlined for Client Dogs to only training/care-relevant information:
    * Allergies & Sensitivities
    * Existing Injuries / Physical Limitations
    * Current Medication — where relevant to training/care
    * Important Medical Conditions
    * Emergency / Vet Information
    * General Health Notes
* **Implementation**:
  * Decoupled Client Dogs from the full owner `HealthDashboardScreen`.
  * Added a dedicated streamlined Health & Safety bottom sheet/modal with inline editing and reactive state persistence.

### 3. `lib/screens/email_verification_screen.dart`
* **Client Request**:
  * Under “Verify Your Email”, change text to: *“We’ve sent a verification link to your email address. Follow the link to verify your account.”*
  * Inside “Awaiting Verification” box, change text to: *“Check your inbox and spam folder for an email from Ulvenik, then follow the link to verify your account.”*
  * Change second button from “I’ve Verified My Email” to: *“I’ve Verified — Continue”*.
* **Implementation**:
  * Updated subtitle text, awaiting verification banner copy, and secondary action button label.

### 4. `lib/screens/create_password_screen.dart` & `lib/widgets/password_strength_indicator.dart`
* **Client Request**:
  * Change placeholder from example text to: *“Enter new password”*.
  * Password strength progress: **Weak → Good → Strong** (removed "Fair").
  * Dynamic color progression on strength bar:
    * Muted red for Weak
    * Amber/orange for Good
    * Ulvenik sage green for Strong
* **Implementation**:
  * Updated placeholder text to `"Enter new password"`.
  * Adjusted password evaluator to 3-tier system (Weak, Good, Strong).
  * Implemented dynamic muted red (`#C75D5D`), amber (`#D99B4B`), and sage green (`AppColors.secondarySage`) on the 4-dash strength indicator.

---

## Batch 2: Password Updated, Two-Factor Authentication & Home Dashboard

### 5. `lib/screens/password_updated_screen.dart`
* **Client Request**:
  * Change notice to: *“Your previous password is no longer active and any other sessions have been signed out.”*
  * Remove redundant *“Sign out of all other devices”* button.
* **Implementation**:
  * Replaced security message copy.
  * Removed secondary sign-out button, maintaining clean spacing to login action.

### 6. `lib/screens/two_factor_setup_screen.dart`
* **Client Request**:
  * QR Code instructions: *“Scan this QR code using your authenticator app.”*
  * Key label: *“Manual setup key”* (previously all-caps).
  * Status text: Under “NOT ENABLED”, change to: *“Add an extra layer of security to help protect your account if your password is ever compromised.”*
  * Button label: Change “Enable Two-Factor Authentication” to *“Set Up Two-Factor Authentication”*.
  * UK spelling: *“unrecognised device”*.
  * Recovery codes: Do not keep permanently visible; add *“View Recovery Codes”* requiring verification before displaying, with Copy, Download, and Print.
  * Disabling 2FA: Require confirmation before disabling.
* **Implementation**:
  * Updated copy, labels, and UK spelling.
  * Added locked recovery codes card with "View Recovery Codes" security challenge.
  * Added confirmation dialog before disabling 2FA.

### 7. `lib/screens/homepage_screen.dart`
* **Client Request**:
  * Change “K9 PERFORMANCE” at top bar to Ulvenik branding/logo.
  * Under “Welcome back, [name].”, rotate between 12 selection messages on app session start:
    1. *Pick up where you left off.*
    2. *Keep the journey moving.*
    3. *Every session adds something.*
    4. *Progress is built over time.*
    5. *Keep showing up.*
    6. *Small steps. Lasting progress.*
    7. *Another step in the journey.*
    8. *Consistency shapes progress.*
    9. *Keep building on yesterday.*
    10. *Today is part of the journey.*
    11. *Progress happens in the work.*
    12. *Ready for what’s next?*
  * Under “Start Training”, change subtitle to: *“Record a training session”*.
  * Under “Start S&C”, change subtitle to: *“Record an S&C session”*.
  * Change “FULL STATS” to: *“VIEW STATS”*.
* **Implementation**:
  * Replaced header title with Ulvenik mountain crest logo + `ULVENIK` typography and hamburger menu.
  * Implemented session-start random rotation for the 12 welcome messages.
  * Updated quick action subtitles and insights header button.

---

## Batch 3: Dogs List, Workspaces & Dog Profile Screen

### 8. `lib/screens/my_dogs_screen.dart`
* **Client Request**:
  * Empty state copy: Change from *“Add your first dog to begin recording its journey with Ulvenik.”* to:
    * *“Add your first dog to start recording their journey with Ulvenik.”*
  * Dog details formatting: Replace abbreviations like `“Golden Retriever · 4y · M”` with full format:
    * `“Golden Retriever · 4 yrs · Male”` / `“Belgian Malinois · 2 yrs · Female”` / `“Mixed Breed · 1 yr · Male”`
  * Natural activity timestamps: Use natural sentence/title case rather than ALL-CAPS:
    * `“2 hrs ago”` rather than `“2H AGO”`
    * `“1 week ago”` rather than `“1W AGO”`
    * Retain `“Yesterday”` and `“3 days ago”`.
  * Consistent bottom line: Every dog card bottom line represents their most recent activity. If a dog has no recorded activity yet, display `“No activity yet”` (e.g. for Nova & Monty) rather than a training category.
  * Workspace subscription pills: Add top tabs linked to subscriptions:
    * `My Dogs` — Core
    * `Sport Dogs` — Sport Pack
    * `Client Dogs` — Trainer Pack
* **Implementation**:
  * Updated empty state copy.
  * Reformatted all dog details to `[Breed] · [Age] yrs · [Gender]`.
  * Standardized activity timestamps to natural case (`Obedience · 2 hrs ago`, `Agility · Yesterday`, `Herding · 3 days ago`, `Tracking · 1 week ago`, `No activity yet`).
  * Added top horizontal workspace selector with subscription indicators.

### 9. `lib/screens/dogs_all_workspaces_screen.dart`
* **Client Request**:
  * Tabs at top linked to relevant subscriptions:
    * `My Dogs` — Core (6)
    * `Sport Dogs` — Sport Pack (3)
    * `Client Dogs` — Trainer Pack (1)
  * Dog profile photo repositioning/cropping: Allow users to reposition/crop their dog’s profile photo so it displays correctly within larger landscape cards.
* **Implementation**:
  * Added interactive repositioning & cropping tool for each landscape card:
    * Overlay reposition button on each landscape card.
    * Interactive bottom sheet with vertical framing slider (`-1.0` to `1.0`), quick presets (`Top Focus`, `Center Focus`, `Bottom Focus`), and live framing preview.
    * Direct connection to `ImageEditorScreen(initialCircularCrop: false)` for advanced pan, zoom, and crop adjustments.
  * Connected workspace tabs to subscription details (`SubscriptionDetailsScreen`, `SportPackOverviewScreen`, `TrainerWorkspaceSettingsScreen`).

### 10. `lib/screens/dog_profile_screen.dart`
* **Client Request**:
  * Change *“Training Log”* to *“Training”* and *“Start Training Session”* to *“Record Training Session”*.
  * Add *“S&C”* to profile navigation and change *“Sports”* to *“Sport”*.
  * Final navigation: `Overview | Training | S&C | Health | Sport | Media` (with horizontal scroll if needed).
  * Overview empty state: Replace the Goals box with a matching Strength & Conditioning box showing:
    * *“No S&C Sessions Recorded”* and a *“Record S&C Session”* button.
  * Change *“No upcoming activities scheduled.”* to *“No Upcoming Activities”*.
  * Today's Focus filter: Only display items that are actually relevant/due that day, rather than active ongoing goals.
  * Goals stat at top: Tapping the Goals badge (`5 GOALS`) navigates directly through to that dog’s goals (`GoalsListScreen`).
* **Implementation**:
  * Configured `TabController` and `TabBar` with 6 scrollable tabs: `Overview`, `Training`, `S&C`, `Health`, `Sport`, and `Media`.
  * Wired all 6 views with dedicated dashboards and actions.
  * In empty state, updated training button label, replaced Goals with S&C box, and updated upcoming title.
  * In populated state, updated Today's Focus to strictly time-bound due items (`08:00 AM · Due Today`, `Due Today · 15m Drill`, `06:00 PM · Due Today`).
  * Linked the `5 GOALS` stat badge in the header directly to `GoalsListScreen()`.

---

## Batch 4: Training Screen, Training Session Details & Skills Overview

### 11. `lib/screens/training_screen.dart`
* **Client Request**:
  * Change headline “Your Sessions” to “Training Sessions”.
  * Change “+ New Session” to “+ Record Session”.
  * Change “Start Training Session” (empty state) to “Record Training Session”.
  * Adapt dog category filters based on user’s subscription:
    * Core only — no category filter needed (hidden)
    * Core + Sport — All Dogs | My Dogs | Sport Dogs
    * Core + Trainer — All Dogs | My Dogs | Client Dogs
    * Complete — All Dogs | My Dogs | Sport Dogs | Client Dogs
    * Rule: All Dogs should only appear when the user has more than one dog category available.
* **Implementation**:
  * Updated headline title to `Training Sessions`.
  * Updated quick action button to `+ Record Session` and empty state action to `Record Training Session`.
  * Created `TrainingSubscriptionTier` enum with adaptive `_availableFilters` getter.
  * Filters hide completely on Core-only tier and adapt dynamically across Core + Sport, Core + Trainer, and Complete tiers.
  * Added testing toggle on TRAINING badge to cycle through all 4 subscription filter states.

### 12. `lib/screens/training_session_screen.dart`
* **Client Request**:
  * Change button “+ Add Section” / “++ Add Section” to “+ Add Training Area”.
  * Change “Phases Logged” and “Session Sections” to “Training Areas” for consistent terminology.
  * When “Complete Session” is selected, automatically populate the finish time with the current time, while still allowing manual edits.
  * Ensure training session page remains available within Core.
  * Ensure “Delete Session” requires confirmation before permanently deleting.
* **Implementation**:
  * Renamed section headers and button label to `+ Add Training Area` and `TRAINING AREAS`.
  * Updated `_complete()` method to automatically set `_finish ??= TimeOfDay.now()`, calculating duration while keeping the finish time field editable.
  * Enhanced `_confirmDelete()` modal dialog with explicit confirmation prompt before permanent removal.
  * Maintained full compatibility with Core subscription tier.

### 13. `lib/screens/skills_list_screen.dart`
* **Client Request**:
  * Change empty-state text underneath “No Skills Yet” to:
    * *“Create your dog’s skills, add exercises and track their progress over time.”*
* **Implementation**:
  * Updated empty-state description text underneath the `No Skills Yet` title to the exact copy.

---

## Batch 5: Skills List, Skill Details, Add Skill & Add Exercise

### 14. `lib/screens/skills_list_screen.dart`
* **Client Request**:
  * Reorder filters to: `All Skills | Recently Trained | Needs Work`.
  * `All Skills` selected by default when the page is opened.
  * When `Recently Trained` is selected, each skill shown consistently displays when it was last trained.
  * Keep `Needs Work`, but based on skills the user has marked as needing work rather than Ulvenik determining this automatically.
* **Implementation**:
  * Updated filter order to `['All Skills', 'Recently Trained', 'Needs Work']` with default selection index `0` (`All Skills`).
  * Updated recency display logic in `_buildSkillCard`: when `Recently Trained` (`_filter == 1`) is active, each card consistently displays its `lastTrained` timestamp with divider.
  * Filter for `Needs Work` (`_filter == 2`) now filters strictly by handler-marked set `_userMarkedNeedsWork` with an explicit badge indicator.

### 15. `lib/screens/skill_details_screen.dart`
* **Client Request**:
  * Change the “Exercise” action at the top to “Add Exercise”.
  * Ensure goal progress percentage and session ratings (such as “Great” / “Neutral”) are based on information entered/selected by the user rather than Ulvenik automatically judging the dog’s performance.
* **Implementation**:
  * Converted to `StatefulWidget` to maintain user-recorded evaluations.
  * Renamed top action button to `Add Exercise` and wired it to `AddExerciseScreen(parentSkill: widget.skillName)`.
  * Added interactive goal progress updating modal bottom sheet (`_showProgressDialog`), allowing the handler to adjust their progress percentage with slider and presets; updated label to `PROGRESS (USER-RECORDED)`.
  * Made recent session ratings interactive (`_editSessionRating`), allowing the handler to record and change ratings (`GREAT`, `GOOD`, `NEUTRAL`, `NEEDS WORK`) reflecting their personal assessment.

### 16. `lib/screens/add_skill_screen.dart`
* **Client Request**:
  * Change text underneath “Discard Changes?” to:
    * *“You have unsaved changes to this skill. If you leave now, your changes won’t be saved.”*
  * Change Skill Name placeholder/example from “e.g. Heeling” to “e.g. Heelwork”.
* **Implementation**:
  * Updated discard modal sheet with alert warning icon, `Discard Changes?` title, and the exact client copy.
  * Replaced buttons with `Continue Editing` (primary green) and `Discard Changes` (destructive action).
  * Updated Skill Name text field hint to `"e.g. Heelwork"`.

### 17. `lib/screens/add_exercise_screen.dart`
* **Client Request**:
  * Change “Parent Skill” to “Skill”.
  * Change text underneath Recall to:
    * *“This exercise will be linked to Recall and inherit its training tags.”*
  * Change Exercise Name example from “e.g., Hidden subject recall” to “e.g. Recall through distractions”.
  * Under Visual Identification, change “Inherited from Recall” to “Using Recall image”.
* **Implementation**:
  * Renamed section header to `SKILL`.
  * Updated dynamic description under skill card to `'This exercise will be linked to ${widget.parentSkill} and inherit its training tags.'`.
  * Updated exercise name input hint to `"e.g. Recall through distractions"`.
  * Updated visual identification asset title to `'Using ${widget.parentSkill} image'`.
  * Standardized discard confirmation dialog to match the same high-visibility modal.

---

## Batch 6: Exercise Details, Edit Exercise & Goals Overview

### 18. `lib/screens/exercise_details_screen.dart`
* **Client Request**:
  * Change the “PARENT” action to “SKILL”.
  * Change “Skill Hierarchy” to “Linked Skill”, and change “Tap to view parent skill progression” to “Tap to view skill progress”.
  * Any progression shown on this page (goal completion percentages and session success rates) must be based entirely on information entered/set by the user rather than Ulvenik assessing the dog’s performance itself.
  * On Archive Exercise dialog: change *“your active lists”* to *“your active exercises”*.
  * On Delete Exercise dialog: change *“47 past session logs”* to *“47 past session records”*.
* **Implementation**:
  * Updated quick action label to `SKILL` with `Icons.psychology_outlined`.
  * Renamed section header to `Linked Skill` and tap hint to `'Tap to view skill progress'`.
  * Replaced static progression with handler-assessed tracking:
    * Active goal completion shows `'55% COMPLETE'` and allows the handler to adjust their recorded progress via `_updateGoalProgress()`.
    * Recent sessions show handler success rates (`90%`, `75%`) with interactive evaluation update sheet (`_editSessionSuccessRate`).
  * Implemented `_showArchiveDialog()` bottom sheet with green archive icon, exact copy: *“Archiving "Retrieve & Hold" will hide it from your active exercises...”*, and actions.
  * Implemented `_showDeleteDialog()` bottom sheet with warning banner, *“47 past session records”*, *“Historical chart data”*, and destructive action confirmation.
  * Added top right `...` more menu in AppBar to access Edit, Archive, and Delete options.

### 19. `lib/screens/edit_exercise_screen.dart`
* **Client Request**:
  * Change “PARENT SKILL” to “SKILL”.
  * Change “TRAINING NOTES” to “NOTES”.
  * Properly centre dropdown arrows/chevrons within fields.
  * If changing the linked Skill also changes any inherited tags/information, make sure the user is made aware before those changes are applied.
* **Implementation**:
  * Renamed label to `SKILL` and picker header to `Select Skill`.
  * Renamed label to `NOTES`.
  * Centered dropdown chevron vertically using `crossAxisAlignment: CrossAxisAlignment.center` and `height: 1.2` text styling.
  * Added `_confirmSkillChange` dialog alerting the user when changing the linked skill that inherited tags and training parameters will update before applying changes.

### 20. `lib/screens/goals_list_screen.dart`
* **Client Request**:
  * Reorder filters to: `All | Active | Completed | Overdue` with `All` selected by default.
  * Add S&C to the goal categories alongside Training, Health and Sport.
  * Sport should only be available as a category for users subscribed to the Sport Pack.
  * Any goal progress shown should be based on information entered/recorded by the user (objective progress like session counts can update automatically).
  * Replace “K9 PERFORMANCE” at the top with the Ulvenik branding/logo.
  * Change empty state heading from *“Start Working Towards Your Next Achievement”* to *“Set Your First Goal”*.
  * Change empty state subtitle to: *“Create goals for training, S&C, health and more, and track your progress over time.”*
* **Implementation**:
  * Reordered filters to `['All', 'Active', 'Completed', 'Overdue']` with index `0` (`All`) active by default, and updated category filtering logic across all goal types.
  * Added `S&C` (Strength & Conditioning) category chip alongside `Training` and `Health`.
  * Conditionally rendered `Sport` category chip based on `_hasSportPack` subscription status.
  * Clearly distinguished objective session progress (`14/20 Session Count`) from handler-assessed qualitative milestones.
  * Replaced top bar with Ulvenik mountain crest logo + `ULVENIK` typography and hamburger menu.
  * Updated empty state headline to *“Set Your First Goal”* and body copy to the exact client text.

---

### 21. `lib/screens/goal_details_screen.dart`
* **Client Request**:
  * Change "PRIORITY HIGH" to "HIGH PRIORITY", as this reads more naturally.
  * Make Archive Goal and Delete Goal follow the same layout/flow as Archive Exercise and Delete Exercise, with both management options available together in the same place.
  * For the Archive Goal confirmation, change the text underneath "Archive Goal?" to:
    *"This will archive 'Pass BH' and remove it from your active goals. All data and linked sessions will remain intact, and you can restore it at any time."*
  * For the Delete Goal confirmation:
    * **WILL NOT BE DELETED**:
      * All linked training sessions
      * Notes and media attached to sessions
    * **WILL BE PERMANENTLY REMOVED**:
      * Goal progress history and statistics
      * Goal-specific notes and reminders
* **Implementation**:
  * Updated priority badge text from `PRIORITY HIGH` to `HIGH PRIORITY`.
  * Added top-right options menu icon (`...`) with options for "Archive Goal" and "Delete Goal".
  * Built styled modal bottom sheets for both confirmations matching Ulvenik dark obsidian UI.
  * Applied exact copy for Archive Goal and the categorized bullet breakdown for Delete Goal.

### 22. `lib/screens/create_goal_screen.dart`
* **Client Request**:
  * Add Sport to the goal categories, but only for users subscribed to the Sport Pack.
  * Under Automatic, change "Track based on logged sessions" to "Track based on recorded sessions".
  * Automatic progress should only calculate objective progress from information the user has recorded, rather than Ulvenik assessing the dog's training performance.
  * Make sure Trainer Pack users can create and manage goals for their Client Dogs, with the relevant client dog selected when creating the goal.
* **Implementation**:
  * Added dog selection selector at the top with support for Core dogs ("My Dogs") and Trainer Pack dogs ("Client Dogs").
  * Added `Sport` category choice chip conditionally rendered based on `_hasSportPack`.
  * Changed Automatic tracking description from *"Track based on logged sessions"* to *"Track based on recorded sessions"*.
  * Added explanatory note clarifying that automatic progress calculates purely objective progress (e.g. session counts) and never automated performance judgement.

### 23. `lib/screens/statistics_tab.dart`
* **Client Request**:
  * Change empty state copy to: *"Record your first training session to start building Arlo's statistics."*
  * Change action button from *"Start Training Session"* to *"Record Training Session"*.
  * Add `S&C` (Strength & Conditioning) filter pill alongside `Overview` and `Skills`.
  * Training Overview: Display objective session metrics (`SESSIONS - 126`) instead of automatic success rates.
  * Training Sessions Over Time: Interactive curve allowing tap/press on points to inspect relevant period and session count (e.g. *"AUGUST: 14 Sessions"*).
  * Activity Heatmap: Clear calendar-style heatmap with month labels across top (`Jul`, `Aug`, `Sep`, `Oct`, `Nov`), day indicators (`M`, `T`, `W`, etc.), intensity levels 0-4, and interactive tap showing date and recorded sessions.
  * Training by Day: Mon-Sun bar chart displaying sessions on each day with Saturday highlighted as most active day.
* **Implementation**:
  * Updated empty state title and subtitle with dynamic dog name interpolation and exact wording.
  * Updated button label to *"Record Training Session"*.
  * Added `S&C` filter pill and interactive timeframe dropdown selector (`Lifetime`, `This Year`, `Last 6 Months`, `This Month`).
  * Implemented interactive `fl_chart` LineChart with tap tooltips, Activity Heatmap grid with intensity levels 0-4 and tap inspections, and Training by Day bar chart.

---

### 24. `lib/screens/timeline_screen.dart` & `lib/screens/timeline_dashboard_screen.dart`
* **Client Request**:
  * Change empty state supporting text to:
    *"Record your first training session, S&C session, milestone or health record to start building Arlo’s journey."*
  * For users with the Sport Pack, their relevant Sport/Competition records should also contribute to and appear within the Timeline.
  * Rather than making Training the main action with "Add a Health Record instead" underneath, make the record options balanced: a unified Record action/menu giving access to Training Session, S&C Session, Health Record, Milestone, and (for Sport Pack users) Sport/Competition option.
  * Options shown should adapt to what the user has access to through their subscription.
  * Make sure Timeline filters include the relevant record types across Training, S&C, Health and Goals/Milestones, with Sport/Competition available for Sport Pack users.
  * Summary stats at the top should account for the different areas that contribute to the Timeline, including S&C.
  * Change "45min" to "45 min".
  * Retain chronological layout and visual separation of different record types.
* **Implementation**:
  * Added `sc` to `TimelineCategory` enum and integrated S&C throughout filter pills, bottom sheet filters, and event card decorators.
  * Added `Arlo` as the default sample dog with exact metadata (*German Shepherd · 3 yrs · Born 14 March 2023*) and feed items matching Figma Image 2.
  * Updated empty state supporting copy to dynamic string formatting: `"Record your first training session, S&C session, milestone or health record to start building Arlo’s journey."`
  * Implemented balanced Record action sheet (`_showQuickAddSheet`) giving equal access to:
    * Training Session (`RecordSessionScreen`)
    * S&C Session (`StrengthConditioningDashboardScreen`)
    * Health Record (`AddHealthRecordScreen`)
    * Milestone (Record Milestone prompt)
    * Sport / Competition (`AddCompetitionScreen`, conditionally rendered for Sport Pack)
  * Removed obsolete imbalanced "Add a Health Record instead" link underneath primary action in both `timeline_screen.dart` and `timeline_dashboard_screen.dart`.
  * Top summary stats now account for Training (`126 Sessions`), S&C (`32 S&C`), Goals (`4 Goals`), Health (`18 Health`), and Sport (`12 Sport`).
  * Formatted all duration badges with natural spacing: `1hr 45 min` and `45 min`.

### 25. `lib/screens/health_screen.dart`
* **Client Request**:
  * Use "Body Condition", "Vaccinations" and "Medications" rather than shortened wording like "Body Cond...", "Vaccines" and "Meds" where possible.
  * Change "Add First Health Record" to "Add Health Record".
  * Add text labels to the health category tiles underneath the empty state rather than displaying icons alone.
  * Change "NEXT VAX" to "NEXT VACCINATION" and "REHAB" to "REHABILITATION".
  * Add "Body Condition" as one of the Health categories so users can record and track their dog's body condition over time alongside their weight.
  * Remove "Vitals" as a separate category.
  * Remove "Activity" from the Health section (Training and S&C have dedicated areas).
  * Ensure category changes are consistent across both populated and empty states.
* **Implementation**:
  * Replaced all shortened terminology: `NEXT VACCINATION` (was `NEXT VAX`), `REHABILITATION` (was `REHAB`), `BODY CONDITION` (was `BODY COND.`), `VACCINATIONS` (was `VACCINES`), and `MEDICATIONS` (was `MEDS`).
  * Added `Body Condition` category tile in populated and empty state categories linking to weight & body condition tracking.
  * Removed `Vitals` and `Activity` categories from Health.
  * In empty state categories grid, replaced 9 icon-only placeholder squares with 9 labeled interactive tiles displaying both icons and clear category labels (`Weight`, `Body Condition`, `Vaccinations`, `Medications`, `Vet Visits`, `Injuries`, `Rehabilitation`, `Supplements`, `Dental Care`).
  * Changed CTA button label from *"Add First Health Record"* to *"Add Health Record"*.
  * Updated empty state subtitle to: *"Start building Luna's complete health history. Track weight, body condition, vaccinations, medications and vet visits all in one place."*

### 26. `lib/screens/health_records_screen.dart`
* **Client Request**:
  * In the summary section, change "Vaccines" to "Vaccinations", "Meds" to "Medications", and replace "Heart" with "Body Condition".
  * Change empty-state text to:
    *"Start building Koda’s complete health history. Track weight, body condition, vaccinations, medications and vet visits all in one place."*
  * Remove "Learn about Health Records" at the bottom.
  * Wire record card taps to open the correct record type details (`injury` vs `medication`).
* **Implementation**:
  * Updated summary stats grid: `Weight`, `Vaccinations`, `Medications`, `Body Condition` (replacing `Heart`), `Injuries`, and `Next Vet`.
  * Updated empty state body text using dynamic dog name: *"Start building $_selectedDog's complete health history. Track weight, body condition, vaccinations, medications and vet visits all in one place."*
  * Removed the obsolete *"Learn about Health Records"* text link from the bottom of the empty state.
  * Added `recordType` to `_buildRecordCard` (`'medication'` for Metacam and `'injury'` for Left Paw Laceration) navigating to `HealthRecordDetailsScreen`.

---

## Batch 9: Health Categories & Record Management

### 27. `lib/screens/health_screen.dart` (Image 1)
* **Client Request**:
  * Change "NEXT VAX" to "NEXT VACCINATION" and "REHAB" to "REHABILITATION".
  * Add Body Condition to the Categories section so users have a dedicated place to view and track body condition records over time.
  * Change "Medication" in Categories to "Medications" for consistency.
  * Ensure Category options match the 10 agreed Health categories:
    `Weight | Body Condition | Medications | Vaccinations | Vet Visits | Injuries | Rehabilitation | Supplements | Documents | Other Records`.
  * Remove "General Health" and redundant non-agreed categories.
* **Implementation**:
  * Updated `_buildHealthSummaryStrip()` with `NEXT VACCINATION` and `REHABILITATION`.
  * Configured `_buildCategoriesGrid()` and `_buildEmptyCategoriesGrid()` to strictly display the agreed 10 Health categories with matching iconography: `Weight`, `Body Condition`, `Medications`, `Vaccinations`, `Vet Visits`, `Injuries`, `Rehabilitation`, `Supplements`, `Documents` (linked to `CertificatesDocumentsScreen`), and `Other Records` (linked to `HealthRecordsScreen`).

### 28. `lib/screens/add_health_record_screen.dart` (Images 2 & 3)
* **Client Request**:
  * Category dropdown options must strictly match the agreed 10 Health categories (remove `General Health`).
  * Remove the generic Status field ("Completed") from the page.
  * Veterinarian remains optional where not relevant.
  * If the user has already selected Medication before reaching the form, do not show Vaccine and Weight chips at the top; simply show Medication as the selected record type.
  * Change all instances of "Vaccine" to "Vaccination".
  * Change attachment text from *"Tap to upload prescriptions or receipts"* to **"Add photos or documents"**.
* **Implementation**:
  * Updated category options to: `Weight`, `Body Condition`, `Medications`, `Vaccinations`, `Vet Visits`, `Injuries`, `Rehabilitation`, `Supplements`, `Documents`, and `Other Records`. Removed `General Health`.
  * Completely removed the generic `STATUS` dropdown / field from the form.
  * Marked veterinarian as optional: label updated to `VETERINARIAN (OPTIONAL)`.
  * When `_category == 'Medications'`, displays Medication as the single selected record badge (`Medications ✓`) without displaying Vaccine or Weight chips.
  * Displays specialized `MEDICATION DETAILS` section (Medication Name, Dosage, Frequency dropdown, Start Date & optional End Date, Instructions) when adding/editing medication records.
  * Updated attachment card with upload box displaying the exact requested copy: **"Add photos or documents"**.
  * Replaced all instances of "Vaccine" with "Vaccination".

### 29. `lib/screens/health_record_details_screen.dart` (Images 4 & 5)
* **Client Request**:
  * For injury records (Image 4):
    * Use Recovery Status as the single status for injury records rather than having two different status systems ("ACTIVE" badge at top vs "Recovery Status – Ongoing" below).
    * Status badge at the top reflects current Recovery Status (e.g. `ONGOING`).
    * Require confirmation dialog before Delete Record permanently deletes the record.
    * Preserve Record Timeline and update history.
  * For medication records (Image 5):
    * Retain medication-specific statuses (Active, Completed, Discontinued).
    * Change *"End Date – Not set"* to **"End Date – Ongoing"** when active with no end date.
    * Require confirmation dialog before Delete Record permanently deletes the record.
    * Preserve Linked Records section connecting medications to related injuries/vet visits.
* **Implementation**:
  * Built dynamic view supporting both `injury` and `medication` modes with seamless top menu switcher and constructor support (`recordType`, `recoveryStatus`, `medicationStatus`, `isOngoingEndDate`).
  * **Injury View**:
    * Top badge displays single unified recovery status `ONGOING` with green indicator dot.
    * Preserved full injury health details, notes, attachments empty state, and 3-step Record Timeline.
  * **Medication View**:
    * Top badge displays medication status `ACTIVE`.
    * Health information displays `End Date` as **"Ongoing"** instead of "Not set".
    * Preserved Linked Records section showing `Left Shoulder Inflammation` (Injury) and `Shoulder Assessment` (Vet Visit).
    * Preserved reminders card and 3-step medication timeline.
  * **Delete Confirmation Dialog**:
    * Implemented confirmation modal on `Delete Record` for both record types with Cancel and destructive Delete actions.

---

## Static Analysis Verification Status
All 28 modified files across Batches 1 to 9 pass Flutter static analysis cleanly with 0 errors and 0 warnings:
```bash
flutter analyze \
  lib/screens/onboarding_screen.dart \
  lib/screens/client_dog_profile_screen.dart \
  lib/screens/email_verification_screen.dart \
  lib/screens/create_password_screen.dart \
  lib/widgets/password_strength_indicator.dart \
  lib/screens/password_updated_screen.dart \
  lib/screens/two_factor_setup_screen.dart \
  lib/screens/homepage_screen.dart \
  lib/screens/my_dogs_screen.dart \
  lib/screens/dogs_all_workspaces_screen.dart \
  lib/screens/dog_profile_screen.dart \
  lib/screens/training_screen.dart \
  lib/screens/training_session_screen.dart \
  lib/screens/skills_list_screen.dart \
  lib/screens/skill_details_screen.dart \
  lib/screens/add_skill_screen.dart \
  lib/screens/add_exercise_screen.dart \
  lib/screens/exercise_details_screen.dart \
  lib/screens/edit_exercise_screen.dart \
  lib/screens/goals_list_screen.dart \
  lib/screens/goal_details_screen.dart \
  lib/screens/create_goal_screen.dart \
  lib/screens/statistics_tab.dart \
  lib/screens/timeline_screen.dart \
  lib/screens/timeline_dashboard_screen.dart \
  lib/screens/health_screen.dart \
  lib/screens/health_records_screen.dart \
  lib/screens/add_health_record_screen.dart \
  lib/screens/health_record_details_screen.dart

Result: No issues found!
```


## Batch 10: Medication Details, Weight Tracking & Medication Manager

### 29. `lib/screens/health_record_details_screen.dart` (Image 1)
* **Client Request**:
  * For medication records, retain status with medication-specific statuses such as Active, Completed, and Discontinued.
  * Change "End Date – Not set" to "End Date – Ongoing" where the medication is currently active with no end date.
  * Ensure Delete Record requires confirmation before the record is permanently deleted.
  * Keep the Linked Records section to allow medications to connect to relevant injuries or vet visits.
* **Implementation**:
  * Maintained medication-specific statuses (`Active`, `Completed`, `Discontinued`) in `_buildStatusDropdown()` and status badge.
  * Set `isOngoingEndDate = true` default and display `'End Date'` as `'Ongoing'` when no end date is configured for active medications.
  * Wrapped `_deleteRecord()` with a permanent deletion `AlertDialog` confirmation dialog (`Delete Record?`) prior to deletion.
  * Preserved the `Linked Records` section connecting medication records to associated injuries and vet visits.

### 30. `lib/screens/weight_tracker_screen.dart` (Images 2 & 3)
* **Client Request**:
  * Change "Add First Weight" to "Record First Weight".
  * Change empty-state text to:
    `"Start tracking Koda’s weight to monitor changes and build a clear picture of their weight over time."`
  * Remove "Learn about Weight Tracking".
  * Ensure Target Weight remains optional so users can track weight without setting a target.
  * Replace "30 Day Change" with "Change", showing the difference between the dog's two most recent weight entries.
  * Ensure summary strip shows:
    `Current | Highest | Lowest | Change | Target | Last Recorded`.
  * Underneath the large current weight, show target delta when target is set (e.g., `"0.9 kg above target"` or `"0.5 kg below target"`), and omit when no target is set.
  * Change "Monthly Change" further down to "Change" for consistency.
  * Keep interactive Weight Over Time graph with date, weight, and View Entry.
  * Ensure individual weight entries can be edited or deleted when opened from the History list or graph, with deletion confirmation.
* **Implementation**:
  * Updated empty-state button label to `"Record First Weight"`.
  * Updated empty-state description to `"Start tracking ${_activeDog.name}’s weight to monitor changes and build a clear picture of their weight over time."`.
  * Removed `"Learn about Weight Tracking"` link and unused modal methods.
  * Made Target Weight optional and calculated target variance subtext underneath current weight (`"${diff.toStringAsFixed(1)} kg above/below target"`).
  * Calculated `_latestChange` as the difference between the two most recent entries and replaced `"30 DAY CHANGE"` and `"MONTHLY CHANGE"` with `"CHANGE"`.
  * Configured top summary strip: `Current | Highest | Lowest | Change | Target | Last Recorded`.
  * Retained the interactive Weight Over Time chart with interactive tooltips and detail bottom sheets.
  * Added edit and delete actions to weight entry detail bottom sheets with a confirmation dialog (`AlertDialog`) before deletion.

### 31. `lib/screens/medication_manager_screen.dart` (Images 4 & 5)
* **Client Request**:
  * Update Medication Overview labels to clearly represent whether they refer to medications or doses:
    `Active Medications | Upcoming Doses | Missed Doses | Completed Medications`.
  * Remove "Learn about Medication Manager".
  * Require quick confirmation dialog before Skip Dose records the dose as skipped, preventing accidental changes.
  * Require confirmation dialog before Stop Medication changes the medication's status.
* **Implementation**:
  * Updated empty state metric boxes to: `Active Medications`, `Upcoming Doses`, `Missed Doses`, `Completed Medications`.
  * Updated populated overview metric items to: `ACTIVE MEDICATIONS`, `UPCOMING DOSES`, `MISSED DOSES`, `COMPLETED MEDICATIONS` with centered multi-line layout.
  * Removed "Learn about Medication Manager" link and removed unused educational guide methods (`_showLearnModal`, `_buildGuideSection`).
  * Implemented confirmation dialog in `_showSkipDoseModal()` before marking the dose as skipped.
  * Implemented `_confirmStopMedication()` with an `AlertDialog` confirmation dialog before updating status to completed/discontinued.

---

## Cumulative Verification Status (Batches 1 – 10)
All 31 modified project files across Batches 1 to 10 have been thoroughly validated with `flutter analyze`:
```bash
flutter analyze \
  lib/screens/onboarding_screen.dart \
  lib/screens/client_dog_profile_screen.dart \
  lib/screens/email_verification_screen.dart \
  lib/screens/create_password_screen.dart \
  lib/widgets/password_strength_indicator.dart \
  lib/screens/password_updated_screen.dart \
  lib/screens/two_factor_setup_screen.dart \
  lib/screens/homepage_screen.dart \
  lib/screens/my_dogs_screen.dart \
  lib/screens/dogs_all_workspaces_screen.dart \
  lib/screens/dog_profile_screen.dart \
  lib/screens/training_screen.dart \
  lib/screens/training_session_screen.dart \
  lib/screens/skills_list_screen.dart \
  lib/screens/skill_details_screen.dart \
  lib/screens/add_skill_screen.dart \
  lib/screens/add_exercise_screen.dart \
  lib/screens/exercise_details_screen.dart \
  lib/screens/edit_exercise_screen.dart \
  lib/screens/goals_list_screen.dart \
  lib/screens/goal_details_screen.dart \
  lib/screens/create_goal_screen.dart \
  lib/screens/statistics_tab.dart \
  lib/screens/timeline_screen.dart \
  lib/screens/timeline_dashboard_screen.dart \
  lib/screens/health_screen.dart \
  lib/screens/health_records_screen.dart \
  lib/screens/add_health_record_screen.dart \
  lib/screens/health_record_details_screen.dart \
  lib/screens/weight_tracker_screen.dart \
  lib/screens/medication_manager_screen.dart

Result: Analyzing 31 items... No issues found! (ran in 1.3s)
```


## Batch 11: Vaccination Manager, Vet Visits & Injuries Tracking

### 32. `lib/screens/vaccination_manager_screen.dart` (Images 1 & 2)
* **Client Request**:
  * Change "Expired" to "Overdue" so the terminology matches the populated Vaccination Manager.
  * Change the supporting text to:
    `"Keep Koda’s vaccination history organised in one place. Record vaccinations and keep track of upcoming and overdue boosters."`
  * Remove "Learn about Vaccination Manager".
  * Change "Lifetime" to "Total Records" so it’s clearer what the figure represents.
  * Change "Renew Now" to "Record Vaccination" if this button takes the user through to record the new vaccination/booster.
* **Implementation**:
  * In the empty-state summary card, replaced `'EXPIRED'` with `'OVERDUE'`.
  * Updated empty-state supporting text to dynamic dog name: `"Keep ${_activeDog.name}’s vaccination history organised in one place. Record vaccinations and keep track of upcoming and overdue boosters."`.
  * Removed "Learn about Vaccination Manager" link, along with unused `_showLearnModal` and `_buildGuideSection` methods.
  * In the populated top metric cards, replaced `"Lifetime"` with `"Total Records"` (rendering as `"TOTAL RECORDS"` with centered multi-line styling).
  * Replaced `"Renew Now"` button with `"Record Vaccination"` on the overdue hero alert banner, and updated the renewal bottom sheet title and submit button to `'Record Vaccination'`.

### 33. `lib/screens/vet_visits_screen.dart` (Images 3 & 4)
* **Client Request**:
  * Change the supporting text to:
    `"Keep a record of your dog’s veterinary visits, appointments and follow-ups in one place."`
  * Remove "Learn about Vet Visits".
  * In the Vet Summary, replace "Active Treatments" with "Follow-Ups", as treatments can already be managed through the relevant Health areas and follow-ups are more directly relevant to Vet Visits.
  * The summary order is: `Total Visits | Upcoming | Last Visit | Follow-Ups`.
* **Implementation**:
  * Updated empty-state supporting text to: `"Keep a record of your dog’s veterinary visits, appointments and follow-ups in one place."`.
  * Removed "Learn about Vet Visits" link, along with unused `_showEducationalModal` and `_buildEducationPoint` methods.
  * In the Vet Summary 2x2 grid, replaced `"ACTIVE TREATMENTS"` with `"FOLLOW-UPS"`, connected to `_followUpsCount` (`_visits.where((v) => v.isFollowUpRequired).length`), ensuring the summary represents: `Total Visits | Upcoming | Last Visit | Follow-Ups`.

### 34. `lib/screens/injuries_recovery_screen.dart` (Image 5)
* **Client Request**:
  * Change the supporting text to:
    `"Record injuries and monitor your dog’s recovery over time."`
  * Remove "Learn about Injury Tracking".
* **Implementation**:
  * Updated empty-state supporting text to: `"Record injuries and monitor your dog’s recovery over time."`.
  * Updated empty-state CTA button to `"Add Injury"` (matching the `+ Add Injury ->` layout in Image 5).
  * Removed "Learn about Injury Tracking" link, along with unused `_showEducationalModal` and `_buildEducationPoint` methods.

---

## Cumulative Verification Status (Batches 1 – 11)
All 34 modified project files across Batches 1 to 11 have been thoroughly validated with `flutter analyze`:
```bash
flutter analyze \
  lib/screens/onboarding_screen.dart \
  lib/screens/client_dog_profile_screen.dart \
  lib/screens/email_verification_screen.dart \
  lib/screens/create_password_screen.dart \
  lib/widgets/password_strength_indicator.dart \
  lib/screens/password_updated_screen.dart \
  lib/screens/two_factor_setup_screen.dart \
  lib/screens/homepage_screen.dart \
  lib/screens/my_dogs_screen.dart \
  lib/screens/dogs_all_workspaces_screen.dart \
  lib/screens/dog_profile_screen.dart \
  lib/screens/training_screen.dart \
  lib/screens/training_session_screen.dart \
  lib/screens/skills_list_screen.dart \
  lib/screens/skill_details_screen.dart \
  lib/screens/add_skill_screen.dart \
  lib/screens/add_exercise_screen.dart \
  lib/screens/exercise_details_screen.dart \
  lib/screens/edit_exercise_screen.dart \
  lib/screens/goals_list_screen.dart \
  lib/screens/goal_details_screen.dart \
  lib/screens/create_goal_screen.dart \
  lib/screens/statistics_tab.dart \
  lib/screens/timeline_screen.dart \
  lib/screens/timeline_dashboard_screen.dart \
  lib/screens/health_screen.dart \
  lib/screens/health_records_screen.dart \
  lib/screens/add_health_record_screen.dart \
  lib/screens/health_record_details_screen.dart \
  lib/screens/weight_tracker_screen.dart \
  lib/screens/medication_manager_screen.dart \
  lib/screens/vaccination_manager_screen.dart \
  lib/screens/vet_visits_screen.dart \
  lib/screens/injuries_recovery_screen.dart

Result: Analyzing 34 items... No issues found! (ran in 4.9s)
```


## Batch 12: Injuries Recovery, Rehabilitation Hub & Supplements

### 35. `lib/screens/injuries_recovery_screen.dart` (Image 1)
* **Client Request**:
  * Remove automatic Recovery Progress percentages (e.g. 35%, 70%) as Ulvenik cannot determine how recovered an injury actually is.
  * Update current injury cards to display:
    * Status: Active / Recovering
    * Area: [body area]
    * Recorded: [date]
    * Severity: [severity]
    * Recovery: [time since recorded] (in days for shorter periods, in weeks for longer periods)
    * Current Stage: Resting / Rehabilitation / other user-selected stage
  * Keep top summary: Active | Recovering | Resolved | Avg Recovery (with Avg Recovery calculated from previous resolved injuries).
  * Keep resolved injury cards as they are.
* **Implementation**:
  * Removed the automatic recovery progress percentage text and animated progress bar from `_buildCurrentInjuryCard()`.
  * Formatted current injury cards with clean metadata row: `[injury.bodyArea, _formatDate(injury.date), if (injury.severity.isNotEmpty) injury.severity].join(' · ')`.
  * Added `Recovery: [time since recorded]` dynamically calculating days (e.g. `12 days since recorded`) or weeks (e.g. `Week 8`).
  * Replaced the progress bar slider in the details modal with user-selected `Current Stage` choice chips (`Resting`, `Rehabilitation`, `Controlled Exercise`, `Resolved`).
  * Preserved the top 2x2 summary grid (`ACTIVE`, `RECOVERING`, `RESOLVED`, `AVG RECOVERY`), and kept resolved injury cards intact.

### 36. `lib/screens/physio_hydro_hub_screen.dart` (Images 2 & 3)
* **Client Request**:
  * Change the page title from "Physio & Hydro" to "Rehabilitation" to match the Health category.
  * Change empty-state text to:
    `"Record and track your dog’s rehabilitation sessions throughout their recovery."`
  * Change "Add Session" to "Record Session".
  * Remove "Learn about Rehabilitation Tracking".
  * In the top summary, replace "Progress – 70%" with "Last Session", so the summary becomes:
    `Sessions | Physio | Hydro | Last Session | Next Appt | Avg Duration`.
  * Replace the Recovery Trend percentage graph with "Sessions Over Time", showing the number of rehabilitation sessions recorded over time rather than trying to calculate a recovery percentage.
  * On individual session cards, remove the Recovery percentages (e.g. 70%, 55%, 40%) and progress bars.
  * Retain Improving / No Change as "Outcome", based on user/practitioner input.
  * Keep Physiotherapy and Hydrotherapy as individual session types/filters.
* **Implementation**:
  * Updated app bar title to `"Rehabilitation"`.
  * Updated empty-state subtitle to `"Record and track your dog’s rehabilitation sessions throughout their recovery."`.
  * Updated both empty-state and populated bottom action buttons from `"Add Session"` to `"Record Session"`.
  * Removed "Learn about Rehabilitation Tracking" link and purged unused educational modal methods.
  * Replaced the `PROGRESS` summary box with `LAST SESSION` (`14 Aug`), resulting in: `SESSIONS | PHYSIO | HYDRO | LAST SESSION | NEXT APPT | AVG DUR`.
  * Replaced the Recovery Trend percentage line chart with `"Sessions Over Time"` showing monthly rehabilitation session counts on a discrete numerical scale with interactive points.
  * Removed recovery percentage text and progress bars from session cards, displaying a dedicated clean `Outcome` row (`Outcome: IMPROVING ↑` or `Outcome: NO CHANGE →`).
  * Preserved Physiotherapy and Hydrotherapy filter pills and types.

### 37. `lib/screens/supplements_screen.dart` (Images 4 & 5)
* **Client Request**:
  * Change the supporting text to:
    `"Keep track of your dog’s supplements, dosages and schedule, with a complete history over time."`
  * Remove "Learn about Supplement Tracking".
  * Ensure Supplements sits within the Health section rather than being a separate dog profile tab (main dog profile navigation remains `Overview | Training | S&C | Health | Sport | Media`).
  * Change "Record Administration" to "Record as Given".
  * Change "Next Dose" on supplement cards to "Next Due".
* **Implementation**:
  * Updated empty-state subtitle to `"Keep track of your dog’s supplements, dosages and schedule, with a complete history over time."`.
  * Removed "Learn about Supplement Tracking" link and purged unused educational modal methods.
  * Removed the mock dog profile tab bar row (`Overview | Training | Supplements | Health`) from the empty state, and removed unused `_buildTabPill()` method, ensuring Supplements functions purely as a dedicated sub-view of Health.
  * Changed the Today's Schedule action button from `"Record Administration"` to `"Record as Given"`, and updated the modal header accordingly.
  * Changed `"NEXT DOSE"` on all active supplement cards to `"NEXT DUE"`.

---

## Cumulative Verification Status (Batches 1 – 12)
All 36 modified project files across Batches 1 to 12 have been thoroughly validated with `flutter analyze`:
```bash
flutter analyze \
  lib/screens/onboarding_screen.dart \
  lib/screens/client_dog_profile_screen.dart \
  lib/screens/email_verification_screen.dart \
  lib/screens/create_password_screen.dart \
  lib/widgets/password_strength_indicator.dart \
  lib/screens/password_updated_screen.dart \
  lib/screens/two_factor_setup_screen.dart \
  lib/screens/homepage_screen.dart \
  lib/screens/my_dogs_screen.dart \
  lib/screens/dogs_all_workspaces_screen.dart \
  lib/screens/dog_profile_screen.dart \
  lib/screens/training_screen.dart \
  lib/screens/training_session_screen.dart \
  lib/screens/skills_list_screen.dart \
  lib/screens/skill_details_screen.dart \
  lib/screens/add_skill_screen.dart \
  lib/screens/add_exercise_screen.dart \
  lib/screens/exercise_details_screen.dart \
  lib/screens/edit_exercise_screen.dart \
  lib/screens/goals_list_screen.dart \
  lib/screens/goal_details_screen.dart \
  lib/screens/create_goal_screen.dart \
  lib/screens/statistics_tab.dart \
  lib/screens/timeline_screen.dart \
  lib/screens/timeline_dashboard_screen.dart \
  lib/screens/health_screen.dart \
  lib/screens/health_records_screen.dart \
  lib/screens/add_health_record_screen.dart \
  lib/screens/health_record_details_screen.dart \
  lib/screens/weight_tracker_screen.dart \
  lib/screens/medication_manager_screen.dart \
  lib/screens/vaccination_manager_screen.dart \
  lib/screens/vet_visits_screen.dart \
  lib/screens/injuries_recovery_screen.dart \
  lib/screens/physio_hydro_hub_screen.dart \
  lib/screens/supplements_screen.dart

Result: Analyzing 36 items... No issues found! (ran in 3.2s)
```


---

## Batch 13: Allergies & Sensitivities, Dental Care, and Health History / Timeline Screens

### 1. Screen Identification & Image Reference Mapping
| # | Image / Design Reference | Verified Target Screen Name | Target File |
|---|---|---|---|
| **1** | `media_1793693393101_6e681ff9.jpg` | Allergies & Sensitivities (Empty State) | [`lib/screens/allergies_sensitivities_screen.dart`](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/allergies_sensitivities_screen.dart) |
| **2** | `media_1793693414781_d611399d.jpg` | Allergies & Sensitivities (Populated State) | [`lib/screens/allergies_sensitivities_screen.dart`](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/allergies_sensitivities_screen.dart) |
| **3** | `media_1793693432906_8b3cecbd.png` | Dental Care (Empty State) | [`lib/screens/dental_care_screen.dart`](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/dental_care_screen.dart) |
| **4** | `media_1793693449421_1880fd9a.jpg` | Dental Care (Populated State) | [`lib/screens/dental_care_screen.dart`](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/dental_care_screen.dart) |
| **5** | `media_1793693466638_205c06d8.png` | Health History (Empty State, previously mislabeled "Injuries & Recovery") | [`lib/screens/health_reports_timeline_screen.dart`](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/health_reports_timeline_screen.dart) |

### 2. Detailed Changes Implemented

#### A. Allergies & Sensitivities (`lib/screens/allergies_sensitivities_screen.dart`)
1. **Empty State Title**:
   - Updated from `"No Allergies Recorded"` to `"No Allergies or Sensitivities Recorded"`.
2. **Empty State Supporting Copy**:
   - Updated from `"Record allergies and sensitivities to keep important health information organised and accessible for owners, trainers and vets."` to:
     `"Record allergies and sensitivities to keep important health information organised and accessible."`
3. **Empty State CTA Button**:
   - Updated from `"Add Allergy"` to `"Add Allergy or Sensitivity"`.
4. **Learn Link Removal**:
   - Removed `"Learn about Allergy Tracking"` link and cleanly excised unused private helper methods (`_showLearnModal`, `_buildLearnPoint`) to ensure 0 static analysis warnings.
5. **Summary Cards Expansion**:
   - Replaced abbreviated category labels:
     - `"ENV"` -> `"ENVIRONMENTAL"`
     - `"MEDS"` -> `"MEDICATION"`
   - Fitted boxes to gracefully scale down labels on compact mobile displays without wrapping or overflow.
   - Retained the `Confirmed | Suspected | Severe` summary and `Mild | Moderate | Severe` user-recorded severity levels.
6. **Sticky Bottom CTA & App Bar Tooltips**:
   - Updated from `"+ Add Allergy"` to `"+ Add Allergy or Sensitivity"`.

#### B. Dental Care (`lib/screens/dental_care_screen.dart`)
1. **Empty State Supporting Copy**:
   - Updated to: `"Keep track of your dog’s dental health, including professional procedures, home care and oral health records."`
2. **Learn Link Removal**:
   - Removed `"Learn about Dental Care Tracking"` link and cleanly removed `_showLearnSheet()`.
3. **User-Entered Oral Health Assessment (No Automatic Scoring)**:
   - Eliminated artificial Ulvenik calculation (`0.9 - _activeIssues * 0.25...`) and removed the automatic progress bar gauge from the header card.
   - Header banner now cleanly presents `CURRENT ORAL HEALTH` on the left and the user-assessed status (`Good`, `Requires Treatment`, `Fair`, `Under Observation`) on the right, matching Image 4.
   - Tapping the banner opens `_showOralAssessmentSheet` where the user directly updates their recorded assessment.
   - In `_showAddSheet`, added a dedicated "ORAL HEALTH ASSESSMENT" chip selector so the user sets the status when recording dental events.
4. **Terminology Alignment**:
   - Renamed `'Teeth Brushing Session'` to `'Teeth Brushing'`.

#### C. Health History / Timeline (`lib/screens/health_reports_timeline_screen.dart`)
1. **Screen Title**:
   - Changed page title from `"Injuries & Recovery"` / `"Health Reports & Timeline"` to `"Health History"`.
2. **Vitals Panel Removal**:
   - Excised the `Weight | Body Cond | Resting HR | Temp | Resp Rate | Hydration` bento container from the empty state, adhering to the client decision that Ulvenik does not feature a general vitals area with heart rate, temperature, respiratory rate, or hydration.
3. **Empty State Supporting Copy**:
   - Updated to: `"Health History builds automatically from records created across ${_dog.name}'s Health areas (Weight, Body Condition, Medications, Vaccinations, Vet Visits, Injuries, Rehabilitation, Supplements and other Health records)."`
4. **Learn Link Removal**:
   - Removed `"Learn about Health Records"` button and unused `_showLearnSheet()` helper.

---

### 3. Verification & Static Analysis Results
- All 39 files across Batches 1 to 13 pass `flutter analyze` with zero errors and zero warnings:
```bash
flutter analyze \
  lib/screens/onboarding_screen.dart \
  lib/screens/client_dog_profile_screen.dart \
  lib/screens/email_verification_screen.dart \
  lib/screens/create_password_screen.dart \
  lib/widgets/password_strength_indicator.dart \
  lib/screens/password_updated_screen.dart \
  lib/screens/two_factor_setup_screen.dart \
  lib/screens/homepage_screen.dart \
  lib/screens/my_dogs_screen.dart \
  lib/screens/dogs_all_workspaces_screen.dart \
  lib/screens/dog_profile_screen.dart \
  lib/screens/training_screen.dart \
  lib/screens/training_session_screen.dart \
  lib/screens/skills_list_screen.dart \
  lib/screens/skill_details_screen.dart \
  lib/screens/add_skill_screen.dart \
  lib/screens/add_exercise_screen.dart \
  lib/screens/exercise_details_screen.dart \
  lib/screens/edit_exercise_screen.dart \
  lib/screens/goals_list_screen.dart \
  lib/screens/goal_details_screen.dart \
  lib/screens/create_goal_screen.dart \
  lib/screens/statistics_tab.dart \
  lib/screens/timeline_screen.dart \
  lib/screens/timeline_dashboard_screen.dart \
  lib/screens/health_screen.dart \
  lib/screens/health_records_screen.dart \
  lib/screens/add_health_record_screen.dart \
  lib/screens/health_record_details_screen.dart \
  lib/screens/weight_tracker_screen.dart \
  lib/screens/medication_manager_screen.dart \
  lib/screens/vaccination_manager_screen.dart \
  lib/screens/vet_visits_screen.dart \
  lib/screens/injuries_recovery_screen.dart \
  lib/screens/physio_hydro_hub_screen.dart \
  lib/screens/supplements_screen.dart \
  lib/screens/allergies_sensitivities_screen.dart \
  lib/screens/dental_care_screen.dart \
  lib/screens/health_reports_timeline_screen.dart

Result: Analyzing 39 items... No issues found! (ran in 4.4s)
```


---

## Batch 14: Health History / Timeline, Surgery & Procedures, and Health Statistics Screens

### 1. Screen Identification & Image Reference Mapping
| # | Image / Design Reference | Verified Target Screen Name | Target File |
|---|---|---|---|
| **1** | `media_1793701858830_b74d9505.jpg` | Health History (Populated State) | [`lib/screens/health_reports_timeline_screen.dart`](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/health_reports_timeline_screen.dart) |
| **2** | `media_1793701877029_5f524056.png` | Surgery & Procedures (Empty State) | [`lib/screens/surgery_procedures_screen.dart`](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/surgery_procedures_screen.dart) |
| **3** | `media_1793701894621_5e888ae8.jpg` | Surgery & Procedures (Populated State) | [`lib/screens/surgery_procedures_screen.dart`](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/surgery_procedures_screen.dart) |
| **4** | `media_1793701911809_c948e5df.png` | Health Statistics (Empty State) | [`lib/screens/health_statistics_screen.dart`](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/health_statistics_screen.dart) |
| **5** | `media_1793701932724_7dba131e.jpg` | Health Statistics (Populated State) | [`lib/screens/health_statistics_screen.dart`](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/health_statistics_screen.dart) |

### 2. Detailed Changes Implemented

#### A. Health History / Timeline (`lib/screens/health_reports_timeline_screen.dart`)
1. **Screen Title**:
   - Maintained title `"Health History"` in the app bar.
2. **Timeline Terminology**:
   - Updated weight entry from `"Weight Check"` to **`"Weight Recorded"`** across `EntryTypeX.label` and timeline cards, avoiding the implication that every weight record stems from a formal health examination.
3. **Filter Categories Expansion**:
   - Expanded `EntryType` to support filtering by all core Health record categories:
     `Vet Visits`, `Weight`, `Body Condition`, `Medications`, `Vaccinations`, `Injuries`, `Rehabilitation`, `Supplements`, `Surgeries`, `Dental Care`, `Conditions`, and `Reminders`, alongside Year/Date filtering.
4. **Overview Card**:
   - Preserved overview metrics:
     `Total Records | Active Conditions | Medications | Last Vet Visit | Current Weight | Reminders`.

#### B. Surgery & Procedures (`lib/screens/surgery_procedures_screen.dart`)
1. **Empty State Supporting Copy**:
   - Updated to:
     > *"Keep a permanent record of your dog’s surgeries, procedures, implants and related information."*
2. **Learn Link Removal**:
   - Removed `"Learn about Surgery & Procedures"` button and unused `_showLearnSheet()` helper method.
3. **Objective Time-Based Recovery (No Progress Percentages)**:
   - Excised automatic recovery percentages (e.g., 65%, 85%) and progress bars from procedure cards.
   - For active recovery (`recovering`, `rehabilitation`), procedures display objective elapsed time:
     e.g., `"Recovery: Week 6"` (TPLO) or `"45 days since procedure"` (GDV Repair) alongside user-selected recovery status badges (`RECOVERING`, `REHABILITATION`).
   - Fully recovered procedures hide ongoing recovery progress.
4. **User-Selected Stage Selector**:
   - In `_showAddProcedureSheet`, replaced the progress percentage slider with a user-selected status chip selector (`Recovering`, `Rehabilitation`, `Fully Recovered`, `Scheduled`).
5. **Default View Alignment**:
   - Set `_showChart = false;` by default so procedure cards start directly below filter chips matching Image 3.

#### C. Health Statistics (`lib/screens/health_statistics_screen.dart`)
1. **Removal of Health Score & Coming Soon**:
   - Completely removed `"Health Score"` and `"Coming Soon"` from both empty and populated states.
2. **Empty State Overview Grid**:
   - Replaced old overview cells with 6 objective Health metrics:
     - Row 1: `CURRENT WEIGHT` | `ACTIVE CONDITIONS` | `VACCINATIONS DUE`
     - Row 2: `VET VISITS` | `ACTIVE MEDICATIONS` | `TOTAL RECORDS`
   - Used full terminology `"Vaccinations"` and `"Medications"` (never abbreviated).
   - Removed info link and `"Learn about Health Statistics"` button and `_showLearnSheet()`.
3. **Populated State Overview Grid**:
   - Replaced `"Health Score – COMING SOON"` with **`"Last Health Record"`** displaying actual recorded date (`12 Jul 2026`).
   - Renamed `"Active Meds"` to **`"Active Medications"`**.
   - Overview grid now displays:
     `Total Records` (124) | `Current Weight` (28.4 kg)
     `Active Issues` (2) | `Active Medications` (3)
     `Supplements` (4) | `Last Health Record` (12 Jul 2026)
4. **Supplements Consistency Percentage Removal**:
   - Removed `"Consistency – 88%"` and progress bar from the Supplements card.
   - Replaced with factual status: `Given Today: 3 of 4 Active`.
5. **Injury & Recovery Progress Status Conversion**:
   - Removed progress bars and percentages (65%, 85%, 100%) from `_buildInjuryRecoveryProgressCard()` and stat cards.
   - Transformed into `INJURIES & RECOVERY STATUS` presenting objective time and user-selected statuses:
     - `ACL Repair`: `Recovery: Week 6 · Recorded 14 Jul 2025` · `RECOVERING`
     - `GDV Surgery`: `45 days since procedure` · `REHABILITATION`
     - `Paw Laceration`: `Resolved · 12 Mar 2026` · `RESOLVED`

---

### 3. Verification & Static Analysis Results
- All 41 project files across Batches 1 to 14 pass `flutter analyze` with zero errors and zero warnings:
```bash
flutter analyze \
  lib/screens/onboarding_screen.dart \
  lib/screens/client_dog_profile_screen.dart \
  lib/screens/email_verification_screen.dart \
  lib/screens/create_password_screen.dart \
  lib/widgets/password_strength_indicator.dart \
  lib/screens/password_updated_screen.dart \
  lib/screens/two_factor_setup_screen.dart \
  lib/screens/homepage_screen.dart \
  lib/screens/my_dogs_screen.dart \
  lib/screens/dogs_all_workspaces_screen.dart \
  lib/screens/dog_profile_screen.dart \
  lib/screens/training_screen.dart \
  lib/screens/training_session_screen.dart \
  lib/screens/skills_list_screen.dart \
  lib/screens/skill_details_screen.dart \
  lib/screens/add_skill_screen.dart \
  lib/screens/add_exercise_screen.dart \
  lib/screens/exercise_details_screen.dart \
  lib/screens/edit_exercise_screen.dart \
  lib/screens/goals_list_screen.dart \
  lib/screens/goal_details_screen.dart \
  lib/screens/create_goal_screen.dart \
  lib/screens/statistics_tab.dart \
  lib/screens/timeline_screen.dart \
  lib/screens/timeline_dashboard_screen.dart \
  lib/screens/health_screen.dart \
  lib/screens/health_records_screen.dart \
  lib/screens/add_health_record_screen.dart \
  lib/screens/health_record_details_screen.dart \
  lib/screens/weight_tracker_screen.dart \
  lib/screens/medication_manager_screen.dart \
  lib/screens/vaccination_manager_screen.dart \
  lib/screens/vet_visits_screen.dart \
  lib/screens/injuries_recovery_screen.dart \
  lib/screens/physio_hydro_hub_screen.dart \
  lib/screens/supplements_screen.dart \
  lib/screens/allergies_sensitivities_screen.dart \
  lib/screens/dental_care_screen.dart \
  lib/screens/health_reports_timeline_screen.dart \
  lib/screens/surgery_procedures_screen.dart \
  lib/screens/health_statistics_screen.dart

Result: Analyzing 41 items... No issues found! (ran in 3.5s)
```

---

## Batch 15 Implementation Summary

### 1. Screen 1: Health Reminders (`lib/screens/health_reminders_screen.dart`)
- **Empty State Supporting Text**:
  - Updated to: `“Keep track of upcoming medications, vaccinations, appointments and other health reminders in one place.”`
- **Filter Chips (Empty State)**:
  - Changed `Vaccines` filter chip to `Vaccinations`.
  - Ensured `Appointments` displays in full without horizontal clipping or truncation.
- **Summary Bento Grid**:
  - Maintained `Due Today | Overdue | Upcoming | Completed` stats and `Create Reminder` action.
- **Removed "Learn about Health Reminders"**:
  - Removed link and its unused private handler `_showLearnDialog()`.
- **Populated State Filters**:
  - Updated filter tabs order to: `All | Due Today | Upcoming | Overdue | Completed`, with `All` selected by default.
  - Aligned switch case logic in `_filteredReminders` to handle `Due Today`, `Upcoming`, `Overdue`, `Completed`, and `All`.
- **Overdue Reminders Status Logic**:
  - Past-due reminders remain clearly identified as **Overdue** rather than automatically labelled "Missed".
  - "Missed" / "Skipped" is reserved strictly for statuses explicitly selected or recorded by the user.
  - Updated chart legend label to `Overdue / Snoozed`.
  - Maintained list / calendar view toggles and date-based reminder grouping.

### 2. Screen 2: Health Settings (`lib/screens/health_settings_screen.dart`)
- **Vitals & Temperature Unit Removal**:
  - Completely removed `Temperature Unit – Celsius (°C) – Coming Soon`, as temperature and vitals are not a core Health tracking area.
- **Weight Section**:
  - Changed section title from `MEASUREMENT UNITS` to `WEIGHT`.
  - Retained `Weight Unit` (`Kilograms (kg)` / `Pounds (lbs)`) as the sole measurement setting.
- **Bottom Navigation**:
  - Ensured bottom navigation bar strictly follows standard app navigation: `Home | Dogs | Training | Timeline | More` (replacing older `Dogs | Journal | Stats | Settings`).
- **New Settings**:
  - Added **Health Notifications** toggle (`SwitchListTile`) allowing users to turn health reminders/notifications on or off.
  - Added **Default Reminder Time** setting (`showTimePicker`), allowing users to choose their preferred default time (defaults to `09:00 AM`).
- **Decoupled Data Privacy & Cloud Backup**:
  - Removed `DATA PRIVACY & BACKUP` and cloud sync card from Health Settings, as import, export, and backup are housed in their dedicated section.

### 3. Screen 3: Import & Export (`lib/screens/import_export_screen.dart`)
- **Export Options Across All Health Categories**:
  - Expanded export selection to include **all 10 agreed Health record categories available for the dog**:
    1. `Weight`
    2. `Body Condition`
    3. `Medications`
    4. `Vaccinations`
    5. `Vet Visits`
    6. `Injuries`
    7. `Rehabilitation`
    8. `Supplements`
    9. `Documents`
    10. `Other Records`
  - Retained `Select All` / `Deselect All` toggle and `PDF | CSV` format selection.
- **Import Records Formats**:
  - Removed `PDF` from Import description and options, reserving PDF for exported/readable reports.
  - Specified genuine import formats: `CSV, JSON or backup files`.
  - Added `Import JSON Health History` and `Import CSV Data Sheet`.
- **Restore Backup Confirmation**:
  - Implemented an explicit confirmation dialog before restoring any backup:
    - Clearly warns that restoring will replace the dog's current health records with the backup file data.
    - Warns that any records added or modified since the backup was created will be permanently overwritten.
    - Prominent `Restore Data` button with warning badge and `Cancel` action.
- **Removed "Auto Cloud Backup – Coming Soon"**:
  - Removed from both populated status summary and empty state card for launch.
- **Maintained Distinct Action Cards**:
  - Kept `Import Records`, `Export Records`, `Create Backup`, and `Restore Backup` as separate, dedicated options.

---

### Verification
```bash
flutter analyze lib/screens/health_reminders_screen.dart lib/screens/health_settings_screen.dart lib/screens/import_export_screen.dart
Result: Analyzing 3 items... No issues found! (ran in 0.9s)
```

---

## Batch 16 Implementation Summary

### 1. Screen 1 & 2: Health Archive (`lib/screens/health_archive_screen.dart`)
- **Removed Static Category Box**:
  - Completely removed the `Vet Visits | Vaccinations | Medications | Test Results` panel at the top of the empty state, allowing archived records to come dynamically from any Health category.
- **Empty State Supporting Text**:
  - Updated to: `“Health records you archive will appear here and remain part of your dog’s health history.”`
- **Summary Metrics**:
  - Replaced `STORAGE USED` with **`LAST ARCHIVED`**, displaying the formatted date of the most recent archived record (`Total Archived | This Year | Categories | Last Archived`).
- **Dynamic Category Filtering**:
  - Updated category filtering to derive available filters dynamically from actual archived records present in the archive rather than hardcoded categories.
- **Restore Confirmation**:
  - Enhanced the Restore action confirmation sheet to explicitly state that the record will be moved back into its relevant active Health section rather than duplicated.

### 2. Screen 3 & 4: Health Dashboard (`lib/screens/health_dashboard_screen.dart`)
- **Health Summary Categories**:
  - Updated empty-state Health Summary categories from `Weight | Diet | BCS | Heart | Activity | Sleep` to:
    `Weight | Body Condition | Medications | Vaccinations | Vet Visits | Injuries`
- **Removed Overall Status Section**:
  - Removed the `OVERALL STATUS` section from both the empty state (`No Data - Add health records to generate status`) and populated state (`Good`), avoiding automated overall clinical status evaluations.
- **Welcome to Health Copy**:
  - Updated empty-state supporting text to:
    `“Start building your dog’s health history by keeping their important health records together in one place.”`
- **Health Summary Grid**:
  - Maintained populated objective summary cards:
    `Current Weight | Active Issues | Active Medications | Upcoming | Last Vet Visit | Vaccinations`
- **Cross-Category Health Alerts**:
  - Enhanced `ALERTS` section to accommodate due/overdue reminders from across Health areas (Vaccinations, Follow-ups, Medications, and Weight Checks) with relevant actions and routing.

### 3. Screen 5: Strength & Conditioning Dashboard (`lib/screens/strength_conditioning_dashboard_screen.dart`)
- **Empty State Supporting Copy**:
  - Updated supporting text underneath “No Activities Yet” to:
    `“Create your first Strength & Conditioning activity to start building your dog’s activity library and recording their S&C sessions.”`
- **Removed Learn Link**:
  - Removed `Learn about Strength & Conditioning` link and its unused handler dialog `_showLearnDialog()`.

---

### Verification
```bash
flutter analyze lib/screens/health_archive_screen.dart lib/screens/health_dashboard_screen.dart lib/screens/strength_conditioning_dashboard_screen.dart
# Result: Analyzing 3 items... No issues found!

# Cumulative check across all 47 modified files from Batches 1 to 16:
# Result: Analyzing 47 items... No issues found! (0 errors, 0 warnings)
```

---

## Batch 17 Implementation Summary

### 1. Screen 1: Strength & Conditioning Dashboard (`lib/screens/strength_conditioning_dashboard_screen.dart`)
- **Metric Header Replacement**:
  - Replaced `Streak` with **`Activities`**, displaying the number of active S&C activities created for the dog:
    `Sessions | Duration | Activities | Active Goals`.
  - Updated empty-state summary row to `ACTIVITIES` (`0`) instead of `STREAK` (`0 Days`).
  - Removed streak assumptions and indicators, reflecting that rest and recovery form integral components of canine conditioning.

### 2. Screen 2 & 3: Activity Library (`lib/screens/activity_library_screen.dart`)
- **Empty State Supporting Copy**:
  - Updated text underneath “No Activities Created” to:
    `“Create your first Strength & Conditioning activity to start building your dog’s personalised activity library.”`
- **Removed Learn Link**:
  - Removed `Learn about the Activity Library` link and its unused private dialog method `_showLearnDialog()`.
- **Removed Streaks from Activities**:
  - Removed individual activity streak badges (e.g. `12 Day Streak`, `5 Day Streak`, `3 Day Streak`) from both Favourites and All Activities lists.
  - Kept session count and last-used date:
    `${act.sessionCount} Sessions • Last: ${act.lastTrained}`.
- **Filter Chips**:
  - Filter list updated to: `['Recently Used', 'Alphabetical', 'Most Sessions']` (ensured `Most Sessions` plural form and removed `Highest Streak`).

### 3. Screen 4 & 5: Activity Details (`lib/screens/activity_details_screen.dart`)
- **Empty State Activity Summary Cleaned**:
  - Removed both `No Streak` and `Never Completed` indicators.
  - Cleanly displays only **`0 Sessions`** when no sessions have been recorded.
- **CTA Button**:
  - Changed primary action from `Start First Session` to:
    **`Record First Session`**.
- **Empty State Supporting Copy**:
  - Updated text underneath “No Sessions Recorded” to:
    `“This activity hasn’t been used yet. Record your first session to start building its training history.”`
- **Activity Details Header (Populated)**:
  - Removed `12 Day Streak` badge, cleanly displaying:
    `${_act.sessionCount} Sessions • Last: ${_act.lastTrained}`.
- **Quick Statistics Section**:
  - Removed `Current Streak` and `Longest Session`.
  - Added **`Sessions This Month`**, updating Quick Statistics to:
    **`Total Sessions | Total Duration | Avg Duration | Sessions This Month | Last Completed`**.
- **User-Recorded Star Ratings**:
  - Preserved handler-entered star ratings on Recent Sessions.

---

### Verification
```bash
flutter analyze lib/screens/strength_conditioning_dashboard_screen.dart lib/screens/activity_library_screen.dart lib/screens/activity_details_screen.dart
# Result: Analyzing 3 items... No issues found!

# Cumulative check across all 49 modified files from Batches 1 to 17:
# Result: Analyzing 49 items... No issues found! (0 errors, 0 warnings)
```


---

## Batch 18: Strength & Conditioning Custom Metrics, S&C Session Recording, Session Details & Activity Statistics

### Target Files Verified & Updated
1. [activity_library_screen.dart](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/activity_library_screen.dart) - Model support (`CustomActivityMetric` class and `customMetrics` on `LibraryActivityItem`)
2. [create_activity_screen.dart](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/create_activity_screen.dart) - Image 1 (`media_1793707793740_3bb1fade.jpg`)
3. [record_session_screen.dart](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/record_session_screen.dart) - Images 2 & 3 (`media_1793707841331_85034dfa.png`, `media_1793707902909_0a61ce65.jpg`)
4. [session_details_screen.dart](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/session_details_screen.dart) - Image 4 (`media_1793707924467_deb085e9.jpg`)
5. [activity_statistics_screen.dart](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/activity_statistics_screen.dart) - Image 5 (`media_1793707951629_2b0c82eb.png`)
6. [activity_details_screen.dart](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/activity_details_screen.dart) - Updated navigation parameters to propagate custom metrics to recording and statistics.

---

### Implementation Details

#### 1. Screen 1: Create Activity (`lib/screens/create_activity_screen.dart`)
- **Custom Metrics Data Model**:
  - Defined `CustomActivityMetric` with `id`, `name`, and `unit`.
  - Added `List<CustomActivityMetric> customMetrics` to `LibraryActivityItem`.
- **Custom Metrics Section**:
  - Added optional **“Custom Metrics (Optional)”** section above Favourites toggle.
  - Subtitle: `“Create whatever you want to track for this particular activity (e.g. Distance — metres, Load — kg, Incline — %).”`
  - When empty, displays a clean guidance hint.
  - Added `+ Add Metric` button opening an interactive modal bottom sheet.
- **Add Custom Metric Modal Sheet**:
  - Metric name input with quick suggestion chips (`Distance`, `Speed`, `Incline`, `Height`, `Load`, `Repetitions`).
  - Unit input with quick suggestion chips (`metres`, `mph`, `%`, `cm`, `kg`, `reps`, `sec`, `min`).
  - Allows multiple metrics or none at all.
  - Each added metric displays in a badge card with a remove icon.
  - Attached custom metrics are saved into the `LibraryActivityItem`.

#### 2. Screen 2 & 3: Record S&C Session (`lib/screens/record_session_screen.dart`)
- **Header Title**:
  - Changed heading from `TRAINING SESSION` to:
    **`RECORD S&C SESSION`** (across both unselected and selected views).
- **Dynamic Metrics Section**:
  - Once an activity is selected, automatically loads and displays the custom metrics created for that specific activity (e.g. `Distance — metres`, `Load — kg`), rather than predefined fixed metrics (`Distance`, `Repetitions`, `Sets`, `Weight`).
  - If the Activity has no custom metrics, the Metrics section does not appear.
  - When no activity is selected yet, replaced the fixed Distance/Pace lock cards with a generic Custom Metrics Locked placeholder.
- **Media Attachments (Camera & Library)**:
  - For **Add Photo**: opens bottom sheet with **Capture with Camera** and **Choose from Library**.
  - For **Add Video**: opens bottom sheet with **Record with Camera** and **Choose from Library**.
  - Added media items are attached to the session and displayed in the preview slots with remove buttons.
- **Preserved Core Features**:
  - Retained user-selected Performance Rating (star ratings).
  - Retained Intensity selector (`Low`, `Med`, `High`), Notes, Date & Time, draft autosave, and Save Session.
  - When saved, passes recorded custom metrics, attached media, and exact user notes to `SessionDetailsScreen`.

#### 3. Screen 4: S&C Session Details (`lib/screens/session_details_screen.dart`)
- **Dynamic Metrics Display**:
  - Metrics displayed under Session Details dynamically reflect the custom metrics configured for that activity and recorded during this session.
- **Removed Personal Best Banner**:
  - Removed **`NEW PERSONAL BEST — Longest Session`** card (longer S&C sessions are not treated as achievements).
  - Cleaned up unused ticker animation controller and glow animation fields.
- **Media Section**:
  - Any photos or videos captured or uploaded while creating the session automatically appear in the Media section grid.
- **Notes & Rating**:
  - Notes display exactly what the user entered when recording the session.
  - 4/5 star rating preserved as user-selected.
- **Delete Confirmation**:
  - Verified Delete Session requires confirmation dialog before permanently deleting.

#### 4. Screen 5: Activity Statistics (`lib/screens/activity_statistics_screen.dart`)
- **Standard Statistics**:
  - Kept **`Total Sessions`** and **`Total Duration`** as the standard statistics.
- **Removed Fixed Metrics**:
  - Removed fixed `Avg. Pace | Max Distance | Calories | Avg. Heart Rate` statistics.
- **Custom Metric Statistics**:
  - Any additional statistics displayed are derived from the custom metrics created for that activity (e.g. `Avg Distance`, `Max Load`).
  - If the activity has no custom metrics, statistics cleanly focus on `Total Sessions` and `Total Duration`.
- **Empty State Aligned**:
  - Empty statistics card displays `Total Sessions` and `Total Duration`, plus custom metric rows if configured for that activity.
  - Preserved `No Statistics Available` headline, date filters (`Last 30 Days | Last 3 Months | All Time`), and `Record Session` CTA.

---

### Verification
```bash
flutter analyze lib/screens/activity_library_screen.dart lib/screens/create_activity_screen.dart lib/screens/record_session_screen.dart lib/screens/session_details_screen.dart lib/screens/activity_statistics_screen.dart lib/screens/activity_details_screen.dart
# Result: Analyzing 6 items... No issues found! (0 errors, 0 warnings)
```


---

## Batch 19: Strength & Conditioning Activity Statistics Trends, Activity Goals & Activity Insights

### Target Files Verified & Updated
1. [activity_statistics_screen.dart](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/activity_statistics_screen.dart) - Image 1 (`media_1793709989739_51223354.jpg`)
2. [activity_goals_screen.dart](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/activity_goals_screen.dart) - Images 2 & 3 (`media_1793710093688_ebcebe93.png`, `media_1793710128581_fd528509.jpg`)
3. [activity_insights_screen.dart](file:///c:/Users/Haram/Desktop/ULVENIK/lib/screens/activity_insights_screen.dart) - Images 4 & 5 (`media_1793710149668_82382122.png`, `media_1793710170377_796539d9.jpg`)

---

### Implementation Details

#### 1. Screen 1: Activity Statistics (`lib/screens/activity_statistics_screen.dart`)
- **Removed Streaks and Longest Session**:
  - Removed `Longest Session`, `Current Streak`, and `Longest Streak` from Overview in line with S&C standards.
  - Retained standard core statistics: **`Total Sessions | Total Duration | Avg Duration`**.
  - Additional statistics are dynamically derived from custom numerical metrics configured for that activity (e.g. `Avg Distance`, `Max Incline`).
- **Activity Trend Graph**:
  - Replaced hardcoded total hours graph (`0h`, `20h`, `40h`) with **session frequency over time** as the standard/default trend.
  - Added trend metric selector allowing users to switch between **Sessions** (frequency count) and the activity's custom numerical metrics (e.g. `Distance` [metres]).
  - Left Y-axis labels and active tooltip items dynamically reflect session frequency (e.g. `12 Sessions`) or custom metric units.
- **Date Range Filters**:
  - Updated filter pills to match design: `['Last 7 Days', 'Last 30 Days', 'This Year']`.

#### 2. Screen 2 & 3: Activity Goals (`lib/screens/activity_goals_screen.dart`)
- **Empty State (`media_1793710093688_ebcebe93.png`)**:
  - Updated supporting copy underneath “No Goals Created” to:
    `“Set your first goal for this activity and track your progress over time.”`
  - Removed `Learn about Goals` text link and its popup menu item.
  - Aligned empty summary card columns to:
    **`ACTIVE GOALS | COMPLETED | TOTAL GOALS`**.
- **Populated State (`media_1793710128581_fd528509.jpg`)**:
  - Replaced `OVERALL PROGRESS — 68%` with **`TOTAL GOALS`**, so top summary card is:
    **`Active Goals | Completed | Total Goals`** (e.g. `3 | 7 | 10`).
  - Preserved individual goal progress as actual recorded values (`12 / 20 Sessions`, `22 / 30 minutes`, `0 / 8 weeks`).
  - Removed the `“Swim 30 Days Streak”` example (no streaks in S&C).
  - Avoided Personal Best/PB references: updated `“Sub 1:30 100m Free”` achievement from `1:28 PB` to `1:28 Achieved`.

#### 3. Screen 4 & 5: Activity Insights (`lib/screens/activity_insights_screen.dart`)
- **Empty State (`media_1793710149668_82382122.png`)**:
  - Updated supporting copy underneath “No Insights Available” to:
    `“Record more sessions to start seeing patterns and trends in this activity over time.”`
- **Populated State (`media_1793710170377_796539d9.jpg`)**:
  - Removed `Current Streak`, `Longest Streak`, and `Most Consistent`.
  - Replaced frequency/volume cards with:
    **`Sessions This Month | Avg / Week | Total Sessions | Avg / Month`**
    - `SESSIONS THIS MONTH`: e.g. `14 Sessions`
    - `AVG / WEEK`: e.g. `2.8`
    - `TOTAL SESSIONS`: e.g. `48`
    - `AVG / MONTH`: e.g. `10.4`
  - Preserved Activity Trends section with `Sessions | Duration | Avg Duration`.
  - Preserved Milestones (`10 | 25 | 50 Sessions`).
  - Changed **“Progress Summary”** to **“Activity Summary”**.
  - Information kept strictly factual: reports session frequency change (+15%), average weekly workouts (2.8 sessions), average duration (45m), and total volume (62h 15m).
  - Removed subjective assessments and streak references (e.g. “Highly consistent”, “On track to beat longest streak”).

---

### Verification
```bash
flutter analyze lib/screens/activity_statistics_screen.dart lib/screens/activity_goals_screen.dart lib/screens/activity_insights_screen.dart
# Result: Analyzing 3 items... No issues found! (0 errors, 0 warnings)
```

---

## Batch 20 Implementation: Equipment Library, Session Templates & S&C Export

### Screens Addressed
1. **Equipment Screen (Empty & Populated)** (`lib/screens/equipment_screen.dart` / `media_1793711474865_ca86803c.jpg`, `media_1793711497072_0309d7d4.jpg`)
2. **Session Templates Screen (Empty & Populated)** (`lib/screens/session_templates_screen.dart` / `media_1793711521714_9ad9f557.png`, `media_1793711550674_a98d3721.jpg`)
3. **S&C Export Screen** (`lib/screens/export_screen.dart` / `media_1793711572100_f4fc01d0.jpg`)

---

### Detailed Changes

#### 1. Equipment Library (`lib/screens/equipment_screen.dart`)
- **Shared Equipment Library**:
  - Configured Equipment to work as a shared Equipment Library across Ulvenik, rather than being specific to Strength & Conditioning.
  - Added subtle shared indicator in equipment details sheet (`Shared across Training, S&C and Sport sessions`).
- **Empty State Supporting Copy**:
  - Changed from:
    `"Create your first equipment item to keep track of what you use during your Strength & Conditioning sessions."`
    To:
    `"Create your first equipment item to start building your Equipment Library and keep track of what you use across your dog’s training."`
- **Item Usage & Metadata**:
  - Kept `"Used X times · Last used [date]"` information against each equipment item reflecting its cross-discipline usage (Training, S&C, and Sport sessions).
  - Preserved Create Equipment, search, filters (`All Types`, `Active`, `Favorites`, etc.), and sorting (`A-Z`, `Most Used`, `Recent`).

#### 2. Session Templates (`lib/screens/session_templates_screen.dart`)
- **Empty State Supporting Copy**:
  - Changed from:
    `"Create your first template to quickly record your regular Strength & Conditioning sessions."`
    To:
    `"Create your first template to quickly set up Strength & Conditioning sessions you use regularly."`
- **Button Renaming**:
  - Changed `"Start Session"` to **`"Record Session"`** on all template cards and within the template details modal sheet to keep terminology consistent throughout S&C.
- **Loading Activities & Saved Custom Metrics**:
  - Integrated `CustomActivityMetric` from `activity_library_screen.dart` into `SessionTemplateItem`.
  - Added custom metrics badges to template cards (e.g. `Speed (mph)`, `Incline (%)`, `Distance (metres)`, `Load (kg)`, `Repetitions (reps)`).
  - Updated `_startSessionWithTemplate(item)` to launch `RecordSessionScreen` pre-populated with:
    - `initialActivityName: item.activityName`
    - `initialIcon: item.activityIcon`
    - `initialCustomMetrics: item.customMetrics`
    - `startWithActivity: true`
  - Ready for the user to immediately enter actual values upon tapping **Record Session**.

#### 3. S&C Export Screen (`lib/screens/export_screen.dart`)
- **Export Scope**:
  - Allowed user to choose relevant dog(s) and date range:
    - Dog Scope: **`All Dogs`** vs **`Selected Dogs Only`** (with interactive multi-select chips: `Murphy`, `Koda`, `Luna`, `Rex`, `Nova`).
    - Date Range: **`Last 7 Days | Last 30 Days | Last 90 Days | This Year | All Time | Custom`** (with interactive date range picker).
  - Completely removed obsolete filters:
    - `"Training Sessions Only"`
    - `"Competitions Only"`
    - `"Health Metrics Only"`
- **Include Data Options**:
  - Based strictly on actual S&C information available on the platform:
    1. **`Session Details`**
    2. **`Custom Metrics`**
    3. **`Notes`**
    4. **`Statistics`**
    5. **`Goals`**
    6. **`Equipment`**
    7. **`Tags`**
    8. **`Photos`**
    9. **`Videos`**
    10. **`Activity Insights`**
    11. **`Location`**
    12. **`Weather`**
  - Completely removed non-S&C and outdated placeholder options:
    - `"Heart Rate Data"`
    - `"Recovery Scores"`
    - `"Injury Logs"`
    - `"Nutrition Logs"`
    - `"Weight History"`
    - Old placeholders (`Session Notes`, `Environmental Conditions`, `Handler Notes`, `Video References`, `GPS Coordinates`, `Custom Tags`).
- **Format, File Name & Export Generation**:
  - Maintained `PDF | CSV | JSON` format options.
  - Maintained interactive editable `FILE NAME` with dynamic name generation.
  - Maintained `Generate Export` action, progress modal, and `Export History` list with re-download, share, and delete.

---

### Verification
```bash
flutter analyze lib/screens/equipment_screen.dart lib/screens/session_templates_screen.dart lib/screens/export_screen.dart
# Result: Analyzing 3 items... No issues found! (0 errors, 0 warnings)
```

---

## Batch 21 Implementation: Configured S&C Export, S&C Archive, S&C Settings & Timeline Empty State

### Screens Addressed
1. **Configured S&C Export Screen** (`lib/screens/export_screen.dart` / `media_1793712702112_6cd6af3f.jpg`)
2. **S&C Archive Screen (Empty & Populated)** (`lib/screens/sc_archive_screen.dart` / `media_1793712737700_5b78f380.png`, `media_1793712779708_c12d65ce.jpg`)
3. **S&C Settings Screen** (`lib/screens/sc_settings_screen.dart` / `media_1793712856182_a6b47e07.jpg`)
4. **Timeline Empty State** (`lib/screens/timeline_screen.dart`, `lib/screens/timeline_dashboard_screen.dart` / `media_1793712876542_81644233.jpg`)

---

### Detailed Changes

#### 1. Configured S&C Export Screen (`lib/screens/export_screen.dart`)
- **Export Scope**:
  - Restored `All Time Data` and `Selected Date Range` radio options matching the configured design.
  - Kept date range presets: `Last 7 Days | Last 30 Days | Last 90 Days | This Year | All Time | Custom`.
- **Include Data Options**:
  - Ensured **`Custom Metrics`** is selectable alongside the platform S&C data:
    `Session Details | Custom Metrics | Notes | Statistics | Goals | Equipment | Tags | Photos | Videos | Activity Insights | Location | Weather`
- **Other Controls Maintained**:
  - `PDF | CSV | JSON` format selectors, editable `FILE NAME`, `Generate Export` CTA, and `Export History` preserved.

#### 2. S&C Archive Screen (`lib/screens/sc_archive_screen.dart`)
- **Removed Equipment Section**:
  - Removed Equipment category from the S&C Archive (`enum ArchiveCategory { activity, template }`).
  - Removed Equipment accordion section, equipment demo items, and equipment references from the analytics breakdown.
  - Equipment is now exclusively managed via the shared Equipment Library across Ulvenik.
- **Empty State Supporting Copy**:
  - Updated supporting copy underneath **“Archive is Empty”** to:
    > *“You don’t have any archived Strength & Conditioning items. Archived activities and session templates will appear here.”*
- **Confirmation Dialogs**:
  - Added simple confirmation dialog to **Restore** explaining:
    > *“Are you sure you want to restore [item]? The item will be returned to its relevant active section in [Activities / Session Templates].”*
  - Added confirmation dialog to **Delete Permanently** requiring confirmation before permanent removal.

#### 3. S&C Settings Screen (`lib/screens/sc_settings_screen.dart`)
- **Removed Default Session Rating**:
  - Removed `Default Session Rating` setting row and its selection sheet, ensuring users deliberately select ratings for each individual session rather than having one pre-selected.
  - Maintained `Default Activity`, `Auto-Save Draft Sessions`, `Auto-Attach Location`, and `Auto-Record Weather`.
  - Maintained `Activity Preferences`.
- **Show Milestones Copy**:
  - Updated description underneath `Show Milestones` from:
    `"Display milestone achievements in statistics"`
    to:
    `"Display recorded session milestones in statistics."`
    keeping milestones factual rather than performance achievements.

#### 4. Timeline Empty State (`lib/screens/timeline_screen.dart` & `lib/screens/timeline_dashboard_screen.dart`)
- **Headline & Supporting Copy**:
  - Headline: **“Your Dog's Journey Starts Here”**
  - Updated supporting copy to:
    > *“Training sessions, S&C sessions, health records, milestones and memories will appear here as you build your dog’s journey with Ulvenik.”*
  - Omitted "Competition" from universal wording (preserved dynamically for Sport Pack users).
- **CTA Button**:
  - Changed from `“Record Your First Activity”` to:
    **`“Start Their Journey”`** (with arrow forward).
- **Hero Header & Navigation**:
  - Hero banner displays **“Your Dogs' Journey”** with subtitle **“Every moment, every dog, in one place”**.
  - Maintained dog selector card, compass icon, and scenic background.

---

### Verification
```bash
flutter analyze lib/screens/export_screen.dart lib/screens/sc_archive_screen.dart lib/screens/sc_settings_screen.dart lib/screens/timeline_screen.dart lib/screens/timeline_dashboard_screen.dart
# Result: Analyzing 5 items... No issues found! (0 errors, 0 warnings)
```


---

## Batch 22 — Timeline Filters, Empty State, Summary Grid & Event Details (5 Screens)

1. **Populated Timeline (`lib/screens/timeline_screen.dart`)**:
   - Added **`S&C`** to the Timeline filter strip and made **`Sport/Competition`** subscription-aware (`All Events | Training | S&C | Health`, plus `Sport/Competition` when the user has the Sport Pack).
   - Preserved the `Events | Sessions | Health | Goals` summary strip (`142 Events`, `86 Sessions`, `24 Health`, `18 Goals`), dog selector, search bar, and chronological grouping of records.

2. **Empty State Timeline Dashboard (`lib/screens/timeline_dashboard_screen.dart`)**:
   - Removed the `Duration | Distance | Events` segmented bar at the top.
   - Changed the primary CTA to **`Add First Record`** (opening the subscription-aware record/session type selector) and removed any separate `"Add a Health Record instead"` link.
   - Kept **`No Timeline Events Yet`**, **`Every journey starts somewhere...`**, dog selector, and `All Types` filter as designed.

3. **Populated Timeline Dashboard (`lib/screens/timeline_dashboard_screen.dart`)**:
   - Simplified the 6-cell summary grid to: **`Total Events | This Month | Last Activity | Training Sessions | S&C Sessions | Health Records`**.
   - Kept `All | Training | Health | S&C` filters with subscription-aware `Sport/Competition` support for Sport Pack users.

4. **Health Timeline Event Details (`lib/screens/timeline_event_details_screen.dart`)**:
   - Updated the **Summary** section and detail rows so they only display factual user-recorded details from the original Health record (`"Routine annual physical examination and core vaccination booster recorded. Weight logged at 34.2 kg..."`, weight `34.2 kg`, condition score `5/9`) without auto-generating health assessments (`"excellent health"`, `"optimal weight"`, `"exceptional"`).

5. **Training Timeline Event Details (`lib/screens/timeline_event_details_screen.dart`)**:
   - Updated the **Summary** section to display only factual user-entered session details (`"Off-leash obedience session recorded in a medium-distraction park environment. Practised focused heelwork (15 mins), recall with distraction (5 reps), and long down-stay (3 mins)."`), removing auto-generated performance assessments.
   - Changed `DURATION` from **`45 Minutes (Active)`** to **`45 Minutes`**.


---

## Batch 23 — Timeline Filters, Timeline Search & Results, and Timeline Calendar (5 Screens)

1. **Timeline Filters (`lib/screens/timeline_filters_screen.dart`)**:
   - Kept **`Training | Health | S&C | Goals | Media`** as standard selectable Timeline categories.
   - Made **`Competition`** and Competition-specific saved filters (such as **`Competition Results`**) subscription-aware so they only appear for users with access to the Sport Pack (`hasSportPack`).
   - For Sport Pack subscribers, `Competition` appears as a normal selectable filter alongside the other categories without a lock badge.

2. **Timeline Search (`lib/screens/timeline_search_screen.dart`)**:
   - Made **Saved Searches**, **Recent Searches**, and **`Popular in [Dog's Name]'s Timeline`** dynamically driven by the user's actual searches and the dog's recorded Timeline data (`_popularInDogTimeline`) rather than generic hardcoded suggestions.
   - Preserved `Search Notes`, `Search Attachment Names`, and `Clear All`.

3. **Timeline Search Results (`lib/screens/timeline_search_screen.dart`)**:
   - Aligned the category filter pills to **`All | Training | Health | S&C | Goals | Media`**, with **`Sport/Competition`** added where the user has the Sport Pack.
   - Updated search matching (`_itemMatchesQuery`) so results match record titles, content/locations, attachment names (when `Search Attachment Names` is enabled), and record Notes (when `Search Notes` is enabled).

4. **Timeline Calendar — Month View (`lib/screens/timeline_calendar_screen.dart`)**:
   - Made the selected-day summary (`14 Aug Summary`) subscription-aware: `Training | Health | S&C | Goals | Media` appear as standard, with `Competition` (`COMP.`) and competition events only shown for users with access to the Sport Pack.

5. **Timeline Calendar — Day View (`lib/screens/timeline_calendar_screen.dart`)**:
   - Made `COMP` in the **Daily Summary** card subscription-aware so it only appears for users with the Sport Pack.
   - Updated the **No Events Recorded** supporting text from *"Keep track of your dog’s progress by logging an event."* to:
     **"Nothing was recorded for this date. Keep building your dog’s journey by adding a new record."**
   - Added **`+ S&C`** alongside **`+ Training`** and **`+ Health`** quick actions (plus **`+ Sport`** when the user has the Sport Pack).


---

## Batch 24 — Timeline Calendar Week View, Timeline Statistics, and Timeline Export (5 Screens)

1. **Timeline Calendar — Week View (`lib/screens/timeline_calendar_screen.dart`)**:
   - Made Competition events and categories subscription-aware across the Week View (`_getDailySummary`, `_buildWeekSelectedDayPreview`, and `_buildWeekDetailsEventList`), so Competition entries only appear for users with the Sport Pack (`_hasSportPack`).
   - Preserved `Day | Week | Month` navigation, weekly date strip, event overview, Details section, and `View more events`.

2. **Timeline Statistics — Empty State (`lib/screens/timeline_statistics_screen.dart`)**:
   - Changed **“Go to Timeline”** CTA to **“Add a Record”** (navigating to `RecordSessionScreen`).
   - Removed **“Learn about the Timeline”** link underneath.
   - Preserved **“No Statistics Yet”**, supporting text, week navigator, and wireframe skeleton layout.

3. **Timeline Statistics — Populated State (`lib/screens/timeline_statistics_screen.dart`)**:
   - Updated **Category Breakdown** (`_buildCategoryBreakdownCard`) so both the donut chart and legend reflect all recorded Timeline categories: **`Training | S&C | Health | Goals | Media`**, with **`Competition`** included for users with the Sport Pack.
   - Preserved date filters, `Total Events`, streak information, and the `Activity Over Time` graph.

4. **Timeline Export — Empty State (`lib/screens/timeline_export_screen.dart`)**:
   - Changed **“Go to Timeline”** CTA to **“Add a Record”**.
   - Preserved **“No Timeline Data”**, supporting text, and the disabled **“Generate Export”** button.

5. **Timeline Export — Populated State (`lib/screens/timeline_export_screen.dart`)**:
   - Updated `_updateDateRangeByPreset` so **This Year** dynamically reflects the actual current year (`DateTime.now().year`, i.e., `Jan 1, <currentYear> - Dec 31, <currentYear>`).
   - Preserved `Date Range | Specific Events`, date presets, `PDF Document` format, and `Generate Export`.


---

## Batch 25 — Timeline Favourites, Timeline Archive, and Timeline Settings (5 Screens)

1. **Timeline Favourites — Empty State (`lib/screens/timeline_favourites_screen.dart`)**:
   - Updated supporting text underneath **“No Favourite Events”** from *"Favourite your most important Timeline moments to access them quickly. Tap the heart icon on any event to save it here."* to:
     **“Favourite important Timeline events to find them quickly. Tap the heart icon on any event to save it here.”**
   - Preserved **“No Favourite Events”** and **“Go to Timeline”** CTA.

2. **Timeline Favourites — Populated State (`lib/screens/timeline_favourites_screen.dart`)**:
   - Changed **“SAVED MOMENTS”** (`18 Saved Moments`) in the metrics bento summary card to **“FAVOURITE EVENTS”** (`Favourite Events`), keeping terminology consistent with Timeline Events.
   - Made **Competition** favourites, category indicator dots, and category filter options subscription-aware (`hasSportPack`), so Competition only appears for users with the Sport Pack.
   - Preserved search, category filters, sorting, `Latest` / `Oldest` information, and favourite event cards.

3. **Timeline Archive — Empty State (`lib/screens/timeline_archive_screen.dart`)**:
   - Hidden the bottom **Filter** and **Search** controls while there are no archived events (`_isEmptyState`), so search and filtering controls only appear once the archive contains records.
   - Preserved **“No Archived Events”**, the supporting text, and **“Return to Timeline”**.

4. **Timeline Archive — Populated State (`lib/screens/timeline_archive_screen.dart`)**:
   - Replaced **“MB Storage Used”** (`18.4 MB STORAGE USED`) in the **Timeline Archive Summary** card with **“Categories”** (`CATEGORIES`, showing the distinct count of archived categories), so the summary displays:
     **`Archived Events | Categories | Last Archived`**
   - Preserved search, multi-select mode, `Export`, `Restore`, individual archived event cards, and orphaned record handling (`ORPHANED RECORD` / `Original record deleted — reference only` / `Remove Reference`).

5. **Timeline Settings (`lib/screens/timeline_settings_screen.dart`)**:
   - Ensured **Time Format** allows the user to choose between **12-hour** (`12 Hour`) and **24-hour** (`24 Hour`) display, dynamically updating time displays such as `Daily Digest Time`.
   - Updated **Reset Timeline Settings** (`_confirmReset`) to require a clear confirmation dialog before resetting all settings to their defaults.
   - Preserved the full **Timeline Settings** accordion structure: `Display`, `Grouping`, `Event Preview`, `Favourites`, `Archive`, `Search`, `Notifications`, `Performance`, and `Privacy`.


---

## Batch 26 — Timeline Insights, Timeline Memories, and Timeline Activity Map (5 Screens)

1. **Timeline Insights — Empty State (`lib/screens/timeline_insights_screen.dart`)**:
   - Changed **“Go to Timeline”** CTA to **“Add a Record”** (navigating to `RecordSessionScreen`).
   - Removed **“Learn about Timeline Insights”** link underneath.
   - Preserved **“Not Enough Timeline Data”** and its supporting text.

2. **Timeline Insights — Populated State (`lib/screens/timeline_insights_screen.dart`)**:
   - Changed **“Recording Consistency”** to **“Recording Patterns”**.
   - Removed **“Activity Balance”** as an Insight category.
   - Updated all Insights across **Recording Patterns**, **Training**, **Strength & Conditioning**, **Health**, **Goals**, and **Milestones** so every insight is calculated strictly from objective patterns in the user’s recorded data (streaks, most active/consistent month, average time between entries, session counts, locations, durations, recorded weights, and goal completion durations) rather than subjective assessments.

3. **Timeline Memories — Empty State (`lib/screens/timeline_memories_screen.dart`)**:
   - Removed **“Learn about Timeline Memories”** link.
   - Updated the **Milestone Engine** description to reflect objective generation from user-recorded Timeline data:
     *“Memories and milestones are generated automatically from your recorded Timeline data — including dates, anniversaries, session counts, completed goals, and recorded events.”*
   - Preserved **“No Memories Yet”**, supporting text, and **“Go to Timeline”**.

4. **Timeline Memories — Populated State (`lib/screens/timeline_memories_screen.dart`)**:
   - Updated memory descriptions and subtitles so automatically generated memories reflect objective recorded data (anniversaries, session counts, completed goals, recording streaks, first records, and previous events), with results/ratings such as `"Excellent"` shown explicitly as part of the user's recorded result (`Recorded result: 94/100 · Excellent`).
   - Made **Competition** memories and category filters subscription-aware (`hasSportPack`), so they are only available for users with the Sport Pack.

5. **Timeline Activity Map — Empty State (`lib/screens/timeline_activity_map_screen.dart`)**:
   - Removed **“GPS tags enable tracking & speed logs”** underneath the CTA so the empty state focuses on location information attached to Timeline records.
   - Preserved **“No Recorded Locations”**, the supporting text, and **“Go to Timeline”**.


---

## Batch 27: Timeline Activity Map (Marker Selected & Default States), Timeline Compare & Smart Collections (Empty State)

1. **Timeline Activity Map — Marker Selected State (`lib/screens/timeline_activity_map_screen.dart`)**:
   - Updated **“Recorded here:”** (`_recordedCategoriesForPin`) to dynamically display whichever Timeline categories actually have records at that location (including **Training**, **S&C**, **Health**, **Goals**, **Media**, and any other recorded categories), with **Competition** only available for Sport Pack users (`hasSportPack`).
   - Added `hasSavedLocation` filtering (`_savedLocations`) so locations only appear from records where location information has actually been saved/allowed by the user.
   - Preserved **Visits**, **First Visit**, **Last Visit**, favourite events, recent sessions, **View All Events Here**, and **Open in Timeline**.

2. **Activity Map — Default Map State (`lib/screens/timeline_activity_map_screen.dart`)**:
   - Updated the bottom category key (`_buildCategoryLegendBar` and `_mappedLegendCategories`) and map filter sheet (`_showMapFilterSheet`) to dynamically reflect the Timeline categories that have mapped records for that user (including **Media** where applicable), with **Competition** only available for Sport Pack users.

3. **Timeline Compare — Empty State (`lib/screens/timeline_compare_screen.dart`)**:
   - Under **“What gets compared?”**, changed the subtitle from *“Gait velocity, heart variability & track scent accuracy”* to:
     *“Sessions, duration, goals & recorded activity”*
   - Updated the **What Gets Compared?** sheet and export descriptions so Timeline Compare strictly reflects objective information from records entered by the user.

4. **Timeline Compare — Populated State (`lib/screens/timeline_compare_screen.dart`)**:
   - Verified and preserved the Period A vs Period B selectors, quick presets, Summary, Category Breakdown, Activity graph, Recording Consistency, Locations, Attachments, Milestones, Change Dates, and Export functionality based on objective recorded data.

5. **Smart Collections — Empty State (`lib/screens/timeline_smart_collections_screen.dart`)**:
   - Changed the supporting text underneath **“No Collections Available”** to:
     *“Related Timeline events are automatically organised into collections as your history grows.”*
   - Removed **“Learn about Smart Collections”** underneath **Go to Timeline**.
   - Preserved **No Collections Available**, **Go to Timeline**, search, and the rest of the page.


---

## Batch 28: Smart Collections (Populated State), Timeline Widgets (Empty & Populated States) & More (Main & Expanded Views)

1. **Smart Collections — Populated State (`lib/screens/timeline_smart_collections_screen.dart`)**:
   - Changed the section heading from **“HEALTH & BIOMETRICS”** to **“HEALTH”** and updated the weight collection rule formula to `health.weightKg != null`.

2. **Timeline Widgets — Empty State (`lib/screens/timeline_widgets_screen.dart`)**:
   - Removed **“Learn about Timeline Widgets”** underneath **+ Add Widget** and removed its unused modal method.
   - Preserved **No Timeline Widgets Added**, the supporting text, **+ Add Widget**, and **Reset Layout**.

3. **Timeline Widgets — Populated State (`lib/screens/timeline_widgets_screen.dart`)**:
   - Added explicit **Goal Progress Source** configuration (`Recorded Sessions & Milestones` or `Manual Progress Entry`) for **GOALS** widgets so any Goal Progress shown in a widget follows the same logic as the main Goals section — either entered by the user or automatically calculated from objective recorded data.
   - Preserved the Home Dashboard preview, widget gallery cards, size selectors, and layout controls.

4. **More — Main Menu (`lib/screens/more_page_screen.dart`)**:
   - Removed the **COMMUNITY** section (**Ulvenik Rewards**, **Refer a Friend**, and **Community**) and its associated placeholder bottom sheets so no unavailable community/referral features appear at launch.
   - Made **Offline Storage & Cloud Sync** (`Fully Synced`) conditional on `isCloudSyncAvailable` (defaulting to `true` to match the live **Backup & Sync** functionality, or displaying **Offline Storage** without cloud-sync wording when disabled).

5. **More — Expanded Dashboard & Backup & Sync (`lib/screens/more_dashboard_screen.dart`, `lib/screens/backup_sync_screen.dart`)**:
   - Preserved **Backup & Sync** (`Last synced 2 minutes ago`) under **DATA & STORAGE** and the **Cloud Sync** (`Synced`) KPI card, wired to the interactive **Backup & Sync** screen (automatic cloud sync toggle, mobile data sync toggle, live manual **Sync Now** progress, connected devices management, and cloud storage breakdown).


---

## Batch 29: Notification Settings, Backup & Sync, Offline Mode & Downloads, Storage Management & Help Centre

1. **Notification Settings (`lib/screens/notification_settings_screen.dart`)**:
   - Removed **“Recovery Reminders”** from the **STRENGTH & CONDITIONING** section (`_pushToggles` and `_buildPushNotificationsCard()`).
   - Added subscription-aware `hasSportPack` and `hasTrainerPack` flags to keep **COMPETITIONS** notification options and reminder timing restricted to **Sport Pack** users and **TRAINER** notifications restricted to **Trainer Pack** users.

2. **Backup & Sync (`lib/screens/backup_sync_screen.dart`)**:
   - Kept the **Backup & Sync** screen as designed and confirmed that the `5 GB` cloud storage allowance (`_cloudTotalGb = 5.0`) is currently placeholder/example UI content that can be configured to match any intended per-user or subscription-tier storage allowance.

3. **Offline Mode & Downloads (`lib/screens/offline_mode_screen.dart`)**:
   - In the **STORAGE** section (`_storageMb` and `_buildStorageBreakdownCard`), changed:
     - `Training Data` → **`Training Records`**
     - `Health Data` → **`Health Records`**
     to keep terminology consistent with the **AVAILABLE OFFLINE** section above.
   - Updated the **Remove Downloaded Content** confirmation sheet (`_confirmRemoveAll`) to clearly state that it only removes downloaded/local copies and that the user's cloud data and account records remain safe.

4. **Storage Management (`lib/screens/storage_management_screen.dart`)**:
   - In the **OVERVIEW** card (`_buildOverviewCard`), changed **“Other”** to **“Other Files”**.
   - Added a confirmation bottom sheet to **Clear Cache** (`_clearCache`) before cached files are cleared.
   - Updated the **Remove All Local Downloads** confirmation bottom sheet (`_confirmRemoveAllLocalDownloads`) so it explicitly states that this only removes downloaded/local copies and that the user's cloud data and account records will remain safe.

5. **Help Centre (`lib/screens/help_centre_screen.dart`)**:
   - Under **Strength & Conditioning** (`th_sc` and `gs_sc`), updated the supporting subtitle to **`“Strength & Conditioning tracking and session types”`** (and **`“Get started with Strength & Conditioning tracking”`**) rather than abbreviating to `S&C`.
   - Kept everything else on the Help Centre page as designed.


---

## Batch 30: Contact Support, Report a Bug, Feature Requests, About Ulvenik & Privacy Policy

1. **Contact Support (`lib/screens/contact_support_screen.dart`)**:
   - Under **DIAGNOSTICS**, replaced **“Dog Owner Plan”** with the user’s actual Ulvenik subscription (`_userSubscriptionLabel`: **Core**, **Core + Sport**, **Core + Trainer**, or **Complete** depending on the user's subscription / pack access).

2. **Report a Bug (`lib/screens/report_bug_screen.dart`)**:
   - Under **DIAGNOSTICS**, replaced **“Dog Owner Plan”** with the user’s actual Ulvenik subscription (`_userSubscriptionLabel`: **Core**, **Core + Sport**, **Core + Trainer**, or **Complete** depending on the user's subscription / pack access).
   - Preserved everything else on the page as designed.

3. **Feature Requests (`lib/screens/feature_requests_screen.dart`)**:
   - Kept the page layout/design intact and confirmed that the sample feature requests shown (**Training Templates**, **Smart Health Insights**, **Multi-Dog Training Session**, **Offline Goal Tracking**, **Custom Reward Icons**, and **Export to PDF**) are placeholder/example UI entries that can be updated to any final examples.

4. **About Ulvenik (`lib/screens/about_ulvenik_screen.dart`)**:
   - Under **WHO IS IT FOR?** (`_audienceRoles`), simplified and reordered the list to:
     - **Dog Owners**
     - **Working Dog Handlers**
     - **Professional Dog Trainers**
     - **Sport Competitors**
     - **Behaviourists**
     - **Breeders**
     - **Dog Clubs & Training Groups**
   - Under **OUR PHILOSOPHY**, ended the paragraph after **“bigger picture.”** and removed **“Because progress isn’t accidental —”** and the wording that followed.

5. **Privacy Policy (`lib/screens/privacy_policy_screen.dart`)**:
   - Kept the Privacy Policy layout and design as is, ready for final pre-launch policy wording updates.

---

## Batch 31: Terms & Conditions, What's New, Settings, Notifications & Profile

1. **Terms & Conditions (`lib/screens/terms_conditions_screen.dart`)**:
   - Kept the layout as designed.
   - Removed inapplicable references (**“competitive canine sport handlers”**, **“trail GPS logging”**, **“reverse-engineer biometric telemetry”**, **“related telemetry services”**, and **“physiological load analytics”**) and updated the wording to reflect Ulvenik’s dog training, strength & conditioning, health, goal-tracking, and Timeline record-keeping functionality, as well as the standard subscription tiers (**Core**, **Sport Pack**, **Trainer Pack**, and **Complete**).
   - Ready for final pre-launch policy review of the age requirement, subscriptions/billing, refunds, and account termination sections.

2. **What's New (`lib/screens/whats_new_screen.dart`)**:
   - Confirmed that the version history, release dates, and feature lists shown on the page are treated as placeholder content until actual release notes are populated.
   - Removed the duplicate **`Added Training Templates`** entry under **Version 1.0.1** (since Training Templates is already highlighted in **Version 1.2.0**), replacing it with **`Added Custom Reminder Schedules`**.

3. **Settings (`lib/screens/app_settings_screen.dart`)**:
   - Replaced **“Trainer Plan”** (`TRAINER PLAN` badge on the account card, `Account & Plan` bottom sheet subtitle, `Contact Support` subtitle, and `Storage & Sync` sheet subtitle) with the user’s actual Ulvenik subscription (`_userSubscriptionLabel`: **Core**, **Core + Sport**, **Core + Trainer**, or **Complete**).
   - Under **Privacy & Security** (`_privacySubtitle`, `_openPrivacySheet`, and search keywords), changed **“Biometrics”** / **“Biometric Unlock”** to **“Biometric Login”**.

4. **Notifications (`lib/screens/notifications_page_screen.dart`)**:
   - Removed **“Telemetry Sync: Online”** and **“GPS Collar #4”** from the bottom of the page (`_buildTelemetryFooter()`, `_openTelemetrySheet()`, and `_telemetryOnline`).
   - Updated the **Backup Complete** notification (`id: 'sync_1'`) body from **“Your telemetry data has been backed up successfully.”** to **`“Your Ulvenik data has been backed up successfully.”`** (and updated its context label to `Ulvenik Cloud Backup`).

5. **Profile (`lib/screens/profile_page_screen.dart`, plus `lib/screens/more_page_screen.dart`, `lib/screens/more_dashboard_screen.dart`, and `lib/screens/billing_history_screen.dart`)**:
   - Changed the membership name from **“Core + Trainer Pack”** (and hero badge **`CORE · TRAINER PACK`**) to **`“Core + Trainer”`** (and **`CORE + TRAINER`** via `_userSubscriptionLabel`, supporting `Core | Core + Sport | Core + Trainer | Complete`).
   - Under **Account & Security** (and **Privacy & Security**), changed **“biometrics”** / **“Biometrics”** / **“Biometric Unlock”** to **“Biometric Login”** (and removed telemetry wording from the Privacy & Security sheet).
   - Removed **“ULVENIK ATHLETIC INTELLIGENCE · NORDIC BUILD 85”** from the bottom of the Profile page (and removed **“Ulvenik Athletic Intelligence”** from the About Ulvenik sheet subtitle).

---

## Batch 32: Edit Profile, Billing History, Subscription, Restore Purchases & Delete Account

1. **Edit Profile (`lib/screens/edit_profile_screen.dart`, plus `lib/screens/profile_page_screen.dart` and `lib/screens/app_settings_screen.dart`)**:
   - Under **MEASUREMENT PREFERENCES**, removed **Temperature (`Celsius (°C)`)** since Ulvenik does not record or display temperature.
   - Kept **Weight** and **Distance** as designed (and cleaned up the Temperature unit selector in `app_settings_screen.dart` and `profile_page_screen.dart`).

2. **Billing History (`lib/screens/billing_history_screen.dart`)**:
   - Changed **“Core + Trainer Pack”** under **ACCOUNT SUMMARY** (`CURRENT PLAN`) to **`“Core + Trainer”`** (via `_userSubscriptionLabel`, supporting `Core | Core + Sport | Core + Trainer | Complete`).
   - Kept the prices as placeholder/example content and preserved everything else on the page as designed.

3. **Subscription (`lib/screens/subscription_details_screen.dart`)**:
   - Updated the current membership hero card (`_currentMembershipTitle` in `_buildCoreHeroCard` and `_openManageCoreSubscriptionSheet`) so the user’s current membership is dynamically displayed using:
     - **Core**
     - **Core + Sport**
     - **Core + Trainer**
     - **Complete**
     depending on their active subscription.
   - Removed the **Club Pack** (`id: 'club'`) from `_packs` and removed `CLUBTRIAL` promo code handling from `_openRedeemCodeSheet`.
   - Kept the prices as placeholder/example content and preserved everything else on the page as designed.

4. **Restore Purchases (`lib/screens/restore_purchases_screen.dart`)**:
   - Under **ITEMS THAT CAN BE RESTORED** (`_entitlements`), updated the entitlement names to:
     - **Core**
     - **Sport Pack**
     - **Trainer Pack**
     (replacing `Core Membership` so subscription naming stays consistent throughout the app).
   - Preserved everything else on the page as designed.

5. **Delete Account (`lib/screens/delete_account_screen.dart`)**:
   - Under **WHAT WILL BE PERMANENTLY DELETED**, removed the **“Cloud Backups”** (appearing as “Club Backups” in the small screenshot) entry from `_rightDeletedItems`.
   - Preserved everything else on the page as designed.

---

## Batch 33: Export My Data, Change Password, Calendar, Country or Region & Measurement Units

1. **Export My Data (`lib/screens/export_my_data_screen.dart`)**:
   - Under **Training**, changed **“Statistics”** to **“Stats”** (`collapsedSubtitle: 'Training Records · S&C · Goals · Stats'` and `trn_stats` option label `'Stats'`).
   - Under **Packs** (`_packOptions` / `_groups`), gated **Competitions (Sport Pack)** behind `widget.hasSportPack` and **Trainer Pack Data** behind `widget.hasTrainerPack`, dynamically building the collapsed subtitle and hiding the **Packs** group when the user has neither pack.

2. **Change Password (`lib/screens/change_password_screen.dart`)**:
   - Updated the password strength indicator (`_strengthLabel` and `_strengthColor`) so the 5-segment strength bar and label change colour dynamically depending on the password strength using subtle, Ulvenik-consistent tones:
     - **Weak** — muted red (`_weakRed`: `0xFFB85C5C`)
     - **Good** — amber/orange (`_goodAmber`: `0xFFC88A4B`)
     - **Strong** — Ulvenik sage green (`_strongSageGreen`: `0xFF5E8F79`)

3. **Calendar (`lib/screens/global_calendar_screen.dart`)**:
   - Gated all **Competition** events (`_EventCategory.competition`, including **“Competition – IGP Trial”**) and Competition category filters (`_availableCategories` and `_matchesActiveFilters`) behind `widget.hasSportPack`.

4. **Country or Region (`lib/screens/country_region_screen.dart`)**:
   - Removed the alphabet section header bars (`A`, `C`, `D`, `F`, `G`, `N`, `S`, `U`) on the left-hand side of the country list in `_buildAllCountriesCard()`, while attaching `_letterKeys[letter]` to the first country row of each letter group so the right-hand **A–Z** quick navigation rail continues to scroll smoothly.
   - Ensured each country row renders its vector country flag next to the country name via `_CountryCodeEmblem` (`CustomPaint(size: Size.infinite, painter: _FlagVectorPainter(...))`).

5. **Measurement Units (`lib/screens/measurement_units_screen.dart`)**:
   - Removed **Temperature** (`Celsius 14°C`) from the **ENVIRONMENT** section (`_buildCategoriesCard`) and from the **PREVIEW** section (`_buildPreviewCard`), as well as from the system summary lines (`_systemSummaryLine` and `_buildPresetSelectorRow`: `kg · km · cm` and `lb · mi · in`).
   - Preserved the **Metric | Imperial | Custom** options and individual unit mix-and-match functionality as designed.

---

## Batch 34: Media Library, Video Viewer, Photo Viewer & Media Uploads

1. **Media Library (`lib/screens/media_library_screen.dart`)**:
   - Confirmed that **`2.4 GB STORAGE`** in the top summary card (`_buildSummaryCard()`) represents the amount of storage currently being used by the user’s media (`147 PHOTOS` + `34 VIDEOS` + `12 DOCS`), rather than a storage allowance or limit.
   - Kept the Media Library layout and filters as designed.

2. **Video Details (`lib/screens/video_viewer_screen.dart`)**:
   - Updated the **NOTES** section (`_notes`, `_relatedClips`, and `_showEditNotesSheet`) so the notes clearly represent notes entered by the user/handler (and removed `'FOCUS SCORE: 94%'` from `_showLinkedRecordSheet`, replacing it with `'DURATION: 45 min'`).
   - Changed the action button label from **“Open”** to **“Open Record”** (`_buildActionStripCard`, opening `_showLinkedRecordSheet`) for consistency with the photo details page.
   - Gated Competition-related tags behind `widget.hasSportPack` in `_buildTagsRow()`.

3. **Photo Details (`lib/screens/photo_viewer_screen.dart` — Images 3 & 4)**:
   - Confirmed the action button is labelled **“Open Record”** (`_buildActionStripCard` at line 1112, opening `_showLinkedRecordSheet`).
   - Updated the **NOTES** section (`p3` notes, `_showLinkedRecordSheet`, and added `_showEditNotesSheet()` + an **`Edit`** action next to `NOTES`) so all notes clearly display user/handler-entered session notes rather than automated assessments.
   - Gated **Competition** tags (`'Competition'`) behind `widget.hasSportPack` in `_buildTagsRow()`.

4. **Media Uploads (`lib/screens/media_upload_manager_screen.dart`)**:
   - Gated Competition-related uploads/records (`id: 'w1'` — `Koda_Competition_Score.pdf`, `'Competition · 10 Jul 2026'`, and Competition document options in `_showAddMediaSheet`) behind `widget.hasSportPack`.
   - Preserved the upload progress, queue controls, and failed/retry functionality as designed.

---

## Batch 35 Implementation Summary

1. **Collections (`lib/screens/media_collections_screen.dart`)**:
   - Gated Competition-related collections behind `widget.hasSportPack`: marked albums `col_3` ("Competition Day — Oslo") and `col_4` ("Scent & Search Trials") with `isCompetition: true`.
   - In `_filteredCollections`, filtered out any collection with `isCompetition: true` when `widget.hasSportPack == false`.
   - Preserved custom user collection creation and existing layouts.

2. **Media Search (`lib/screens/media_search_screen.dart`)**:
   - Added `widget.hasSportPack` parameter.
   - Gated the primary filter chip **“Competition”** so it is only displayed when `widget.hasSportPack == true`.
   - Gated search results so that items with `category == 'Competition'` are hidden from non-Sport Pack users.
   - Removed `'competition'` from `_recentSearches` suggestions when `hasSportPack == false`.

3. **Favourites (`lib/screens/media_favourites_screen.dart`)**:
   - Added `widget.hasSportPack` parameter.
   - Added `isSport` and `isCompetition` flags to `FavouriteMediaEntry`.
   - Flagged `fav_1` ("Agility Finals — Örebro") as competition/sport.
   - Gated **Sport** and **Competition** filter tabs in `_tabs` so they are only visible when `widget.hasSportPack == true`.
   - In `_filteredFavourites`, excluded any Sport/Competition-specific content when `widget.hasSportPack == false`.

4. **Sport Pack Overview (`lib/screens/sport_pack_overview_screen.dart`)**:
   - Changed the page title in `_buildTopBar()` from **“Sports”** to **“Sport”** to stay consistent with Sport Pack and terminology used elsewhere.
   - In the **SPORT SUMMARY** grid, changed the metric cell label from **“Sport Skills”** to **“Skills”**.
   - Gated the entire screen area behind `widget.hasSportPack` with a dedicated Sport Pack access-restriction state and an “Upgrade to Sport Pack” button navigating to `SubscriptionDetailsScreen`.
   - Forwarded `widget.hasSportPack` to `MySportsScreen`.

5. **My Sports (`lib/screens/my_sports_screen.dart`)**:
   - In the **SPORT SUMMARY** metric grid, changed **“Total Skills”** to **“Skills”** to maintain unified terminology with the rest of Ulvenik.
   - Added `widget.hasSportPack` gating with the dedicated Sport Pack upgrade view.

6. **Parent Navigation Wiring (`lib/screens/media_library_screen.dart` & `lib/screens/more_page_screen.dart`)**:
   - Added `hasSportPack` parameter to `MediaLibraryScreen` and wired it when opening `MediaCollectionsScreen`, `MediaSearchScreen`, and `MediaFavouritesScreen`.
   - Wired `_hasSportPack` derived from the active subscription plan in `MorePageScreen` into `MediaLibraryScreen` and `SportPackOverviewScreen`.

---

## Batch 36 Implementation Summary

1. **Sport Details (`lib/screens/sport_details_igp_screen.dart`)**:
   - Updated the **NOTES** section so it starts completely empty by default until the user adds their own note (removed hardcoded/pre-written examples).
   - When no note has been added, renders an empty-state container displaying **“No notes added”** with an **“Add Note”** action button.
   - When notes exist, renders the user-entered notes with an **“Edit”** option.
   - Updated the note dialog with placeholder *“Add any additional notes about this sport…”*.

2. **Create Sport (`lib/screens/create_sport_screen.dart`)**:
   - Changed the placeholder text under **NOTES** in `_buildNotesCard()` from:
     *“Add equipment lists, training objectives, rule changes or personal reminders…”*
     to:
     *“Add any additional notes about this sport…”*.

3. **Competitions Overview & Sport Pack (`lib/screens/competitions_overview_screen.dart` & `lib/screens/sport_pack_overview_screen.dart`)**:
   - Replaced all usages of **“Planned”** with **“Upcoming”** across future competition records (including `Club Trial — Autumn 2026`).
   - Standardized the four canonical competition statuses across Ulvenik: **Upcoming | Completed | Withdrawn | Cancelled**.
   - Updated `_pillLabelFor` so that `'entered'`, `'planned'`, and `'upcoming'` are all normalized to **“Upcoming”**.
   - Updated the status filter chips and new trial creation options to consistently use **Upcoming**.

4. **Competition Details (`lib/screens/competition_details_screen.dart`)**:
   - Left the **NOTES** section empty by default until the user adds their own note (removed pre-written Essex trial example notes).
   - When empty, renders an empty-state card displaying **“No notes added”** with an **“Add Note”** button.
   - When notes exist, renders the user's note with an **“Edit Notes”** action.

5. **Record Competition Result (`lib/screens/record_competition_result_screen.dart`)**:
   - Removed the **“OVERALL RESULT”** input field and the automated rating generator (`_ratingForScore` which assigned *“Excellent”*, *“Very Good (SG)”*, etc.).
   - Competition results are now strictly based on the actual information recorded by the user: **Score**, **Placement**, **Qualifications**, and **Awards**.
   - Preserved **Judge’s Comments** and **Personal Notes** as requested.


---

## Batch 37 Implementation Summary

1. **Sport Statistics (`lib/screens/sport_statistics_screen.dart`)**:
   - Under **Skills**, removed **"Active curriculum"** underneath the Skills count.
   - Removed **"Specific drills"** underneath the Exercises count (as curriculum/drills terminology is not used elsewhere in Ulvenik; Skills and Exercises are clear on their own).
   - Removed all secondary occurrences of "curriculum" and "drill" in modal bottom sheets, updating "Open Sport Curriculum & Logs" to "Open Sport & Training Records" and "Curriculum Coverage" to "Skills Coverage".
   - Replaced all "Discipline" terminology ("SPORT DISCIPLINE", "Discipline Scope", "Discipline Split") with unified "Sport" terminology.

2. **Sport / My Sports Overview (`lib/screens/my_sports_screen.dart` & project-wide)**:
   - Changed page title from **"Sports"** / **"My Sports"** to **"Sport"**.
   - Removed **"Disciplines"** terminology throughout the app (including `delete_account_screen.dart`, `help_centre_screen.dart`, `about_ulvenik_screen.dart`, `qualifications_titles_awards_screen.dart`, and `add_competition_screen.dart`), keeping **Sports** as the unified terminology.
   - Removed subjective training advice/quote boxes, "velocity target", "Precision Drills", and changed session action wording to **"RECORD SESSION"**.

3. **Sport Details (IGP) (`lib/screens/sport_details_igp_screen.dart`)**:
   - Added prominent **"Record Training Session"** action button in the hero card (changing from "Start Training Session" / "Log Session").
   - Updated session count and log terminology to **"recorded"** (e.g. "142 recorded").
   - Avoided "Drills", "Phase", and "Verified" terminology in session breakdowns and trial scores, using clean objective structure ("Tracking", "Obedience", "Protection", "Section A", "Section B", "Section C").
   - Added **ACTIVE GOALS** section showing user-defined target goals based strictly on user records and objective data (e.g. Footstep Track Completion 15/20 tracks completed, Protection Hold & Bark Duration: 18s / 45s target), with no subjective automated accuracy ratings.

4. **Competitions Overview (`lib/screens/competitions_overview_screen.dart`)**:
   - Changed **"Season Performance"** to **"Season Summary"**.
   - Changed **"1st Wins"** to **"Wins"** (with gold trophy icon).
   - Added canonical Season Summary KPI card: Total Trials (7), Wins (3), Podiums (5), Avg Score (284.5), Personal Best (294 / 300), and Upcoming (2).
   - Implemented horizontal status filter pills: **All | Upcoming | Completed | Withdrawn | Cancelled**.

5. **Add Competition (`lib/screens/add_competition_screen.dart`)**:
   - Under Status, removed automatic forcing of **"Completed"** when a competition date is in the past.
   - "Upcoming" updates automatically based on future dates, but **Completed**, **Withdrawn**, and **Cancelled** strictly reflect what the user actually records or selects.
   - Standardized status options to **Upcoming | Completed | Withdrawn | Cancelled**.


---

## Batch 38 Implementation Summary

1. **Competition Details (`lib/screens/competition_details_screen.dart`)**:
   - In the Statistics / Results section, removed subjective overall performance ratings (e.g. automated star ratings or rating assessments). Official scores, placements, qualification status, and factual statistics remain.
   - Replaced all `Phase` references (`Phase A`, `Phase B`, `Phase C`) with objective `Section` terminology (`Section A`, `Section B`, `Section C`).
   - Notes section only displays content actually entered by the user (initialized to empty string by default). When empty, displays **"No notes added"** with an **"Add Note"** action button.

2. **Competition Results & Record Competition Result (`lib/screens/competition_results_screen.dart` & `lib/screens/record_competition_result_screen.dart`)**:
   - Ensured **Personal Best** is either selected by the user or calculated only where determined objectively from directly comparable recorded results, rather than subjective app assessments. Added explicit guidance: *"Selected by user or calculated from objective recorded scores."*
   - Emptied default pre-filled notes and section notes.
   - In both screens, **Judge Feedback / Comments** and **Notes** are empty by default (`""`), ensuring they only contain information entered directly by the user/judge.

3. **Achievements & Titles (`lib/screens/achievements_titles_screen.dart`)**:
   - Ensured **Personal Bests and Milestones** are based strictly on information entered by the user or objectively determined from factual competition results.
   - Replaced legacy Phase labels (`Phase C Protection PB` -> `Protection PB`, `Phase A Tracking PB` -> `Tracking PB`).
   - Standardized milestone terminology (`250+ Logged Sport Sessions` -> `250 Recorded Training Sessions`, `1st Place V-Rated National Finish` -> `1st Place National Finish`).
   - Added user-facing explanatory guidance in custom achievement dialogs clarifying that personal bests and milestones reflect user entries or objective scores from recorded competition results.

4. **Trainer Dashboard (`lib/screens/trainer_dashboard_screen.dart`)**:
   - Under Quick Actions, updated action label from **"Start Lesson"** / **"Start Lesson Session"** to **"Record Session"** to keep session terminology consistent across Ulvenik.
   - In the **Business Snapshot** KPI grid, changed **"47 Recorded"** to **"47 Sessions"** for immediate clarity.

5. **Trainer Profile (`lib/screens/trainer_profile_screen.dart`)**:
   - Ensured **About**, **Expertise**, **Qualifications**, **Services**, and **Contact** details only display information actually entered by the trainer, rather than pre-written/example profile content.
   - Initialized default fields to clean empty states (`_aboutBio = ''`, `_contactEmail = ''`, `_contactWebsite = ''`, `_contactInstagram = ''`, `_expertiseTags = []`, `_qualifications = []`, `_services = []`).
   - Added intuitive empty states with action buttons (**"Add Bio"**, **"Add Expertise"**, **"Add Qualification"**, **"Add Service"**, **"Add Contact Details"**) when no content has been entered yet, allowing trainers to seamlessly add and edit their own business details.


---

## Batch 39 Implementation Summary

1. **Clients Page (`lib/screens/clients_page_screen.dart`)**:
   - Added `'UPCOMING SESSIONS'` to `_allFilterChips` and updated filter logic to match clients with upcoming active sessions.
   - Updated client cards to use **"Next Session"** and **"Upcoming Sessions"** consistently throughout (e.g. `Next Session · Thursday 10:00`, `No upcoming session`), replacing any legacy "Lesson" terminology.

2. **Client Details / Profile (`lib/screens/client_profile_screen.dart`)**:
   - In the client hero banner card, updated next session badge to **"Next Session"** (e.g. `Next Session · Thursday · 10:00`).
   - In the KPI grid, updated metrics to:
     - `2 LINKED DOGS` (opens `ClientDogsScreen`)
     - `3 ACTIVE GOALS` (opens goal creation/list)
     - `2 HOMEWORK DUE` (opens homework checklist)
     - `8 SESSIONS TOTAL` (changed from *8 Lessons Total*, opens `SessionRecordsScreen`)
   - In Quick Actions, updated action buttons to:
     - **"Record Session"** (changed from *Record Lesson*)
     - **"Assign HW"**
     - **"Create Goal"**
     - **"Add Note"**
   - In the **Permissions** section, retained Health Records as restricted by default (`Restricted`) unless shared by the client, and displayed explicit access labels for all categories (`Read / Write`, `View Only`, `View & Upload`, `Restricted`).
   - In the **Trainer Notes** section, removed pre-filled hardcoded sample notes. When empty, displays *"No trainer notes added yet"* with an *"Add"* button. When notes are added, preserves private lock indicators and explicit client privacy guarantees (*"Notes are private and never visible to the client."*).

3. **Emma's Dogs / Client Dogs (`lib/screens/client_dogs_screen.dart`)**:
   - Implemented dedicated Client Dogs workspace view (`Emma's Dogs` / `${client.firstName}'s Dogs`).
   - Removed predefined classification badges (**"Primary Athlete"** and **"Agility Focus"**) from dog images/cards, allowing client dogs to be presented cleanly without artificial categorization.
   - Displays dog identity, age, breed/sport, streak and activity metrics (`12 Day Streak • Yesterday • 2 Goals`), action button to open dog details (`SHARED WITH OWNER >`), and active homework alerts.

4. **Session Records (`lib/screens/session_records_screen.dart`)**:
   - Implemented dedicated Session Records screen (formerly *Lesson Records*).
   - Changed page title from **"Lesson Records"** to **"Session Records"**.
   - In header summary, changed **"12 Lessons Total"** to **"12 Sessions Total"**.
   - Displays session history grouped by month with objective metadata: date/time, category (`ONE-TO-ONE`, `BEHAVIOUR CONSULTATION`), activity title, linked dog tags, location, duration, and homework assignment status.

5. **Trainer Reports (`lib/screens/trainer_reports_screen.dart`)**:
   - Aligned Reports screen with design specification: top app bar with filter action, summary KPI strip (`7 Total Reports`, `4 Shared`, `1 Draft`), and tabs (`All Reports`, `Shared`, `Drafts`, `Archived`).
   - Replaced all references to "Lessons" with "Sessions" across all report cards:
     - `8 Lessons` $\rightarrow$ **`8 Sessions`** (*Murphy — Progress*)
     - `3 Lessons` $\rightarrow$ **`3 Sessions`** (*Bella — Behaviour Consultation*)
     - `24 Lessons` $\rightarrow$ **`24 Sessions`** (*Murphy — 3 Month*)
   - Also updated trainer dashboard metrics (`trainer_dashboard_screen.dart`) to use unified session terminology (`SESSIONS TODAY`, `Sessions Week`, `Weekly Session Volume`, `Record Client Session`).


---

## Batch 40 Implementation Summary

1. **Trainer Business Analytics (`lib/screens/trainer_analytics_screen.dart` & `lib/screens/trainer_dashboard_screen.dart`)**:
   - Implemented the dedicated Trainer Business Analytics screen (`TrainerAnalyticsScreen`) with period filters (`THIS WEEK`, `THIS MONTH`, `LAST 90 DAYS`), 6-metric overview grid, weekly session bar chart, homework completion card, goals summary card, and 30-day client engagement chart, wired from `TrainerDashboardScreen`.
   - Replaced all remaining "Lesson" terminology with "Session":
     - `Lessons This Week` → **`SESSIONS THIS WEEK`**
     - `Lesson Activity` → **`SESSION ACTIVITY`**
     - `32 Lessons` → **`32 Sessions`**
     - `Average 1.6 lessons/day` → **`Average 1.6 sessions/day`**
   - Also updated `TrainerDashboardScreen` daily chart tooltip (`lesson`/`lessons` → `session`/`sessions`).

2. **Trainer Notifications (`lib/screens/trainer_notifications_screen.dart` & `lib/screens/trainer_dashboard_screen.dart`)**:
   - Restored and wired `TrainerNotificationsScreen` (`All`, `Action Required`, `Read` tabs, `Mark All Read` action) directly from the Trainer Dashboard notifications icon.
   - Updated notification title from **"Lesson reminder"** to **"Session reminder"**.

3. **Dog / Operational Performance Analytics (`lib/screens/trainer_workspace_settings_screen.dart` & `lib/screens/client_progress_screen.dart`)**:
   - Replaced subjective **"Success Rate"** KPI card with the objective statistic **"Goals Completed"** (`goalsCompleted` count and active goals subtitle), ensuring Ulvenik never judges whether a dog's training has been successful.
   - Removed the **"87% / Keep it up! Top 15% active dog"** comparison ring and ranking text underneath **Best Streak** (and equivalent `Top 15%` rankings in `ClientProgressScreen`), keeping only the actual streak (`12 days`) with objective session count underneath (`15 sessions during this streak`).
   - Gated **Competition** in **Session Breakdown** (`_shouldShowCompetition`) so Competition categories and statistics only appear when the trainer has access to the **Sport Pack** (`hasSportPack`) and relevant Competition activity has been recorded (`hasRecordedCompetitionActivity` and `compRatio > 0`).

4. **Clients Directory & Client Archiving (`lib/screens/clients_page_screen.dart` & `lib/screens/client_profile_screen.dart`)**:
   - Updated the empty-state copy on `ClientsPageScreen` from *"Build your Trainer Pack by adding your first client and mapping their field progress."* to:
     **"Add your first client to start managing their dogs, sessions, goals and progress."**
   - Added an explicit confirmation dialog (`AlertDialog` — *"Archive {Client Name}?"*) before archiving a client from both the swipe `ARCHIVE` action and the `•••` action menus on `ClientsPageScreen` and `ClientProfileScreen`.

5. **Client Dog Profile Health Permissions (`lib/screens/client_dog_profile_screen.dart`, `lib/screens/trainer_dashboard_screen.dart`, `lib/screens/client_profile_screen.dart`, & `lib/screens/client_permissions_screen.dart`)**:
   - Added reactive `canViewHealthRecords` state (default `false` / restricted) to `TrainerClient` in `TrainerPackStore`, synced across `ClientProfileScreen` (`Health Records` toggle) and `ClientPermissionsScreen` (`View Health Records` permission).
   - Enforced owner health permissions across `ClientDogProfileScreen`:
     - When `canViewHealthRecords` is `false`, `Last Health Update` in Overview, the `Health` action tile and modal sheet, and the `Health Summary` card are completely hidden, and `_accessPermissionSummary` reflects that health records remain restricted by the dog owner.
     - When `canViewHealthRecords` is `true`, displays the owner-shared `HEALTH SUMMARY` (`SHARED BY <OWNER>`) and enables shared health details.


---

## Batch 41 — Add Client, Edit Client, Homework & Homework Details

1. **Add Client (`lib/screens/add_client_screen.dart`)**:
   - Updated the Client Access & Permissions toggle label from **"View Training Records"** to **"View Training Sessions"** (`_viewTrainingSessions`).
   - Removed the **`Company (optional)`** input field from Basic Information (`_companyCtrl` removed).
   - Synced example contact phone number hints (`_countryPhoneExamples`, `_mobileHint`, `_altPhoneHint`) and fallback phone formatting dynamically with the selected country (`_selectedCountry`, e.g. `+47 912 34 567` / `+47 480 12 345` for Norway, `+44 7700 900418` / `+44 7700 900512` for United Kingdom).

2. **Edit Client & Individual Permissions (`lib/screens/edit_client_screen.dart`, `lib/screens/client_permissions_screen.dart`, & `lib/screens/client_profile_screen.dart`)**:
   - Updated **"View Training"** under **Individual Permissions** (`EditClientScreen` and `ClientPermissionsScreen`) to **"View Training Sessions"**.
   - Removed the **`Company (optional)`** input field from `EditClientScreen` to match `AddClientScreen`.
   - Synced example contact phone numbers and addresses with the client's country (`_countryExamples`, `_inferCountry`, `_syncContactsWithSelectedCountry`), using `+47` phone codes for Norway (`Oslo`) and `+44` phone codes for UK clients (`ClientProfileScreen` & `TrainerPackStore`), and persisting edits back to `TrainerPackStore`.

3. **Homework Page (`lib/screens/client_homework_screen.dart`)**:
   - **Objective Completion Progress %**: Backed `_HomeworkAssignment.progress` strictly by trainer/client task completion counts (`completedTasks / totalTasks`), never assessing dog performance quality.
   - **Automatic `Overdue` Status**: Computed status via `_HomeworkAssignment.effectiveStatus(todayDateOnly)` so incomplete homework automatically transitions to `OVERDUE` once its `dueDate` passes, while keeping `Not Started`, `In Progress`, `Overdue`, and `Completed` statuses and filters (`Active`, `Completed`, `Overdue`, `High Priority`) as designed.
   - **Trainer-Selected Priority**: Kept `High Priority` strictly trainer-selected (`isHighPriority`), synced between the Homework list, Assign/Edit Homework sheet, and Homework Details screen.
   - **Archive Confirmation**: Added a confirmation `AlertDialog` (*"Archive Homework?"*) before archiving any homework item from the swipe `ARCHIVE` action.

4. **Homework Details Page (`lib/screens/homework_details_screen.dart`)**:
   - **Objective Overall Completion %**: Calculated `_displayProgress` strictly from completed homework reps (`_completedReps / _totalReps`, e.g. `8 / 12` → `67%`) and synced changes back to `ClientHomeworkScreen`.
   - **Trainer Feedback & Client Notes**: Removed auto-generated fallback strings on empty submissions so Trainer Feedback only displays trainer-entered feedback and Client Notes only display client/trainer-entered notes.
   - **Linked Skills Subtitle**: Updated the subtitle under `Decoy Focus & Steady Drive` from *"3 sessions completed"* to objective homework completion wording (`"$_completedReps of $_totalReps homework reps completed"`), removing automated engagement percentage assessments.


---

## Batch 42 — Client Progress Analytics, Shared Records, Client Permissions, Trainer Reports & Rewards Management

1. **Client/Dog Progress Analytics (`lib/screens/client_progress_screen.dart`)**
   - **Objective Statistic (`Goals Completed`)**: Replaced `successRate` / `successDelta` fields with objective `goalsCompleted` / `goalsSubtitle` across all tabs (`Overview`, `Training`, `S&C`, `Skills`, `Health`) and removed subjective `sessionsDelta` (`"100% gait cleared"` → `"+1 vs last month"`).
   - **Training Frequency**: Removed `"Consistent pace"` (and all other subjective status labels underneath `Sessions per week`), keeping only the objective sessions-per-week figure (`4.5`).
   - **Your Consistency**: Removed `"Top 15%"` and `"You're in the top 15% of active working dog teams this month"` (along with all ranking/comparison copy across tabs). Retained the 4×7 consistency heatmap based strictly on the user's own recorded activity (`activeDays / 28 days` and objective session counts per day), alongside `Top Skills` (`By time spent`), `Total Training Time`, `Sessions`, and the `Training Time` graph.

2. **Shared Records & Sharing Permissions (`lib/screens/shared_records_screen.dart`, `lib/screens/client_profile_screen.dart`, `lib/screens/client_dog_profile_screen.dart`)**
   - Updated `"Training Records"` to `"Training Sessions"` in `ClientProfileScreen` sharing permissions (`_permissions` and `_permissionAccessLabel`), updated read-only access wording in `ClientDogProfileScreen`, and ensured `SharedRecordsScreen` matches `"Training Sessions"` / `"TRAINING SESSION"` consistently while keeping search/filters, sharing statuses, sharing history, and `Generate Shared Report` as designed.
   - Wired navigation from `ClientProfileScreen` to `SharedRecordsScreen`, `ClientPermissionsScreen`, `ClientProgressScreen`, and `ClientHomeworkScreen`.

3. **Client Permissions (`lib/screens/client_permissions_screen.dart`)**
   - Verified `"View Training Sessions"` under `Training` and updated `"View Sessions"` under `Strength & Conditioning` to `"View S&C Sessions"` (`key: 'sc_view'`), keeping all granular permissions and the 4 permission presets (`View Only`, `Standard Trainer`, `Full Access`, `Custom`) as designed.

4. **Trainer Reports (`lib/screens/trainer_reports_screen.dart`, `lib/screens/more_page_screen.dart`)**
   - Aligned `TrainerReportsScreen` with the Trainer Reports design (`Trainer Reports` header, search bar, filter sheet, dog badges, date ranges, `SHARED` / `NOT SHARED` pills, file sizes & `PDF` format, swipe-left `COPY` and `DELETE` actions, and `+` report generator).
   - **Sport Pack / Complete Gating**: Gated `Competition Progress Report` cards, filter chips, and creation options behind `hasSportPack && hasCompetitionRecords`, ensuring Trainer Pack users without Sport Pack never see Competition report options.
   - **Delete Confirmation**: Added a confirmation `AlertDialog` (`"Delete Report?"`) before permanently deleting any report from the swipe `DELETE` action or report details sheet.

5. **Rewards Management, Add Reward, Edit Reward & Custom Reward Types (`lib/screens/rewards_management_screen.dart`, `lib/screens/add_reward_screen.dart`, `lib/screens/edit_reward_screen.dart`, `lib/screens/manage_reward_types_screen.dart`)**
   - **Customisable Reward Types**: Seeded optional starter categories (`Food`, `Toy`, `Praise`, `Play`, `Other`) without system locks so every category can be renamed, reordered, archived, or deleted, and wired `Manage Types` + an inline `+ New Type` filter chip on `RewardsManagementScreen` alongside inline `+ New Type` creation in `AddRewardSheet` and `EditRewardSheet`. Updated screen title to `Rewards Management`.
   - **User-Entered Descriptions Only**: Removed automatic `valueTier` (`High` / `Medium` / `Low`) from `RewardItemModel` so Ulvenik never determines reward value or appropriate use, and updated optional `DESCRIPTION` placeholders in `AddRewardSheet` and `EditRewardSheet` to neutral user-note wording (`"Add any personal notes about this reward (optional)..."`).


---

## Batch 43 — Add Reward Placeholder & Delete Reward Confirmation

1. **Add Reward (`lib/screens/add_reward_screen.dart`)**
   - Updated the `REWARD NAME` input so it starts completely empty with subtle placeholder text `"e.g. Freeze-Dried Liver"` (and a muted unfocused underline border) rather than appearing pre-populated.

2. **Edit Reward & Rewards Management Delete Confirmation (`lib/screens/edit_reward_screen.dart`, `lib/screens/rewards_management_screen.dart`)**
   - Confirmed and refined the confirmation `AlertDialog` (`"Delete Reward?"` — `"Are you sure you want to permanently delete \"...\"? This action cannot be undone."` with `Cancel` and `Delete Reward` actions) on both `EditRewardSheet._handleDeleteReward()` and `RewardsManagementScreen._confirmDeleteReward()`.



---

## Batch 44 — Automatic Training Session Skill & Exercise Calculation, Repetitions & Demonstration Records

1. **Automatic Distinct Skill, Distinct Exercise, Duration & Skill Tag Calculation (`lib/screens/training_screen.dart`)**
   - Replaced manually specified `skillCount`, `exerciseCount`, `duration`, and `tags` fields on `TrainingSession` with structured `RecordedSkillEntry` and `RecordedExerciseEntry` models backed by `TrainingSessionStore`.
   - **`skillCount` & `formattedSkillCount`**: Automatically counts each **distinct skill** recorded in the session once (case- and whitespace-normalized via `normalizeTrainingKey`), even when multiple exercises are recorded under that skill (`1 Skill` / `X Skills`).
   - **`exerciseCount` & `formattedExerciseCount`**: Automatically counts each **distinct exercise** recorded in the session once (`1 Exercise` / `X Exercises`), replacing the abbreviated `'X Ex'` suffix.
   - **Separate Repetitions (`RecordedExerciseEntry.repetitions` & `totalRepetitions`)**: Exercise repetitions are stored and displayed separately (`X reps`) and never increase the session's `exerciseCount`.
   - **Recorded Duration (`durationMinutes` & `duration`)**: Automatically reflects the user's recorded duration (`recordedDurationMinutes` or calculated from `startTime` / `finishTime`).
   - **Matching Skill Tags (`skillTags`)**: Session card skill tags derive directly from the distinct skills actually recorded in that session in recorded order.

2. **Live Session Recording, Editing & Custom Skills/Exercises (`lib/screens/training_session_screen.dart`, `lib/screens/add_skill_screen.dart`, `lib/screens/add_exercise_screen.dart`, `lib/screens/skills_list_screen.dart`)**
   - Bound `TrainingSessionScreen` directly to the session's `recordedSkills`, `recordedDurationMinutes`, `startTime` / `finishTime`, and `TrainingSessionStore`, with a live header summary strip (`duration · X Skills · Y Exercises`) that updates automatically whenever skills, exercises, repetitions, or duration change.
   - Added full `SKILLS & EXERCISES` management with separate repetition steppers (`[-]` `X reps` `[+]`), inline custom skill creation (`_showAddSkillSheet`), inline custom exercise creation (`_showAddExerciseSheet`), user-editable `Duration`, and live persistence back to `TrainingScreen` on `Save Changes`, `Complete Session`, `Save Draft`, and `Delete Session`.
   - Wired `AddSkillScreen`, `AddExerciseScreen`, and `SkillsListScreen` to `TrainingSessionStore` (`registerCustomSkill` / `registerCustomExercise`) so custom skills and custom exercises work seamlessly with automatic session statistics.

3. **Slide 2 Demonstration Records & Timeline Alignment (`lib/screens/training_screen.dart`, `lib/screens/timeline_dashboard_screen.dart`, `lib/screens/timeline_event_details_screen.dart`)**
   - Seeded genuine underlying `recordedSkills` and `RecordedExerciseEntry` data for all 5 Slide 2 demonstration records so their displayed figures and skill tags are calculated automatically from real recorded data:
     - **Cooper — `Emergency Down Training`**: `8 min · 2 Skills · 3 Exercises` (`Emergency Down`: `Down on verbal cue`, `Down at a distance`; `Distance Control`: `Maintaining the down while the handler moves away`)
     - **Jax — `Focused Heelwork`**: `9 min · 2 Skills · 4 Exercises` (`Focused Heelwork`, `Pace Transitions`)
     - **Lady — `Down Stay Training`**: `7 min · 2 Skills · 3 Exercises` (`Down Stay`, `Distraction Control`)
     - **Lady — `Retrieve Training`**: `6 min · 2 Skills · 3 Exercises` (`Retrieve`, `Hold & Delivery`)
     - **Jax — `Position Changes`**: `8 min · 2 Skills · 3 Exercises` (`Position Changes`, `Distance Control`)
   - Aligned the Timeline training session (`Obedience — Heel Work & Recall`) across `timeline_dashboard_screen.dart` and `timeline_event_details_screen.dart` (`45 min · 3 Skills · 3 Exercises`, `Heelwork, Recall, Down Stay`, with `5 reps` recorded separately on `Recall with Distraction`).
