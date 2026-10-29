# Ulvenik — Master Screen Testing & Verification Guide
## Aligned to Frontend Development Handover Batches

This testing guide mirrors the exact **Batch 1 through Batch 11 + New Screens** structure defined in `Ulvenik_Frontend_Handover.md`. It provides step-by-step visual click-paths for every screen, empty/populated state toggles, interactive testing flows, animated telemetry chart verifications, and modal bottom sheet validations with **zero code or class names**.

---

## CANONICAL NAVIGATION RULES

### Persistent 5-Tab Bottom Navigation Bar
- **Home**: Main canine overview, active health alerts, next training session, activity bento.
- **Dogs**: Canine profiles, skills curriculum, goal velocity tracker, strength & conditioning, statistics.
- **Training**: Active session recording, drill timer, field telemetry.
- **Timeline**: Chronological canine timeline, filters, calendar, search, activity map, memories, compare, smart collections, widgets gallery.
- **More**: Workspace identity, settings, media library, billing, trainer workspace, sport pack.

### Active Tab Enforcement
- **Home tab**: Home Dashboard (Empty & Populated).
- **Dogs tab**: Dogs, Dog Profile and all sub-branches (Training, Health, S&C, Timeline, Goals, Skills, Statistics, Rewards, Sport Pack).
- **Training tab**: Live training session recording and drill counter.
- **Timeline tab**: Global Timeline and all Timeline sub-features.
- **More tab**: More, Settings, Profile, Account, Media, Notifications, Trainer Pack.

### Screens with No Bottom Navigation Bar (Full Modals)
- Global Search
- Change Photo (Bottom Sheet)
- Image Editor (Crop Guide)
- Video Viewer
- Photo Viewer
- Add Reward (Bottom Sheet)
- Edit Reward (Bottom Sheet)
- All Confirmation and Discard bottom sheets throughout the app

---

## BATCH 1 — AUTH & ONBOARDING

### 1.1 Splash Screen
- **Action**: BUILD
- **How to Access**: Launch the application cold.
- **What to Verify**:
  - Obsidian dark background with centered Ulvenik crest logo in mint green.
  - Subtle breathing glow animation.
  - Automatic transition to Onboarding Screen 1 after 2 seconds.

### 1.2 Onboarding Screens (1, 2, 3)
- **Action**: BUILD
- **How to Access**: Automatically follows Splash Screen on first launch, or tap **More** → **Help Centre** → **Replay Onboarding Tour**.
- **What to Verify**:
  - `Screen 1 (Canine Performance Tracking)`: High-contrast athletic dog imagery, headline, value proposition copy, and 3-segment progress indicator with segment 1 highlighted.
  - Swipe left or tap `Next` → `Screen 2 (Conditioning & Health Ledgers)`: Segment 2 highlighted.
  - Swipe left or tap `Next` → `Screen 3 (Sport Titles & Trainer Workspace)`: Segment 3 highlighted.
  - Actions: `Skip` (top right, jumps directly to Welcome) and `Get Started` on Screen 3 (opens Create Account).

### 1.3 Login & Create Account
- **Action**: BUILD
- **How to Access Login**: From Onboarding Screen 3 tap `Sign In`, or from Welcome tap `I already have an account`.
- **What to Verify on Login**:
  - Flat bottom-bordered inputs: Email address and Password.
  - Eye icon toggle to reveal/hide password characters.
  - Links: `Forgot Password?` and `Create New Account`.
  - Primary button: `Sign In` (Forest Green).
  - Social login alternatives: Apple and Google sign-in buttons.
- **How to Access Create Account**: From Login tap `Create New Account`, or from Onboarding tap `Get Started`.
- **What to Verify on Create Account**:
  - Flat inputs: Full Name, Email Address, Password, Confirm Password.
  - Password strength meter (Length, Number, Special Character indicators).
  - Terms and Privacy checkbox with clickable policy links.
  - Primary button: `Create Account`.

### 1.4 Forgot Password & Set New Password
- **Action**: BUILD
- **How to Access Forgot Password**: From Login tap `Forgot Password?`.
- **What to Verify**:
  - Headline: "Reset Password", instructions copy, and Email input.
  - Primary button: `Send Reset Link` → Opens Confirmation Screen.
- **How to Access Set New Password**: Tap confirmation link or simulated reset token.
- **What to Verify**:
  - Flat inputs for `New Password` and `Confirm New Password`.
  - Primary button: `Update Password` → Navigates to Password Updated.

### 1.5 Confirmation Screen & Email Verified
- **Action**: BUILD
- **How to Access**: Displayed immediately after submitting Create Account or Forgot Password.
- **What to Verify**:
  - Envelope illustration with pulsing green checkmark.
  - Instructions: "Check your inbox for verification email".
  - Actions: `Open Mail App`, `Resend Email (60s timer)`, and `Proceed to App`.
  - Email Verified screen: Green success banner, "Email successfully confirmed", and `Continue` CTA.

### 1.6 Password Updated
- **Action**: BUILD
- **How to Access**: Displayed upon successful password update.
- **What to Verify**:
  - Shield checkmark icon in mint green.
  - Headline: "Password Updated Successfully".
  - Primary button: `Back to Login`.

### 1.7 Welcome
- **Action**: BUILD
- **How to Access**: First-time landing screen after completing registration and email confirmation.
- **What to Verify**:
  - Greeting text rotating from curated greeting bank: "Welcome to Ulvenik", "Elite Canine Conditioning Starts Here".
  - Quick setup tiles: `Set Up First Dog`, `Join Trainer Workspace`, `Explore Sample Profile`.
  - Primary button: `Enter Workspace`.

### 1.8 2FA Setup (Enabled & Disabled States)
- **Action**: BUILD (with Enabled/Disabled states)
- **How to Access**: Tap **More** → **Settings** → **Account Security** → **Two-Factor Authentication**.
- **What to Verify in Disabled State**:
  - Status pill: `Disabled` (Grey), shield icon, description of authenticator app protection.
  - Action button: `Enable Two-Factor Authentication` → Displays QR code and 16-character backup key.
- **What to Verify in Enabled State**:
  - Status pill: `Enabled • Active` (Mint Green).
  - 6-digit confirmation code verification box.
  - Action buttons: `View Backup Codes` and `Disable 2FA` (prompts security password confirmation).

---

## BATCH 2 — CORE APP ENTRY

### 2.1 Homepage (Empty & Populated States)
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap the 1st tab labeled **Home** in bottom navigation bar.
- **What to Verify in Populated State**:
  - Rotating decorative greeting banner (curated greeting bank).
  - Active dog card: Avatar, name (`Murphy`), breed (`Working Malinois`), age (`3 Years`), and current working title.
  - Health status indicator pill (`Optimal • Checked 2d ago`).
  - Next scheduled training session card with countdown and venue location.
  - 2x2 Activity Bento: Sessions This Week, Active Streak, Goal Completion Rate, Rest Days Logged.
  - Quick action floating bar: `Record Session`, `Log Weight`, `Add Health Note`.
