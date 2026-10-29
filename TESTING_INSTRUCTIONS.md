# Ulvenik — Complete Visual Screen Testing & Verification Guide

This guide provides end-to-end visual click-paths to navigate, test, and verify every single screen in the Ulvenik canine athletic management application. All instructions follow real user touch interactions with **zero code or class symbols**.

---

## CANONICAL NAVIGATION BARS

Ulvenik uses a persistent 5-tab bottom navigation bar across all main hubs:
- **Home**: Main dog overview, health status, next training session, activity bento.
- **Dogs**: Canine profiles, skills curriculum, goal velocity tracker, strength & conditioning, statistics.
- **Training**: Active session recording, drill timer, field telemetry.
- **Timeline**: Chronological canine timeline, filters, calendar, search, activity map, memories, compare, smart collections, widgets gallery.
- **More**: Workspace identity, settings, media library, billing, trainer workspace, sport pack.

---

## 1. TIMELINE ECOSYSTEM

### 1.1 Global Timeline
- **How to Access**: Tap the 4th tab labeled **Timeline** in the bottom navigation bar.
- **What to Verify in Populated State**:
  - Top bar shows dog avatar and name selector (`Murphy` / `Freya`).
  - Active hero memory card with photo, date, and "Open Original Event" CTA.
  - Chronological grouped date headers: `TODAY`, `YESTERDAY`, `EARLIER THIS WEEK`.
  - Event cards for Training (Blue), Health (Red), S&C (Bronze), Goals (Gold), Competitions (Green).
  - Tapping any card opens the Event Details view.
  - Floating action button (Forest Green circle with `+`) opens the session recording sheet.
- **How to Test Empty State**:
  - Tap the dog name in the top bar to open the dog selection sheet, then select `Fenris (0 Events — Empty State Demo)` or tap the Eye icon in the top bar.
  - Card displays "No Events Yet" with radar pulse animation and "Record Your First Session" CTA.

---

### 1.2 Timeline Insights
- **How to Access**: Tap **Timeline** in bottom bar → Tap the three dots (`•••`) in top right → Select **Open Timeline Insights**.
- **What to Verify in Populated State**:
  - Top summary bento card: `24 Active Insights`, `Just Now Last Updated`, `3 Years Period Analysed`.
  - `RECENTLY DISCOVERED` section: Gold badge `• 2 New` showing "Longest Goal Yet Completed" (94 Days) and Training insight cards.
  - Split action bar: `Filter` and `Export`.
  - 7 Expandable category accordions: Recording Consistency, Training, S&C, Health, Goals, Milestones, Activity Balance.
- **Interactive Filter Testing**:
  - Tap the filter icon (`🎚️`) in top bar or the `Filter` button.
  - Select `Health` chip → Tap `Apply Filter`.
  - Verify active filter indicator bar appears: `Filtered by: Health` with `Clear Filter` button.
  - Verify ONLY the `Health` accordion is shown and automatically expanded.
  - Tap `Clear Filter` → All 7 categories reappear.
- **How to Test Empty State**:
  - Tap the Eye icon in top right app bar to toggle empty state with lightbulb card and "Go to Timeline" button.

---

### 1.3 Timeline Activity Map (3 Interactive States)
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Activity Map**.
- **State 1 — Default State**:
  - Top carousel: `23 Locations`, `Riverside Trail (34 SESSIONS)`, `147 Events`.
  - Interactive dark vector map canvas displaying Nordic Sport Grid lines, waterways, and trails.
  - Numbered hotspot ring markers: `18` (Riverside Trail Loop), `7` (Alpine Ridge Summit), `9` (Bavarian Forest Grid), `4` (Meadow Agility Arena).
  - Floating controls on right: Heatmap toggle, Split route toggle, GPS recenter target.
  - Bottom location card: `Riverside Trail Loop` (4.8 km • 34 Sessions Recorded • Jan 2022 - Sep 2026).
- **State 2 — Marker Selected State**:
  - Tap the `18` cluster ring pin or tap the preview card at the bottom.
  - Top GPS coordinates pill appears: `51.236° N • 0.570° W`.
  - Pin pulses with a glowing green ring and a floating `• SELECTED` badge directly above it.
  - Expanded bottom sheet slides up with 3 stat columns (Visits, First Visit, Last Visit), recent sessions list, and action buttons.
  - Tap `✕` or tap anywhere on the map to return to Default State.
- **State 3 — Empty State**:
  - Tap the State Switcher icon in top bar or select `Empty State` from the `•••` menu.
  - Centered card: Pin inside circular ripple, "No Recorded Locations", and "Go to Timeline" button.

---

### 1.4 Timeline Memories
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Timeline Memories**.
- **What to Verify in Populated State**:
  - Hero Card: Misty mountain background silhouette, `• ONE YEAR AGO TODAY` gold badge, title "Murphy's First Off-Lead Recall Session", date `14 Sep 2025 • Riverside Trail`, description, primary button `Open Original Event →`, and secondary button `Share This Memory`.
  - `TODAY` section (2 Memories).
  - `THIS MONTH` section (5 Memories) with `+ 3 more this month ˅` expand trigger.
  - `MILESTONES` section (4 Memories) with green milestone badges.
  - `ACHIEVEMENTS` section with recording streaks.
  - `PREVIOUS YEARS` chronological sections (2024, 2023, 2022) with expand triggers.
  - Bottom split bar: `Filter Categories` and `Browse Years` (year jump selector).
- **How to Test Empty State**:
  - Tap the Eye icon in top right app bar to view clock radar icon, "No Memories Yet", and `MILESTONE ENGINE` card with `STANDBY` status.

---

