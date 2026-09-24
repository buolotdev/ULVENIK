# Ulvenik — Web Frontend Handover
## Responsive Layout Specification — All Screens, All Breakpoints

---

## BREAKPOINTS

| Name | Width | Device |
|---|---|---|
| Mobile | < 768px | Phone |
| Tablet | 768px – 1199px | iPad, tablet |
| Desktop | ≥ 1200px | Laptop, PC, large screen |

All layouts are mobile-first. Build up from mobile, override at tablet and desktop breakpoints.

---

## GLOBAL WEB LAYOUT RULES

### No Bottom Nav Bar on Web
The mobile bottom nav bar (Home · Dogs · Training · Timeline · More) does NOT exist on web.
It is replaced entirely by the sidebar on tablet and desktop.
On mobile web (< 768px), a bottom nav bar IS shown — same as the mobile app.

### Sidebar (tablet ≥ 768px and desktop ≥ 1200px)
- Width: 240px
- Background: Carbon `#1A1F22`
- Right border: 1px `rgba(255,255,255,0.08)` hairline
- Position: fixed left, full height
- Top: Ulvenik brand mark logo
- Middle: nav items
- Bottom: user avatar + name + logout

**Nav item states:**
- Active: 3px Forest Green left border accent + Forest Green icon + Off White label
- Inactive: Stone Grey icon + Stone Grey label
- Hover: `rgba(255,255,255,0.04)` bg tint

**Sidebar nav items (in order):**
Home · Dogs · Training · Timeline · Calendar · Search · (divider) · Sport Pack (if subscribed) · Trainer Pack (if subscribed) · (divider) · More / Settings

### Top Bar (all authenticated screens, tablet + desktop)
- Height: 64px
- Background: `#101214`
- Bottom border: 1px `rgba(255,255,255,0.08)`
- Left: screen title (17px semibold, Off White) — offset 240px to account for sidebar
- Right: action buttons (search icon, notifications bell, user avatar)
- On mobile web: full width, no sidebar offset

### Content Area
- Desktop: max-width 1280px, centred, 80px horizontal padding, offset 240px for sidebar
- Tablet: full width minus sidebar (240px), 32px horizontal padding
- Mobile web: full width, 16px horizontal padding

### Modals (web replaces bottom sheets)
- Mobile web: bottom sheet slides up (same as app)
- Tablet + desktop: centred modal overlay
  - Background: `#1A1F22`
  - Border: 1px `rgba(255,255,255,0.08)`
  - Corner radius: 20px
  - Max width: 560px
  - Dark backdrop: `rgba(0,0,0,0.6)` behind modal
  - Dismiss on backdrop click

### Confirmation Dialogs (web)
- Mobile web: bottom sheet (same as app)
- Tablet + desktop: small centred modal, max-width 400px, same card styling

### FAB (Floating Action Button)
- Mobile web: bottom-right, 24px from edge, above bottom nav
- Tablet + desktop: FAB may be replaced by a primary button in the top bar right area or within the content area header — contextual

### Cards and Grids
- Mobile: single column
- Tablet: 2-column grid where appropriate
- Desktop: 2–3 column grid where appropriate
- Card gap: 24px standard
- Card corner radius: 16–20px (same as app)

### Wide Content (tables, code, large grids)
- Always in `overflow-x: auto` container
- Page body never scrolls sideways

### Split View Pattern (list + detail)
Available on tablet and desktop for: Clients, Dogs list, Media Library, Health Records, Goals, Skills, Training Sessions, Trainer Reports, Timeline, Notifications
- Left panel: list (fixed width ~360px on desktop, 280px on tablet)
- Right panel: detail/content — fills remaining space
- On mobile: list and detail are separate screens (one at a time)

---

## SCREEN-BY-SCREEN RESPONSIVE RULES

---

### BATCH 1 — AUTH & ONBOARDING

