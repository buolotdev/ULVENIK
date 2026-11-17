# Ulvenik — Client Change Requests: Gap Analysis

Source: 14 PDFs in `C:\Users\Haram\Downloads\Ulvenik-Changes` (13 Nov 2026 review round).
Each section: what the client asks → what the code does today → gap.
Legend: ❌ not done · ⚠️ partially done / needs a closer look · ✅ already matches · ❓ question for client

## Cross-cutting themes (apply everywhere)
1. **Remove intermediate dashboards on every dog-profile tab**: Health ("Open Health Dashboard"), S&C ("Open S&C Dashboard"), Sport ("Open Sport Pack Overview"), Media ("Open Dog Media Library"). Each tab shows its content directly.
2. **Real logo, no mountain**: replace `white_mountain_only.png` (splash, onboarding, welcome, home header, others) with the full approved logo; remove the "THE JOURNEY BUILDS THE WOLF" duplicate.
3. **One shared Record Session form** for Training (main tab, dog tab, skill, exercise), with S&C and Sport variants. Replace every "coming soon" snackbar.
4. **Remove "Sport Dogs"** everywhere (Dogs page, Training filter): only My Dogs + Client Dogs.
5. **Single Save at the bottom** of every form (drop top-right Save); disk icon; Cancel/Back top-left.
6. **Remove tags/categories/favourites** from Skills, Exercises, S&C Activities.
7. **Rating labels**: Excellent / Good / Mixed / Needs Work everywhere.
8. **Analytics template**: 4 stats → line chart → single-month heatmap (4 colour levels, ‹ › arrows) → 7-day Training Patterns → horizontal "Most …" bar chart (session counts, not hours). Time sheet: "Select Time Period" with Lifetime / This Year / Last 6 Months / This Month.
9. **Palette in the PDFs**: #121212 bg, #1C1C1C cards, #2F5D50 green (ours is #101214 / #1A1F22 / #2E6B57). Updating `AppColors` once would cover most of it.
10. **No fake success/data**: no hard-coded sample dogs/counts, no "Export started" without a file, no demo toggles.

## ✅ Done — app-wide pass (16 Nov 2026)
- **Palette**: `AppColors` + all hard-coded hex now #121212 / #1C1C1C / #2F5D50 (85 files).
- **Logo**: new `UlvenikLogo.full` / `UlvenikLogo.wordmark` (`lib/widgets/ulvenik_logo.dart`; assets `logo_full.png`, `logo_wordmark.png` trimmed from the supplied `stacked.png` / `white_text_only.png`). Replaced the mountain on Splash, Onboarding, Welcome, Login, Register, Forgot/Create/Updated Password, Email Verification, About; wordmark on Home + Goals headers. Removed blurred mountain watermarks and Welcome's duplicate "THE JOURNEY BUILDS THE WOLF." line.
- **Icons added** to `UlvenikIcons`: `strengthConditioning` (crossed dumbbells), `rewards` (ball-on-rope), `equipment` (cone), `save` (disk), `listView`, `cardView`, `favourite`, `favouriteFilled`. Archive / Delete / Automatic / Link / Sport / Filter still await client approval.
- **Sport Dogs removed**: My Dogs, Dogs All Workspaces (also removed its subscription banner), Training filters + sample data.
- **Ratings**: shared `lib/widgets/session_rating.dart` (Excellent / Good / Mixed / Needs Work, optional, green tick, Clear rating). Used on Skill Details, Record S&C Session, S&C Session Details, Activity Details; star ratings removed; rating defaults to "Not rated".
- **Single bottom Save**: removed header Save from New Skill, New Exercise, Create Goal, Add Health Record, Create Sport, Add Competition, Add Client, Competition Results. Save icon applied to Save Skill / Save Exercise / Save Session / Save Health Record.
- **Record Session**: new `openNewTrainingSession()` in `training_screen.dart`, which now opens the real form from the dog Training card (renamed to "Training Sessions" / "128 sessions recorded" / "Record Session"), the empty state, the statistics empty state, the Skill page ("Record Session" with the doc+ icon) and the Exercise page. Default title is "Training Session · 16 Nov 2026".

## ✅ Done — sections 1 & 2 (Loading, Onboarding, Sign-in, Welcome, Home)
- **Splash**: full logo + "Train. Record. Progress.", small spinner + "Loading Ulvenik...", leaves as soon as start-up images load (no fake fill bar or timed delay), "Couldn't load Ulvenik" + Try Again on failure.
- **Onboarding**: new copy for all 3 steps, full-width Continue / Get started, centred dots beneath, Skip works (hidden on step 3), Skip and Get started both go to account entry, Back keeps the step, stable text area, stronger gradient, no panning.
- **Welcome**: "Every Session Counts." / "Your training journey, all in one place.", matched Create Account / Log In, "Or continue with" Apple / Google (official icons, no network image), Terms of Service + Privacy Policy links, TRAIN • RECORD • PROGRESS footer, fade-in.
- **Sign-in**: less top space + logo, "Welcome back" / "Sign in to your Ulvenik account.", labels "Email address" / "Password", "Sign in", "or", equal Apple/Google buttons, "New to Ulvenik? Create an account", "Forgot password?", inline errors, double-submit guard, autofill hints, fields no longer hidden by the keyboard.
- **Home**: 15 approved greetings, shuffled per app open and per log-in, name-free fallback. Header: hamburger removed, wordmark centred, 40 px initials button → account. Start Session (doc+ icon) and Quick Log (+ icon) open Training / S&C (Sport only with the pack). Today shows planned and completed items with a green tick; empty state "Your schedule is clear. Ready to get started?" with the Calendar icon. Upcoming is sorted by date with a + that opens "Add to Schedule" (Training / S&C / Custom Reminder). Recent Activity shows the 3 latest completed sessions with a square dog photo and "View All". Insights shows Sessions This Week / Active Days / Training Time, calculated from the session list for the current Mon–Sun week, plus "View Analytics" and an empty state with the Progress icon. Core/Sport/Trainer pills and the streak are removed.
- **Still blocked**: approved onboarding photos; real sign-in, Apple/Google sign-in and first-run vs returning routing (need backend/storage); the Add to Schedule options open the Calendar, because scheduling isn't built yet.

## ✅ Done — section 3 (Dogs & Goals)
- **Shared demo data**: `lib/data/sample_data.dart`, the dogs and goals used by Dogs, Goals, Goal Details and Create Goal, so their counts agree.
- **Dogs**: one "Dogs" screen with My Dogs / Client Dogs (Trainer Pack only) and no pack badges or banners. List View is the default, with a Card View toggle using the new list/card icons; the choice is remembered for the session. Bell with green unread dot opens Notifications. Search by name or breed. Filter sheet: breed, sex, recent activity, sort Alphabetical / Most recently active (with Sort icon), Clear Filters / Apply. Search, Filter and one Add (+) stay fixed while scrolling; the floating + is removed. List cards use a square rounded photo with paw placeholder and "breed · age · sex"; last-activity text and clock are removed. Card View is a wide photo with bottom gradient, with Reposition buttons and sport tags removed. The old "all workspaces" screen now just opens Dogs in Card View.
- **Goals**: Back arrow (no hamburger), dog selector with square photo and Switch Dog sheet (My Dogs / Client Dogs). Active / Completed / Overdue cards are tappable filters with a green highlight; the All/Active/Completed/Overdue pill row is removed; "View All" beside the heading clears the filter; `initialFilter` lets the dog profile preselect Active. Search. Progress bar and percentage only for measurable goals; open-ended goals say so. Floating + opens Create Goal for the selected dog. Streak stat boxes removed.
- **Goal Details**: priority only if chosen, Active/Completed/Overdue + Automatic/Manual, description/notes only when provided. ⋮ menu: Edit Goal (pencil) / Mark as Completed (completed icon) / Archive Goal / Delete Goal; Archive and Delete are text-only because their icons aren't approved, and both ask for confirmation. Automatic goals show "View Linked Sessions"; manual goals show "Update Progress" (number entry, or a note for open-ended goals).
- **Create / Edit Goal**: dog preselected, "My Dog"/"Client Dog" label (Core/Trainer badges and note removed). Training (training icon) / S&C (crossed dumbbells) / Health; Sport only with the Sport Pack and no icon (icon to be confirmed). Approved Automatic/Manual wording, no rejected Automatic icon. Measurable (Sessions / Repetitions / Duration / Distance / Custom + value) or Open-ended. "Link a Record" opens a searchable multi-select of skills, exercises, S&C activities and health records (sport skills with the pack), with "Create a new skill" that keeps the form; no link icon, since it's unapproved. Priority has no default and can be unselected. Due date blank with picker and clear (Calendar icon). Reminder off by default (bell), timing choice, and needs a due date. Notes. One bottom "Save Goal" with the save icon, disabled until a title is entered; it opens the new Goal Details with a success message.
- **Still open**: "Add Dog" has no Create Dog Profile screen to open yet (shows a message); dog cards open the existing single dog profile (Koda) until Dog Overview takes a dog; photo crop/reposition is in the Dog Overview section; nothing is saved between launches.

## ✅ Done — section 4 (Individual Dog Overview)
- **Profile opens the tapped dog** (`DogProfileScreen(dogName:)`) using the shared sample data; other tabs now use that dog's name.
- **Cover**: full-width photo with name and "breed · age · sex" over a gradient; no square thumbnail. A discreet Edit pencil opens the new **Edit Cover Photo** screen (`cover_photo_editor_screen.dart`): drag, pinch-zoom, live preview, Reset, Save / Cancel. Never stretched; the original is kept. Choosing a different photo needs photo-library access (not in this build). Dogs without a photo show a paw placeholder.
- **Header**: Back arrow, ⋮ menu = Edit Profile (pencil) / Archive Dog / Delete Dog. Archive and Delete are text-only with confirmations, and say plainly that nothing is saved yet. No dog switcher.
- **Stat cards** below the cover (not over it), equal size, icon / value / label: Sessions (Record Session icon), which opens session history; Total Time (Training Time icon), real recorded minutes, which opens the Training tab analytics; Active Goals (Goals icon), counted from active goals only, which opens Goals with Active preselected.
- **Tabs**: Overview | Training | S&C | Sport (only with the Sport Pack) | Health | Media, scrollable.
- **Overview**: Skills & Exercises card removed; order is Today's Focus → Continue → Upcoming.
  - **Today's Focus**: sorted by time; "Training · Scheduled 10:00" with Start / Completed ✓; "S&C · Scheduled 17:00" with Start; "Health · Due 08:00" with Log → Given ✓ / Not Given (no tick). "Scheduled Today" / "Due Today" when there's no time. Health **Log** sheet: Given or Skipped / Not Given, actual time, reason/notes, Save, which updates the same entry. Start opens the shared Training form (dog preselected) or the S&C form.
  - **Continue**: up to 3 newest drafts, title + "Training · Saved 2 h ago", **DRAFT badge removed**, Play icon "Resume"; View All when there are more; the whole section is hidden with no drafts.
  - **Upcoming**: next 3 earliest, date block + activity; View All opens the Calendar; tapping opens details (dog, category, date, time) with ⋮ Edit / Reschedule / Cancel and Start Session for Training/S&C. Reschedule updates the same item; Cancel asks first.
- **Still open**: Training tab content, S&C, Health, Sport and Media tabs (their own sections); "Edit Profile" opens the cover editor because there's no dog-details form; Resume opens the draft by title but can't restore fields (no saved drafts); completing a Start doesn't auto-tick the Focus item yet (needs saved sessions).