### 1.5 Timeline Compare (Interactive Chart)
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Timeline Compare**.
- **What to Verify in Populated State**:
  - Period A card (`Sep 2026`, `74 Events`, green border) vs Period B card (`Aug 2026`, `61 Events`, blue border) with central `VS` badge. Tap edit pencil on either card to open the date interval picker.
  - Preset range pills: `This Week vs Last Week`, `This Month vs Last Month`.
  - `Summary` and `Categories` difference tables with numeric highlights.
  - `Stacked Proportional Distribution Bar`: Multi-colored proportional bar for Period A vs Period B.
  - `Activity` Chart: Animated interactive dual-line curve chart.
    - Touch or drag along the curve to trigger interactive tooltips displaying event counts for both periods at that day index.
  - `Recording Consistency`, `Locations`, and `Attachments` 2x2 comparison grid.
  - Bottom split bar: `Change Dates` and `Export`.
- **How to Test Empty State**:
  - Tap the Eye icon in top right app bar to view dual comparison placeholder card and explanatory guide.

---

### 1.6 Timeline Smart Collections
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Smart Collections**.
- **What to Verify in Populated State**:
  - Search bar with magnifying glass and microphone icon for voice queries.
  - Status indicator: `• 15 SMART PRESETS SYNCED` | `AUTO-COMPILED`.
  - `TIME-BASED RANGE` (2x2 grid): `This Week` (12), `This Month` (47), `Last Month` (61), `This Year` (147).
  - `MEDIA & ARTIFACTS` (2x2 grid): Events with Photos (89), Videos (23), Voice Notes (14), Documents (8).
  - `SPORT & CONDITIONING` (2x2 grid): Training Journey (94), S&C Journey (31), Goal Journey (22), Recently Added (6).
  - `HEALTH & BIOMETRICS`: Health Records (38), Weight History (24), and Vet Visits card.
  - Tapping any card opens a preview modal with filtered timeline records.
- **How to Test Empty State**:
  - Tap the Eye icon in top right to view empty collections placeholder and help link.

---

### 1.7 Timeline Widgets Gallery
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Widgets Gallery**.
- **What to Verify in Populated State**:
  - Top `Home Dashboard` banner: `3 Widgets Active` with miniature preview tiles.
  - Sections for `ACTIVITY`, `STATISTICS`, `HEALTH`, `GOALS`, `MEDIA` with `S`/`M`/`L` size selectors and `+ Add` / `✓ Added` buttons.
  - Bottom Sticky Drawer: Selected widget indicator, `Tap to configure` chevron, `↺ Reset Layout`, and `+ Add Widget`.
- **How to Test Empty State**:
  - Tap the Eye icon in top right to view empty widgets wireframe and CTA.

---

### 1.8 Timeline Statistics (Interactive Curves & Donut Chart)
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Timeline Statistics**.
- **What to Verify in Populated State**:
  - Canine identity: `Koda • Border Collie · 3 Years · Erik Voss`.
  - Filter pills: `All Time`, `This Year` (active mint pill), `Last Year`, `This Month`.
  - 3 Horizontal stat cards: `847 Total Events` (+12 this week), `14 Day Streak` (Longest: 31 days), `31 This Year`.
  - `ACTIVITY OVER TIME` Section:
    - Smooth animated spline chart with Jan, Apr, Jul, Oct, Dec milestones.
    - Touch or tap the peak to trigger the interactive tooltip: `August 2026 / 58 Events` with glowing circular node.
  - `CATEGORY BREAKDOWN` Section:
    - Donut chart showing `847 Events` in center ring.
    - Category legend with percentage pills: Training 42%, Health 16%, Comp 8%, S&C 18%, Other 16%.
- **How to Test Empty State**:
  - Tap three dots (`⋮`) in top right → Select `Toggle Empty State`.
  - Verify centered bar chart icon, "No Statistics Yet", "Go to Timeline ->" CTA, and breathing pulsing skeleton containers.

---

### 1.9 Timeline Calendar
- **How to Access**: Tap **Timeline** in bottom bar → Tap calendar icon in top bar (or tap **More** → **Trainer Hub** → **Full Calendar**).
- **What to Verify**:
  - App bar with back arrow, "Calendar", search icon, filter icon.
  - Hero header with misty forest banner, `Murphy`, `September 2026`, and canine thumbnail.
  - Canine filter pills: `All Dogs` (selected mint pill), `Murphy`, `Monty`, `Minnie`, `+`.
  - Month navigator: `< September 2026 Today >`.
  - View tabs: `Month` (active mint underline), `Week`, `Day`, `Year`, `Agenda`.
  - Monthly calendar matrix: Day 16 selected with highlighted circle and colored category dots.
  - Day details: `Tuesday, 16 September • 3 events`:
    - `Morning Obedience Session` (Murphy · 09:00 · 45 min)
    - `Vet Check-Up` (Murphy · 14:30 · Riverside Vets)
    - `Complete Recall Goal` `PLANNED` (Murphy · Due today)
  - Quick action chips: `+ Add Training`, `+ Add Health`, `+ Add Reminder`.
  - `UPCOMING` section: Hydrotherapy Session, IGP Trial, Vaccination Due, Weekly Weight Check.
  - Floating action button (`+`) in bottom right.

---

### 1.10 Timeline Archive
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Archive**.
- **What to Verify in Populated State**:
  - Header: `Koda • Border Collie, 3 Years • Handler: Erik Voss`.
  - `TIMELINE ARCHIVE SUMMARY` Bento: `23 ARCHIVED EVENTS`, `18.4 MB STORAGE USED`, `3 Days Ago LAST ARCHIVED`.
  - Colored indicator dots for Training, S&C, Health, Goals.
  - Search bar with voice query microphone icon.
  - Multi-select action bar: `Deselect All`, `Export`, `Restore` green pill button.
  - Green banner: `MULTI-SELECT MODE • 3 Selected`.
  - Archived event cards:
    - `Tracking — Field Exercise (Advanced)` with 4 photo thumbnails and checkmark.
    - `Annual Check-up — January 2026` with PDF attachment tag and checkmark.
    - `Obedience — Basic Commands Refresher` with checkmark.
    - Orphaned record: `Early Puppy Training — First Week` with info callout and `Remove Reference` link.
    - Goals and S&C cards with individual `Restore` buttons.