#### Splash Screen
- Mobile: full screen, centred stacked logo, Forest Green bg or dark cinematic image
- Tablet: same as mobile, centred in viewport
- Desktop: same centred treatment, wider viewport — logo stays centred, background fills full screen

#### Onboarding 1 / 2 / 3
- Mobile: full screen cards, swipe between steps, progress dots at bottom
- Tablet: centred card, max-width 560px, vertically centred in viewport, progress dots below card
- Desktop: same as tablet, max-width 640px — do NOT stretch onboarding full width

#### Login / Create Account / Forgot Password / Set New Password / Password Updated / Confirmation Screen / Email Verified / 2FA Setup
- Mobile: full screen form
- Tablet: centred card, max-width 480px, vertically centred in viewport
- Desktop: same as tablet, max-width 520px
- No sidebar, no top bar on auth screens — these are pre-login, standalone pages
- Background: Obsidian `#101214` with optional subtle decorative image (dark, desaturated)

#### Welcome
- Mobile: full screen
- Tablet + Desktop: centred card, max-width 640px, vertically centred
- No sidebar on this screen — it's a post-auth first-time screen before the main app loads

---

### BATCH 2 — CORE APP ENTRY

#### Home (Homepage Empty / Populated)
- Mobile: single column scroll — greeting, summary cards, recent activity, goals, reminders
- Tablet: 2-column grid for summary stat cards; activity feed and goals side by side
- Desktop: 3-column layout — left: dog switcher + quick stats, centre: main dashboard content, right: upcoming reminders + recent activity panel
- Greeting message rotates from pre-written bank (never static, never AI-generated)
- Decorative hero imagery rotates from curated bank

#### Dogs Page (My Dogs Empty / Populated / All Workspaces)
- Mobile: vertical list of dog cards, single column
- Tablet: 2-column dog card grid
- Desktop: 2–3 column dog card grid, sidebar active on Dogs tab
- Dog cards: photo top, name + breed below, workspace badge if applicable
- Split view not applicable here (list IS the main view)

---

### BATCH 3 — DOG PROFILE & BRANCHES

#### Dog Profile Overview (New Dog / Populated)
- Mobile: stacked sections, full scroll
- Tablet: hero photo area + profile info side by side at top; sections below in 2-column grid
- Desktop: same as tablet, wider — hero photo left ~40%, profile details right ~60%; sections below in 2–3 column grid

#### Training Page (Empty / Populated)
- Mobile: single column — session list, stats summary at top
- Tablet: stats summary row at top (3 tiles across), session list below in 2 columns
- Desktop: split view — session list left panel (360px), session detail right panel; stats tiles in 3–4 column row

#### Training Session (Draft / Completed)
- Mobile: full scroll, sections stacked
- Tablet: session header top full width; below: 2-column layout — left: session info + notes, right: sections + media
- Desktop: same 2-column split, more breathing room; media gallery shows larger thumbnails

#### Skills List (Empty / Populated) + Skill Details + Add/Edit Skill + Add/Edit Exercise + Exercise Details
- Mobile: list screen → detail screen (separate)
- Tablet + Desktop: split view — skills list left panel, skill detail right panel
- Add/Edit: modal overlay on tablet + desktop (max-width 560px), full screen on mobile

#### Goals List (Empty / Populated) + Create Goal + Goal Details
- Mobile: list → detail (separate screens)
- Tablet + Desktop: split view — goals list left, goal detail right
- Create Goal: modal on tablet + desktop, full screen on mobile

#### Statistics (Empty / Populated)
- Mobile: single column — charts stacked vertically
- Tablet: 2-column chart grid
- Desktop: 3-column chart grid, larger chart areas, charts render at full resolution

#### Dog Timeline (Empty / Populated)
- Mobile: vertical timeline, single column
- Tablet: timeline with wider event cards, 2-column event grid below the timeline line
- Desktop: timeline centred with event detail panel opening to the right on click

---

### BATCH 4 — HEALTH