- **How to Test Empty State**:
  - Tap dog selector in top bar → Select `New Canine (Empty State)` or tap the State Toggle Eye icon.
  - Empty state displays centered radar pulse card, rotating welcome prompt, and `Add Your First Dog` button.

### 2.2 My Dogs (Empty & Populated States)
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap the 2nd tab labeled **Dogs** in bottom navigation bar.
- **What to Verify in Populated State**:
  - Canine avatar carousel displaying all registered dogs (`Murphy`, `Freya`, `Fenris`).
  - Active canine card with large photo, working titles (`IGP 3`, `BH/VT`), weight, and microchip number.
  - Sub-navigation tabs: `Overview`, `Training`, `Health`, `S&C`, `Goals`, `Skills`, `Statistics`, `Rewards`.
  - Floating action button (`+`) to register a new canine.
- **How to Test Empty State**:
  - Select empty workspace profile or tap State Toggle Eye icon.
  - Displays empty kennel graphic, "No Dogs in Workspace", and `Register Canine Profile` button.

### 2.3 Dogs All Workspaces
- **Action**: BUILD
- **How to Access**: From **Dogs** tab → Tap the workspace switch icon in top left.
- **What to Verify**:
  - Multi-workspace list: Personal Kennel, Competition Club, Trainer Workspace.
  - Dogs assigned to each workspace with handler badges.
  - Action to `Create New Workspace` or `Switch Active Kennel`.

---

## BATCH 3 — DOG PROFILE

### 3.1 Dog Profile Overview (New Dog & Populated States)
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap **Dogs** tab → Select **Overview** sub-tab.
- **What to Verify in Populated State**:
  - Rotating decorative hero background behind canine silhouette.
  - Athletic summary bento: Weekly Workload, Current Streak (`12 Days 🔥`), Active Goals (`3`), Health Status.
  - Recent timeline highlights and active conditioning blocks.
- **How to Test New Dog (Empty State)**:
  - Tap Eye icon in top bar.
  - Displays empty onboarding checklist: `Add Pedigree`, `Set First Goal`, `Log Baseline Weight`, `Record Benchmark Drill`.

### 3.2 Training Page (Empty & Populated States)
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap **Dogs** tab → Select **Training** sub-tab.
- **What to Verify in Populated State**:
  - Active curriculum progress bar.
  - Recent training sessions list with drill tags, durations, and success percentages.
  - Action buttons: `Start Training Session` and `Manage Skills Curriculum`.
- **How to Test Empty State**:
  - Displays "No Training Recorded Yet" with `Record First Session` CTA.

### 3.3 Training Session Recording (Draft & Completed States)
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap the 3rd tab labeled **Training** in bottom navigation bar (or tap `Start Training Session`).
- **What to Verify in Draft State**:
  - Live drill stopwatch timer with `Pause`, `Resume`, `Lap` controls.
  - Active skill selector: `Recall under distraction`.
  - Repetition counter and success/fault tally buttons (`+ Rep`, `Fault`).
  - Heart rate / field telemetry input fields.
  - Action: `Save Draft` or `Discard Session` (triggers discard confirmation bottom sheet modal).
- **What to Verify in Completed State**:
  - Summary recap card: Total Time, Reps Logged, Success Rate (`94%`), Handler Notes.
  - Media attachments row (video clip / photo).
  - Primary button: `Complete & Sync to Timeline`.

### 3.4 Skills List & Skill Details
- **Action**: BUILD
- **How to Access Skills List**: Tap **Dogs** tab → Select **Skills** sub-tab.
- **What to Verify in Populated State**:
  - Canine skills curriculum grouped by discipline: Obedience, Tracking, Protection, Agility.
  - Skill cards showing mastery percentage (`Recall: 92%`, `Heelwork: 85%`, `Send-Away: 64%`).
  - Search bar to filter skills by name or keyword.
  - Floating action button (`+`) to add a skill.
- **How to Test Skill Details**:
  - Tap `Recall` card.
  - Detailed breakdown of exercises, session history, handler criteria, and video demonstrations.
  - Actions: `Add Exercise`, `Edit Skill`, `Archive Skill`.

### 3.5 Add Skill & Add Exercise Forms
- **Action**: BUILD
- **How to Access Add Skill**: From Skills List tap `+` button in bottom right.
- **What to Verify**:
  - Flat bottom-bordered inputs: Skill Name, Discipline Dropdown, Mastery Criteria description.
  - Target frequency selector (Daily, 3x Weekly, Weekly).
  - Action: `Save Skill`.
- **How to Access Add Exercise**: From Skill Details tap `+ Add Exercise`.
- **What to Verify**:
  - Flat inputs: Exercise Title, Difficulty Level (Foundation, Intermediate, Proofing), Distraction Level (Low, Medium, High).
  - Action: `Save Exercise`.

### 3.6 Exercise Details & Edit Exercise
- **Action**: BUILD
- **How to Access**: From Skill Details tap an individual exercise (e.g. `Emergency Recall 50m`).
- **What to Verify**:
  - Step-by-step handler instructions, reward association, criteria for success.
  - Tap `Edit` in top right to open technical edit form with pre-filled values.
  - Discard/delete actions trigger confirmation modals.

### 3.7 Goals List, Create Goal & Goal Details
- **Action**: BUILD
- **How to Access Goals List**: Tap **Dogs** tab → Select **Goals** sub-tab.
- **What to Verify in Populated State**:
  - Active canine goals with percentage progress bars (`Complete 20 Recall Sessions • 14/20 (70%)`).
  - Target date countdown (`12 Days Remaining`).
  - Floating action button (`+`) to create a goal.
- **How to Test Create Goal**:
  - Tap `+` button → Enter Goal Title, Linked Skill, Target Metric (Reps, Sessions, Competition Date), and Target Deadline.
  - Tap `Create Goal`.
- **How to Test Goal Details**:
  - Tap on `Complete 20 Recall Sessions` card.
  - Velocity graph showing weekly session cadence, days elapsed, and remaining milestones.
  - Tapping `Archive Goal` or `Delete Goal` triggers confirmation alert modal.

### 3.8 Statistics & Dog Timeline Sub-Tabs
- **Action**: BUILD
- **How to Access**: Tap **Dogs** tab → Select **Statistics** sub-tab or **Timeline** sub-tab.
- **What to Verify in Statistics**:
  - Timeframe filter pills (`Last 30 Days`, `This Year`, `All Time`).
  - Workload volume, skill progression curves, and consistency radar.
- **What to Verify in Dog Timeline**:
  - Filtered timeline feed containing only events belonging to the currently selected dog.

---

## BATCH 4 — HEALTH