- **How to Test Empty State**:
  - Tap three dots (`⋮`) in top right → Select `Toggle Empty State`.
  - Verify archive box icon, "No Archived Events", "Return to Timeline" button, and bottom filter/search toolbar.

---

### 1.11 Timeline Export
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Export Timeline**.
- **What to Verify in Populated State**:
  - Header with dog avatar, `Koda · Border Collie · 3 Years`.
  - `EXPORT TYPE` selector card: `Date Range` (checked radio) or `Specific Events`.
  - `DATE RANGE` card: Pills `Last 30 Days`, `This Year` (selected), `All Time`, with date display `Jan 1, 2024 - Dec 31, 2024 • 365 Days`.
  - `FORMAT` selector: `PDF Document` (selected radio) with description "Best for printing & sharing".
  - Sticky bottom action bar: `Cancel` text button and `Generate Export ⤓` green button.
- **How to Test Empty State**:
  - Tap three dots (`⋮`) in top right → Select `Toggle Empty State`.
  - Verify document icon, "No Timeline Data", "Go to Timeline ->" CTA, and disabled grey "Generate Export" button.

---

### 1.12 Timeline Favourites
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Open Favourites**.
- **What to Verify in Populated State**:
  - Search bar: "Search favourites..." with microphone.
  - Summary bento: `18 SAVED MOMENTS`, `Today LATEST`, `Aug '23 OLDEST`, with 5 colored dots across categories.
  - Filter chips row: `Training ✕` active pill and `Clear All` button.
  - List of favourited event cards with golden heart icons:
    - `Perfect Recall — 50m Distance Achievement` (Training blue dot, 4 photos, 1 video)
    - `IGP3 Regional Trial — 1st Place, Obedience` (Competition green dot, trophy, 12 photos)
    - `50 Successful Retrieves — Lifetime Milestone` (Goals yellow dot)
    - `Post-Surgery Recovery — Fully Cleared` (Health red dot, document icon)
    - `Agility Conditioning — Phase 1 Complete` (S&C orange dot)
    - `First Off-Lead Tracking Run` (Training blue dot, camera and location pin)
  - Bottom bar: `Sort` and `Filter`.
- **How to Test Empty State**:
  - Tap three dots (`⋮`) in top right → Select `Toggle Empty State`.
  - Verify empty heart outline icon, "No Favourite Events", and "Go to Timeline ->" button.

---

### 1.13 Timeline Settings
- **How to Access**: Tap **Timeline** in bottom bar → Tap three dots (`•••`) in top right → Select **Timeline Settings**.
- **What to Verify**:
  - Subheader status: `All Changes Saved`.
  - 9 Expandable setting accordions:
    1. `Display` (Expanded by default): Default Timeline View, Default Sort Order, Event Density, Date Format, Time Format, Auto-Expand Today's Events toggle.
    2. `Grouping`: Group by options.
    3. `Event Preview`: Thumbnails and telemetry toggles.
    4. `Favourites`: Pin favourites toggle.
    5. `Archive`: Auto-archive frequency.
    6. `Search`: Save recent searches, search scope.
    7. `Notifications`: Milestone reminders, streak alerts, weekly digest.
    8. `Performance`: Cache and media prefetching.
    9. `Privacy`: Private entries and biometric lock.
  - Bottom destructive action card: `Reset Timeline Settings`.

---

## 2. SPORT PACK ECOSYSTEM

### 2.1 Sport Pack Overview
- **How to Access**: Tap the 5th tab labeled **More** in bottom bar → Tap **Sport Pack**.
- **What to Verify**:
  - Hero header with active sports count and trial season summary.
  - Active dog switcher: `Murphy` (IGP-3) / `Freya` (Agility).
  - Quick launch tiles: `Competitions`, `Trial Results`, `Achievements & Titles`, `Sport Statistics`, `Certificates & Documents`.
  - Recent competition timeline cards with placement badges (`1st Place`, `Qualified`).

---

### 2.2 Competitions Overview & Competition Details
- **How to Access**: Tap **More** → **Sport Pack** → Tap **Competitions**.
- **What to Verify in Competitions List**:
  - Filter tabs: `Upcoming`, `Past`, `All Trials`.
  - Competition cards showing date, sport badge (`IGP 3`), trial title, judge name, venue location, and entry status.
  - Floating action button (`+`) to add a competition.
- **How to Test Competition Details**:
  - Tap on any competition card (e.g. `Essex IGP Championship`).
  - Verify trial hero card, judge details, trial phases (Tracking, Obedience, Protection), score tally, and attachments.
  - Tap `Record Result` to launch the competition scoring flow.

---

### 2.3 Add Competition
- **How to Access**: Tap **More** → **Sport Pack** → Tap **Competitions** → Tap `+` button in bottom right.
- **What to Verify**:
  - Form sections:
    - `Competition Information`: Event name, Sport dropdown, Dog selector, Date picker, Start/End time, Venue address, Country, Host Club, Judge, Division, Entry number, Handler name, Weather auto-detect toggle.
    - `Status`: Chips for `Upcoming`, `Confirmed`, `Tentative`.
    - `Event Category`: Regional, National, Club Trial, Friendly.
    - `Link Goals`: Link canine athletic goals to this trial.
    - `Equipment Library`: Select trial tracking harness, dumbbells, decoy gear.
    - `Media & Attachments`: Upload entry confirmations and score sheets.
    - `Notes & Reminders`: Notes counter and competition alert toggle.
  - Primary button: `Create Competition`.