#### Health Page (Empty / Populated)
- Mobile: hub cards stacked
- Tablet: 2-column hub card grid
- Desktop: 3-column hub card grid

#### Health Records (Empty / Populated) + Add Health Record + Health Record Details
- Mobile: list → detail (separate)
- Tablet + Desktop: split view — list left, detail right
- Add Health Record: modal on tablet + desktop

#### Weight Tracker (Empty / Populated)
- Mobile: chart full width, entries below
- Tablet: chart left, entry list right (side by side)
- Desktop: larger chart with more data points visible, entry list right panel

#### Medication Manager / Vaccination Manager / Vet Visits / Injuries & Recovery / Physiotherapy & Hydrotherapy / Supplements / Allergies & Sensitivities / Dental Care / Surgery & Procedures
- Mobile: list → detail (separate screens)
- Tablet + Desktop: split view — list left, detail/record right
- Add/Edit forms: modal on tablet + desktop

#### Health Reports & Timeline
- Mobile: vertical timeline
- Tablet + Desktop: wider timeline, report cards in 2-column grid

#### Health Statistics (Empty / Populated)
- Mobile: charts stacked
- Tablet: 2-column chart grid
- Desktop: 3-column chart grid

#### Health Reminders (Empty / Populated)
- Mobile: list view
- Tablet + Desktop: list with reminder detail panel on right when selected

#### Health Settings / Import & Export / Health Archive / Health Dashboard
- Mobile: single column
- Tablet: 2-column settings sections
- Desktop: 2–3 column layout, dashboard tiles in grid

---

### BATCH 5 — STRENGTH & CONDITIONING

#### S&C Dashboard (Empty / Populated)
- Mobile: stacked sections
- Tablet: 2-column stat tiles + activity list below
- Desktop: 3-column stat tiles, activity list and charts side by side

#### Activity Library (Empty / Populated) + Activity Details + Create Activity
- Mobile: list → detail
- Tablet + Desktop: split view — library list left, activity detail right
- Create Activity: modal on tablet + desktop

#### Record S&C Session
- Mobile: full screen form, sections stacked
- Tablet: 2-column — activity selector left, session info right
- Desktop: same 2-column, wider with more visible activity detail

#### Session Details / Activity Statistics / Activity Goals / Activity Insights
- Mobile: single column
- Tablet: 2-column — stats/charts left, details right
- Desktop: 3-column where charts allow

#### Equipment / Session Templates (Empty / Populated)
- Mobile: list view
- Tablet + Desktop: split view — list left, detail/template right

#### Export / Archive / S&C Settings
- Mobile: single column
- Tablet + Desktop: 2-column layout, settings in grouped cards side by side

---

### BATCH 6 — TIMELINE

#### Global Timeline (Empty / Populated)
- Mobile: vertical timeline, single column
- Tablet: timeline with wider event cards
- Desktop: timeline with event detail side panel — click event, detail opens right without leaving the timeline

#### Timeline Dashboard (Empty / Populated)
- Mobile: stacked sections
- Tablet: 2-column stat tiles + recent events
- Desktop: 3-column — stats left, timeline centre, insights right

#### Timeline Event Details (Health Record / Training Session variants)
- Mobile: full screen detail
- Tablet + Desktop: opens as right panel in split view or centred modal

#### Timeline Filters
- Mobile: bottom sheet
- Tablet + Desktop: filter panel slides in from right OR inline filter bar below top bar

#### Timeline Search (Pre-search / Active Results)
- Mobile: full screen search
- Tablet + Desktop: search bar in top bar expands inline; results appear below in content area
- Results grid: 2 columns tablet, 3 columns desktop

#### Timeline Calendar (Month / Day / Week views)
- Mobile: month view default, tap day to see day view
- Tablet: month view with event list panel on right for selected day
- Desktop: full calendar — month view left ~60%, selected day event list right ~40%; week view shows 7-column grid with events inline