### 4.1 Health Dashboard & Health Overview
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap **Dogs** tab → Select **Health** sub-tab.
- **What to Verify in Populated State**:
  - Health status indicator (`Good Health • All Vaccinations Current`).
  - Quick stat cards: Current Weight (`32.4 kg`), Next Vet Visit (`14 Nov 2026`), Medication Count (`1 Active`).
  - Quick action row: `Log Weight`, `Add Medical Record`, `Add Reminder`, `View Timeline`.
  - Health modules grid: Medications, Vaccinations, Vet Visits, Injuries, Physio & Hydro, Dental, Surgery.
- **How to Test Empty State**:
  - Tap State Toggle Eye icon → Displays medical cross graphic, "No Health Data Logged", and `Log First Health Check` button.

### 4.2 Health Records & Add Health Record
- **Action**: BUILD
- **How to Access Health Records**: From Health Dashboard tap `Health Records`.
- **What to Verify**:
  - Grouped chronological list of veterinary and medical entries.
  - Type badges: Check-up (Blue), Injury (Red), Medication (Green), Vaccine (Orange).
  - Floating action button (`+`) to add a record.
- **How to Test Add Health Record**:
  - Tap `+` button.
  - Form switches between `General Record` and `Medication Record` variants.
  - Flat inputs: Record Title, Date Picker, Clinic Name, Attending Vet, Diagnosis, Treatment Plan, Cost.
  - Attachment tile: Upload prescription or clinic receipt.
  - Primary button: `Save Health Record`.

### 4.3 Health Record Details (Injury & Medication Variants)
- **Action**: BUILD (One screen, two state variants)
- **How to Access**: From Health Records list tap on `Right Carpus Soft Tissue Strain` (Injury variant) or `Metacam Anti-inflammatory` (Medication variant).
- **What to Verify in Injury Variant**:
  - Red injury badge, anatomical injury location diagram, diagnosis notes, recovery protocol, restricted activities list.
- **What to Verify in Medication Variant**:
  - Dosage (`1.5 mg/day`), administration schedule, remaining pills counter, prescribing vet.

### 4.4 Weight Tracker
- **Action**: BUILD (Empty & Populated)
- **How to Access**: From Health Dashboard tap `Weight Tracker`.
- **What to Verify in Populated State**:
  - Latest weight display (`32.4 kg`) with delta comparison (`+0.2 kg vs last month`).
  - Animated weight history chart showing monthly weigh-ins against ideal breed target corridor.
  - Historical weigh-in log with dates and body condition score (BCS) ratings.
  - Floating action button (`+`) to log a weigh-in.
- **How to Test Empty State**:
  - Displays empty scale illustration and `Log First Weight Entry` CTA.

### 4.5 Medication Manager & Vaccination Manager
- **Action**: BUILD
- **How to Access**: From Health Dashboard tap `Medication Manager` or `Vaccination Manager`.
- **What to Verify in Medication Manager**:
  - Active prescriptions list with daily dose schedules, time reminders, and refill alerts.
  - Past / finished medications section.
- **What to Verify in Vaccination Manager**:
  - Core vaccines list: Rabies, DHPP, Leptospirosis, Kennel Cough.
  - Validity status pills: `VALID` (Green), `DUE SOON` (Orange), `EXPIRED` (Red).
  - Batch number, clinic stamp, and next booster date.

### 4.6 Vet Visits, Injuries & Recovery
- **Action**: BUILD
- **How to Access**: From Health Dashboard tap `Vet Visits` or `Injuries & Recovery`.
- **What to Verify in Vet Visits**:
  - Past clinic visits ledger with invoices, diagnoses, and follow-up consultation dates.
- **What to Verify in Injuries & Recovery**:
  - Active rehabilitation tracker: Days elapsed, recovery phase (Acute, Rehabilitation, Return-to-Sport).
  - Rehabilitation exercise checklist.

### 4.7 Physiotherapy & Hydrotherapy Hub
- **Action**: BUILD
- **How to Access**: From Health Dashboard tap `Physio & Hydro Hub`.
- **What to Verify**:
  - Session history: Underwater treadmill, laser therapy, passive range of motion.
  - Session notes: Water speed, water height, duration, handler observations.

### 4.8 Supplements, Allergies & Sensitivities, Dental Care
- **Action**: BUILD
- **What to Verify in Supplements**: Daily supplement list (Omega-3, Glucosamine, Collagen) with administration meal times (Morning/Evening).
- **What to Verify in Allergies**: Critical allergen alert cards (Chicken, Beef, Grain, Pollen) with severity levels (Mild, Moderate, Severe).
- **What to Verify in Dental**: Plaque assessment, brushing frequency tracker, annual scaling records.

### 4.9 Health Reports, Statistics & Health Archive
- **Action**: BUILD
- **What to Verify in Health Reports**: Exportable veterinary dossier PDF generation with date range filters.
- **What to Verify in Health Statistics**: Annual healthcare cost breakdown, visit frequency, medication compliance rate.
- **What to Verify in Health Archive**: Archived medical records ledger with restore options.

---

## BATCH 5 — STRENGTH & CONDITIONING (S&C)

### 5.1 S&C Dashboard (Empty & Populated States)
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap **Dogs** tab → Select **S&C** sub-tab.
- **What to Verify in Populated State**:
  - S&C Readiness score: `92% Optimal`.
  - 4-Metric Bento: Weekly Conditioning Time, Peak Heart Rate, Sprint Distance, Rest Compliance.
  - Quick action buttons: `Record Conditioning Session`, `Browse Activity Library`, `View Workload Stats`.
  - Active conditioning block: `Sprint Interval Phase 2`.
- **How to Test Empty State**:
  - Tap State Toggle Eye icon → Displays dumbbell outline graphic, "No S&C Data Logged", and `Start S&C Program` button.

### 5.2 Activity Library & Activity Details
- **Action**: BUILD
- **How to Access Activity Library**: From S&C Dashboard tap `Activity Library`.
- **What to Verify**:
  - Categorized canine conditioning exercises:
    - `Cardio & Stamina`: Canicross, Bikejoring, Treadmill, Sprint Intervals.
    - `Strength & Power`: Weight Pulling, Incline Sprints, Hill Climbs.
    - `Flexibility & Core`: Cavaletti Poles, Wobble Board, Peanut Ball Balance.
- **How to Test Activity Details**:
  - Tap `Canicross 5km Trail`.
  - Muscle groups targeted, equipment required, warm-up and cool-down protocols.
  - Action button: `Record This Activity` (pre-selects activity in session recorder).

### 5.3 Create Activity & Record S&C Session
- **Action**: BUILD
- **How to Access Create Activity**: From Activity Library tap `+ Create Activity`.
- **What to Verify**:
  - Flat inputs: Activity Title, Category Dropdown, Muscle Group Tags, Difficulty Rating, Protocol description.
  - Action: `Save Activity`.
- **How to Access Record S&C Session**: From S&C Dashboard tap `Record Conditioning Session`.
- **What to Verify**:
  - Live activity stopwatch, distance tracker (GPS/manual km), elevation gain, interval timer.
  - Heart rate monitor pairing status.
  - Action: `Save S&C Session`.