## ✅ Done — section 5 (Bottom-nav Training Sessions)
- **Header**: "TRAINING" label and hero photo removed; compact "Training Sessions" + "Across all dogs" (or the chosen group); the original Ulvenik mark (`brand.png`) is large, faded and cropped at the right edge. Bell, Export, Activity Library and Rewards & Reinforcers shortcuts removed.
- **Action stack**: full-width green **Record Session** (doc+ icon) → charcoal **Strength & Conditioning** (crossed dumbbells), which opens a dog picker and then that dog's profile on the **S&C tab** (`DogProfileScreen(initialTab: 'S&C')`), not the old dashboard → charcoal **Continue Draft** (Play icon). Continue Draft is hidden with no drafts, opens the draft directly with one, and shows a "Choose a Draft" sheet (newest first, dog + title) with several.
- **Search** "Search sessions, dogs or skills..." live, with clear, no microphone. **Dogs**: All Dogs / My Dogs / Client Dogs (only with client access). **Date Range · Lifetime** opens "Select Time Period" (Lifetime / This Year / Last 6 Months / This Month, green tick, applies and closes), with an × back to Lifetime. **Recent Sessions** with Newest / Oldest First, now sorted by the recorded date and time (backdated sessions land in the right place). Drafts are no longer mixed into the list.
- **Cards**: compact title + "Dog · 15 Sep · 08:15 · 8 min" + chevron; blank thumbnail, skill chips and counts removed.
- **Saved Session Details**: header image = dog photo when there is one, otherwise no banner (skills have no images yet), kept shallow. One **Edit Session** under the summary (bottom Edit, More Options and bottom Delete removed). ⋮ = **Share Session** (copies the session link, "Share link copied") / **Export as PDF** / **Delete Session** (last, confirm); Duplicate removed. Export as PDF honestly says "Couldn't export PDF – not available in this build yet" instead of the fake "Export started". **Skill Tags and Tags boxes removed**; **Manage Media removed** and tapping media opens the photo/video viewer. **Rewards Used / Equipment Used** shown read-only with the new icons, only when present.
- **Rewards & Equipment** (shared `lib/widgets/session_items_picker.dart`): separate optional multi-select fields with ball-on-rope / cone icons, an add-new box in the same sheet, and a shared library. Added to both the **Training** recording form and the **S&C** recording form.
- **Still open**: real PDF generation needs packages (`pdf` + `share_plus`); share links won't open until there's a backend; More › Export Data and More › Rewards & Equipment are covered in the More section.

## ✅ Done — section 6/7 (Dog › Training analytics, v09 + v34)
- Rewrote `statistics_tab.dart`. All figures are **calculated** from one set of demo sessions per dog and the chosen period (no hard-coded numbers); a session counts once, and skills / exercises / locations count once per grouping.
- **Categories**: Overview | Skills | **Exercises** | Locations (S&C removed; it has its own dog tab). They scroll sideways on narrow screens. **Select Time Period** sheet (Lifetime / This Year / Last 6 Months / This Month, green tick, applies at once) drives every category.
- **Overview**: Avg. Duration, Sessions / Week, Total Sessions, Most Active Day (durations only from sessions that recorded one). Removed: "Most Trained Skills" (moved to Skills) and "Annual Goals".
- **Training Activity** (was "Training Sessions Over Time") with "Track how frequently you've trained over time.", tap a point for the exact count. **Training Activity Heatmap**: one full calendar month, ‹ › arrows independent of the period, day numbers, four levels (charcoal 0 / muted 1 / medium 2 / strong 3+) with a colour key and "SESSIONS PER DAY", tap a day for date and count. **Training Patterns** with "Most Active: Saturday" (dynamic, no repeated count), tappable bars.
- **Skills**: Skills Trained + Most Trained Skill; distinct skills per month / per day / per weekday; "Most Trained Skills" bar chart in **sessions, not hours**. **Exercises**: Exercises Trained + Most Trained Exercise, same charts, "Most Trained Exercises". **Locations**: Locations Trained + Most Used Location, "Most Used Locations"; only user-recorded locations count and unlabelled sessions stay in Overview only.
- Empty states: "No Statistics Yet" when there is no data or none in the period.
- **Still open**: backed by demo data until sessions are saved; the optional Training Location field on the Record Session form is not wired (see Skills & Exercises section).