#### Timeline Statistics / Export / Favourites / Archive
- Mobile: single column
- Tablet: 2-column
- Desktop: 3-column for stats/charts; list + detail split for favourites/archive

#### Timeline Settings / Insights / Memories / Compare / Smart Collections / Widgets
- Mobile: single column scroll
- Tablet: 2-column sections
- Desktop: 2–3 column sections, widgets gallery in 3–4 column grid

#### Timeline Activity Map (Empty / Marker Selected / Default)
- Mobile: full screen map, bottom sheet for marker detail
- Tablet: map fills content area, detail panel slides in from right on marker tap
- Desktop: map left ~65%, marker detail panel right ~35%, always visible

---

### BATCH 7 — MORE & SETTINGS

#### More Page / More Dashboard
- Mobile: hub card list, single column
- Tablet: 2-column hub card grid
- Desktop: 3-column hub card grid
- Note: on web, "More" becomes less prominent — Settings, Profile, Notifications etc. are directly accessible from sidebar. More Page still exists as a hub but sidebar shortcuts reduce its necessity.

#### Notification Settings / Appearance Settings / Backup & Sync / Offline Mode & Downloads / Storage Management
- Mobile: single column grouped settings
- Tablet: 2-column grouped settings (labels left, controls right)
- Desktop: 2-column, wider — max-width 800px centred in content area

#### Help Centre / Contact Support / Report a Bug / Feature Requests / About Ulvenik / Privacy Policy / Terms & Conditions / What's New / Open Source Licences
- Mobile: single column scrollable content
- Tablet: content max-width 720px centred
- Desktop: content max-width 800px centred, comfortable reading width — never full viewport width for text-heavy pages

#### Settings (hub)
- Mobile: grouped list
- Tablet: 2-column grouped sections
- Desktop: sidebar-within-content pattern — settings categories left sub-panel, settings content right

#### Notifications Page
- Mobile: single column list
- Tablet + Desktop: list with notification detail on right when selected (split view)

#### Profile Page
- Mobile: full screen profile
- Tablet: profile header top, 2-column sections below
- Desktop: profile header left (photo + name + stats), settings sections right in 2-column grid

#### Edit Profile
- Mobile: full screen form
- Tablet + Desktop: centred modal max-width 560px OR inline within the profile page right panel

---

### BATCH 8 — ACCOUNT & UTILITY

#### Billing History / Subscription Details / Restore Purchases / Delete Account / Export My Data
- Mobile: single column
- Tablet + Desktop: centred content max-width 720px

#### Change Email Address / Change Password
- Mobile: full screen form
- Tablet + Desktop: centred modal max-width 480px

#### Calendar Page
- Mobile: month view, tap for day detail bottom sheet
- Tablet: month view + day detail panel right
- Desktop: full calendar — month left ~60%, selected day right ~40%; week view 7-column

#### Global Search
- Mobile: full screen overlay (no bottom nav)
- Tablet + Desktop: search bar expands in top bar, results appear as full-page overlay or inline below top bar — NOT a separate page on web; it's a universal search overlay

#### Country or Region / Language / Measurement Units / Date & Time Format / Time Zone
- Mobile: full screen list
- Tablet + Desktop: centred modal max-width 480px with searchable list

#### Change Photo (Bottom Sheet) / Image Editor (Crop Guide)
- Mobile: bottom sheet → full screen editor
- Tablet + Desktop: centred modal for photo selection options; image editor opens as large centred modal max-width 800px, crop circle centred in the editor area; pure black `#000000` background inside editor modal

---

### BATCH 9 — MEDIA & LIBRARY

#### Media Library
- Mobile: 3-column thumbnail grid
- Tablet: 4-column thumbnail grid
- Desktop: 5–6 column thumbnail grid, larger thumbnails

#### Video Viewer
- Mobile: full screen, pure black `#000000` bg, no nav
- Tablet: video centred in dark overlay modal, controls below
- Desktop: large centred modal, max-width 1200px; video fills modal, controls overlay on hover; pure black bg