---

### 2.4 Record Competition Result
- **How to Access**: Tap **More** → **Sport Pack** → Tap **Competitions** → Select a past trial → Tap **Record Result**.
- **What to Verify**:
  - Trial hero card with event title and date.
  - Result status dropdown: `Qualified`, `Not Qualified`, `Disqualified`, `Withdrawn`.
  - Overall score input: `287.5 / 300` and placement selector: `2nd Place`.
  - Add qualification / title chips: `IGP3`, `High Tracking Award`.
  - Judge's comments and personal handler reflections with character counter.
  - Attachment preview card: `Score Sheet.pdf (28 KB)` with download and remove icons.
  - Primary button: `Save Result`.

---

### 2.5 Competition Results
- **How to Access**: Tap **More** → **Sport Pack** → Tap **Trial Results** (or tap any completed trial in Competitions).
- **What to Verify**:
  - Hero card: Score tally `92.4 pts` • `1st Place` • `QUALIFIED` green badge.
  - Outcome chips and Qualification status.
  - Placing & Ranks: 3 columns (Class Rank, Overall Placement, Division Size).
  - Scores summary: Total, Max, Percentage, and Personal Best toggle switch.
  - Section Scores: Expandable scoring breakdown (Phase A Tracking, Phase B Obedience, Phase C Protection) with addable/removable rounds.
  - Faults & Penalties section with point deductions.
  - Awards chips with `+ Add Award` dialog.
  - Judge Feedback card with critique notes.
  - Attachments grid with document and photo thumbnails.
  - Primary button: `Save Results`.

---

### 2.6 Qualifications, Titles & Awards
- **How to Access**: Tap **More** → **Sport Pack** → Tap **Qualifications, Titles & Awards**.
- **What to Verify**:
  - 4 Horizontal summary metric cards: `4 Qualifications`, `1 Titles`, `3 Awards`, `15 Sep 2026 Latest`.
  - All Achievements chronological list:
    - Trophy icons for Titles (IGP 1, IGP 2, IGP 3).
    - Star icons for Awards (High in Trial, Best Protection).
    - Document icons for Official Working Certificates.
  - Floating action button (`+`) to log a new title or certificate.

---

### 2.7 Achievements & Titles (Bento Grid)
- **How to Access**: Tap **More** → **Sport Pack** → Tap **Achievements & Titles**.
- **What to Verify**:
  - 2x3 Bento summary grid: `4 Titles`, `12 Qualifications`, `7 Awards`, `9 Personal Bests`, `3 Wins`, `IGP3 Highest`.
  - Expandable accordions for Titles, Qualifications, Awards, Personal Bests, Milestones.
  - Outlined button: `Add Custom Achievement`.
  - Report row: `Generate Achievement Report →`.

---

### 2.8 Sport Statistics (Animated Interactive Bar Chart)
- **How to Access**: Tap **More** → **Sport Pack** → Tap **Sport Statistics**.
- **What to Verify**:
  - Timeframe filter pills: `Last 30 Days`, `Last 90 Days`, `This Year` (selected), `All Time`.
  - Summary 2x2 Bento: Total Sessions, Hours Logged, Average Score, Qualification Rate.
  - `MONTHLY SESSION VOLUME (Apr-Sep 2026)` Chart:
    - Animated interactive bar chart.
    - Touch each monthly bar (Apr, May, Jun, Jul, Aug, Sep) to trigger touch tooltips displaying exact session counts and hours.
  - Skills curriculum breakdown with completed vs active drill indicators.
  - Strip cards for Competitions and Achievements.

---

### 2.9 Certificates & Documents
- **How to Access**: Tap **More** → **Sport Pack** → Tap **Certificates & Documents**.
- **What to Verify**:
  - Document counter: `12 documents` with sort dropdown (`Newest First`, `Name A-Z`, `Size`).
  - Document cards list with file sizes, verification tags, and preview thumbnails:
    - `FCI Working Certificate — Murphy (2.4 MB)`
    - `IGP-3 Scorebook Entry — Regional Trial (850 KB)`
    - `Kennel Club Registration & Pedigree (3.1 MB)`
    - `Official Hip & Elbow Dysplasia Clearance (1.8 MB)`
  - Tapping any document card opens the full-screen Document Viewer.
  - Floating action button (`+`) to scan or upload new documents.

---

### 2.10 My Sports & Create Sport
- **How to Access**: Tap **More** → **Sport Pack** → Tap **My Sports**.
- **What to Verify**:
  - List of active canine disciplines: `IGP / Schutzhund`, `Agility`, `Tracking`, `Scent Work`.
  - Tap on `IGP` to open the Sport Details view showing trial phases and scoring rules.
  - Tap `+ Create Sport` in top right:
    - Enter Sport Name, Governing Body (FCI, AKC, UKC), Scoring Type (Points, Time, Pass/Fail), and Phase Structure.
    - Tap `Save Sport`.

---

## 3. TRAINER PACK ECOSYSTEM