### 5.4 Activity Statistics, Goals & Insights
- **Action**: BUILD
- **How to Access**: From S&C Dashboard tap `Activity Statistics`, `Activity Goals`, or `Activity Insights`.
- **What to Verify in Statistics**:
  - Weekly workload distribution bar chart, distance progression curve, training vs rest balance.
- **What to Verify in Goals**:
  - Active conditioning goals (`Complete 100km Canicross this season • 64/100km`).
- **What to Verify in Insights**:
  - Automated conditioning observations: "Sprint stamina improved by 14% over 30 days".

### 5.5 Equipment & Session Templates
- **Action**: BUILD
- **How to Access**: From S&C Dashboard tap `Equipment` or `Session Templates`.
- **What to Verify in Equipment**:
  - Gear inventory: Canicross harness, bungee line, balance disc, conditioning vest, weight bags.
- **What to Verify in Session Templates**:
  - Pre-built drill templates: `Tuesday Morning High-Intensity Interval`, `Friday Core Stability Routine`.
  - Action: `Start from Template`.

---

## BATCH 6 — TIMELINE

### 6.1 Global Timeline (Empty & Populated States)
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap the 4th tab labeled **Timeline** in bottom navigation bar.
- **What to Verify in Populated State**:
  - Dog avatar and name selector (`Murphy` / `Freya`) in top bar.
  - Hero memory card with photo, date, and `Open Original Event →` button.
  - Grouped chronological date headers: `TODAY`, `YESTERDAY`, `EARLIER THIS WEEK`.
  - Color-coded event cards: Training (Blue), Health (Red), S&C (Bronze), Goals (Gold), Competitions (Green).
  - Tapping any card opens Event Details.
  - Floating action button (Forest Green `+`) opens session recording sheet.
- **How to Test Empty State**:
  - Tap dog selector → Select `Fenris (0 Events — Empty State)` or tap the Eye icon.
  - Displays "No Events Yet" with radar pulse animation and `Record Your First Session` CTA.

### 6.2 Timeline Insights (Empty & Populated States)
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Timeline Insights**.
- **What to Verify in Populated State**:
  - Top summary bento: `24 Active Insights`, `Just Now Last Updated`, `3 Years Period Analysed`.
  - `RECENTLY DISCOVERED` section: Gold badge `• 2 New` showing "Longest Goal Yet Completed" (94 Days).
  - Split action bar: `Filter` and `Export`.
  - 7 Expandable accordions: Recording Consistency, Training, S&C, Health, Goals, Milestones, Activity Balance.
- **Interactive Filter Testing**:
  - Tap `Filter` button → Select `Health` chip → Tap `Apply Filter`.
  - Active filter indicator bar appears: `Filtered by: Health` with `Clear Filter` button.
  - ONLY the `Health` accordion is shown and automatically expanded.
  - Tap `Clear Filter` → All 7 categories reappear.
- **How to Test Empty State**:
  - Tap Eye icon in top bar → Displays lightbulb card, "Not Enough Timeline Data", and `Go to Timeline` CTA.

### 6.3 Timeline Activity Map (Empty, Default, Marker Selected States)
- **Action**: BUILD (One screen, three states)
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Activity Map**.
- **State 1 — Default State**:
  - Top carousel: `23 Locations`, `Riverside Trail (34 SESSIONS)`, `147 Events`.
  - Dark vector map canvas with Nordic Sport Grid lines, waterways, and trails.
  - Hotspot ring markers: `18` (Riverside Trail Loop), `7` (Alpine Ridge Summit), `9` (Bavarian Forest Grid), `4` (Meadow Agility Arena).
  - Floating map controls: Heatmap toggle, Split route toggle, GPS recenter target.
  - Bottom preview card: `Riverside Trail Loop (4.8 km • 34 Sessions)`.
- **State 2 — Marker Selected State**:
  - Tap the `18` cluster ring pin.
  - Top GPS coordinates pill appears: `51.236° N • 0.570° W`.
  - Pin pulses with glowing green halo and floating `• SELECTED` badge.
  - Bottom sheet slides up with 3 stat columns (Visits, First Visit, Last Visit), recent sessions list, and `Open in Timeline →` action.
  - Tap `✕` or tap map to return to Default State.
- **State 3 — Empty State**:
  - Tap State Switcher icon → Displays pin inside circular ripple, "No Recorded Locations", and `Go to Timeline` CTA.

### 6.4 Timeline Memories (Empty & Populated States)
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Timeline Memories**.
- **What to Verify in Populated State**:
  - Hero card: Mountain background silhouette, `• ONE YEAR AGO TODAY` gold badge, title "Murphy's First Off-Lead Recall Session", date `14 Sep 2025`, and `Open Original Event →` CTA.
  - `TODAY` section (2 memories).
  - `THIS MONTH` section (5 memories) with `+ 3 more this month ˅` expand trigger.
  - `MILESTONES` section with green milestone badges.
  - `PREVIOUS YEARS` chronological sections (2024, 2023, 2022) with expand triggers.
  - Bottom split bar: `Filter Categories` and `Browse Years` (year jump selector).
- **How to Test Empty State**:
  - Tap Eye icon → Displays clock radar icon, "No Memories Yet", and `MILESTONE ENGINE` card with `STANDBY` status.

### 6.5 Timeline Compare (Empty & Populated States)
- **Action**: BUILD (One screen, two states)
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Timeline Compare**.
- **What to Verify in Populated State**:
  - Period A card (`Sep 2026`, `74 Events`, green border) vs Period B card (`Aug 2026`, `61 Events`, blue border) with `VS` badge.
  - Preset range pills: `This Week vs Last Week`, `This Month vs Last Month`.
  - `Summary` and `Categories` difference tables with numeric highlights.
  - `Stacked Proportional Distribution Bar`: Multi-colored proportional bar for Period A vs Period B.
  - `Activity` Chart: Animated interactive dual-line curve chart.
    - Touch or drag along the curve to trigger interactive tooltips displaying event counts for both periods at that day index.
  - `Recording Consistency`, `Locations`, and `Attachments` 2x2 comparison grid.
- **How to Test Empty State**:
  - Tap Eye icon → Displays dual comparison placeholder card and explanatory guide.

### 6.6 Timeline Smart Collections & Widgets Gallery
- **Action**: BUILD
- **How to Access Smart Collections**: Tap **Timeline** → `•••` → **Open Smart Collections**.
  - Search bar with voice query microphone icon.
  - 2x2 Grids for `TIME-BASED RANGE`, `MEDIA & ARTIFACTS`, `SPORT & CONDITIONING`, and `HEALTH & BIOMETRICS`.
- **How to Access Widgets Gallery**: Tap **Timeline** → `•••` → **Open Widgets Gallery**.
  - Size selectors (`S`/`M`/`L`) for Activity, Statistics, Health, Goals, and Media widgets.
  - Sticky bottom drawer with active widget configuration.