#### Photo Viewer
- Mobile: full screen, pure black bg, swipe between photos
- Tablet + Desktop: centred modal, photo fills available height maintaining aspect ratio; arrow controls left/right; pure black bg

#### Document Viewer
- Mobile: full screen scroll
- Tablet: document centred, side margins visible
- Desktop: document max-width 800px centred with comfortable reading margins

#### Media Upload Manager
- Mobile: single column upload queue
- Tablet + Desktop: 2-column — upload queue left, upload progress/details right

#### Media Collections
- Mobile: collection cards, single column
- Tablet: 2-column collection cards
- Desktop: 3-column collection cards; selecting a collection shows its media in a split view right panel

#### Storage Manager
- Mobile: single column, usage bars stacked
- Tablet + Desktop: usage overview at top in a row, breakdown sections in 2-column grid below

#### Media Search
- Mobile: full screen search overlay
- Tablet + Desktop: inline search within Media Library top bar; results in same grid layout as Media Library

#### Favourites
- Mobile: 3-column thumbnail grid
- Tablet: 4-column
- Desktop: 5–6 column

---

### BATCH 10 — SPORT PACK

#### Sport Pack Overview
- Mobile: hub cards stacked
- Tablet: 2-column hub cards
- Desktop: 3-column hub cards with stat summary row at top

#### My Sports
- Mobile: sport cards list
- Tablet: 2-column sport card grid
- Desktop: 3-column sport card grid

#### Sport Details (IGP)
- Mobile: full screen detail, sections stacked
- Tablet: hero info top, 2-column sections below
- Desktop: split — sport info + stats left, competitions/skills right

#### Create Sport
- Mobile: full screen form
- Tablet + Desktop: centred modal max-width 560px

#### Competitions Overview
- Mobile: list view
- Tablet + Desktop: split view — competition list left, competition detail right

#### Competition Details / Record Competition Result / Competition Results
- Mobile: full screen
- Tablet + Desktop: modal or right panel in split view

#### Qualifications, Titles & Awards / Sport Statistics
- Mobile: single column
- Tablet: 2-column
- Desktop: 3-column for stats; awards in masonry or 3-column grid

#### Add Competition
- Mobile: full screen form
- Tablet + Desktop: centred modal max-width 560px

#### Achievements & Title / Certificates & Documents
- Mobile: list/card view
- Tablet: 2-column grid
- Desktop: 3-column grid; selecting item opens detail in right panel

---

### BATCH 11 — TRAINER PACK

#### Trainer Dashboard
- Mobile: stacked stat cards + activity feed
- Tablet: 2-column stat tiles, activity feed below
- Desktop: 3-column stat tiles, activity feed centre, quick actions right panel

#### Trainer Profile & Business Identity
- Mobile: full screen profile
- Tablet: profile header top, 2-column sections below
- Desktop: profile photo + identity left, business info + settings right

#### Clients Page
- Mobile: client cards list
- Tablet: 2-column client card grid
- Desktop: split view — client list left panel (360px), client detail right; OR 3-column client grid with detail modal on click

#### Client Profile
- Mobile: full screen, sections stacked
- Tablet: hero info top full width, 2-column sections below
- Desktop: client hero + summary left ~35%, content sections right ~65% in scrollable panel

#### Client Dog Profile
- Mobile: full screen
- Tablet: 2-column sections
- Desktop: split — dog info left, training/health summary right

#### Add Client / Edit Client
- Mobile: full screen form
- Tablet + Desktop: centred modal max-width 560px

#### Client Notes
- Mobile: notes list → note detail
- Tablet + Desktop: split view — notes list left, note content right (full text editor style)

#### Client Homework / Homework Details
- Mobile: list → detail
- Tablet + Desktop: split view — homework list left, homework detail right

#### Client Progress
- Mobile: single column, charts stacked
- Tablet: 2-column chart grid
- Desktop: 3-column chart grid, progress summary row at top