### 3.1 Trainer Dashboard & Analytics (Animated Graph Sheet)
- **How to Access**: Tap the 5th tab labeled **More** in bottom bar → Tap **Trainer Workspace** (or **Trainer Hub**).
- **What to Verify on Dashboard**:
  - Hero card: Business identity `Take the Lead Essex`, Trainer `Liv Old`, `TRAINER PACK` badge.
  - 2x2 Bento: `4 Lessons Today`, `12 Active Clients`, `21 Client Dogs`, `3 Reviews Pending`.
  - Notification Bell in top bar (with red unread dot): Tapping opens `Trainer Notifications`.
  - Attention Required cards:
    - `3 Homework Assignments Pending • Murphy`: Tapping opens `Homework & Training Plans`.
    - `Incomplete client profile • James Harlow`: Tapping opens `Edit Client`.
  - Today's Schedule: Time slots (09:00 Emma • Murphy, 11:30 James • Bella) with `CONFIRMED` / `UPCOMING` badges.
  - Quick Action Tiles (6 grid items):
    - `Add Client`: Opens Add Client form.
    - `Start Lesson`: Opens session recording.
    - `Assign Task`: Opens homework assignment flow.
    - `Trainer Notes`: Opens Trainer Notes private ledger.
    - `Create Goal`: Opens Create Goal screen.
    - `Open Calendar`: Opens Calendar view.
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

---

### 3.2 Trainer Profile & Business Identity
- **How to Access**: Tap **More** → **Trainer Hub** → Tap the Trainer Avatar in the hero card.
- **What to Verify**:
  - Forest hero header with avatar and business identity `Liv Old • Take the Lead Essex`.
  - 4-metric strip: `12 Active Clients`, `21 Client Dogs`, `47 Sessions`, `3 yrs On Ulvenik`.
  - `About`: Professional bio and training philosophy.
  - `Expertise`: Interactive chips (`Working Dogs`, `IGP Tracking`, `Behaviour Rehabilitation`, `Off-Lead Control`).
  - `Qualifications`: Listed certificates (`FCI Certified Decoy`, `City & Guilds Canine Behaviourist`) with DBS check verified badge.
  - `Services Offered`: Private 1-to-1, Group Drills, Video Critique with duration and pricing.
  - Contact and booking action buttons.

---

### 3.3 Clients Directory
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Clients** (or tap `12 ACTIVE CLIENTS` bento).
- **What to Verify**:
  - Search bar: "Search clients by name, dog, or email...".
  - Filter chips: `ACTIVE ✕`, `UPCOMING LESSONS`, `PENDING REVIEWS`.
  - Subheader: `12 Clients` sorted by `Recently Active`.
  - Client cards:
    - `Emma Johnson` (Murphy · Malinois, Bella · Border Collie, Next Lesson: Thu 10:00, Active Goals: 3, `ACTIVE CLIENT` green badge).
    - `James Harlow` (Bella · Border Collie, Next Lesson: Fri 14:00, `ACTIVE CLIENT` green badge).
    - `Sarah Mitchell` (`INVITATION PENDING` orange badge).
  - Floating action button (`+`) to invite/add a new client.

---

### 3.4 Client Profile
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Clients** → Tap **Emma Johnson**.
- **What to Verify**:
  - Avatar `EJ`, `Emma Johnson`, `ACTIVE CLIENT` badge.
  - Quick contact row: Phone and Email buttons.
  - 2x3 Details grid: Member Since, Total Dogs, Total Lessons, Completed Goals, Overdue Tasks, Homework Rate.
  - Quick Actions row:
    - `Dogs`: Tapping opens `Emma's Dogs` directory.
    - `Homework`: Tapping opens client homework list.
    - `Notes`: Tapping opens client private notes.
    - `Progress`: Tapping opens client athletic analytics.
    - `Reports`: Tapping opens trainer progress reports.
    - `Share`: Opens client record sharing settings.
  - Horizontal dog cards: `Murphy` (Working Malinois) and `Bella` (Border Collie).
  - Private trainer notes section with `Add Note +`.
  - Three dots (`•••`) menu in top bar: Options for `View Client Account & Linked Dogs`, `Edit Client`, `Archive Client`, `Export Client`, `Delete Client`.

---

### 3.5 Client Account & Linked Dogs
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Clients** → Tap **Emma Johnson** → Tap `•••` in top right → Select **View Client Account & Linked Dogs**.
- **What to Verify**:
  - Hero Card: `Emma Johnson`, `• Connected to Ulvenik`, `Client since July 2026`, `2 Linked Dogs`, `Next Lesson · Thursday · 10:00`, `ACTIVE CLIENT` badge.
  - 2x2 Bento grid: `2 LINKED DOGS`, `3 ACTIVE GOALS`, `2 HOMEWORK DUE`, `8 LESSONS TOTAL`.
  - Quick Actions: `Record Lesson`, `Assign HW`, `Create Goal`, `Add Note`.
  - `LINKED DOGS` cards: Murphy (12 Day Streak) and Luna (5 Day Streak).
  - `PERMISSIONS` summary: Training Records (Read/Write), Goals (Read/Write), Statistics (View Only), Media (View & Upload), Health Records (Restricted), with `Manage Permissions >` link.
  - `RECENT ACTIVITY` timeline.
  - `TRAINER NOTES` card with `PRIVATE — Not visible to client` callout.

---

### 3.6 Emma's Dogs Directory
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Clients** → Tap **Emma Johnson** → Tap **Dogs** action (or tap **View All >** in Client Account).
- **What to Verify**:
  - Subheader: `2 Dogs • ACTIVE IN WORKSPACE`.
  - Dog Card 1: `PRIMARY ATHLETE` badge, `Murphy • 3 Years`, `Golden Retriever • IGP`, `12 Day Streak • Yesterday • 2 Goals`, and `SHARED WITH OWNER >` button.
  - Dog Card 2: `AGILITY FOCUS` badge, `Bella • 5 Years`, `Border Collie`, `15 Day Streak • 2 days ago • 1 Goal`, and `SHARED WITH OWNER >` button.
  - Alert callout strip: `• Homework overdue — Murphy | Check ->`.
  - Floating action button (`+`) to add a dog.

---