Still app-wide but not done: removing the intermediate dashboards on the dog-profile tabs (each needs its tab content built, so it's handled per section).

## ✅ Done — Skills & Exercises (v58)
- **Skills list**: title "Skills & Exercises"; filters All / Recent / Focus Areas; sort sheet; two stat cards; cards show name, "N Exercises" and "Last trained…" only when sessions exist; Focus Area marked with a green dot; Add Skill button.
- **New Skill**: no Information heading/asterisk; inline "Please enter a skill name."; Skill Photo + Notes; single Save Skill; tags/organisation removed.
- **Skill details**: no Foundation/Outdoor tags; Record Session + Add Exercise; editable notes/cover/progress (copy "Update your dog's progress based on your own assessment."); session card opens the session; ⋮ menu with approved Archive/Delete copy.
- **New / Edit Exercise**: Linked Skill card ("This exercise belongs to {skill}."), inline name error, description hint, Exercise Photo ("Using {skill}'s photo" / Choose Different Photo / Use Skill Photo), tags removed, one Save button; Edit has back arrow only.
- **Exercise details**: title "Exercise Details"; tags and circular action row removed; order Cover > Name > Description > one Record Session > Linked Skill ("View {Skill}" opens the skill) > Active Goal > Recent Sessions (3 newest + View All Sessions); success rate is a typed 0-100 value; ⋮ menu Edit / Archive / Delete with approved copy; rename from Edit is reflected.
- **Photos**: added `image_picker` + shared `lib/widgets/photo_picker.dart` (Take Photo / Choose from Library, clear message if access is denied). Wired into New Skill, New Exercise, Edit Exercise and the dog cover (then crop). iOS camera/photo usage strings added. Not yet exercised on a real device.
- **Still open**: real persistence (demo data), unapproved Archive/Delete/Link icons stay text-only/Material.

## ✅ Done — Health (v6, partly)
- **Health tab** (`health_tab.dart`): no dashboard/dog selector. Health Records shortcut (live record count) + Health Reminders shortcut (next item + Add Reminder) > Health Overview: exactly two stat cards (Current Weight with change since last entry, Body Condition n/9), compact Weight History preview, Upcoming Health (max 3, soonest first, View All Reminders, exact empty state "No Upcoming Health Events"). Per-dog data from `lib/data/health_store.dart`; missing data shows "Not recorded / No entries".
- **Health Records** (`health_records_hub_screen.dart`): exactly 12 categories, 6x2 in the approved order, distinct icons; grid stays visible with "No Health Records Yet" + Add Health Record when empty.
- **New screens**: Weight Records (units kg/lb, backdated entries, 4 date filters, tappable chart points, edit/delete), Body Condition (1-9 picker, guide, chart, history), Parasite Prevention, Reproductive Health (Heat Cycles, Matings, Pregnancy, Whelping, Male records, Spaying & Neutering; sex-aware), Other Records, Health Reminders (upcoming / overdue / completed, full Add Reminder form with repeat, notifications timing, complete/edit/delete).
- Removed "coming soon" search/filter from the legacy Health Records screen. Detail screens have the three-dot Edit Record / Delete Record (confirmed).
- **Remaining categories built to the PDF field lists** (all in `health_log_screen.dart`, dog-scoped, backdated dates, attachments via `file_picker`, optional reminder created from the record): Medications (Active/History, Given/Skipped dose history, Prescribed By + Administration Method), Supplements (no Prescribed By / Administration Method; Brand + Purpose), Vaccinations with Titre Tests inside, Vet Visits (Upcoming Appointments / Visit History, same record updated after the visit), Allergies & Medical Conditions (one shared form, two sections, Active/Resolved), Injuries & Rehabilitation (linked, Active/Recovering/Resolved, rehab links to an injury), Documents (title, original date, file, linked records).
- **Still open**: attachments are stored by file name only (in memory), no view/download of the file itself; device notifications need a notifications package + permission; the old standalone medication/supplement/vaccination/vet/allergy/injury/documents screens are no longer reachable from Health (files left in place); icons for scale / body condition / stethoscope aren't in the approved set (Material used).

## ✅ Done — Strength & Conditioning (v53 Part A)
- **S&C tab** (`sc_tab.dart`): no dashboard/dog selector. Activity Library card (crossed-dumbbells, live count, chevron) > S&C Sessions card (live count + Record S&C Session) > S&C Analytics (Overview | Activities | Progress; no Locations). Data from `lib/data/sc_store.dart`; no preloaded activities.
- **Activity Library**: search + one Sort (Recently Used / Alphabetical / Most Trained), no categories/filters/favourites, cards "N Sessions · Last: date" or "0 Sessions · Not yet trained", Add Activity FAB, ⋮ > Archived Activities (restore; search/sort preserved), exact empty states.
- **Add/Edit Activity**: name (required), description, measurement checkboxes (Repetitions, Sets, Duration, Distance, Resistance / Weight) with user-selected units, no default unit; saved values keep their own unit.
- **Activity Details**: description, measurements, Record S&C Session (activity preselected), recorded sessions newest first (open the session), ⋮ Edit / Archive / Delete (delete keeps session history; confirmation says so).
- **Record S&C Session**: optional name (default "S&C Session · date"), editable date/time, timer or manual duration, several activities with their own measurement fields + unit, Rewards/Equipment sheets (shared with Training), notes, photos/videos, optional rating Excellent/Good/Mixed/Needs Work (no Success Rate). One session saved; opens Session Details.
- **Session Details** (⋮ Edit / Delete, no Archive) and **S&C Sessions History** (search by name, Date Range, Newest/Oldest, S&C only).
- **Analytics**: Overview (Total S&C Sessions, Total Duration, S&C Activity line, one-month heatmap with its own arrows, S&C Training Patterns w/ Most Active), Activities (Activities Trained, Most Trained Activity, distinct-activity line/heatmap/weekday, Most Trained Activities bars), Progress (Activity + Measurement dropdowns, Select Time Period, one graph per unit, tap a point > Open Session, exact "No Progress Data Yet" empty state).
- **Still open**: media/attachments are stored by file name only (in memory); old dashboard/archive/settings S&C screens are no longer reachable from the tab (files left in place); S&C data is in memory only.

## ✅ Done — Sport Pack (v29)
- **Sport tab** (`sport_screens.dart`): no Sport Pack Overview / dashboard. Cards for My Sports, Sport Sessions (+ Record Sport Session) and Competitions & Trials. Data in `lib/data/sport_store.dart`; no preset sports, skills, exercises or competitions.
- **My Sports**: user-created sports with live skill/exercise/session counts, + adds, ⋮ > Archived Sports (Restore Sport; empty "No Archived Sports"), search + the existing sort options kept across the Archived visit, empty "No Sports Yet". Add/Edit Sport: name required, description + notes optional. Edit / Archive / Delete (delete keeps sessions and competitions).
- **Individual sport**: Sport Skills & Exercises, Sport Sessions, Sport Progress (+ Competitions & Trials filtered to that sport). Skills & exercises are user-created, with edit / archive / delete.
- **Record Sport Session**: one record for several sports; each with its own skills/exercises; optional per-sport minutes only when 2+ sports; one overall duration; rewards, equipment, notes, media, rating. Launched from a sport it preselects it. Details (⋮ Edit / Delete), history (search, date range, newest/oldest, sport names on cards) per sport and overall; exact empty states.
- **Sport Progress**: Total Sport Sessions, Total Training Duration (single-sport = session time; multi-sport = only time entered for that sport, never divided), Training Activity line, monthly heatmap, Skills Trained / Exercises Completed, Most Trained Skills & Exercises (tap opens the item), Training Patterns with ties; exact "No Sport Progress Yet" empty state.
- **Competitions & Trials**: main (all sports) and per sport views of the same record; Upcoming (soonest first) moves to History automatically when the date passes; all approved fields + custom result fields + attachments + optional reminder timing; Edit / Archive / Delete; Archived Competitions with Restore; empty "No Competitions Yet".
- **Still open / blocked**: linking existing Core skills/exercises to a sport (the Core Skills screen keeps a private demo list, no shared store); attachments by file name only; reminders saved as a preference, no device notifications; in-memory data; old Sport Pack screens unreachable from the tab (files left in place).

## ✅ Done — Dog Profile › Media
- **Media tab** (`dog_media_library.dart`): opens the dog's library directly (no Media & Highlights card, no statistics row). Media Library heading + green Add Media; "Search media..." + one filter button; tabs All / Photos / Videos / Documents / Collections / Favourites; three-column grid (play icon on videos, file-type tile for documents); ⋮ > Media Storage.
- **Data** (`lib/data/media_store.dart`): one item per file per dog; no sample media. Files attached inside S&C sessions, Sport sessions, competitions and Health records appear automatically and stay linked (one tile however many links). Training sessions can be linked from Add Media / Edit Details (the Training form has no file picker yet).
- **Add Media**: several mixed files at once, optional title, editable (backdated) media date separate from upload time, description, personal collections (create inline), links to existing records; a failed save keeps files and details; a retry reuses files already added.
- **Collections**: automatic (named after linked skills/activities/sports/records, live names, empty ones hidden) and personal (create / rename / delete, visually distinct); Favourites with a green filled heart; filter sheet (date range, source, sort Newest / Oldest / Recently Added, collection, favourites only; Apply / Clear); distinct no-results state; all six empty states.
- **Viewers**: swipe gallery for the opened list, photo zoom, video playback (stops when swiping away), in-app PDF viewer with Download / Share, linked-record chips (Back returns to the viewer), ⋮ Edit Details / Add to Collection / Download-Save / Delete Media (linked-record warning). Long-press selection with count + bulk Add to Collection / Download / Delete (linked warning).
- **Edit Details**: title, description, media date, link / unlink records; updates every view.
- **Not verified / open**: video, PDF, share and save use new packages (`video_player`, `pdfrx`, `share_plus`) and were not run on a device; no loading/failure states (data is in memory); Media Storage shows used space only (plans and limits are deferred in the PDF); old media screens are no longer reachable (files left in place); Training session attachments are not captured.

## ✅ Done (partly) — Timeline (final handoff)
- **Main Timeline** (`timeline_screen.dart`, `lib/data/timeline_store.dart`): one feed *derived* from the saved originals (Training, S&C, Sport sessions, competitions, Health records / weights / body condition, manual Milestones) so each card opens its exact original by type + ID + dog. Compact dog header + Switch Dog / All Dogs, "Search events...", one Filters sheet (multi-category, Lifetime / This Year / Last 6 Months / This Month / Custom, photo-or-video only; draft with Apply / Reset), visible Newest / Oldest First, Add Record (Training, S&C, Health, Milestone, Competition), Today / Yesterday / Month-year groups, exact "No Matching Events" copy. Removed: stats rows, cadence chart, bell, Settings / Insights / Dashboard / Event Details pages.
- **Favourites**, **Timeline Archive** (select, Select All, Restore n Events? confirmation, Export, "Original Record Deleted" + Remove Reference), **Timeline Export** (Specific Events / Date Range, PDF or CSV, Preparing > Export Ready with Save File / Share File, exact validation text), **Statistics** (total, categories that add up, bar chart with daily / monthly / yearly buckets, export), **Compare** (two ranges, presets, swap, category, signed differences, export), **Memories** (On This Day / This Month, category + year selectors), **Calendar** (Month / Week / Day, selected-day list, Today, category, inline Add Record) with **Calendar Search** (recent queries, attachment names), **Add Milestone** + milestone details.
- **Not built**: Activity Map (records hold no saved coordinates), Smart Collections, Home Widgets, Session Templates / Library Archive, Share This Memory (Copy Link / Save Memory Card), reminders for Health follow-up / competitions as real notifications, Goals as Timeline events (goals are demo data with no editable store), Health follow-up / Competition status editing from the spec, Rewards/Equipment columns in exports, per-photo thumbnails in PDF, session share-link flow.
- **Caveats**: Training sessions on the Timeline are the app's existing demo sessions; favourites / archive / milestones are in memory; PDF/CSV, Save and Share were not run on a device.

## ✅ Done (partly) — More, Settings & Trainer
- **More hub** (`more_hub_screen.dart`): one compact profile card (saved photo/initials + display name, no sample name/email/plan) and four groups: Your Tools, Settings, Support, About & Legal, with the approved labels (Subscription, Storage & Sync, Notification Settings, Search All Records, Rewards, Trainer Workspace). Real build version via `package_info_plus`. Account Settings, Privacy & Security reuse the existing sheets.
- **Saved settings** (`lib/data/app_settings.dart`, `shared_preferences`): one source of truth, written to the device immediately; a failed write shows an error and keeps the old value. **My Profile** (photo, First name required, Last, Display name, exact helper text, one Save Changes, Keep Editing / Discard Changes). **Appearance** (text size Small / Standard / Large / Extra Large applied app-wide, Reduce Animations, Touch Feedback, Reset to Defaults with scope). **Regional Preferences** (kg/lb, km/mi, date format, 12/24-hour, week start, example values, one Save Changes). **Notification Settings** (Push, per-category toggles disabled when off, Quiet Hours with start/end, Product News, App Icon Badge).
- **Rewards and Equipment** (`rewards_equipment_screens.dart`, `lib/data/item_library.dart`): two equal, fully custom, persisted libraries with search, add / edit (exact approved copy), custom types (Add type, Manage types), archive / restore. Nothing is preloaded; the Training / S&C / Sport session pickers now read and write this same library (the four seeded sample items are gone).
- **Support forms** with the exact final copy: Contact Support, Report a Bug, Suggest a feature (private form). They validate and keep input, but nothing can be sent (no support service); the app says so.
- **Trainer Clients** (`trainer_clients_screens.dart`, `lib/data/trainer_store.dart`, saved on device, no sample clients): directory with one search (name / dog / email), staged filters (Status All current / Active / Inactive / Archived, outstanding homework, pinned) with removable chips and real counts, Pin / Unpin, one Add Client, per-card menu (Edit Client Details, Pin, Client Notes, Archive / Restore), exact empty vs no-match states; Add / Edit Client; client detail (Client since, linked dogs, "No session scheduled", Assign Homework); Homework list (progress separate from due timing, opening a row never changes it) and Assign Homework form (title, instructions, dog, optional due, Save Draft; says it is saved to the journal, not sent); private Trainer Notes.
- **Trainer Access** (`trainer_access_screen.dart`): per client; trainer > client header with included dogs; presets Read Only / Training & Homework / Custom that really set the switches; grouped expandable sections (Dog Profile, Training, S&C, Goals, Homework, Media, Reports, Shared Notes) with View / Add / Edit / Delete using plain labels; View required first; staged edits with one Save Changes, Discard Changes, Keep Editing / Discard prompt on leave; real access history (actor + time); Health shown as owner-controlled with no self-grant; private notes never granted. Saved on device; not enforced anywhere yet (no backend / owner side).
- **Trainer Profile** (`trainer_profile_new_screens.dart`): one saved business identity (More > Trainer Profile), no preview, no verified / accredited claims; actual active-client and client-dog counts; separate focused forms — Add / Edit Bio, Edit Expertise (add / remove tags), Edit Contact (email / URL validation), Add / Edit Qualification (title required, organisation, date awarded, expiry or Does not expire), Add / Edit Service (name required, description, duration, price amount + currency + per session / hour / day, or Price on enquiry) with remove — plus the pencil's Edit Trainer Profile (business name, trainer name defaulting to My Profile). Every form has one Save Changes and a discard prompt; saved on device.
- **Not built (Trainer)**: business photo / cover, reports and analytics, Workspace Settings route fix, client sessions / goals / Training-S&C routing, sending anything to a client (no backend), Shared Records / export.
- **Not built**: theme choice (only Dark exists, so no Light / Device selector), Country / Language / Time Zone (need country, translation and zone datasets), App Lock / 2FA / Signed-in Devices, real subscription / billing / storage / sync state, Trainer clients, workspace, profile, reports and analytics, Notifications Inbox rewrite, Settings search, real notification permission / scheduling, units not yet applied across existing record screens.

## ✅ Done — data now survives a restart
- Health (weights, body condition, reminders, all category records), S&C, Sport (sports, skills / exercises, sessions, competitions), Media (items, collections, favourites, record links rebuilt from saved keys) and Timeline (favourites, archive, milestones) now save to the device after every change and load at app start (`lib/data/persist.dart`; writes are queued so the newest data always wins). IDs are time-based so they can't clash after a restart. The old Health demo data (Murphy / Bella) was removed.
- **Still not saved**: Training sessions and skills (they are the app's built-in demo data with their own stores); Goals, Dogs, Trainer / settings already were. Media only stores each file's path: if the system clears a temporary copy, that file shows as unavailable. Nothing syncs between devices.

## ✅ Done — Dogs now a real persisted data model
- New `DogsStore` (`lib/data/dogs_store.dart`), same pattern as `GoalsStore`: seeded once from the existing sample dogs, then every change (a chosen cover photo and its saved framing, Archive Dog, Delete Dog) writes to the device and survives a restart. `SampleData.dogs` / `myDogs` / `clientDogs` / `dogNamed` now delegate to it (archived dogs excluded, same as other stores' archive lists).
- Dog Profile's ⋮ menu **Archive Dog** and **Delete Dog** actually archive/delete the saved dog and return to the Dogs list, instead of the "not saved in this build" message. The Edit Cover Photo flow now saves the picked photo (by path, like the My Profile photo) and its crop/zoom framing to the same record, so reopening the profile shows the same photo and framing.
- Updated every screen that rendered `dog.photoUrl` directly (My Dogs cards, Goals' dog switcher, Timeline's dog avatar, the Training session header image) to use the new `dog.photoProvider`, so a user-picked photo displays everywhere a seeded one used to.
- **Still open**: no Create Dog Profile / Add Dog screen yet (unchanged from before); nothing restores an archived dog from the UI yet (no Archived Dogs screen, matching how this was already flagged for Sport/S&C's own archive screens elsewhere in this doc).

## ✅ Done — remaining Timeline items
- **Competition status** (Upcoming / Completed / Withdrawn / Cancelled, saved): a past date alone never marks it completed — a still-Upcoming past competition shows "Did this competition take place?"; reminders only for Upcoming.
- **Smart Collections** (`timeline_collections_screens.dart`): built-in groups (By Date, With Attachments, By Record Type, Health) + custom definitions (name, record type, photos/videos, minimum minutes for Training / S&C, plain-language rule, live count); pin / unpin, archive / restore, search, Sort (Grouped / Most Events / Pinned First), type filter, exact empty states. Matching Records open the originals. "Added Recently" is not offered (records have no creation date).
- **Home Widgets** (`home_widgets.dart`): Recent Records, Today's Records, Upcoming Health Reminders, Latest Weight, Recent Photos, Recent Videos as in-app panels on Home; one per type, Small / Medium / Large, saved dog scope, Add to Home / Added to Home, Edit Home Layout (Move Up / Down / Remove, Save Layout, Reset). Active Goals is omitted (goals are demo data).
- **Session Templates + Library Archive** (`session_templates_new.dart`, S&C only): real saved templates per dog, search, Sort (Recently Used / Most Used / A-Z / Favourites First), Filters (activity, favourites), create / edit with duplicate-name check, review sheet, Use Template (opens the S&C form pre-filled; a use is counted once, only when that session is saved), Save as Template from a session, Export Templates (PDF / CSV), Library Archive (Activities / Session Templates with Restore).
- **Share This Memory**: preview card then Save Image (PNG). **Copy Link is not offered** — there are no shareable links.
- **Activity Map**: shows the exact empty state; no map yet because records don't store locations.
- **Still not built**: a real Activity Map, Training-type templates (Training sessions can't be pre-filled), Goals as Timeline events.

## ✅ Done — remaining More / Settings / Trainer items
- **Preferences now applied**: dates (`14 Mar 2026` / DD/MM/YYYY / MM/DD/YYYY / YYYY-MM-DD) and 12/24-hour time follow Regional Preferences everywhere via the shared `fmtDate` / `fmtTime`; weights display in the chosen kg / lb (charts, history, Health tab) without changing saved entries.
- **Settings search** on the More hub (filters rows, clear no-results message).
- **Country or region** (searchable list of 190+) and **Time zone** (Use device time zone, or a searchable list of named zones with the real UTC offset for today, daylight saving included) saved with Save Changes.
- **App Lock** (`app_lock.dart`, `local_auth`): off until set up; turning it on or off needs the device prompt; lock screen on cold start and after returning from the background; clear message when the device has no screen lock. Android (`FlutterFragmentActivity`, `USE_BIOMETRIC`) and iOS (`NSFaceIDUsageDescription`) set up — needs a real device test.
- **Trainer business photo and cover** (Change cover / business photo) and **Client Report** (homework assigned / completed / in progress / not started / overdue with the denominator stated, PDF or CSV, no private notes).
- **Still not built**: Light theme, Language translations, two-factor authentication, Signed-in Devices, real subscription / billing / storage / sync state, Notifications Inbox rewrite, Training-type templates, real Activity Map, Goals as Timeline events, Copy Link, linking Core skills to a sport, and anything needing a server.

## ✅ Done — more of the remaining items
- **Link Core skills to a sport**: individual sport > ⋮ > Link a Training skill (lists the Training skills; one skill, shown "Linked from Training", nothing copied).
- **Notifications Inbox** (`notifications_inbox_screen.dart`): only reminders that have actually come due (a future reminder never appears as received), dog + type + time on each row, Mark all as read, Mark as unread, Archive / Restore notification, tabs All / Unread / Archived; reading or archiving never completes the reminder; tap opens the reminder.
- **Training templates**: Session Templates now hold S&C or Training templates (explicit type; skills from the Training catalogue). Use Template opens a fresh Training draft pre-filled with skills, equipment and rewards; Times used is counted from completed sessions carrying the template tag. Reachable from More > Session Templates (dog picker) and the S&C tab.
- **Still not built**: Goals as Timeline events (goals are fixed demo data with no achievement date), real Activity Map, Light theme, Language translations, two-factor authentication, Signed-in Devices, real subscription / billing / storage / sync, Copy Link, and anything needing a server.

## New icons needed (not in `UlvenikIcons`)
S&C crossed dumbbells · Rewards (ball-on-rope) · Equipment (training cone) · List view · Card view · Save (disk) · Archive · Delete (bin) · Heart (favourite). Client says **don't invent** Automatic, Manual, Link, Archive, Delete, Sport or Filter icons until approved.

## Blockers / need from client or a decision
- **Assets**: full Ulvenik logo file(s) to use (we have `white_app_logo.png`, `white_stack.png` etc. — confirm which is "approved"), and dog/training photos for onboarding.
- **Packages** for real features: `image_picker` (camera/library), `pdf` + `share_plus` + `path_provider` (export/share), `shared_preferences` (first-run, remembered view, settings persistence), `file_picker` (documents), video player.
- **No backend**: many specs (live counts, sync, no duplicates, persistence, notifications) need a data layer. In the current prototype we can only do UI, copy, navigation and local state.
- Questions for client from Welcome review: does a new user add a first dog before dashboard? do Apple/Google sign-ups follow the same onboarding?

---

## 1. Loading, Onboarding & Sign-in — `ULVENIK_Loading_Onboarding_Sign_In_Review.pdf` (4 pp)
Screens: `splash_screen.dart`, `onboarding_screen.dart`, `login_screen.dart`

### Splash / loading
| Request | Current code | Status |
|---|---|---|
| Centre the real Ulvenik logo + "Train. Record. Progress." under it | Uses `white_mountain_only.png` (the "generic mountain placeholder"); no tagline | ❌ |
| Small loader + label "Loading Ulvenik..." | Label is "Preparing your training journey..." | ❌ |
| Indeterminate indicator unless progress is measurable; no artificial delay | Fake determinate bar, fixed 1.2 s fill + 2.4 s anim timers (`splash_screen.dart:45,103`) | ❌ |
| Failure state with Retry | None | ❌ |
| First-run → intro; returning signed-in user → normal destination | Always goes to onboarding (no persistence exists) | ❌ (needs storage) |

### Onboarding (3 screens)
| Request | Current code | Status |
|---|---|---|
| Replace mountain placeholder with exact full logo | `white_mountain_only.png` at `onboarding_screen.dart:254` | ❌ |
| Theme: #121212 bg, #1C1C1C surfaces, #2F5D50 green | AppColors uses #101214 / #1A1F22 / #2E6B57 | ⚠️ (close but not exact — confirm whether to change global palette or just these screens) |
| Stronger dark bottom gradient; consistent heading/paragraph/Skip/footer positions | Needs check/tune | ⚠️ |
| Full-width primary button: "Continue" (1-2), "Get started" (3) | Button exists, label "Get Started" (capital S); verify full width | ⚠️ |
| 3 dots centred **beneath** the button | Check layout | ⚠️ |
| Skip top-right on 1-2; may be hidden on 3 | Skip shows "Coming soon" snackbar (`onboarding_screen.dart:262`) | ❌ |
| New copy: 1 "Welcome to Ulvenik" / "Keep your dog's training, records and progress together in one place." 2 "Train your way" / "Create your own skills, exercises, rewards and equipment to suit you and your dog." 3 "Record the work. See the progress." / "Bring sessions, health records, notes and media together to review your dog's progress over time." | Old long copy + titles "Train Your Way", "Track What Matters" | ❌ |
| Back/swipe keeps step | Verify | ⚠️ |
| Imagery: real dog/training photos | Uses mountain landscapes `bg-images/onboarding_1-3.png`. Client says "use approved supplied assets" — **we need the photos from the client** | ❌ (blocked on assets) |

### Sign-in
| Request | Current code | Status |
|---|---|---|
| Less empty space above heading; add logo | Has `brand.png`, large top gap | ⚠️ |
| Heading "Welcome back", subtitle "Sign in to your Ulvenik account." | "Welcome Back" / "Sign in to continue your training journey." | ❌ |
| Labels "Email address", "Password" | "Email Address" | ❌ |
| Primary "Sign in", divider "or" | Check button text (screenshot shows "Log In") | ❌ |
| "New to Ulvenik? Create an account" link | Has "Sign Up" link | ❌ (wording) |
| Same-size Apple/Google buttons, proper branding | Exist, SVG logos | ✅/⚠️ verify sizes |
| No prefilled credentials | Controllers start empty in code ✅ (screenshot showed a test email — likely browser autofill) | ✅ |
| Inline errors, keep email on failure, prevent double submit | Inline errors exist; check double-submit guard | ⚠️ |
| Keyboard open / large text: nothing clipped | Verify | ⚠️ |

---

## 2. Welcome + Home Dashboard — `Ulvenik_Review_v07.pdf` (6 pp)
Screens: `welcome_screen.dart`, `homepage_screen.dart`

### Welcome
| Request | Current | Status |
|---|---|---|
| Full Ulvenik logo instead of mountain | Mountain image | ❌ |
| Remove "THE JOURNEY BUILDS THE WOLF" text | Present (`welcome_screen.dart:51`) | ❌ |
| Heading "Every Session Counts." | "Welcome to Ulvenik" | ❌ |
| Sub "Your training journey, all in one place." | "Choose how you'd like to continue." | ❌ |
| Create Account / Log In identical size | Verify | ⚠️ |
| "Or continue with" between main buttons and Apple/Google | Check | ⚠️ |
| Official Google icon; Apple/Google aligned | Apple uses `Icons.apple`, Google present; both "Coming soon" | ⚠️ |
| Footer "TRAIN • RECORD • PROGRESS" spaced | Missing | ❌ |
| Fade-in, press feedback, Terms/Privacy links | Check; legal links missing | ❌ |
| Questions for Shaban (onboarding/add first dog flow) | — answer to client | ❓ |

### Home dashboard
| Request | Current | Status |
|---|---|---|
| 15 rotating greetings with {Name}, shuffled, name-free fallback | Fixed "Welcome back, James." / "Ready to work." (`homepage_screen.dart:227`) | ❌ |
| Header: remove mountain icon, centred official ULVENIK wordmark | Mountain image (`:171`) | ❌ |
| Remove hamburger menu | `Icons.menu` at `:161` | ❌ |
| Profile circle 36-40 px with initials/photo → account settings | Check | ⚠️ |
| Start Session (Record Session icon) → choose Training / S&C (/ Sport) | Snackbar "coming soon" (`:342`) | ❌ |
| "Log Activity" → rename **Quick Log** (Add icon), retrospective entry | Snackbar (`:352`) | ❌ |
| Today: scheduled + completed, green tick, tappable; empty text "Your schedule is clear. Ready to get started?" + Calendar icon | Empty sub-text still "Rest days are essential for performance." | ❌ |
| Upcoming: Training/S&C/reminders by due date; + opens "Add to Schedule" (Training / S&C / Custom Reminder) | Static rows (Competition/Vet/Lesson), header "VIEW ALL", no + | ❌ |
| Recent Activity: 3 latest sessions, square dog photo, name, type, date, duration, "View All"; History icon | Header says "VIEW TIMELINE" | ⚠️ |
| Insights: Sessions This Week / Active Days / Training Time, "View Analytics", Progress icon | Header "VIEW STATS"; check stat labels | ⚠️ |
| Sport Pack integration rules (one dog profile, no 6th tab, etc.) | Architecture rules — affect Dogs & Start Session | ⚠️ |

---

## 3. Dogs & Goals — `ULVENIK_Dogs_Goals_COMPLETE_Icons_Fixed.pdf` (4 pp)
Screens: `my_dogs_screen.dart`, `dogs_all_workspaces_screen.dart`, `goals_list_screen.dart`, `goal_details_screen.dart`, `create_goal_screen.dart`

| Request | Current | Status |
|---|---|---|
| Remove "Sport Dogs" category; only My Dogs + Client Dogs (Trainer) | 3 pills incl. Sport Dogs (`my_dogs_screen.dart:44`) | ❌ |
| Title "Dogs" on both layouts; remove all promo/subscription banners | Check banners; pills show pack badges ("Core", "Sport Pack") | ❌ |
| List view default + Card view toggle (icons I01/I02), remember choice | Check toggle; no persistence | ⚠️ |
| Bell with green unread dot | Check | ⚠️ |
| Search name/breed; filters breed/sex/activity; sort A-Z / recent; Clear | Check | ⚠️ |
| Search/Filter/Add sticky while scrolling | Check | ⚠️ |
| Only ONE Add (+) beside search; remove FAB and + on cards | Both header + and FAB (`:61`, `:182`) | ❌ |
| List cards: square rounded photo, paw placeholder | Check | ⚠️ |
| Remove last-activity text + clock icon ("Obedience · 2 hrs ago") | Present (`:80,100,107`) | ❌ |
| Remove Reposition buttons + sport tags from cards | Check | ⚠️ |
| Edit Goals screen: hamburger → Back arrow | `Icons.menu` (`goals_list_screen.dart:50`) | ❌ |
| 3 summary boxes clickable as filters, selected highlighted | Boxes exist; check tap | ⚠️ |
| Remove All/Active/Completed/Overdue pill row; "View All" next to heading | Pill row present (`:20`) | ❌ |
| Goal Details: ⋮ menu Edit / Mark as Completed / Archive / Delete (confirm) | Archive + Delete exist; check Edit / Mark Completed | ⚠️ |
| Automatic → "View Linked Sessions"; Manual → "Update Progress" | Check | ⚠️ |
| Create Goal: remove Core/Trainer Pack badges ("My Dog · Core") → "My Dog"/"Client Dog" | Badge text present (`create_goal_screen.dart:278`) and Trainer Pack note (`:173`) | ❌ |
| Categories Training/S&C/Health (+Sport only w/ pack) | Check | ⚠️ |
| Automatic text: "Progress updates automatically from qualifying linked sessions and activities." Manual: "Track and update your progress manually." | Manual says "Manually update progress" | ❌ |
| Targets: Sessions / Repetitions / Duration / Distance / Custom | Check | ⚠️ |
| Priority: NO default | Defaults to 'Medium' (`:33`) | ❌ |
| Due Date blank, Reminder OFF, use Calendar/Bell Ulvenik icons | Material `Icons.calendar_today` / `notifications_none` | ⚠️ |
| Remove top-right "Save"; single bottom "Save Goal", disabled until valid; open Goal Details after save | Top-right Save at `:89` | ❌ |
| Icons awaiting approval: Automatic, Manual, Link, Archive, Delete, Sport, Filter — **don't invent** | — | ❓ |

---

## 4. Individual Dog Profile – Overview — `ULVENIK_Individual_Dog_Overview_COMPLETE_RESTORED.pdf` (6 pp)
Screen: `dog_profile_screen.dart`

| Request | Current | Status |
|---|---|---|
| Full-width cover photo with name/breed/age/sex over gradient; no square thumbnail | Check header | ⚠️ |
| Discreet Edit pencil on cover → crop/zoom/reposition with Save/Cancel | Check (`image_editor_screen.dart` exists) | ⚠️ |
| 3 equal stat cards BELOW cover: Sessions (Record Session icon) / Total Time (Training Time icon) / Active Goals (Goals icon); each tappable | Check | ⚠️ |
| Tabs order: Overview / Training / S&C / **Sport / Health** / Media; Sport only with pack | Order is Overview, Training, S&C, **Health, Sport**, Media (`:28`) | ❌ |
| Remove Skills & Exercises card from Overview | Check | ⚠️ |
| Order Today's Focus → Continue → Upcoming | Check | ⚠️ |
| Today's Focus labels: "Training · Scheduled 10:00" Start/Completed ✓; "Health · Due 08:00" Log / Given ✓ / Not Given | Check | ⚠️ |
| Health → Log sheet (Given / Skipped, time, notes) | Check | ⚠️ |
| Continue: up to 3 drafts, title + "Training · saved time" muted, **remove green DRAFT badge**, Play icon for Resume, hide when empty | DRAFT badge at `:486` | ❌ |
| Upcoming: 3 next items, View All → dog calendar, tap → details w/ ⋮ Edit/Reschedule/Cancel (+Start Session) | Static rows with Material icons (`:570-574`) | ⚠️ |
| S&C icon = crossed dumbbells (new icon, not in our set) | Missing from `UlvenikIcons` | ❌ |

---

## 5. Bottom-nav Training (Training Sessions list) — `ULVENIK_Bottom_Nav_Training_Frontend_Review.pdf` (22 pp)
Screens: `training_screen.dart`, `training_session_screen.dart`, `session_details_screen.dart`
Approved mockup (p3): title "Training Sessions" / "Across all dogs" → green **Record Session** (doc+ icon) → charcoal **Strength & Conditioning** (crossed dumbbells) → charcoal **Continue Draft** (Play icon) → Search → Recent Sessions.

| Request | Current | Status |
|---|---|---|
| Remove small "TRAINING" label above title; close top gap | Present (`training_screen.dart:1256`) | ❌ |
| Large faded, right-cropped Ulvenik mark in header (muted green) | Missing | ❌ |
| Remove bell | Bell at `:1199` | ❌ |
| Remove Export shortcut (→ More › Export Data) | Present (`:1171`) | ❌ |
| Remove Activity Library shortcut | Present (`:1373`) | ❌ |
| Remove Rewards & Reinforcers shortcut (→ More › Rewards & Equipment) | Present (`:1417`) | ❌ |
| Action order: Record Session (green) / S&C (charcoal) / Continue Draft (charcoal, Play), same height/radius, full width | Different layout; draft tile toggles to "Recent Sessions" with edit icon (`:1387`) | ❌ |
| S&C → dog picker → that dog's S&C tab (not old S&C dashboard) | Opens `StrengthConditioningDashboardScreen` (`:1360`) | ❌ |
| Continue Draft: hidden with 0, opens directly with 1, "Choose a Draft" sheet for many | Single draft only | ❌ |
| Search placeholder "Search sessions, dogs or skills..." live; remove mic | "Search sessions, dogs, skills..." + mic "Voice search coming soon" (`:1314,1326`) | ❌ |
| Dog filter: All Dogs / My Dogs (/ Client Dogs if access); **remove Sport Dogs** | Sport Dogs present (`:1004-1008`) | ❌ |
| Date Range · Lifetime default; sheet Lifetime / This Year / Last 6 Months / This Month w/ green tick | Check | ⚠️ |
| Sort Newest/Oldest beside "Recent Sessions" | Exists (`:1620`) | ✅ |
| Cards: title, dog name, date · time · duration, chevron, optional Success Rate; remove blank thumbnail & skill chips | Check card widget | ⚠️ |
| Session details header image: first skill image → dog photo → collapse | Check | ⚠️ |
| Single "Edit Session" under summary; remove bottom Edit, "More Options" button | Two Edit buttons + More Options (`training_session_screen.dart:1868,1872,1998`) | ❌ |
| ⋮ menu: Share Session / Export as PDF / Delete Session only; remove Duplicate; remove bottom Delete button | Duplicate present (`:1193`), bottom Delete (`:2006`) | ❌ |
| Share → "Share link copied" | Check | ⚠️ |
| Export PDF: "Exporting PDF..." → open file w/ Save/Share; failure "Couldn't export PDF" + Try Again | Toast "Export started" only (`:1213`) | ❌ (needs pdf package) |
| Remove Manage Media; tap attachment to view | "Manage Media" (`:2120`) | ❌ |
| Remove "Skill Tags" and "Tags" boxes | Tags chips (`:1990`) | ❌ |
| Rewards Used / Equipment Used sections; remove inline Edit links | Equipment Used exists in `session_details_screen.dart:815`; check inline edits | ⚠️ |
| Recording forms: separate optional Rewards + Equipment multi-select sheets w/ add-new | Check | ⚠️ |

---

## 6. Dog › Training tab (remaining screens) — `ULVENIK_Training_Remaining_Screens_v09.pdf` (8 pp)
Screens: `dog_profile_screen.dart` (`_buildTrainingTab`), `statistics_tab.dart`

| Request | Current | Status |
|---|---|---|
| Rename "Training Drills" → "Training Sessions" | "Training Drills" (`dog_profile_screen.dart:695`) | ❌ |
| Remove "94% criteria pass rate"; text "128 sessions recorded" (dynamic) | "Logged 128 sessions · 94% criteria pass rate" (`:700`) | ❌ |
| Button "Record Training Session" → "Record Session" with Record Session icon, opens New Training Session with dog prefilled | Old label, snackbar "coming soon" (`:703-705`); also `statistics_tab.dart:111`, empty state `:322` | ❌ |
| Analytics categories: Overview / Skills / **Exercises** / Locations (remove S&C), scrollable | Overview / Skills / **S&C** / Locations (`statistics_tab.dart:135-138`) | ❌ |
| Stat labels: Avg. Duration / Sessions / Week / Total Sessions / Most Active Day | AVG SESSION / PER WEEK / SESSIONS / MOST ACTIVE (`:224-232`) | ❌ |
| Chart title "Training Activity" + sub "Track how frequently you've trained over time."; tap point shows count | "Training Sessions Over Time" (`:271`) | ❌ |
| Heatmap → "Training Activity Heatmap" + "See your training consistency throughout the month."; ONE month calendar grid with ‹ › arrows, day numbers, 4 levels (0 charcoal, 1, 2, 3+) + key "SESSIONS PER DAY"; tap date shows count | Five-month heatmap, 5 legend levels (`:402-512`) | ❌ |
| "Training Patterns" with label "Most Active: Saturday" (don't repeat count); tappable bars | Check | ⚠️ |
| Move "Most Trained Skills" from Overview → Skills category | In Overview (`:635`) | ❌ |
| Remove "Annual Goals" card from Overview | Present (`:693`) | ❌ |

---

## 7. Training Remaining Screens v34 — `ULVENIK_Training_Remaining_Screens_v34.pdf` (31 pp)
**v34 contains all of v09 (section 6) word-for-word, plus the pages below. Treat v34 as the source of truth.**
Screens: `statistics_tab.dart`, `dog_profile_screen.dart`, `training_session_screen.dart`

| Request | Current | Status |
|---|---|---|
| "Select Time Period" heading on sheet; Lifetime / This Year / Last 6 Months / This Month; green tick; tap = apply + close (no Apply button) | Sheet with options exists (`statistics_tab.dart:154`); check heading + auto-close | ⚠️ |
| Dog profile header: Back → Dogs list; **⋮ menu = Edit Profile / Archive Dog / Delete Dog** (pencil, archive, bin icons); NO dog-switcher | No popup menu found in `dog_profile_screen.dart` | ❌ |
| All 4 analytics tabs share same layout; switching tab must change the data (not just highlight); no per-item pickers; empty states | Tabs only change highlight (static data) | ❌ |
| **Skills tab:** 2 stats "Skills Trained" + "Most Trained Skill"; line graph = distinct skills/month; heatmap = distinct skills/day; patterns = distinct skills/weekday; Most Trained Skills bar chart in **sessions, not hours** | Not built | ❌ |
| **Exercises tab:** "Exercises Trained" + "Most Trained Exercise"; distinct-exercise line/heatmap/patterns; "Most Trained Exercises" bar chart (sessions) | Not built (tab doesn't exist) | ❌ |
| **Locations tab:** "Locations Trained" + "Most Used Location"; distinct-location line/heatmap/patterns; "Most Used Locations" bar chart (e.g. "18 sessions") | Not built | ❌ |
| Record Session form: optional **Training Location** ("Choose a saved location or enter a new one"), no GPS | `training_session_screen.dart` has a Location picker (`:1530`) — check label/add-new | ⚠️ |
| Record Session from Training tab / exercise detail must open real New Training Session form (no "coming soon"): optional name (date-based default), date/time, dog preselected, timer or manual duration, multi skills+exercises, notes, photos/videos, success rate 0-100%, rating, single "Save Session" | Dog Training tab still shows "coming soon" snackbar | ❌ |
| Rewards + Equipment: optional, multi-select, user-created, add in same bottom sheet; session-wide; identical in Training & S&C | Edit chips "Equipment used"/"Rewards used" (`:1969-1974`) — not bottom sheet w/ add | ⚠️ |
| Icons: Rewards = ball-on-rope toy; Equipment = training cone (new icons needed) | Not in icon set | ❌ |

---

## 8. Skills & Exercises (Training Tab Review v58) — `ULVENIK_Training_Tab_Review_v58.pdf` (54 pp)
Screens: `dog_profile_screen.dart` (Training tab card), `skills_list_screen.dart`, `add_skill_screen.dart`, `skill_details_screen.dart`, `add_exercise_screen.dart`, `exercise_details_screen.dart`, `edit_exercise_screen.dart`, `training_session_screen.dart` (record form)

### Skills & Exercises list
| Request | Current | Status |
|---|---|---|
| Card on Training tab: "Skills & Exercises" / "6 skills · 21 exercises" / Skills icon / chevron, whole card tappable | Check | ⚠️ |
| Page heading "Skills & Exercises" (not "Skills"), centred | "Skills" (`skills_list_screen.dart:372`) | ❌ |
| Select Dog = taller bottom sheet, "Select Dog" + Close, search, square photos, breed · My Dog, green tick; Trainer: My Dogs / Client Dogs groups | Check | ⚠️ |
| Stats: only 2 tappable cards Skills / Exercises (remove "253 Sessions") | Check | ⚠️ |
| Full-width "+ Add Skill" button under stat cards (not sticky); remove FAB | Check | ⚠️ |
| Filters "All / Recent / Focus Areas" | "All Skills / Recently Trained / Needs Work" (`:128`) | ❌ |
| Skill cards: name, "N Exercises", "Last trained …" only if trained; remove sessions count, goal + video badges; green dot for Focus Area | Shows "N Exercises · N Sessions" + badges (`:634-650`) | ❌ |
| ⋮ menu: Manage Skills / Manage Exercises / Sort Skills (A-Z, recently trained, date created) | "Skill options coming soon" (`:383`) | ❌ |

### New Skill form
| Request | Current | Status |
|---|---|---|
| Remove "Information" heading and red asterisk; error "Please enter a skill name." | Both present (`add_skill_screen.dart:259,440`) | ❌ |
| "Visual Reference" → "Skill Photo"; Take Photo / Choose Library; crop/zoom; fallback dog photo | Old heading; Library "coming soon" (`:284,319`) | ❌ (camera/picker needs `image_picker`) |
| Remove Organisation/Tags section | Present (`:330`) | ❌ |
| "Private Notes" → "Notes", placeholder "Add training cues, observations or reminders..." | Old (`:344`) | ❌ |
| Remove top-right Save; one bottom "Save Skill" with disk icon; return to list showing new skill | Top-right Save (`:235`) | ❌ |

### Individual Skill page
| Request | Current | Status |
|---|---|---|
| Remove FOUNDATION / OUTDOOR tags | Present (`skill_details_screen.dart:331-333`) | ❌ |
| Cover: dog photo default, pencil top-right → change/crop | Check | ⚠️ |
| Actions: Record Session (doc+ icon, primary) + Add Exercise; remove Edit button (moves to ⋮) | Record uses `Icons.play_arrow`, label "Record"; Edit button exists (`:379-383`) | ❌ |
| ⋮ menu: Edit Skill / Archive Skill / Delete Skill with approved confirm copy | No menu on skill page | ❌ |
| Current Goal card (measurable vs milestone) + "Update Progress" muted-green w/ pencil, no frame; "View All Goals" when >1 | Card exists; check style | ⚠️ |
| Update Goal Progress sheet: desc "Update your dog's progress based on your own assessment.", label "Progress" (not "Handler-Assessed Progress"), opens at saved value, tap % to type | "Handler-Assessed Progress" (`:115`) | ❌ |
| Rating labels: Excellent / Good / Mixed / Needs Work (+ descriptions) | Great / Neutral / Needs Work (`:219-222`) | ❌ |
| Session card tap → Session Details; only rating badge opens rating sheet; chevron; hide empty badge | Check | ⚠️ |
| Media gallery horizontal, View All, play icon on video | Check | ⚠️ |
| Skill History: real session names, 5 items + "View Full History" | Check | ⚠️ |

### New / Edit Exercise
| Request | Current | Status |
|---|---|---|
| "Linked Skill" section with Skills icon (not padlock), helper "This exercise belongs to Recall."; remove tag-inherit wording | Padlock + "…inherit its training tags." (`add_exercise_screen.dart:234,239`) | ❌ |
| Remove Information heading & asterisk; desc placeholder "Describe how this exercise is performed..." | Present | ❌ |
| "Exercise Photo" / "Using Recall's photo" / "Automatically uses the skill's photo." / "Choose Different Photo" / "Use Skill Photo" revert | "Default visual asset", "Use Custom Image" (`:317,344`) | ❌ |
| Remove Organisation/Tags | Present (`:356,514`) | ❌ |
| Remove top-right Save; bottom "Save Exercise" w/ disk icon → back to skill page | Top-right Save (`:201`) | ❌ |
| Edit Exercise: Linked Skill read-only card (no dropdown), remove Tags, keep Notes, "Save Changes" w/ disk icon, remove bottom Cancel | Dropdown, Tags, Cancel button (`edit_exercise_screen.dart:87,97,107`) | ❌ |

### Individual Exercise page
| Request | Current | Status |
|---|---|---|
| Title "Exercise Details" (not "Ulvenik") | "Ulvenik" (`exercise_details_screen.dart:489`) | ❌ |
| Remove Foundation/Outdoor; description only if exists | Check | ⚠️ |
| One action: Record Session (doc+); move Edit to ⋮; remove Skill button / circular action row | Check circular row; Record = "coming soon" (`:612`) | ❌ |
| Order: Cover › Name › Description › Record Session › Linked Skill › Active Goal › Recent Sessions | Check | ⚠️ |
| Linked Skill card text "View Recall" (dynamic); opens skill page | "Tap to view skill progress" + "coming soon" (`:628,692,728`) | ❌ |
| ⋮: Edit / Archive / Delete with approved copy ("This exercise will be removed from your active exercises…", "…permanently deleted. Your previous training sessions and their records will remain intact.") | Menu + dialogs exist; verify copy | ⚠️ |
| Recent Sessions: 3 newest, "View All Sessions"; success rate only if entered; numeric 0-100% entry instead of preset list | "View All coming soon" (`:887`); preset sheet "Record Session Success Rate" (`:384`) | ❌ |

### Record Session (shared New Training Session form)
| Request | Current | Status |
|---|---|---|
| One form used from main Training, skill, exercise (dog/skill/exercise preselected) | Skill/exercise/dog-tab entry points show "coming soon" | ❌ |
| Optional Session Name → default "Training Session · 7 Nov 2026" | Check | ⚠️ |
| Date + Time prefilled now, editable | Check | ⚠️ |
| Duration: timer (start/pause/resume/stop) OR manual; optional | Check | ⚠️ |
| "+ Add Skills / Exercises" grouped by skill; remove from session | Check | ⚠️ |
| Session Notes placeholder "Record your observations, progress or anything worth remembering..." | Check | ⚠️ |
| Photos & Videos: Take Photo / Record Video / Choose Library, multi, preview, remove | Needs `image_picker` | ❌ |
| One bottom "Save Session" w/ disk icon; no top-right save; after save open the saved record | Check | ⚠️ |
| Recording a session must NOT change goal progress | n/a (no data layer) | — |

---

## 9. Health — `ULVENIK_Health_Frontend_Review_v6_COMPLETE.pdf` (25 pp)
Screens: `dog_profile_screen.dart` (`_buildHealthTab`), `health_screen.dart`, `health_records_screen.dart`, `health_record_details_screen.dart`, `health_reminders_screen.dart`, `weight_tracker_screen.dart`, category screens
Layout reference (p2): dog header + tabs → "Health Records" heading → **Health Records** card (“View and manage medical history”) → **Health Reminders** card (“Upcoming care and scheduled tasks”) → "Health Overview" → 2 cards **Current Weight** (28.5 kg, “+0.5 kg since last entry”) / **Body Condition** (4 / 9, “Latest recorded score”) → **Weight History** line preview (“Last 6 months”) → **Upcoming Health** list.

| Request | Current | Status |
|---|---|---|
| Health tab shows the above directly; **no "Open Health Dashboard"** intermediate screen, no extra dog selector | Tab shows "Health Overview" card + "Open Health Dashboard" / "Health Categories" / "Health Stats" buttons (`dog_profile_screen.dart:~806-831`) | ❌ |
| Only 2 stat cards (Current Weight w/ delta, Body Condition /9); tap → Weight Records / Body Condition Records | Not on tab | ❌ |
| Weight History compact preview → tap opens Weight Records | Missing on tab | ❌ |
| Upcoming Health: max 3, soonest first, "View All Reminders"; empty: "No Upcoming Health Events" / "Your dog's upcoming appointments and reminders will appear here." | Missing | ❌ |
| Icons: scale (weight), body-assessment (BCS), trend line (preview), calendar-clock (Upcoming), stethoscope (vet), bell (reminder) | n/a | ❌ |
| **Exactly 12 categories, 6×2 in order:** Weight / Body Condition; Medications / Supplements; Vaccinations / Parasite Prevention; Vet Visits / Allergies & Medical Conditions; Injuries & Rehabilitation / Reproductive Health; Documents / Other Records | `health_screen.dart:396-405` order differs: Weight, Body Condition, Medications, Vaccinations, Vet Visits, Injuries, (Allergies?), Supplements, Documents, Other Records. **Missing Parasite Prevention + Reproductive Health**; "Injuries" not "Injuries & Rehabilitation" | ❌ |
| Body Condition must open its own BCS screen (1-9 scale, guide, chart) | Opens `WeightTrackerScreen` (`:397`) | ❌ (new screen) |
| New screens needed: **Body Condition**, **Parasite Prevention**, **Reproductive Health** (Heat Cycles, Mating, Pregnancy & Whelping, Male Records, Spaying & Neutering) | None exist | ❌ |
| Titre Tests live inside Vaccinations | Check `vaccination_manager_screen.dart` | ⚠️ |
| Supplements form must NOT have Prescribed By / Administration Method | Check | ⚠️ |
| Allergies & Medical Conditions = 2 sections in one category, shared form | `allergies_sensitivities_screen.dart` allergies only? | ⚠️ |
| Injuries & Rehabilitation combined (rehab ≠ S&C) | `injuries_recovery_screen.dart` + separate `physio_hydro_hub_screen.dart` | ⚠️ |
| Health Records empty: "No Health Records Yet" / "Start building your dog's health history by adding their first record." + green "Add Health Record"; grid still visible | Heading + button exist (`health_records_screen.dart:674,713`); check copy | ⚠️ |
| Category empty states e.g. "No Weight Records Yet — Add your dog's first weight to begin tracking changes over time. — Add Weight Record" | Check each | ⚠️ |
| Record details: ⋮ Edit Record / Delete Record (confirm) | Popup exists (`health_record_details_screen.dart:107`) | ⚠️ |
| Health Reminders form: title, date, type list, time, repeat None/Daily/Weekly/Monthly/Custom, linked record, notes, notifications (At time / 1 h / 1 day / custom) | Check | ⚠️ |
| Remove "coming soon" search/filter in Health Records | Snackbars (`health_records_screen.dart:55,59`) | ❌ |

---

## 10. Strength & Conditioning — `ULVENIK_SC_Complete_Developer_Handover_v53.pdf` (56 pp)
**Part A (pp 2-8 + addenda pp 50-52) overrides Part B history.**
Screens: `dog_profile_screen.dart` (`_buildStrengthConditioningTab`), `activity_library_screen.dart`, `create_activity_screen.dart`, `activity_details_screen.dart`, `record_session_screen.dart`, `session_details_screen.dart`, `session_records_screen.dart`, `activity_statistics_screen.dart`, `strength_conditioning_dashboard_screen.dart`, `sc_archive_screen.dart`

| Request | Current | Status |
|---|---|---|
| S&C tab content directly (no "Open S&C Dashboard"): **Activity Library card** (crossed-dumbbells, "8 activities", chevron) → **S&C Sessions card** ("24 sessions recorded" + green "Record S&C Session" doc+ icon) → **S&C Analytics** tabs Overview / Activities / Progress (no Locations) | Card "Strength & Conditioning" + old desc + "Open S&C Dashboard" + "Record S&C" buttons (`dog_profile_screen.dart:~742-768`) | ❌ |
| Description if needed: "Track strength, conditioning, mobility and recovery." | "Track physical load, intensity, sprints and endurance volume." | ❌ |
| Same theme as Training (no separate sage accent) | Check | ⚠️ |
| Activity Library: heading, Back → same dog profile S&C tab; search like Skills; ONE Sort button → sheet Recently Used / Alphabetical / Most Trained | Sort options incl. "Most Sessions", "Highest Streak" (`activity_library_screen.dart:124`) | ❌ |
| Remove categories (Water Work/Running/Strength/Core/Agility), Filter button, category sheet | Present (`:177-305, 387`) | ❌ |
| Remove Favourites + stars | Present (`:359`) | ❌ |
| Cards: name, optional desc, "N Sessions · Last: …" or "0 Sessions · Not yet trained"; no preloaded activities | Seed data w/ equipment etc. | ⚠️ |
| FAB Add Activity; ⋮ → Archived Activities; empty "No Activities Yet" / "Create your first strength and conditioning activity to get started." | Check | ⚠️ |
| Add/Edit Activity: name (req), desc, measurement checkboxes Repetitions / Sets / Duration / Distance / Resistance-Weight + **user-selectable units**; no category/icon grid/favourite | Has icon/category grid, `_isFavourite`, fixed 'Strength' category (`create_activity_screen.dart:41-76`) | ❌ |
| Activity Details like Skill Details; no Update Progress; Record S&C Session w/ activity preselected; ⋮ Edit / Archive / Delete (delete keeps history); empty "No Sessions Recorded Yet" / "Record your first session to start tracking this activity." | Check menu & copy | ⚠️ |
| Archived Activities empty: "No Archived Activities" / "Activities you archive will appear here." | Check `sc_archive_screen.dart` | ⚠️ |
| Record S&C Session = same as Training form; multi activities each w/ its measurement fields; name default "S&C Session · [date]"; timer/manual duration; Rewards (ball-rope) + Equipment (cone) bottom sheets; notes; media; **Rating Excellent/Good/Mixed/Needs Work; NO Success Rate** | Has "Performance Rating" (`record_session_screen.dart:1807`); check labels/fields | ⚠️ |
| Session Details ⋮ Edit Session / Delete Session (no Archive) | Check | ⚠️ |
| S&C Sessions History = Training history style; empty "No S&C Sessions Yet" / "Start recording your dog's strength and conditioning journey." | Check | ⚠️ |
| Overview: only Total S&C Sessions + Total Duration (e.g. "2h 35m"); "S&C Activity" line; monthly heatmap (4 levels); "S&C Training Patterns" + "Most Active: …" | `activity_statistics_screen.dart` has Total Duration; check rest | ⚠️ |
| Activities tab: Activities Trained + Most Trained Activity; distinct-activity line/heatmap/patterns; Most Trained Activities bar (sessions) | Check | ⚠️ |
| Progress tab: Activity dropdown + Measurement dropdown + Select Time Period; one graph; tap point → tooltip w/ View Session; empty "No Progress Data Yet" / "Record your first S&C session to start tracking progress." + Record button | Check | ⚠️ |

---

## 11. Sport Pack — `ULVENIK_Sport_Frontend_Review_v29.pdf` (35 pp)
Screens: `dog_profile_screen.dart` (`_buildSportTab`), `my_sports_screen.dart`, `create_sport_screen.dart`, `sport_details_igp_screen.dart`, `sport_statistics_screen.dart`, `competitions_overview_screen.dart`, `add_competition_screen.dart`, `competition_details_screen.dart`, `competition_results_screen.dart`, `sport_pack_overview_screen.dart`
Visual refs: **My Sports** list of sport cards (+ to add) and **Individual Sport** page = 3 cards: "Sport Skills & Exercises" (View Skills & Exercises ›), "Sport Sessions" (Record Sport Session ›), "Sport Progress" (View Progress ›).

| Request | Current | Status |
|---|---|---|
| Sport tab opens content directly: My Sports / Sport Sessions / Competitions & Trials; remove "Open Sport Pack Overview" + intermediate dashboard; no hard-coded sport names in copy | Card "Sport Pack · Competitions & Trials" + "IGP, IPO, Agility, Schutzhund…" + "Open Sport Pack Overview" (`dog_profile_screen.dart:~863-873`) | ❌ |
| Add Sport form: Sport Name (req), Description, Notes → "Save Sport" | Has photo emblem picker + current level fields (`create_sport_screen.dart:30,77,95-100`); button "Create Sport" | ❌ |
| My Sports cards: name, optional desc, live skills/exercises/sessions counts, chevron; ⋮ Edit / Archive / Delete; "Archived Sports" via ⋮ | Shows "Level: IGP 2" etc. (`my_sports_screen.dart:49-95`); filter sheet with Status/Sort | ⚠️ |
| My Sports empty: "No Sports Yet" / "Add your first sport to start organising your dog's sport training." / Add Sport | Check | ⚠️ |
| Archived Sports list with Restore; empty "No Archived Sports" / "Sports you archive will appear here."; Back preserves search/sort/scroll | Archived is a filter, not separate screen | ❌ |
| Individual sport = 3 cards (Sport Skills & Exercises / Sport Sessions / Sport Progress) + Competitions & Trials (filtered to sport) | `sport_details_igp_screen.dart` is a 2.7k-line IGP-specific dashboard | ❌ (rebuild to reference layout, generic for any sport) |
| Record Sport Session = Core Training form + Sports multi-select; skills/exercises grouped per sport; optional per-sport duration when >1 sport; rating Excellent/Good/Mixed/Needs Work | Not built | ❌ |
| Sport Session Details (⋮ Edit / Delete) + Sport Sessions History (search + sort like Training); empty "No Sport Sessions Yet" / "Start recording your dog's sport training journey." | Not built | ❌ |
| Sport Progress: Total Sport Sessions, Total Training Duration, Training Activity line, heatmap; Skills Trained, Exercises Completed, Most Trained Skills & Exercises, Training Patterns; tap item → existing Skill/Exercise Details; empty "No Sport Progress Yet" / "Record your first session to start tracking progress in this sport." | `sport_statistics_screen.dart` exists — check vs spec | ⚠️ |
| Competitions & Trials: Upcoming (soonest first) + History (newest first, auto-move after date) + Add; both in main Sport tab and per sport (filtered) | `competitions_overview_screen.dart` exists; check filtering | ⚠️ |
| Add Competition fields: Name*, Sport*, Date*, Location, Organisation/Club, Level/Class (free text), Result/Score, Placement, Judge, Notes, attachments, Reminder; **multiple custom result fields (label + value)** | Has Name, Judge(s), Reminder; check Organisation/Level/custom fields | ⚠️ |
| Competition Details ⋮: Edit / **Archive** / Delete; Archived Competitions screen | Edit exists; check Archive | ⚠️ |
| Competitions empty: "No Competitions Yet" / "Add your first competition to start building your dog's competition history." | Check | ⚠️ |

---

## 12. Dog Profile › Media — `ULVENIK_Media_Frontend_Review.pdf` (20 pp)
Screens: `dog_profile_screen.dart` (`_buildMediaTab`), `media_library_screen.dart`, `media_upload_manager_screen.dart`, `media_collections_screen.dart`, `media_favourites_screen.dart`, `media_search_screen.dart`, `photo_viewer_screen.dart`, `video_viewer_screen.dart`, `document_viewer_screen.dart`, `storage_manager_screen.dart`
Reference (p16): "Media Library" + green ＋ → "Search media..." with filter button → tabs All / Photos / Videos / Documents → 3-column grid (play icon on videos, doc icon on files).

| Request | Current | Status |
|---|---|---|
| Media tab opens the library directly; remove "Media & Highlights" card + "Open Dog Media Library" button | Card + button present (`dog_profile_screen.dart:~908-918`) | ❌ |
| Remove the statistics row at top of library | Check (storage/stat row) | ❌ |
| Layout: heading + green ＋ Add Media; "Search media..." + ONE filter button; tabs All/Photos/Videos/Documents; Collections + Favourites + Media Storage accessible | Check order; currently tiles for Collections / Favourites / Storage Manager (`media_library_screen.dart:452-475`) | ⚠️ |
| 3-column grid; long-press → selection mode with count; bulk Add to Collection / Download / Delete (linked warning) | Check | ⚠️ |
| Filter sheet: Date range, Source (Training/S&C/Health/Sport/Direct Upload), Sort (Newest/Oldest/Recently Added), Collection, Favourites only; Apply / Clear | Check | ⚠️ |
| Favourites = heart icon: grey outline inactive, **filled forest-green** active | Uses gold (`favouriteGold`) + "starred" wording (`:71,465`) | ❌ |
| Automatic collections (from skills/exercises/activities/sports) + personal collections (visually distinct) | Check `media_collections_screen.dart` | ⚠️ |
| Upload: multi-file mixed; optional title, editable media date, description, collections, record links | Check | ⚠️ |
| Item ⋮: Edit Details / Add to Collection / Download-Save / Delete Media (warn if linked) | Check | ⚠️ |
| Viewers: swipe gallery, stop video on swipe, Back restores grid position; PDF viewer w/ Download / Share / ⋮ / linked records | Check | ⚠️ |
| Empty states: "No Media Yet" ("Add your first photo, video or document to start building your dog's media library." + Add Media), "No Photos Yet", "No Videos Yet", "No Documents Yet", "No Collections Yet", "No Favourites Yet"; separate no-results state | Check | ⚠️ |

---

## 13. Timeline (consolidated, 29 sections) — `ULVENIK_Timeline_Frontend_Review.pdf` (42 pp)
**Replaces the old 348-page review. Text overrides the screenshots (pp 31-42 show the current build as evidence only).**
Screens: `timeline_screen.dart` + every `timeline_*_screen.dart`, `global_calendar_screen.dart`, `session_details_screen.dart`, `training_session_screen.dart`, `add_competition_screen.dart`, `add_health_record_screen.dart`, `session_templates_screen.dart`, `sc_archive_screen.dart`

### Top priority (client's words): records open the wrong original
Tapping Arlo/Murphy Training, Health, Competition, Goal, Milestone cards opens unrelated sample pages ("Fenrir" training, "Rex" Vet Visits, "Atlas" exam). Training Session entry opens an **S&C Hill Work form**. → Every card must route by **record ID + type + dog** to its own original. Remove the intermediate "View Event Details" sheet/page and go **straight to the original record**.

### Global rules for this scope
- Palette #121212 / #1C1C1C / text #F5F5F5, #C9C9C9, #8E8E8E / green #2F5D50. **No blue/orange/pink/yellow category colours** — neutral icons + text.
- Remove all standalone mountain graphics; keep only the real combined logo.
- No demo toggles, "reset demo", fake counts, fixed sample dates, fake telemetry/GPS/encryption claims.
- Success banners only on real success; loading ≠ empty ≠ error.
- Single-choice sheets: green tick, apply-on-tap. Filter editors: draft + Apply/Cancel/Reset.

| Area | Request | Current | Status |
|---|---|---|---|
| Main Timeline header | Shallow dog-photo banner w/ name, breed/age, Switch Dog; All Dogs scope shows dog on each card | Check | ⚠️ |
| Main Timeline clutter | Remove both stats rows, "Weekly Event Cadence" chart, eye/preview toggle, mountain, bell/unread dot | Eye toggle (`timeline_screen.dart:2242`) etc. | ❌ |
| Remove destinations | **Delete Timeline Settings, Timeline Insights, Timeline Dashboard, Timeline Event Details** screens/menu entries | All present in menu (`:965,1230,1260,2393,2404`) | ❌ |
| Menu | Keep: Favourites, Timeline Archive, Memories, Activity Map, Compare, Smart Collections, **Home Widgets**, Statistics, Timeline Export, Calendar — drop "Open Timeline …" prefixes and tech subtitles | "Open Timeline X" labels + subtitles like "Dynamic rule-based clustering…" (`:1385,1415`) | ❌ |
| Grouping | Today / Yesterday / month-year (not "Summer 2026"/"Spring 2026") | Seasons (`:180-245`) | ❌ |
| Controls | "Search events..." (no mic), one Filters with badge, visible Newest/Oldest sort, one Add Record | Check | ⚠️ |
| Filter sheet | Categories multi (Training, S&C, Health, Goals, Milestones, Sport); Lifetime/This Year/Last 6 Months/This Month/Custom; "With Photos or Videos Only"; Apply / Cancel / Reset; empty "No Matching Events" | Check `timeline_filters_screen.dart` (full page — should be compact sheet) | ❌ |
| Favourites | Heart grey/green, "Search favourites...", category picker, sort; empty "No Favourites Yet / Tap the heart on a Timeline event…" + Go to Timeline | Check | ⚠️ |
| Timeline Archive | Remove summary/legend/overflow/demo/eye; Search archive...; sort by original date; Select mode w/ Select All, Restore / Export; "Restore [n] Events?" dialog; "Original Record Deleted" + Remove Reference; empty copy | Check | ⚠️ |
| Timeline Export | PDF / CSV only (remove JSON, telemetry, encryption); Specific Events vs Date Range; validation copy; "Preparing Your Export" → "Export Ready" (Open/Share) / "Couldn't Create Export" | Check; has demo flag | ❌ |
| Memories | On This Day / This Month; All Categories + All Years selectors; remove Milestones/Achievements engine, streaks, demo pack switch; Share = Copy Link / Save Memory Card; empty copy | Check | ⚠️ |
| Activity Map | Two cards Locations / Mapped Events; Most Recorded Location row; draggable panel; remove hearts, GPS Distance, legend, Route Profile, coordinates banner, "GPS ACTIVE/NORDIC" labels; Map Display sheet; empty copy | Check | ❌ (many removals) |
| Compare | "Recorded Activity Comparison"; 2 range cards; table w/ signed Difference; Compare Dates sheet; Swap Dates; remove A/B/VS, streak/consistency metrics, charts | Check | ❌ |
| Smart Collections | Compact rows; groups My Collections / By Date / With Attachments / By Record Type / Health; Sort + Type filter; Create Collection form; Archived Collections; empty copy; remove pills/"15 SMART PRESETS SYNCED" | Check | ❌ |
| Home Widgets | Rename from "Timeline Widgets"/"Widgets Gallery"; in-app panels only (remove Lock Screen / Dynamic Island); keep 7 panels; remove Streak/Summary/Breakdown/etc.; Small/Medium/Large; Edit Home Layout | "Home Screen, Lock Screen & Dynamic Island previews" (`:1415`) | ❌ |
| Statistics | "This shows what you recorded, not a measure of training progress."; Total Recorded Events, Records by Category, bar chart; remove streaks, doughnut, % comparisons; Custom dates; Export Statistics | Check; has demo flag | ❌ |
| Calendar | Month/Week/Day, category-only picker, remove cadence/workload/hourly/legends; empty "No Records on This Date"; Calendar Search w/ 5 recent queries | Check | ⚠️ |
| Add Record | Training / S&C / Health / Milestone / Competition (Calendar missing S&C); Add Milestone form; Health form uses 12 categories; single bottom Save | Check | ⚠️ |
| Session forms | Training opens Training form (not S&C Hill Work); no sample defaults (3200 m, 15 kg, Medium, 4 stars); Edit loads exact original; Keep Editing / Discard Changes | Check `training_session_screen.dart` | ❌ |
| Competition form | Name, Sport (user's own), Dog, Date required; Additional Details expander; statuses Upcoming/Completed/Withdrawn/Cancelled; Results section; reminder presets "1 Day Before / 08:00", "3 Days Before / 18:00", Custom; remove Weather auto-detect | Check | ⚠️ |
| Session Details menu | Share or Export Session / Save as Template / Delete Session (separated); remove shortcuts (Templates, Equipment, Insights, Archive), inline Notes Edit, footer Delete; exact delete copy given | See §5 | ❌ |
| Session Templates | Only user templates (no 6 seeded); "Use Template"; Sort Recently Used/Most Used/A-Z/Favourites First; Filter; Create/Edit Template fields; menu Export Templates + Archived Templates | Check | ❌ |
| Library Archive | Activities / Session Templates views; remove charts, "Delete Permanently" beside Restore, Reset Demo, Empty Archive; empty copy | `sc_archive_screen.dart` has demo | ❌ |
| Removed settings | No Timeline Settings at all (default view, density, telemetry chips, auto-archive, encryption…) | `timeline_settings_screen.dart` exists | ❌ (delete screen) |

---

## 14. More, Settings & Trainer — `ULVENIK_More_Frontend_Review.pdf` (49 pp, sections 01-13)
Screens: `more_page_screen.dart`, `more_dashboard_screen.dart`, `profile_page_screen.dart`, `edit_profile_screen.dart`, `app_settings_screen.dart`, `appearance_settings_screen.dart`, `notification_settings_screen.dart`, `two_factor_setup_screen.dart`, `subscription_details_screen.dart`, `billing_history_screen.dart`, `restore_purchases_screen.dart`, `storage_management_screen.dart`, `backup_sync_screen.dart`, `offline_mode_screen.dart`, `country_region_screen.dart`, `language_settings_screen.dart`, `measurement_units_screen.dart`, `date_time_format_screen.dart`, `timezone_settings_screen.dart`, `rewards_management_screen.dart`, `add_reward_screen.dart`, `edit_reward_screen.dart`, `equipment_screen.dart`, `help_centre_screen.dart`, `contact_support_screen.dart`, `report_bug_screen.dart`, `feature_requests_screen.dart`, `whats_new_screen.dart`, legal screens, all `trainer_*` / `client_*` screens

### P1 (client's priorities)
1. **Fake success**: trainer notes, session media, settings (units, time format, Wi-Fi upload) show "saved" but revert on reopen → persist for real; never show success first.
2. **Wrong routes/identity**: Trainer Workspace Settings opens "Milo's Analytics"; client goal opens personal dog; client recording silently goes to S&C; client names/dogs/totals conflict.
3. **Fake exports/documents**: PDF/export only shows a banner; "View Full Document" just closes the sheet.

### More hub (section 03)
| Request | Current (`more_page_screen.dart`) | Status |
|---|---|---|
| One compact profile card (photo/initials, name, email, real plan) → opens **My Profile** edit form directly | Separate "Profile" row w/ "Handler profile, streak & packs" (`:392-393`) | ❌ |
| 4 groups: **Your Tools** (Notifications Inbox, Search All Records, Calendar, Media Library, Rewards, Sport Pack, Trainer Workspace) / **Settings** (Account Settings, Appearance, Notification Settings, Privacy & Security, Subscription, Storage & Sync, Regional Preferences) / **Support** (Help & Support → Help Centre, Contact Support, Report a Bug; Feature Requests) / **About & Legal** (About, What's New, Privacy, Terms, Licences) | Long list w/ duplicate Settings row (`:406`), duplicate support groups | ❌ |
| Renames: Subscription Management→**Subscription**; Offline Storage & Cloud Sync→**Storage & Sync**; Notifications→**Notification Settings**; Global Search→**Search All Records**; Rewards Management→**Rewards**; Sport Pack Overview→**Sport Pack**; Trainer Dashboard→**Trainer Workspace**; Help & Support + Help Centre merged; one **Feature Requests** (drop "Feedback & Feature Requests") | Old labels (`:149,280,311,358,367,432,477,507,554,644,683`) | ❌ |
| Country/Language/Units/Date & Time/Time Zone grouped under **Regional Preferences** | Separate rows | ❌ |
| No warning-coloured "Off" badge; "Email Not Verified" → "Verify email" only if really unverified; "Fully Synced" only if truly synced; real build version (not fixed 1.0.0) | Hard-coded (`:72,282,294`) | ❌ |
| My Profile: First Name (req), Last Name, Display Name, photo; helper "Used to identify you in Ulvenik and on reports you choose to share. This does not create a public profile."; remove top-right Save → one "Save Changes" | Check `edit_profile_screen.dart` | ⚠️ |

### Rewards & Equipment (section 09) — must be two equal, fully custom libraries
| Request | Current | Status |
|---|---|---|
| Rename "Rewards Management" → "Rewards"; remove "Rook / Belgian Malinois / IGP-3" sample dog header, fixed Food/Toy/Praise/Play/Other chips, six sample rewards | Present in `rewards_management_screen.dart` | ❌ |
| Equipment library with same structure (Add/Edit/Archive/Search, custom types) — not Trainer-only | `equipment_screen.dart` exists (S&C) — align | ⚠️ |
| Add reward copy: "Add reward" / "Save rewards to reuse in Training and S&C sessions." / "Reward name" ("Enter a reward name") / "Type (optional)" + "Add type" ("Type name") / "Notes (optional)" ("Add notes about this reward") / "Save reward" / Cancel | Check `add_reward_screen.dart` | ❌ |
| Add equipment copy mirrors it ("Save equipment to reuse…", "Equipment name", "Save equipment") | Missing | ❌ |

### Regional preferences (section 09)
- Independent units (kg/lb, km/mi, date formats, 12/24 h), "Custom" when mixed; one **Save Changes** per page (remove duplicate Save/Apply buttons).
- Time zone: compute real clock + offset (Europe/London on 13 Nov = UTC+00:00, not +01:00 / fixed "13:42"); "Use device time zone" toggle vs manual.
- Language: only show working translations (Deutsch didn't translate); remove "More languages coming soon"; one Save Changes.
- Appearance: add **Light Mode**; High Contrast must actually work.
- Country: remove duplicate UK suggestion, use UK flag, one Save Changes.

### Support forms (section 11) — exact copy
- **Contact Support**: "Tell us what you need help with." / Category / Subject ("Briefly describe your question or issue") / Message ("Tell us what you need help with and include any relevant details") / Attachments (optional) / Reply email / **Send support request**. No fake `screenshot_01.png`, `user@example.com`.
- **Report a Bug**: "Tell us what went wrong so we can investigate." / Category / Title ("Briefly describe the issue") / What happened? ("Tell us what you expected and what actually happened") / Steps to reproduce (optional) / Attachments (optional) / **Send bug report**. No auto `bug_screenshot.png`.
- **Suggest a feature**: "Tell us what you'd like to see in Ulvenik and how it would help." / App area (optional, no preselect, has Other) / Suggestion title ("Give your idea a short title") / Describe your idea ("What would you like to do, and how would this help?") / **Send suggestion**. Replace the public voting/roadmap board + sample votes + "My Requests" + AI suggestions with this private form.

### Other sections (04-08, 10) — headline items
- Global: sentence case everywhere; Support says Send, forms say Save, metric popups say Apply; no mountain placeholders; dog photos rounded squares.
- Settings screen is a duplicate hub → consolidate into the destinations above; all duplicate routes share one saved value.
- Notifications: Quiet Hours, permission vs preference shown separately; remove streak alerts.
- Subscription/Billing: one current state from real entitlement; exact original logo; clear transaction rows; Restore Purchases / Redeem Code.
- Trainer: remove implementation previews; client filters match results; private trainer notes never shared; homework rows must not change state on tap; client Record Session keeps client+dog and Training vs S&C; pinned clients approved.
- Analytics/reports: one scope + period per screen; no invented scores/streaks; Workspace Settings must open the right screen.
- What's New / legal / licences: real build data, real dependency list.