### 6.7 Timeline Statistics, Calendar, Archive, Export & Favourites
- **Action**: BUILD (All with Populated & Empty states)
- **What to Verify in Statistics**:
  - Canine identity: `Koda • Border Collie · 3 Years · Erik Voss`.
  - Filter pills: `All Time`, `This Year` (selected), `Last Year`, `This Month`.
  - 3 Horizontal stat cards: `847 Total Events`, `14 Day Streak`, `31 This Year`.
  - Animated spline curve chart with August peak tooltip (`58 Events`).
  - Donut chart showing `847 Events` in center ring with 5 category breakdown percentages.
- **What to Verify in Calendar**:
  - Month, Week, Day, Year, Agenda view tabs.
  - Monthly calendar matrix with highlighted day dots and day drill schedule.
- **What to Verify in Archive**:
  - Summary bento, multi-select mode (`3 Selected`), document & media previews, and restore actions.
- **What to Verify in Export**:
  - Date range presets (`This Year`), PDF/CSV formats, and `Generate Export ⤓` green button.
- **What to Verify in Favourites**:
  - Saved moments ledger with golden heart icons and category filter pills.
- **What to Verify in Settings**:
  - 9 Expandable setting accordions and `Reset Timeline Settings`.

---

## BATCH 7 — MORE & SETTINGS

### 7.1 More Page & More Dashboard
- **Action**: BUILD
- **How to Access**: Tap the 5th tab labeled **More** in bottom navigation bar.
- **What to Verify**:
  - User identity bento card: Avatar, handler name (`Lars Viken`), membership tier badge (`CORE ATHLETE`).
  - Navigation links:
    - `Media Library`: Photos, videos, documents.
    - `Sport Pack`: Competitions, trial records, achievements.
    - `Trainer Workspace`: Client management, homework, session notes.
    - `Settings & Preferences`: Notifications, appearance, storage, units.
    - `Help & Support`: Help Centre, bug report, contact.

### 7.2 Settings Hub & Appearance Settings
- **Action**: BUILD
- **How to Access**: Tap **More** → Tap **Settings** → Tap **Appearance**.
- **What to Verify on Appearance Settings**:
  - Top live preview card showing controls that update instantly with settings.
  - `THEME`: Selectors for `System (Default)`, `Dark` (active checkmark), `Light`.
  - `TEXT SIZE`: `Small`, `Default (Recommended ✓)`, `Large`, `Extra Large`.
  - `DISPLAY DENSITY`: `Comfortable (Recommended ✓)`, `Compact`, `Spacious`.
  - `REDUCE MOTION`: Toggle switch (simplifies transitions and chart animations).
  - `HAPTIC FEEDBACK`: Toggle switch (tactile feedback on button taps).
  - Destructive action: `Reset Appearance Settings`.

### 7.3 Notification Settings, Backup & Sync, Offline Mode, Storage
- **Action**: BUILD
- **What to Verify in Notification Settings**: Push notification switches for training reminders, streak alerts, health boosters, homework reviews.
- **What to Verify in Backup & Sync**: Cloud synchronization status, last backup timestamp, manual `Backup Now` button.
- **What to Verify in Offline Mode**: Offline map tiles download, offline cache indicator, sync when online toggle.
- **What to Verify in Storage Management**: Total storage meter bar (Photos, Videos, Docs, Cache) with `Clear Image Cache` and `Clear Offline Tiles` buttons.

### 7.4 Help Centre, Support, Bug Report & Legal
- **Action**: BUILD
- **What to Verify in Help Centre**: Searchable FAQ, video tutorials, canine conditioning guides.
- **What to Verify in Report a Bug**: Bug category selector, description box, attachment uploader, submit action.
- **What to Verify in Legal**: Full-text scrollable screens for `Privacy Policy`, `Terms & Conditions`, `Open Source Licences`, `About Ulvenik`.

### 7.5 Profile Page & Edit Profile
- **Action**: BUILD
- **How to Access**: Tap **More** → Tap the User Identity Card at top.
- **What to Verify**:
  - Handler avatar with initials `JH`, name, role (`K9 Tracking Specialist • Level 4`), active packs.
  - Tap `Edit Profile` in top right to modify name, bio, phone number, and location.

---

## BATCH 8 — ACCOUNT & UTILITY

### 8.1 Billing History & Subscription Details
- **Action**: BUILD
- **How to Access**: Tap **More** → Tap **Subscription Details**.
- **What to Verify**:
  - Current plan card: `Core Membership • Active • Renews 12 Oct 2026`.
  - Add-on packs section: `Trainer Pack (Active)`, `Sport Pack (Active)`, `Club Pack (Add Pack)`.
  - Billing history ledger with past invoices, amounts, and PDF receipts.

### 8.2 Restore Purchases
- **Action**: BUILD
- **How to Access**: Tap **More** → **Subscription Details** → Tap **Restore Purchases** under MANAGE section.
- **What to Verify**:
  - Cloud sync hero icon with circular refresh arrows.
  - Headline: "Missing a Purchase?", description of App Store license check.
  - Restorable items checklist: Core Membership, Trainer Pack, Sport Pack.
  - Primary button: `Restore Purchases`.
  - Tap button → 1.5s loading spinner → Confirmation dialog: "Purchases Restored — Active memberships verified successfully."

### 8.3 Change Photo (Bottom Sheet Modal)
- **Action**: BUILD (No bottom nav bar)
- **How to Access**: Tap **More** → Tap User Avatar on Profile Page.
- **What to Verify**:
  - Drag handle at top.
  - Circular avatar preview with glowing green dot and `CURRENT ACTIVE` tag.
  - Options: `Take Photo` (camera), `Choose from Photo Library` (gallery), `Remove Current Photo` (red trash), `Cancel`.

### 8.4 Image Editor (Crop Guide Modal)
- **Action**: BUILD (No bottom nav bar, pure black background)
- **How to Access**: Select a photo from library in Change Photo.
- **What to Verify**:
  - Pure black background (`#000000`).
  - Interactive crop box with circular canine avatar mask and grid overlay.
  - Pinch-to-zoom and pan gestures.
  - Actions: `Rotate`, `Reset`, `Cancel`, `Save Photo`.

### 8.5 Global Search (Modal)
- **Action**: BUILD (No bottom nav bar)
- **How to Access**: Tap search icon in top bar of any main hub.
- **What to Verify**:
  - Full-screen search input with automatic keyboard focus.
  - Categorized instant search results: Dogs, Training Sessions, Health Records, Skills, Competitions, Clients.
  - Recent searches pills with `Clear History`.