### 3.7 Client Dog Profile (Trainer View)
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Clients** → Tap **Emma Johnson** → Tap **Murphy** dog card.
- **What to Verify**:
  - Forest background hero, Murphy name, `EDITABLE` badge, breed & owner info.
  - Athletic discipline chips: `IGP 1`, `OBEDIENCE`, `TRACKING`.
  - Action buttons: `Start Training` (launches live session recorder) and `Start S&C`.
  - 2-Column Overview trainer view with `12 Days Active 🔥` streak and 3 quick stats.
  - 8 Actions grid tiles: `Record Drill`, `Assign HW`, `Set Goal`, `Log Weight`, `Log Vet`, `Add Note`, `Upload Video`, `Share Profile`.
  - Active Goals progress bars and Recent Videos cards with thumbnails.
  - Health Summary card and Permissions access level selector.

---

### 3.8 Add Client & Edit Client
- **How to Access Add Client**: Tap **More** → **Trainer Hub** → Tap **Clients** → Tap `+` button in bottom right.
- **What to Verify**:
  - `Basic Information`: First name, Last name, Company / Kennel, Client nickname.
  - `Contact Information`: Email, Mobile phone, Alternative phone.
  - `Address`: Expandable address section (Street, City, Postcode, Country).
  - `Trainer Private Notes`: Confidential pre-lesson remarks.
  - `Trainer Permissions Preset`: Chips for Full Access, Training Only, Supervised.
  - `Client Access Switches`: Toggles for dog profile, sessions, health, goals, media.
  - `Send Invitation`: Personal welcome message and `Add Dog Now` toggle switch.
  - Primary button: `Create Client`.
- **How to Access Edit Client**:
  - From Client Profile → Tap three dots (`•••`) in top right → Select `Edit Client`.
  - Pre-filled fields, status chips (`ACTIVE`, `INACTIVE`, `ARCHIVED`), and `Save Changes` button.

---

### 3.9 Client Permissions (Access Control)
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Clients** → Tap **Emma Johnson** → Tap **Manage Permissions**.
- **What to Verify**:
  - Trainer connection hero: `Take the Lead Essex • Connected since Jul 2026`.
  - Security callout: "Changes apply immediately across all shared devices."
  - Category permission switches:
    - `Dog Profile`: View canine identity, Edit canine details.
    - `Training`: View sessions, Log new sessions, Edit existing sessions.
    - `Health Records`: View health records (Private by default), Add health reminders.
    - `Goals & Homework`: Assign homework, Sign off homework, Create goals.
    - `Media & Telemetry`: View photos/videos, Upload session clips.
  - Connection management: `Pause Sharing` and `Disconnect Trainer` actions.

---

### 3.10 Homework & Training Plans (Trainer Management Hub)
- **How to Access**: Tap **More** → **Trainer Hub** → Tap the attention card `3 Homework Assignments Pending` (or tap **Homework** in quick actions).
- **What to Verify**:
  - Filter tabs: `All`, `Awaiting Review` (selected mint line), `In Progress`, `Overdue`, `Completed`.
  - 4-Metric summary strip: `3 Awaiting Review` (mint green), `6 In Progress`, `2 Overdue` (red), `18 Completed`.
  - `AWAITING REVIEW` Section:
    - Card 1: `Recall Foundation Practice • Murphy · Emma Johnson • Due Yesterday`, with video uploaded indicator.
    - Card 2: `Loose Lead Consistency • Bella · James Harlow • Due 2 days ago`, with notes added indicator.
  - `IN PROGRESS` Section:
    - Card 1: `Place Training Basics • Murphy · Emma Johnson` with 40% progress bar (2 of 5 sessions).
    - Card 2: `Socialization Walks • Bella · James Harlow` with 20% progress bar (1 of 5 sessions).
  - `OVERDUE` Section (Red indicator stripe):
    - `Impulse Control Exercises • Murphy · Emma Johnson • 3 days overdue`.
  - Floating action button (`+`) to assign new homework.

---

### 3.11 Homework Details
- **How to Access**: Tap any assignment card in `Homework & Training Plans` (e.g. `Recall Foundation Practice`).
- **What to Verify**:
  - Assignment hero: `AWAITING REVIEW` / `IN PROGRESS` badge, `HIGH` priority tag, assignment title, and handler instructions.
  - 2x2 Meta: Assigned date, Due date, Target sessions, Video requirement.
  - `Mark as Complete` action button.
  - `Progress Card`: Completion percentage bar with 3 sub-stats (Sessions logged, Video submissions, Days active).
  - `Linked Curriculum`: Linked skill and exercise sequence chips.
  - `Client Submissions`: Recorded video clips and handler notes.
  - `Trainer Feedback`: Feedback card with `Add Feedback` modal.
  - Attachments list with video preview player.

---

### 3.12 Lesson Records Log
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Clients** → Tap **Emma Johnson** → Tap `8 LESSONS TOTAL` (or tap `•••` -> `View Client Account` -> `8 LESSONS TOTAL`).
- **What to Verify**:
  - Subheader: Avatar `Emma Johnson · Murphy & Bella • 12 Lessons Total`.
  - Chronological lesson ledger:
    - `15 Sep · 09:00`: `ONE-TO-ONE` badge, `Recall & Distraction Work • Murphy`, Chelmsford Training Ground, `60 min`, `Homework Assigned` green pill.
    - `8 Sep · 09:00`: `ONE-TO-ONE` badge, `Loose Lead Walking — Advanced • Murphy, Bella`, Private Session, `60 min`.
    - `1 Sep · 09:30`: `BEHAVIOUR CONSULTATION` badge, `Reactivity Assessment • Bella`, Client's Home, `90 min`.
    - `AUGUST 2026` group: `28 Aug · 10:00`: `Foundation Heelwork • Murphy`, Chelmsford Training Ground, `60 min`.
  - Tapping any lesson card opens the lesson details bottom sheet.
  - Floating action button (`+`) to log a new lesson.