#### Shared Records
- Mobile: list view
- Tablet + Desktop: split view — records list left, record detail right

#### Client Permissions
- Mobile: full scroll — summary card, preset grid, permission sections, history
- Tablet: summary card + preset grid at top side by side; permission sections in 2-column card grid below
- Desktop: same as tablet, 3-column permission sections grid; permission history in right rail

#### Trainer Reports
- Mobile: reports list, single column
- Tablet: 2-column report card grid
- Desktop: split view — reports list left, report preview/builder right

**Report Builder:**
- Mobile: multi-step form (separate steps on separate screens)
- Tablet + Desktop: single page — all builder sections visible in left panel (scrollable), live preview right panel — both visible simultaneously

#### Trainer Workspace Settings
- Mobile: single column grouped settings
- Tablet + Desktop: 2-column grouped settings

---

### NEW SCREENS

#### Rewards Management
- Mobile: list + type filter pills + FAB
- Tablet: 2-column reward card grid, type filter pills above
- Desktop: 3-column reward card grid; "Manage Types" opens right panel

#### Add Reward / Edit Reward
- Mobile: bottom sheet
- Tablet + Desktop: centred modal max-width 480px

#### Manage Reward Types
- Mobile: full screen list
- Tablet + Desktop: centred modal max-width 560px with draggable type list

---

## NAVIGATION — WEB SIDEBAR ACTIVE STATE RULES

| Section | Active Sidebar Item |
|---|---|
| Home | Home |
| Dogs, Dog Profile and all branches | Dogs |
| Training Session | Training (under Dogs section) |
| Global Timeline | Timeline |
| Calendar | Calendar |
| More / Settings / Profile / Account | Settings (or the specific item) |
| Media / Library | Dogs (or separate Media item if in sidebar) |
| Notifications | Notifications (bell icon top bar) |
| Sport Pack | Sport Pack (gated — only shown if subscribed) |
| Trainer Pack | Trainer Pack (gated — only shown if subscribed) |

---

## MODALS vs BOTTOM SHEETS — WEB RULES

| Pattern | Mobile web | Tablet | Desktop |
|---|---|---|---|
| Options sheet (e.g. Change Photo options) | Bottom sheet | Centred modal | Centred modal |
| Form (e.g. Add Client, Create Goal) | Full screen | Centred modal max-width 560px | Centred modal max-width 560px |
| Confirmation (e.g. Delete, Discard) | Bottom sheet | Small centred modal max-width 400px | Small centred modal max-width 400px |
| Filter panel | Bottom sheet | Right slide-in panel or inline | Inline filter bar or right panel |
| Detail view | Separate screen | Right panel in split view | Right panel in split view |
| Search | Full screen overlay | Inline top bar expansion | Inline top bar expansion |

---

## SPLIT VIEW — WHEN TO USE IT

Apply split view (list left + detail right) on tablet and desktop for:
- Dogs list → Dog Profile
- Training Sessions list → Session Detail
- Skills list → Skill Detail
- Goals list → Goal Detail
- Health Records list → Record Detail
- Clients list → Client Profile
- Client Notes list → Note Detail
- Client Homework list → Homework Detail
- Trainer Reports list → Report Preview
- Timeline events → Event Detail
- Notifications list → Notification Detail
- Media Collections → Collection Contents
- Competitions list → Competition Detail
- Achievements list → Achievement Detail
- Certificates list → Certificate Detail
- Shared Records list → Record Detail

On mobile, these are always separate screens navigated sequentially.

---

## FORMS — MULTI-STEP vs SINGLE PAGE