### 8.6 Localization & Preferences
- **Action**: BUILD
- **What to Verify in Country or Region**: Country selection list with search and flag icons.
- **What to Verify in Language**: English (UK), English (US), Deutsch, Norsk, Svenska.
- **What to Verify in Measurement Units**: Metric (kg, km, cm) vs Imperial (lbs, mi, in).
- **What to Verify in Date & Time Format**: DD/MM/YYYY vs MM/DD/YYYY, 24-Hour vs 12-Hour.
- **What to Verify in Time Zone**: Automatic GPS detection toggle vs custom timezone picker.

### 8.7 Delete Account & Export My Data
- **Action**: BUILD
- **What to Verify in Delete Account**: Warning banner, data deletion implications, password confirmation input, and red `Permanently Delete Account` button.
- **What to Verify in Export My Data**: GDPR/CCPA data takeout archive generator (JSON, CSV, Media ZIP).

---

## BATCH 9 — MEDIA & LIBRARY

### 9.1 Media Library & Media Search
- **Action**: BUILD
- **How to Access**: Tap **More** → Tap **Media Library**.
- **What to Verify**:
  - Filter tabs: `All Media`, `Photos`, `Videos`, `Documents`.
  - Media grid displaying session thumbnails with duration badges on videos.
  - Storage meter banner.
  - Search bar to search media by caption, dog name, or session date.

### 9.2 Photo Viewer (Modal)
- **Action**: BUILD (Pure black background `#000000`, no bottom nav bar)
- **How to Access**: Tap any photo thumbnail in Media Library or Timeline.
- **What to Verify**:
  - High-resolution photo display with pinch-to-zoom and double-tap zoom.
  - Top bar: Back button, photo title, session date, share icon.
  - Bottom bar: Favourites heart toggle, download button, delete button.

### 9.3 Video Viewer (Modal)
- **Action**: BUILD (Pure black background `#000000`, no bottom nav bar)
- **How to Access**: Tap any video thumbnail in Media Library or Timeline.
- **What to Verify**:
  - Full-screen video player with play/pause, scrub bar, elapsed/total time.
  - Slow-motion playback toggle (0.5x, 0.25x) for analyzing canine gait and decoy bites.
  - Frame-by-frame scrub control.

### 9.4 Document Viewer
- **Action**: BUILD
- **How to Access**: Tap any document card in Certificates or Health Records.
- **What to Verify**:
  - Full-screen document preview with page scrolling and zoom controls.
  - Document metadata: File name, file size, upload date.
  - Actions: `Share Document`, `Download PDF`, `Print`.

### 9.5 Media Upload Manager & Media Collections
- **Action**: BUILD
- **What to Verify in Media Upload Manager**: Active upload queue, progress bars, batch retry, auto-compression toggle.
- **What to Verify in Media Collections**: Custom photo albums (`Tracking Trials 2026`, `Agility Championship`, `Puppy Foundation`).

---

## BATCH 10 — SPORT PACK (Sport Pack Subscription Required)

### 10.1 Sport Pack Overview
- **Action**: BUILD
- **How to Access**: Tap **More** → Tap **Sport Pack**.
- **What to Verify**:
  - Hero header with active sports count and trial season summary.
  - Active canine switcher: `Murphy` (IGP-3) / `Freya` (Agility).
  - Quick launch tiles: `Competitions`, `Trial Results`, `Achievements & Titles`, `Sport Statistics`, `Certificates & Documents`.

### 10.2 Competitions Overview & Competition Details
- **Action**: BUILD
- **How to Access**: Tap **More** → **Sport Pack** → Tap **Competitions**.
- **What to Verify**:
  - Tabs: `Upcoming`, `Past`, `All Trials`.
  - Competition cards showing date, sport badge (`IGP 3`), trial title, judge name, venue, entry status.
  - Tap any card (e.g. `Essex IGP Championship`) to view trial hero card, judge details, trial phases (Tracking, Obedience, Protection), and score tally.

### 10.3 Add Competition
- **Action**: BUILD
- **How to Access**: From Competitions Overview tap `+` button in bottom right.
- **What to Verify**:
  - Form sections:
    - `Competition Information`: Event name, Sport dropdown, Dog selector, Date picker, Start/End time, Venue address, Host Club, Judge, Division, Entry number, Handler name, Weather auto-detect toggle.
    - `Status`: Chips for `Upcoming`, `Confirmed`, `Tentative`.
    - `Event Category`: Regional, National, Club Trial, Friendly.
    - `Link Goals`: Link canine athletic goals to this trial.
    - `Equipment Library`: Select trial tracking harness, dumbbells, decoy gear.
    - `Media & Attachments`: Upload entry confirmations and score sheets.
  - Primary button: `Create Competition`.

### 10.4 Record Competition Result & Competition Results
- **Action**: BUILD
- **How to Access Record Result**: From past competition card tap `Record Result`.
- **What to Verify**:
  - Result status dropdown: `Qualified`, `Not Qualified`, `Disqualified`.
  - Overall score input: `287.5 / 300` and placement selector: `2nd Place`.
  - Qualification chips (`IGP3`, `High Tracking Award`).
  - Judge comments and attachment card: `Score Sheet.pdf (28 KB)`.
  - Primary button: `Save Result`.
- **How to Access Competition Results**: Tap **More** → **Sport Pack** → Tap **Trial Results**.
- **What to Verify**:
  - Hero card: Score tally `92.4 pts` • `1st Place` • `QUALIFIED` green badge.
  - Placing & Ranks: 3 columns (Class Rank, Overall Placement, Division Size).
  - Section Scores: Expandable scoring breakdown (Phase A Tracking, Phase B Obedience, Phase C Protection).
  - Faults & Penalties section with point deductions.
  - Awards chips with `+ Add Award` dialog.

### 10.5 Qualifications, Titles & Awards and Achievements & Titles
- **Action**: BUILD
- **How to Access Qualifications**: Tap **More** → **Sport Pack** → Tap **Qualifications, Titles & Awards**.
  - 4 Summary cards: `4 Qualifications`, `1 Titles`, `3 Awards`, `15 Sep 2026 Latest`.
  - List with Trophy, Star, and Document icons.
- **How to Access Achievements**: Tap **More** → **Sport Pack** → Tap **Achievements & Titles**.
  - 2x3 Bento grid: `4 Titles`, `12 Qualifications`, `7 Awards`, `9 Personal Bests`, `3 Wins`, `IGP3 Highest`.
  - Expandable accordions for Titles, Qualifications, Awards, Personal Bests, Milestones.

### 10.6 Sport Statistics (Animated Interactive Bar Chart)
- **Action**: BUILD
- **How to Access**: Tap **More** → **Sport Pack** → Tap **Sport Statistics**.
- **What to Verify**:
  - Timeframe filter pills: `Last 30 Days`, `Last 90 Days`, `This Year` (selected), `All Time`.
  - Summary 2x2 Bento: Total Sessions, Hours Logged, Average Score, Qualification Rate.
  - `MONTHLY SESSION VOLUME (Apr-Sep 2026)` Chart:
    - Animated interactive bar chart.
    - Touch each monthly bar (Apr, May, Jun, Jul, Aug, Sep) to trigger touch tooltips displaying exact session counts and hours.
  - Skills curriculum breakdown with completed vs active drill indicators.