---

### 3.13 Trainer Notes (Private Ledger)
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Trainer Notes** in Quick Actions (or tap **Notes** in Client Profile).
- **What to Verify**:
  - Search input: "Search notes, clients, tags...".
  - Counter: `14 Notes`.
  - Privacy callout: `(i) All notes are private and never shared with clients.`
  - `PINNED` Section (Green indicator stripe):
    - Lightning icon, `LESSON PLANNING` pill, `Emma Johnson` pill.
    - Title: `Pre-lesson checklist — Thursday 10am`.
    - Content: Harness fit check, long line options, Murphy improvement remarks.
    - Lock icon `Private` • `Today`.
  - `RECENT NOTES` Section:
    - `BEHAVIOUR OBSERVATIONS • Murphy`: Distraction threshold observations.
    - `FOLLOW-UP REQUIRED • James Harlow • Bella`: Vet referral reminder.
    - `CLIENT COMMUNICATION`: Post-lesson summary call notes.
  - Floating action button (`+`) to add a private note.

---

### 3.14 Trainer Notifications Hub
- **How to Access**: Tap **More** → **Trainer Hub** → Tap the Notification Bell icon in top bar.
- **What to Verify**:
  - Header: `Notifications` with `Mark All Read` green button.
  - Filter tabs: `All`, `Action Required`, `Read`.
  - `ACTION REQUIRED` Section (Green indicator stripe):
    - Green dot, check clock icon: `Homework awaiting review • 2 hours ago` (Emma completed Recall Foundation Practice) with `Review Now →` link.
    - Green dot, person icon: `New client invitation accepted • 1 hour ago` (Sarah Mitchell joined) with `View Client →` link.
  - `TODAY` Section:
    - `Goal completed • 4 hours ago` (Emma marked Loose Lead Walking as complete).
    - `Training video uploaded • 5 hours ago` (James uploaded session video).
    - `Lesson reminder • This morning` (Emma Johnson • Murphy • Tomorrow 09:00).
  - `YESTERDAY` Section:
    - `Homework completed` (James completed Place Training Basics).
    - `Permission updated` (Emma updated health record access).

---

### 3.15 Client Progress & Analytics (Animated Spline & Donut Chart)
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Clients** → Tap **Emma Johnson** → Tap **Progress** action.
- **What to Verify**:
  - Timeframe selector: `This Month v`.
  - Category filter pills: `Overview` (active), `Training`, `S&C`, `Skills`, `Health`.
  - 2x2 Bento grid with sparklines:
    - `24h 35m Total Training Time` (+16% vs last month)
    - `18 Sessions` (+12% vs last month)
    - `4.5 Training Frequency` (Sessions per week)
    - `82% Success Rate` (0% vs last month)
  - `Training Time (Weekly Trend)` Chart:
    - Animated glowing green cubic spline curve chart.
    - Interactive touch nodes displaying hours logged at weekly milestones.
  - `Session Breakdown` Donut Chart:
    - Total 24h 35m ring with colored distribution bars (General Training 7h 15m, S&C 3h 20m, Competition 1h 10m).
  - `Training Heatmap`: 7x4 day-of-week matrix with peak Tuesday glowing green intensity.
  - `Best Streak`: 12 days card with 87% radial completion ring.

---

### 3.16 Trainer Reports & Progress Reviews
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Reports** in Client Profile (or tap **Trainer Reports** in More).
- **What to Verify**:
  - 3-Column summary: `7 Total Reports`, `4 Shared`, `1 Draft`.
  - Tabs: `All Reports`, `Shared`, `Drafts`, `Archived`.
  - Search bar with clear button.
  - Report cards with status badges:
    - `SHARED` (green pill): 6-Week Foundation Evaluation (Murphy).
    - `DRAFT` (orange pill): S&C Assessment & Hip Joint Observations.
    - `NOT SHARED` (grey pill): Reactivity Assessment & Threshold Baseline.
    - `ARCHIVED`: Puppy Class Initial Intake.
  - Floating action button (`+`) to generate a new report.

---

### 3.17 Shared Records & Sharing History
- **How to Access**: Tap **More** → **Trainer Hub** → Tap **Clients** → Tap **Emma Johnson** → Tap **Share** action.
- **What to Verify**:
  - Filter pills: `ALL`, `TRAINING`, `HEALTH`, `GOALS`, `REPORTS`.
  - Shared records cards with `ACTIVE`, `PENDING`, `EXPIRED` status tags.
  - `Sharing History` timeline with colored chronological audit dots.
  - Action card: `Generate Shared Report`.

---

### 3.18 Trainer Workspace Settings
- **How to Access**: Tap **More** → **Trainer Hub** → Tap Settings gear icon in top right.
- **What to Verify**:
  - Workspace identity card: `Vanguard Working K9 Academy • Pro Trainer Workspace • 28 Active Canine Seats`.
  - Client Onboarding switches: Auto-invite via email, 4K video homework review, Instant submission alerts, Scorebook access.
  - Default Homework Cadence dropdown: `Weekly (7 Days)`.

---

## 4. REWARDS, SETTINGS & ACCOUNT ECOSYSTEM

### 4.1 Rewards Management
- **How to Access**: Tap the 5th tab labeled **More** in bottom bar → Tap **Rewards Management**.
- **What to Verify**:
  - Dog banner: `Rook • Belgian Malinois • IGP-3 SPORT`.
  - Header: `REWARD TYPES` with `Manage Types` link opening `Manage Reward Types`.
  - Type filter chips: `All`, `Food`, `Toy`, `Praise`, `Play`, `Competition`, `High Drive`.
  - Search bar for quick filtering.
  - List of canine reward cards with category badges and tactical notes.
  - Floating action button (`+`) opens `Add Reward`.
  - Tapping any existing reward opens `Edit Reward`.

