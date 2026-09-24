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
| Splash Screen | BUILD | App launch screen |
| ONBOARDING SCREEN 1 | BUILD | — |
| ONBOARDING SCREEN 2 | BUILD | — |
| ONBOARDING SCREEN 3 | BUILD | — |
| Login | BUILD | — |
| Create Account | BUILD | — |
| Forgot Password | BUILD | — |
| Confirmation Screen | BUILD | Shown after registration |
| Email Verified | BUILD | — |
| Set New Password | BUILD | — |
| Password Updated | BUILD | Success state after password reset |
| Welcome | BUILD | First-time welcome after onboarding |
| 2FA Setup | BUILD | — |
| Disabled State | SKIP | Reference state for 2FA toggle — implement as state of 2FA Setup |
| Enabled State | SKIP | Reference state for 2FA toggle — implement as state of 2FA Setup |
| Dog Profile | SKIP | This is the early Stitch test frame — superseded by Dog Profile - Overview screens below |

---

## BATCH 2 — Core App Entry

| Figma Frame | Action | Notes |
|---|---|---|
| Homepage Empty Data | BUILD | Implement as empty state of Home screen |
| Homepage Populated | BUILD | Implement as populated state of Home screen — build one screen, two states |
| My Dogs Empty State | BUILD | Empty state of Dogs screen |
| My Dogs Populated | BUILD | Populated state — one screen, two states |
| Dogs All Workspaces | BUILD | — |

---

## BATCH 3 — Dog Profile

| Figma Frame | Action | Notes |
|---|---|---|
| Dog Profile - Overview (New Dog) | BUILD | Empty/new dog state |
| Dog Profile - Overview (Populated) | BUILD | One screen, two states |
| Training Page - Empty | BUILD | — |
| Training Page - Populated | BUILD | One screen, two states |
| Training Session - Draft State | BUILD | — |
| Training Session - Completed State | BUILD | One screen, two states |
| Skills List - Empty State | BUILD | — |
| Skills List - Populated State | BUILD | One screen, two states |
| Skill Details - Recall | BUILD | — |
| Edit Skill - Discard Flow | SKIP | Reference for discard confirmation flow — implement as modal/alert |
| Add Skill - Technical Form | BUILD | — |
| Add Exercise - Technical Form | BUILD | — |
| Exercise Details - Emergency Recall | BUILD | — |
| Edit Exercise - Technical Form | BUILD | — |
| Archive & Delete Workflows | SKIP | Reference for archive/delete confirmation flows — implement as modals/alerts throughout |
| Goals List - Populated State | BUILD | — |
| Goals List - Empty State | BUILD | One screen, two states |
| Create Goal - Technical Form | BUILD | — |
| Goal Details - Complete 20 Recall Sessions | BUILD | — |
| Goal Details - Archive & Delete States | SKIP | Reference for goal archive/delete — implement as states/modals of Goal Details |
| Statistics - Empty State | BUILD | — |
| Statistics - Populated State | BUILD | One screen, two states |
| Dog Timeline - Empty State | BUILD | — |
| Dog Timeline - Populated State | BUILD | One screen, two states |

---

## BATCH 4 — Health

| Figma Frame | Action | Notes |
|---|---|---|
| Health - Empty State | BUILD | — |
| Health - Populated State | BUILD | One screen, two states |
| Health Records - Empty State | BUILD | — |
| Health Records - Populated State | BUILD | One screen, two states |
| Add Health Record - General Form | BUILD | — |
| Add Health Record - Medication State | SKIP | Reference for medication variant of Add Health Record form — implement as form state |
| Health Record Details - Injury record with empty state sections | BUILD | — |
| Health Record Details - Medication record populated with all sections | SKIP | Reference for medication variant — implement as state of Health Record Details |
| Weight Tracker - Empty State | BUILD | — |
| Weight Tracker - Populated State | BUILD | One screen, two states |
| Medication Manager - Empty State | BUILD | — |
| Medication Manager - Populated State | BUILD | One screen, two states |
| Vaccination Manager - Populated State | BUILD | — |
| Vaccination Manager - Empty State | BUILD | One screen, two states |
| Vet Visits - Empty State | BUILD | — |
| Vet Visits - Populated State | BUILD | One screen, two states |
| Injuries & Recovery - Empty State | BUILD | — |
| Injuries & Recovery - Populated State | BUILD | One screen, two states |
| Physiotherapy & Hydrotherapy - Empty State | BUILD | — |
| Physiotherapy & Hydrotherapy Hub | BUILD | One screen, two states |
| Supplements - Empty State | BUILD | — |
| Supplements - Populated State | BUILD | One screen, two states |
| Allergies & Sensitivities - Empty State | BUILD | — |
| Allergies & Sensitivities - Populated State | BUILD | One screen, two states |
| Dental Care - Empty State | BUILD | — |
| Dental Care - Populated State | BUILD | One screen, two states |
| Health Reports & Timeline - Empty State | BUILD | — |
| Health Reports & Timeline - Populated State | BUILD | One screen, two states |
| Surgery & Procedures - Empty State | BUILD | — |
| Surgery & Procedures - Populated State | BUILD | One screen, two states |
| Health Statistics - Empty State | BUILD | — |
| Health Statistics - Populated State | BUILD | One screen, two states |
| Health Reminders - Empty State | BUILD | — |
| Health Reminders - Populated State | BUILD | One screen, two states |
| Health Settings - Default State | BUILD | — |
| Import & Export - Empty State (No Backup) | BUILD | — |
| Import & Export - Populated State | BUILD | One screen, two states |
| Health Archive - Empty State | BUILD | — |
| Health Archive - Populated State | BUILD | One screen, two states |
| Health Dashboard - Empty State | BUILD | — |
| Health Dashboard - Populated State | BUILD | One screen, two states |