### 10.7 Certificates & Documents and My Sports
- **Action**: BUILD
- **What to Verify in Certificates**:
  - 12 Document cards with file sizes, verification tags, and preview thumbnails.
  - Tapping opens Document Viewer.
- **What to Verify in My Sports**:
  - Active sports list: IGP / Schutzhund, Agility, Tracking, Scent Work.
  - Action: `+ Create Sport` form with scoring type and phase structure.

---

## BATCH 11 — TRAINER PACK (Trainer Pack Subscription Required)

### 11.1 Trainer Dashboard & Analytics (Animated Graph Sheet)
- **Action**: BUILD
- **How to Access**: Tap the 5th tab labeled **More** in bottom bar → Tap **Trainer Workspace** (or **Trainer Hub**).
- **What to Verify on Dashboard**:
  - Hero card: Business identity `Take the Lead Essex`, Trainer `Liv Old`, `TRAINER PACK` badge.
  - 2x2 Bento: `4 Lessons Today`, `12 Active Clients`, `21 Client Dogs`, `3 Reviews Pending`.
  - Notification Bell in top bar (with red unread dot): Tapping opens `Trainer Notifications`.
  - Attention Required cards:
    - `3 Homework Assignments Pending • Murphy`: Tapping opens `Homework & Training Plans`.
    - `Incomplete client profile • James Harlow`: Tapping opens `Edit Client`.
  - Today's Schedule: Time slots (09:00 Emma • Murphy, 11:30 James • Bella) with `CONFIRMED` / `UPCOMING` badges.
  - Quick Action Tiles (6 grid items): `Add Client`, `Start Lesson`, `Assign Task`, `Trainer Notes`, `Create Goal`, `Open Calendar`.
  - Business snapshot: Weekly lesson volume bar indicators.
- **How to Test Animated Analytics Sheet**:
  - Tap the Bar Chart / Analytics icon in the top right app bar.
  - Full-fidelity Analytics bottom sheet expands:
    - Filter pills: `THIS WEEK` (selected), `THIS MONTH`, `LAST 90 DAYS`.
    - 2x3 Bento grid: 12 Active Clients, 21 Client Dogs, 8 Lessons This Week, 31 Active Goals, 82% Homework Completion, 14 Sessions Recorded.
    - `LESSON ACTIVITY` animated bar chart with peak Wednesday indicator.
    - `HOMEWORK` progress bar with completion rate.
    - `GOALS` proportional bar (Obedience 40%, Social 35%, Health 25%).
    - `CLIENT ENGAGEMENT` animated dual-curve line graph (solid green for Training Activity, dashed blue for Homework Submissions).

### 11.2 Trainer Profile & Business Identity
- **Action**: BUILD
- **How to Access**: Tap **More** → **Trainer Hub** → Tap Trainer Avatar in hero card.
- **What to Verify**:
  - Forest hero header with avatar and business identity `Liv Old • Take the Lead Essex`.
  - 4-metric strip: `12 Active Clients`, `21 Client Dogs`, `47 Sessions`, `3 yrs On Ulvenik`.
  - `About`, `Expertise` chips, `Qualifications` list with DBS check verified badge, `Services Offered` with pricing.

### 11.3 Clients Directory & Client Profile
- **Action**: BUILD
- **How to Access Clients Directory**: Tap **More** → **Trainer Hub** → Tap **Clients** (or tap `12 ACTIVE CLIENTS` bento).
  - Search bar, filter chips (`ACTIVE ✕`, `UPCOMING LESSONS`, `PENDING REVIEWS`), 12 clients count.
- **How to Access Client Profile**: Tap on **Emma Johnson** card.
  - Avatar `EJ`, `Emma Johnson`, `ACTIVE CLIENT` badge.
  - 2x3 Details grid and 6 Quick Action buttons (`Dogs`, `Homework`, `Notes`, `Progress`, `Reports`, `Share`).
  - Three dots (`•••`) menu: `View Client Account & Linked Dogs`, `Edit Client`, `Archive Client`, `Export Client`, `Delete Client`.

### 11.4 Client Account & Linked Dogs
- **Action**: BUILD
- **How to Access**: From Client Profile tap `•••` in top right → Select **View Client Account & Linked Dogs**.
- **What to Verify**:
  - Hero Card: `Emma Johnson`, `• Connected to Ulvenik`, `Client since July 2026`, `2 Linked Dogs`, `Next Lesson · Thursday · 10:00`, `ACTIVE CLIENT` badge.
  - 2x2 Bento grid: `2 LINKED DOGS`, `3 ACTIVE GOALS`, `2 HOMEWORK DUE`, `8 LESSONS TOTAL`.
  - Quick Actions: `Record Lesson`, `Assign HW`, `Create Goal`, `Add Note`.
  - Side-by-side dog cards: Murphy (12 Day Streak) and Luna (5 Day Streak).
  - Permissions summary with `Manage Permissions >` link.
  - Recent activity timeline and private trainer notes callout.

### 11.5 Emma's Dogs Directory & Client Dog Profile
- **Action**: BUILD
- **How to Access Emma's Dogs**: From Client Profile tap **Dogs** quick action.
  - Dog Card 1: `PRIMARY ATHLETE` badge, `Murphy • 3 Years`, `Golden Retriever • IGP`, `12 Day Streak`, `SHARED WITH OWNER >`.
  - Dog Card 2: `AGILITY FOCUS` badge, `Bella • 5 Years`, `Border Collie`, `15 Day Streak`, `SHARED WITH OWNER >`.
  - Alert callout: `• Homework overdue — Murphy | Check ->`.
- **How to Access Client Dog Profile**: Tap on **Murphy** card.
  - Forest background hero, Murphy name, `EDITABLE` badge, breed & owner info.
  - Action buttons: `Start Training` and `Start S&C`.
  - 2-Column Overview with 8 action grid tiles (`Record Drill`, `Assign HW`, `Set Goal`, `Log Weight`, `Log Vet`, `Add Note`, `Upload Video`, `Share Profile`).

### 11.6 Add Client & Edit Client
- **Action**: BUILD
- **How to Access Add Client**: From Clients Directory tap `+` button in bottom right.
  - Basic Info, Contact Info, Address, Trainer Private Notes, Permissions Preset chips, Client Access switches, Send Invitation toggle, `Add Dog Now` toggle, and `Create Client` button.
- **How to Access Edit Client**: From Client Profile tap `•••` → Select `Edit Client`.
  - Pre-filled fields, status chips (`ACTIVE`, `INACTIVE`, `ARCHIVED`), and `Save Changes` button.

### 11.7 Client Permissions (Access Control)
- **Action**: BUILD
- **How to Access**: From Client Profile tap **Manage Permissions** (or tap **Share**).
- **What to Verify**:
  - Trainer connection hero: `Take the Lead Essex • Connected since Jul 2026`.
  - Granular switches for Dog Profile, Training Records, Health Records (Private by default), Goals & Homework, Media.
  - Connection actions: `Pause Sharing` and `Disconnect Trainer`.