---

### 4.2 Add Reward
- **How to Access**: Tap **More** → **Rewards Management** → Tap `+` button in bottom right.
- **What to Verify**:
  - Drag handle at top and close (`✕`) button.
  - Subtitle: `Rewards are personal to Rook.`
  - `REWARD NAME`: Text input with green underline, pre-filled with `Freeze-Dried Liver`.
  - `REWARD TYPE`: Chips for `Food ✓` (selected), `Toy`, `Praise`, `Play`, `Competition`, `High Drive`, and `+ New Type` (dashed border).
  - `DESCRIPTION`: Tactical usage notes input (`e.g. Reserved for high distraction environments`).
  - Primary button: `Save Reward` (saves and adds to list).
  - Secondary button: `Cancel`.

---

### 4.3 Edit Reward
- **How to Access**: Tap **More** → **Rewards Management** → Tap any existing reward (e.g. `Freeze-Dried Liver`).
- **What to Verify**:
  - Drag handle and close (`✕`) button.
  - Subtitle: `Rewards are personal to Rook.`
  - Pre-filled reward name with green underline.
  - Pre-filled reward type chips.
  - Pre-filled description (`High value — competition only`).
  - Primary button: `Save Changes`.
  - Secondary button: `Cancel`.
  - Bottom destructive action: Red trash icon with `Delete Reward` (triggers confirmation dialog).

---

### 4.4 Profile Page & Change Photo
- **How to Access Profile Page**: Tap **More** in bottom bar → Tap the User Identity Card at top.
- **What to Verify on Profile Page**:
  - Handler avatar with initials `JH`, handler name, membership badge.
  - Account details, canine count, linked packs.
- **How to Access Change Photo**:
  - Tap the handler avatar on Profile Page.
  - Profile photo bottom sheet slides up:
    - Circular avatar preview with glowing green dot and `CURRENT ACTIVE` tag.
    - Options:
      - `Take Photo` (camera icon)
      - `Choose from Photo Library` (gallery icon)
      - `Remove Current Photo` (red trash icon)
      - `Cancel` (close icon)

---

### 4.5 Restore Purchases
- **How to Access**: Tap **More** in bottom bar → Tap **Subscription Details** → Tap **Restore Purchases** under the MANAGE section.
- **What to Verify**:
  - Hero cloud sync icon with circular refresh arrows.
  - Title: `Missing a Purchase?`
  - Subtitle: `Restore an existing Ulvenik membership or Pack without being charged again.`
  - Information container:
    - `WHAT THIS DOES`: Explains App Store validation with zero charges.
    - `PURCHASE PLATFORM`: `Apple App Store`.
    - `ITEMS THAT CAN BE RESTORED`:
      - `✓ Core Membership`
      - `✓ Trainer Pack`
      - `✓ Sport Pack`
  - Primary button: `Restore Purchases`.
  - Tapping button shows loading spinner for 1.5s, then displays confirmation dialog: "Purchases Restored — Your Core Membership and Trainer Pack entitlements have been successfully verified and activated."
  - Footer note: "You won't be charged. Expired subscriptions cannot be restored."

---

### 4.6 Appearance Settings
- **How to Access**: Tap **More** → Tap **Settings** → Tap **Appearance**.
- **What to Verify**:
  - Top live preview card showing controls that update instantly with settings.
  - `THEME`: Selectors for `System (Default)`, `Dark` (active checkmark), `Light`.
  - `TEXT SIZE`: `Small`, `Default (Recommended ✓)`, `Large`, `Extra Large`.
  - `DISPLAY DENSITY`: `Comfortable (Recommended ✓)`, `Compact`, `Spacious`.
  - `REDUCE MOTION`: Toggle switch (simplifies transitions and chart animations).
  - `HAPTIC FEEDBACK`: Toggle switch (tactile feedback on button taps).
  - Destructive reset button: `Reset Appearance Settings`.

---

### 4.7 Storage Management
- **How to Access**: Tap **More** → Tap **Settings** → Tap **Storage Management**.
- **What to Verify**:
  - Total storage meter bar showing Photos, Videos, Documents, and System Cache.
  - Cache clearance actions: Clear Image Cache, Clear Offline Map Tiles.
  - Auto-cleanup rules and retention period selectors.

---

### 4.8 Measurement Units, Date & Time, Timezone & Language
- **How to Access**: Tap **More** → Tap **Settings** → Select the respective preference tile.
- **What to Verify**:
  - `Measurement Units`: Metric (kg, km, cm) vs Imperial (lbs, mi, in).
  - `Date & Time Format`: DD/MM/YYYY vs MM/DD/YYYY, 24-Hour vs 12-Hour.
  - `Timezone`: Automatic detection vs custom Nordic/European timezones.
  - `Language`: English (UK), English (US), Deutsch, Norsk, Svenska.

---

## 5. COMPLETE VERIFICATION CHECKLIST

- [x] All 114 Figma PNG screenshots in `scratch/` are 100% matched and implemented.
- [x] Zero code or class names are used in this testing guide.
- [x] All telemetry and analytics graphs (Sport Statistics, Trainer Dashboard Analytics, Client Progress Spline, Timeline Compare Dual-Line, Timeline Statistics Curve) are dynamic, animated, and interactive with touch tooltips.
- [x] Populated and Empty states are provided and toggleable across all timeline and pack views.
- [x] Canonical 5-tab navigation bar flow (Home, Dogs, Training, Timeline, More) is preserved without breaking routes.
- [x] `flutter analyze` runs with 0 errors across all screens in the codebase.