| Form | Mobile | Tablet | Desktop |
|---|---|---|---|
| Create Training Session | Multi-step or long scroll | Single page modal | Single page modal |
| Record S&C Session | Multi-step or long scroll | Single page modal | Single page modal |
| Add Health Record | Multi-step or long scroll | Single page modal | Single page modal |
| Create Goal | Single scroll | Modal | Modal |
| Add Client | Single scroll | Modal | Modal |
| Report Builder | Multi-step (sections as steps) | Single page — builder left, preview right | Single page — builder left, preview right |
| Create Sport | Single scroll | Modal | Modal |
| Add Competition | Single scroll | Modal | Modal |
| Add Reward | Bottom sheet | Modal | Modal |
| Manage Reward Types | Full screen | Modal | Modal |

---

## TYPOGRAPHY — WEB SCALE

Same Inter font family as mobile. Scale up where appropriate on desktop:

| Element | Mobile | Tablet | Desktop |
|---|---|---|---|
| Screen/page title | 17px semibold | 20px semibold | 22px semibold |
| Section eyebrow | 11px ALL CAPS | 11px ALL CAPS | 12px ALL CAPS |
| Card headline | 20px semibold | 20px semibold | 22px semibold |
| Body text | 15–16px | 16px | 16–18px |
| Button label | 17px semibold | 17px semibold | 17px semibold |
| Table/list item | 14–15px | 15px | 15–16px |

---

## MEDIA VIEWERS — WEB SPECIFIC

### Video Viewer
- No bottom nav on any size
- Pure `#000000` background always
- Mobile web: full viewport
- Tablet + Desktop: centred modal, max-width 1200px, video maintains aspect ratio
- Controls (play, seek, volume, fullscreen) overlay on hover — hidden when idle
- Fullscreen button always visible

### Photo Viewer
- Pure `#000000` background always
- Mobile web: full viewport, swipe between photos
- Tablet + Desktop: centred modal with left/right arrows, keyboard navigation (← →), Escape to close
- Photo fits within viewport height maintaining aspect ratio

---

## IMAGE EDITOR (Change Profile Photo)
- Mobile web: full screen editor, pure black bg
- Tablet + Desktop: large centred modal max-width 800px, pure black bg inside editor bounds, dark overlay outside
- Circular crop guide centred
- Editing controls (rotate, reset, zoom slider) below the crop area inside the modal
- Live preview strip below controls
- Save/Choose Another buttons at bottom of modal

---

## IMPORTANT WEB-ONLY NOTES

1. **Auth screens have no sidebar** — Login, Register, Forgot Password, Verify Email, Set New Password, Welcome, 2FA — all are centred standalone pages with no sidebar or top bar
2. **Splash screen on web** — shows briefly on initial load only; not a persistent page
3. **Global Search on web** — not a separate page; it is a top bar overlay that appears on all screens
4. **Notifications on web** — bell icon in top bar right; clicking opens a dropdown or slide-in panel from the right rather than navigating to a separate page (the Notifications page still exists as a full page for viewing all notifications)
5. **More Page on web** — less prominent since sidebar gives direct access to most sections; still exists as a hub page but many of its items are directly in the sidebar
6. **Offline Mode on web** — web app handles offline differently from mobile; show an offline banner at the top when connection is lost rather than a full-screen state; data still readable from local cache
7. **FAB on web** — on tablet and desktop, the FAB may be replaced by a "+ Create" button in the top bar or section header; maintain the Forest Green colour and Off White label
8. **Swipe actions (e.g. swipe left to reveal Edit/Delete on cards)** — on web use hover state to reveal action icons (pencil + trash) on the right of each row/card instead of swipe; same actions, different interaction pattern
9. **Haptic feedback** — not applicable on web; ignore all haptic references from the prompts
10. **Biometric login** — Web Authentication API (WebAuthn) for web; passkey/fingerprint where browser supports it
11. **Drag to reorder (e.g. Manage Reward Types)** — drag and drop with mouse on web; same visual outcome
12. **Pull to refresh** — not applicable on web; use a manual refresh button or auto-refresh on focus return
13. **Deep links** — every screen must have a unique URL on web for direct navigation and browser history support
14. **Back navigation** — browser back button must work correctly throughout; no screen transition should break browser history