---

## BATCH 5 — Strength & Conditioning

| Figma Frame | Action | Notes |
|---|---|---|
| Strength & Conditioning Dashboard - Empty State | BUILD | — |
| Strength & Conditioning Dashboard - Populated State | BUILD | One screen, two states |
| Activity Library - Empty State | BUILD | — |
| Activity Library - Populated State | BUILD | One screen, two states |
| Activity Details - Empty State | BUILD | — |
| Activity Details - Populated State | BUILD | One screen, two states |
| Create Activity - Default State | BUILD | — |
| Record Session - No Activity Selected | BUILD | — |
| Record Session - Activity Pre-selected | SKIP | Reference state — implement as state of Record Session |
| Session Details - Populated State | BUILD | — |
| Activity Statistics - Empty State | BUILD | — |
| Activity Statistics - Populated State | BUILD | One screen, two states |
| Activity Goals - Empty State | BUILD | — |
| Activity Goals - Populated State | BUILD | One screen, two states |
| Activity Insights - Empty State | BUILD | — |
| Activity Insights - Populated State | BUILD | One screen, two states |
| Equipment - Empty State | BUILD | — |
| Equipment - Populated State | BUILD | One screen, two states |
| Session Templates - Empty State | BUILD | — |
| Session Templates - Populated State | BUILD | One screen, two states |
| Export - Empty History State | BUILD | — |
| Export - Configured State | SKIP | Reference state — implement as state of Export screen |
| Archive - Empty State | BUILD | — |
| Archive - Populated State | BUILD | One screen, two states |
| Strength & Conditioning Settings | BUILD | — |

---

## BATCH 6 — Timeline

| Figma Frame | Action | Notes |
|---|---|---|
| Global Timeline - Empty State | BUILD | — |
| Global Timeline - Populated State | BUILD | One screen, two states |
| Timeline Dashboard - Empty State | BUILD | — |
| Timeline Dashboard - Populated State | BUILD | One screen, two states |
| Timeline Event - Health Record | BUILD | — |
| Timeline Event - Training Session | SKIP | Reference variant — implement as state of Timeline Event Details |
| Timeline Filters - Partially Applied State | BUILD | — |
| Timeline Search - Pre-search State | BUILD | — |
| Timeline Search - Active Results State | SKIP | Reference state — implement as state of Timeline Search |
| Timeline Calendar - Month View | BUILD | — |
| Timeline Calendar - Day View | SKIP | Reference state — implement as state of Timeline Calendar |
| Timeline Calendar - Week View | SKIP | Reference state — implement as state of Timeline Calendar |
| Timeline Statistics - Empty State | BUILD | — |
| Timeline Statistics - Populated State | BUILD | One screen, two states |
| Timeline Export - Empty State | BUILD | — |
| Timeline Export - Populated State | BUILD | One screen, two states |
| Timeline Favourites - Empty State | BUILD | — |
| Timeline Favourites - Populated State | BUILD | One screen, two states |
| Timeline Archive - Empty State | BUILD | — |
| Timeline Archive - Populated State | BUILD | One screen, two states |
| Timeline Settings | BUILD | — |
| Timeline Insights - Empty State | BUILD | — |
| Timeline Insights - Populated State | BUILD | One screen, two states |
| Timeline Memories - Empty State | BUILD | — |
| Timeline Memories - Populated State | BUILD | One screen, two states |
| Timeline Activity Map - Empty State | BUILD | — |
| Timeline Activity Map - Marker Selected | SKIP | Reference state — implement as state of Activity Map |
| Timeline Activity Map - Default State | SKIP | Reference state — implement as state of Activity Map |
| Timeline Compare - Empty State | BUILD | — |
| Timeline Compare - Populated State | BUILD | One screen, two states |
| Timeline Smart Collections - Empty State | BUILD | — |
| Timeline Smart Collections - Populated State | BUILD | One screen, two states |
| Timeline Widgets - Empty State | BUILD | — |
| Timeline Widgets - Populated Gallery | BUILD | One screen, two states |

---