### 11.8 Homework & Training Plans and Homework Details
- **Action**: BUILD
- **How to Access Homework Hub**: From Trainer Dashboard tap `3 Homework Assignments Pending`.
  - Filter tabs: `All`, `Awaiting Review`, `In Progress`, `Overdue`, `Completed`.
  - 4-Metric strip: `3 Awaiting Review`, `6 In Progress`, `2 Overdue`, `18 Completed`.
  - Cards with progress bars, due dates, and review buttons.
- **How to Access Homework Details**: Tap on `Recall Foundation Practice`.
  - `AWAITING REVIEW` badge, `HIGH` priority tag, instructions, progress bar (2 of 5 sessions), client video submissions, and `Trainer Feedback` card.

### 11.9 Lesson Records Log & Trainer Notes
- **Action**: BUILD
- **How to Access Lesson Records**: From Client Profile tap `8 LESSONS TOTAL`.
  - Chronological lesson ledger: `15 Sep 09:00 (One-to-One, Chelmsford, 60 min, Homework Assigned)`, `8 Sep 09:00`, `1 Sep 09:30`.
- **How to Access Trainer Notes**: From Trainer Dashboard tap `Trainer Notes` in Quick Actions.
  - Private notes ledger: Search field, `14 Notes` count, privacy callout.
  - `PINNED` note: `Pre-lesson checklist — Thursday 10am`.
  - `RECENT NOTES`: Behaviour observations, follow-up reminders, client call notes.

### 11.10 Trainer Notifications Hub
- **Action**: BUILD
- **How to Access**: From Trainer Dashboard tap the Notification Bell icon in top bar.
- **What to Verify**:
  - Tabs: `All`, `Action Required`, `Read`, and `Mark All Read` button.
  - `ACTION REQUIRED`: Homework awaiting review (`Review Now →`), New client invitation accepted (`View Client →`).
  - `TODAY`: Goal completed, Training video uploaded, Lesson reminder.
  - `YESTERDAY`: Homework completed, Permission updated.

### 11.11 Client Progress & Analytics (Animated Spline & Donut Chart)
- **Action**: BUILD
- **How to Access**: From Client Profile tap **Progress** quick action.
- **What to Verify**:
  - Timeframe selector: `This Month v`.
  - Category filter pills: `Overview` (active), `Training`, `S&C`, `Skills`, `Health`.
  - 2x2 Bento grid with sparklines (Total Training Time, Sessions, Frequency, Success Rate).
  - Animated glowing green cubic spline curve chart with touch nodes.
  - `Session Breakdown` Donut Chart: Total 24h 35m ring with distribution bars.
  - `Training Heatmap`: 7x4 day-of-week matrix with peak Tuesday glowing green intensity.
  - `Best Streak`: 12 days card with 87% radial completion ring.

### 11.12 Trainer Reports, Shared Records & Workspace Settings
- **Action**: BUILD
- **What to Verify in Trainer Reports**: 3-Column summary (`7 Total`, `4 Shared`, `1 Draft`), report status badges (`SHARED`, `DRAFT`, `NOT SHARED`, `ARCHIVED`).
- **What to Verify in Shared Records**: Active shared records list with sharing history audit timeline.
- **What to Verify in Trainer Workspace Settings**: Pro trainer kennel identity, auto-invite toggles, 4K video review toggles, default homework cadence dropdown (`Weekly 7 Days`).

---

## NEW SCREENS — REWARDS MANAGEMENT

### N.1 Rewards Management
- **Action**: BUILD (Lives under Dog Profile → Training)
- **How to Access**: Tap **More** in bottom bar → Tap **Rewards Management** (or tap **Dogs** → **Training** → **Rewards**).
- **What to Verify**:
  - Dog banner: `Rook • Belgian Malinois • IGP-3 SPORT`.
  - Header: `REWARD TYPES` with `Manage Types` link opening `Manage Reward Types`.
  - Type filter chips: `All`, `Food`, `Toy`, `Praise`, `Play`, `Competition`, `High Drive`.
  - Search bar for quick filtering.
  - List of canine reward cards with category badges and tactical notes.
  - Floating action button (`+`) opens `Add Reward`.
  - Tapping any existing reward opens `Edit Reward`.

### N.2 Add Reward (Bottom Sheet Modal)
- **Action**: BUILD (No bottom nav bar)
- **How to Access**: From Rewards Management tap `+` button in bottom right.
- **What to Verify**:
  - Drag handle at top and close (`✕`) button.
  - Subtitle: `Rewards are personal to Rook.`
  - `REWARD NAME`: Text input with green underline, pre-filled with `Freeze-Dried Liver`.
  - `REWARD TYPE`: Chips for `Food ✓` (selected), `Toy`, `Praise`, `Play`, `Competition`, `High Drive`, and `+ New Type` (dashed border).
  - `DESCRIPTION`: Tactical usage notes input (`e.g. Reserved for high distraction environments`).
  - Primary button: `Save Reward` (saves and adds to list).
  - Secondary button: `Cancel`.

### N.3 Edit Reward (Bottom Sheet Modal)
- **Action**: BUILD (No bottom nav bar)
- **How to Access**: From Rewards Management tap any existing reward (e.g. `Freeze-Dried Liver`).
- **What to Verify**:
  - Drag handle and close (`✕`) button.
  - Subtitle: `Rewards are personal to Rook.`
  - Pre-filled reward name with green underline.
  - Pre-filled reward type chips.
  - Pre-filled description (`High value — competition only`).
  - Primary button: `Save Changes`.
  - Secondary button: `Cancel`.
  - Bottom destructive action: Red trash icon with `Delete Reward` (triggers confirmation dialog).

### N.4 Manage Reward Types
- **Action**: BUILD (Full screen)
- **How to Access**: From Rewards Management tap `Manage Types` in the header.
- **What to Verify**:
  - Full screen with back arrow and "Manage Reward Types" header.
  - List of all reward types with icons, color indicators, and active reward count.
  - Actions to reorder types, edit names, or create a custom reward category.

---

## COMPLETE VERIFICATION CHECKLIST

- [x] All 11 Batches and New Screens from `Ulvenik_Frontend_Handover.md` are documented in exact order.
- [x] Every screen has step-by-step visual navigation click-paths with zero code or class names.
- [x] All empty and populated state toggles are documented and functional.
- [x] All telemetry charts (Sport Statistics, Trainer Dashboard Analytics, Client Progress Spline, Timeline Compare Dual-Line, Timeline Statistics Curve) are dynamic, animated, and interactive with touch tooltips.
- [x] Active tab rules and no-bottom-nav modal rules are strictly validated.
- [x] `flutter analyze` runs with 0 errors across all screens in the codebase.