## BATCH 7 — More & Settings

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — More Page | BUILD | — |
| Ulvenik — More Dashboard | BUILD | — |
| Ulvenik — Notification Settings | BUILD | — |
| Ulvenik — Appearance Settings | BUILD | — |
| Ulvenik — Backup & Sync | BUILD | — |
| Ulvenik — Offline Mode & Downloads | BUILD | — |
| Ulvenik — Storage Management | BUILD | — |
| Ulvenik — Help Centre | BUILD | — |
| Ulvenik — Contact Support | BUILD | — |
| Ulvenik — Report a Bug | BUILD | — |
| Ulvenik — Feature Requests | BUILD | — |
| Ulvenik — About Ulvenik | BUILD | — |
| Ulvenik — Privacy Policy | BUILD | — |
| Ulvenik — Terms & Conditions | BUILD | — |
| Ulvenik — What's New | BUILD | — |
| Ulvenik — Open Source Licences | BUILD | — |
| Ulvenik — Settings | BUILD | — |
| Ulvenik — Notifications Page | BUILD | — |
| Ulvenik — Profile Page | BUILD | — |
| Ulvenik — Edit Profile | BUILD | — |

---

## BATCH 8 — Account & Utility

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — Billing History | BUILD | — |
| Ulvenik — Subscription Details | BUILD | — |
| Ulvenik — Restore Purchases | BUILD | — |
| Ulvenik — Delete Account | BUILD | — |
| Ulvenik — Export My Data | BUILD | — |
| Ulvenik — Change Email Address | BUILD | — |
| Ulvenik — Change Password | BUILD | — |
| Ulvenik — Calendar Page | BUILD | — |
| Ulvenik — Global Search | BUILD | — |
| Ulvenik — Country or Region | BUILD | — |
| Ulvenik — Language | BUILD | — |
| Ulvenik — Measurement Units | BUILD | — |
| Ulvenik — Date & Time Format | BUILD | — |
| Ulvenik — Time Zone | BUILD | — |
| Ulvenik — Change Photo (Bottom Sheet) | BUILD | Modal — no bottom nav |
| Ulvenik — Image Editor (Crop Guide) | BUILD | Modal — no bottom nav, pure black background |
| Ulvenik — Profile Photo (Empty State) | SKIP | Reference state — implement as state of Change Photo flow |

---

## BATCH 9 — Media & Library

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — Media Library | BUILD | — |
| Ulvenik — Video Viewer | BUILD | Pure black background, no bottom nav |
| Ulvenik — Photo Viewer | BUILD | Pure black background, no bottom nav |
| Ulvenik — Document Viewer | BUILD | — |
| Ulvenik — Media Upload Manager | BUILD | — |
| Ulvenik — Media Collections | BUILD | — |
| Ulvenik — Storage Manager | BUILD | — |
| Ulvenik — Media Search | BUILD | — |
| Ulvenik — Favourites | BUILD | — |

---

## BATCH 10 — Sport Pack (Sport Pack subscription required)

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — Sport Pack Overview | BUILD | — |
| Ulvenik — My Sports | BUILD | — |
| Ulvenik — Sport Details (IGP) | BUILD | First instance — keep, delete duplicate |
| Ulvenik — Create Sport | BUILD | — |
| Ulvenik — Competitions Overview | BUILD | — |
| Ulvenik — Competition Details | BUILD | First instance — keep, delete duplicate |
| Ulvenik — Record Competition Result | BUILD | — |
| Ulvenik — Qualifications, Titles & Awards | BUILD | — |
| Ulvenik — Sport Statistics | BUILD | — |
| Ulvenik — Sports List | SKIP | Duplicate of My Sports — delete from Figma |
| Ulvenik — Sport Details (IGP) | SKIP | Duplicate — delete from Figma, keep first instance |
| Ulvenik — Competition List | SKIP | Duplicate of Competitions Overview — delete from Figma |
| Ulvenik — Add Competition | BUILD | — |
| Ulvenik — Competition Details | SKIP | Duplicate — delete from Figma, keep first instance |
| Ulvenik — Competition Results | BUILD | — |
| Ulvenik — Achievements & Title | BUILD | — |
| Ulvenik — Certificates & Documents | BUILD | — |

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
| Ulvenik — Trainer Workspace Settings | BUILD — no replacement exists, keep this one |

### Branch screens — BUILD these

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — Trainer Dashboard | BUILD | — |
| Ulvenik — Trainer Profile & Business Identity | BUILD | — |
| Ulvenik — Clients Page (second instance) | BUILD | This is the branch PDF version |
| Ulvenik — Client Profile | BUILD | — |
| Ulvenik — Client Dog Profile | BUILD | — |
| Ulvenik — Add Client | BUILD | — |
| Ulvenik — Edit Client | BUILD | — |
| Ulvenik — Client Notes | BUILD | — |
| Ulvenik — Client Homework | BUILD | — |
| Ulvenik — Homework Details | BUILD | — |
| Ulvenik — Client Progress | BUILD | — |
| Ulvenik — Shared Records | BUILD | — |
| Ulvenik — Client Permissions | BUILD | — |
| Ulvenik — Trainer Reports | BUILD | — |

---

## NEW SCREENS (added during final review)

| Figma Frame | Action | Notes |
|---|---|---|
| Ulvenik — Rewards Management | BUILD | Lives under Dog Profile → Training |
| Ulvenik — Add Reward | BUILD | Bottom sheet modal |
| Ulvenik — Edit Reward | BUILD | Bottom sheet modal |
| Ulvenik — Manage Reward Types | BUILD | Full screen |

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
