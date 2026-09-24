# Ulvenik — Full Technical Analysis
## Backend Architecture, Developer Rules, Data Architecture, Security, Delivery & Roadmap
### Compiled from all skipped PDFs — for development team reference

---

## 1. SYSTEM ARCHITECTURE OVERVIEW

Ulvenik is an **offline-first cloud application** consisting of:

- Mobile Application (iOS + Android)
- Responsive Web Application
- Local Device Database (encrypted, per device)
- Synchronisation Engine
- Secure Backend API
- Cloud Database (master record)
- Cloud Media Storage
- Authentication Service
- Subscription Service
- Push Notification Service
- Administrative Portal

**Core principle:** The app always reads from the local database first. The cloud is the master record for sync and recovery, never for real-time reads.

---

## 2. APPLICATION STRUCTURE — THREE LAYERS

### Core (available to every user)
User Accounts · Dogs · Dog Profiles · Skills · Exercises · Training Sessions · Strength & Conditioning · Health · Goals · Calendar · Timeline · Statistics · Notifications · Search · Documents · Photos · Videos · Settings

### Trainer Pack (extends Core — never duplicates it)
Clients · Client Dogs · Homework · Lesson Records · Trainer Notes · Reports · Business Statistics · Permissions
— References existing Core records, never creates parallel systems.

### Sport Pack (extends Core — never duplicates it)
Sports · Competitions · Results · Qualifications · Titles · Awards
— Uses existing Core Training architecture, adds an organisational layer on top.

**Rule:** No module creates its own independent version of shared Core services. Every module reuses: Search · Calendar · Timeline · Statistics · Notifications · Media Library · Document Storage · Permissions · Synchronisation.

---

## 3. DATABASE DESIGN

### Philosophy
- Fully relational and normalised
- Each piece of information exists in ONE place — referenced, never duplicated
- A dog exists once. A session references a dog, never copies dog data.
- Equipment referenced by ID, not copied into every session.

### Primary Database Entities

**Accounts** — user profile, auth details, preferences, subscription, notification settings

**Dogs** — dog profile, breed, sex, DOB, hero image, health summary, archived status. Each dog belongs to one account.

**Client Dogs** (Trainer Pack only) — client relationship, shared permissions, assigned trainer, client notes

**Sports** — user-created, belongs to one account, contains skills, exercises, competition records

**Skills** — user-created, belongs to one sport + one account, contains sessions, notes, videos, statistics, goals

**Strength & Conditioning Activities** — user-created, belongs to one account, contains sessions, statistics, insights, equipment, goals

**Sessions** — every recorded session. References: Dog · Sport · Skill · Activity · Equipment · Rewards · Media · Notes · Weather · Location. Never contains duplicated copies of related records.

**Health Records** — Weight · Medication · Vaccinations · Injuries · Vet Visits · Supplements · Treatments. Each record belongs to one dog.

**Goals** — goal type, target, progress, completion status. References: Dogs · Skills · Activities.

**Timeline** — chronological events referencing all other record types.

**Media** — references session, dog, activity. Never exists without ownership.

**Equipment** — user-created, referenced by sessions.

**Rewards** — user-created, referenced by sessions.

**Tags** — user-created, referenced throughout.

### Standard Fields on Every Record
- Record ID (globally unique, UUID)
- Owner User ID
- Created Date
- Last Modified Date
- Created By Device
- Last Modified By Device
- Sync Status
- Record Version (increments on every successful edit)
- Archived Status
- Deleted Status (soft delete)

### Unique IDs
- Every record has a globally unique identifier
- IDs must never expose: user info, email addresses, sequential numbers, subscription info
- IDs must support offline creation without collisions

### Soft Delete
- Deleting normally uses soft deletion — record disappears from UI but remains recoverable and continues to sync
- Permanent deletion only where explicitly appropriate

### Archiving
- Archived ≠ deleted
- Archived records: remain linked to history, remain searchable where appropriate, can be restored, must never affect historical statistics

### Version Control
- Every record includes a version number
- Each successful edit increments the version
- Used for: synchronisation, conflict detection, recovery, audit history

---

## 4. SYNCHRONISATION ENGINE

### Philosophy
- Offline-first: every user action saves to local DB immediately, UI updates instantly
- Cloud sync happens in the background — invisible during normal use
- Users must never lose data due to poor connectivity

### Sync Flow (every create/edit/delete)
1. Save to local database immediately
2. Update UI instantly
3. Add change to sync queue
4. Monitor internet connectivity
5. Upload pending changes automatically
6. Validate on backend
7. Download newer records from cloud
8. Mark records as synchronised

### Sync Queue — each item contains
- Operation ID
- Record ID
- Record Type
- Action Type
- Time Created
- Record Version
- Sync Status
- Retry Count

### Sync Statuses per record
- Synced
- Waiting to Sync
- Syncing
- Conflict Detected
- Failed
- Retry Pending

### Auto Sync triggers
- Internet connectivity returns
- App launches
- App resumes from background
- User signs in
- Significant batch of offline changes exists
- Manual sync requested

### Background Sync
- Continues in background where OS permits
- Users don't need to keep app open during uploads
- Pauses gracefully if OS limits it, resumes automatically

### Conflict Detection
Conflict occurs when:
- Two devices edit the same record
- Record modified locally after being changed in the cloud
- Sync order cannot safely determine newest version

Detected using: Record Version + Last Modified Timestamp + Device Identifier

### Conflict Resolution
- Minor metadata changes: merge automatically
- Separate notes added independently: merge where possible
- If auto-resolution is unsafe: present user with a clear comparison
- User choices: Keep Local Version · Keep Cloud Version · Merge Manually
- **The app must never silently discard user data**

### Duplicate Prevention
- Each operation has a unique operation ID
- Processed only once even on retry
- Critical at: internet drops during upload, auto-retries, multiple Save taps, reconnecting after long offline periods

### Retry Strategy
- Immediate retry → short delay → increasing intervals → maximum retry limit → continue after connectivity improves
- Retries must not overload backend

### Partial Sync
- Never download entire account on every sync
- Only changed records transfer
- Large media syncs independently from structured records

### Media Sync (separate from record sync)
1. Save session locally
2. Queue media upload
3. Upload in background
4. Generate thumbnails
5. Update media references
6. Mark upload complete

Session appears in app immediately. Media attaches once upload completes. User can continue using app during this time.

### Sync Priority
- **Highest:** Sessions · Health Records · Dog Profiles · Goals
- **Medium:** Statistics · Timeline · Equipment · Activities
- **Lower:** Photos · Videos

---

## 5. AUTHENTICATION & ACCOUNTS

### Auth Methods (V1)
- Email + Password
- Sign in with Apple (where platform supports it)

### Future Auth (architecture must support without major redevelopment)
- Google
- Microsoft

### Account Types (V1)
- Standard User only

### Future Account Types (architecture must support)
- Administrator · Moderator · Beta Tester · Organisation · Club · Kennel · Team Account

### Email Verification
- Required on new registration
- Verification email contains: secure link, expiration time, option to resend
- Gentle reminders until verified

### Password Requirements
- Minimum 8 characters, maximum 128
- Must include: uppercase, lowercase, number, special character
- Never stored in plain text
- Securely hashed, never reversible, never in logs, never accessible to admins

### Login Response (what backend returns on successful auth)
- Secure access token
- Refresh token
- User profile
- Subscription status
- Feature entitlements
- Synchronisation information
- App then initiates sync automatically

### Session Management
Session stays active until: user signs out · session expires · security requires re-auth · password changed · device revoked
Users must NOT be forced to log in repeatedly during normal use.

### Trusted Devices
- Backend maintains: Device ID, Device Name, Platform, Last Active Date, App Version
- Users can remove trusted devices from account settings
- Removing a device immediately revokes its auth tokens

### Multi-Device Support
- Users may access from multiple devices simultaneously (iPhone, iPad, Android Phone, Android Tablet, Web)

### Subscription Entitlements
- On login, backend returns feature entitlements based on subscription
- Trainer Pack and Sport Pack features must be gated client-side AND server-side
- **Never rely on client-side only for subscription gating**

---

## 6. API ARCHITECTURE

### Philosophy
- Fast · Secure · Consistent · Predictable · Versioned · Well documented · Backwards compatible

### Versioning
- All endpoints: `/api/v1/`
- Future: `/api/v2/`, `/api/v3/`
- Breaking changes never introduced into an existing API version
- Older app versions continue functioning until support intentionally withdrawn

### Backend Services (modular)

| Service | Responsibilities |
|---|---|
| Authentication Service | Login, Registration, Password Reset, Token Validation, Email Verification, Session Management |
| User Service | User Profiles, Preferences, Settings, Notification Preferences, Account Deletion |
| Dog Service | Dog Profiles, Hero Photos, Dog Search, Archived Dogs, Remembered Dogs |
| Training Service | Training Sessions, Skills, Exercises, Session History, Training Statistics |
| S&C Service | Activities, Sessions, Equipment, Activity Statistics, Activity Insights |
| Health Service | Weight, Medication, Vaccinations, Injuries, Vet Visits, Treatments, Supplements |
| Timeline Service | Timeline Events, Chronological History, Filtering, Search |
| Goals Service | Goals, Progress Tracking, Milestones, Goal Completion |
| Media Service | Photo Upload, Video Upload, Compression, Thumbnail Generation, Storage, Retrieval |
| Statistics Service | Dashboard Stats, Dog Stats, Skill Stats, Activity Stats, Cached Calculations |
| Search Service | Global search across all modules |
| Subscription Service | Plan validation, entitlement checks, billing events |
| Notification Service | Push notification delivery, reminders, weekly summaries |
| Sync Service | Queue processing, conflict detection, partial sync orchestration |
| Trainer Pack Service | Client management, permissions, homework, lesson records, reports |
| Sport Pack Service | Sports, competitions, results, qualifications, titles, awards |
| Admin Service | Administrative portal operations |

### Every API Request Must
- Require authentication where appropriate
- Validate permissions
- Validate ownership
- Validate request data
- Reject malformed requests
- Reject unauthorised requests
- **Never rely solely on the client app for security**

---

## 7. MEDIA STORAGE & FILE MANAGEMENT

### Supported Media (V1)
- Photos: training photos, hero images, health photos, injury progression, competition photographs
- Videos: training sessions, skill demonstrations, competition runs, behaviour observations, S&C exercises

### Future Media (architecture must support)
- PDF documents · Veterinary reports · X-rays · Blood test results · Audio recordings · GPS route files

### Media Storage Architecture
- Large media files NOT stored inside the primary database
- Database stores: Media ID · Owner ID · Dog ID · Session ID · Upload Date · File Type · File Size · Duration (video) · Thumbnail Reference · Cloud Storage Location · Sync Status
- Original files stored in secure cloud object storage

### File Naming
- Internal storage names must never expose personal information
- Names generated automatically using secure unique identifiers
- Dog names, user names, email addresses must never appear in storage paths

### Upload Process
1. Save local copy
2. Create database record
3. Generate thumbnail
4. Queue the upload
5. Upload in background
6. Verify upload integrity
7. Update cloud reference
8. Mark as synchronised

User continues using app during upload.

### Video Processing (background, automatic)
- Compression
- Thumbnail generation
- Resolution optimisation
- Metadata extraction
- Original quality preserved where practical

### Image Processing
- Automatic orientation correction
- Optimised compression
- Thumbnail creation
- Efficient loading at multiple resolutions

### Thumbnail Generation
- Every photo and video gets a thumbnail automatically
- Used in: Dog Profiles, Timeline, Training History, Video Library, Search Results
- Full resolution loads only when required

### Local Storage / Caching
- Recent media stored locally for: offline viewing, background uploads, temporary caching, draft sessions
- App automatically manages cache size to prevent excessive device storage usage

### Data Retention
- Reports remain available until manually deleted
- Archived records never permanently removed unless explicitly chosen
- Soft-deleted records recoverable

---

## 8. SECURITY, PRIVACY & COMPLIANCE

### Core Security Principles
- Least Privilege Access
- Defence in Depth
- Secure by Default
- Zero Trust between services
- Encryption Everywhere
- Principle of Minimum Data Collection
- Continuous Monitoring

### Encryption in Transit
- All communication between Mobile App, Web App, Backend API, Cloud Storage, Auth Services must use HTTPS
- Unencrypted communication never permitted

### Encryption at Rest
- User profile information · Auth credentials · Refresh tokens · Notification tokens · Personal account details
- Encryption keys never stored alongside encrypted data

### Rate Limiting (must be implemented on)
- Login · Registration · Password Reset · Email Verification · Search · Media Upload · Export Generation
- Rate limits protect infrastructure, remain invisible to legitimate users

### Input Validation (all incoming data)
- Required fields · Character limits · Accepted file types · File sizes · Numeric ranges · Date validation · Relationship validation

### Privacy
- Users own their own data at all times
- Trainer Pack: client always remains the owner of their own data, trainer permissions are granted access only
- Media metadata (GPS location) removed before upload
- Profile photos and uploaded media never publicly visible unless future public profile feature enabled

### Permission Validation (every request involving private info)
- Account ownership
- Subscription entitlement
- Trainer permissions (where applicable)
- Always verified by backend, never client-side only

---

## 9. DEVELOPER RULES & GLOBAL TECHNICAL SPECIFICATION

### Nothing Hardcoded
**Everything user-facing must be dynamic.** Users can create, edit, archive and delete their own:
Sports · Skills · Exercises · S&C Activities · Equipment · **Rewards** · Tags · Goals · Templates · Notes · Collections

### Unlimited Records
No arbitrary limits on:
Dogs · Client Dogs · Sports · Skills · Exercises · Sessions · Photos · Videos · Notes · Equipment · Activities · Goals · Templates · Tags · Health Records
Limits only exist where required by subscription or physical device storage.

### Offline First (mandatory)
Users must be able to do all of the following with no internet:
- Record training sessions
- Record S&C sessions
- Add and edit dogs
- Update health records
- Record notes
- View statistics
- Search data
- View locally stored media
- Create new records

All offline changes auto-sync when connectivity returns. Users never lose data for being offline.

### Auto Save
Forms must automatically save drafts where appropriate. If app closes unexpectedly, in-progress data must be recoverable.

### Performance Requirements
App must remain responsive with:
- 500+ dogs
- 100,000+ sessions
- Thousands of photos and videos
- Large statistical datasets
- Thousands of health records

Scrolling: smooth. Search results: near-instant. Charts: no noticeable delay.

### Search (every searchable module)
- Instant searching
- Partial word matching
- Typo tolerance where practical
- Fast indexing
- Offline searching
- Continuous updates as user types

### Consistent Navigation Pattern (every module must follow this)
Dashboard → Library → Details → Create/Edit → History → Statistics/Insights → Archive → Settings

Users must never need to relearn navigation when moving between modules.

### Auto Save
- Forms auto-save drafts
- Unexpected app close must not lose in-progress data

### Progress & Performance Data
- Must always be based on objective recorded data or information entered/selected by the user or trainer
- Ulvenik must never make subjective assessments about a dog's performance, mood, health or progress
- No AI-generated assessments in V1

### Welcome & Home Messages
- Must NOT be static
- Must rotate through a curated pre-written bank
- Not AI-generated
- Must not make assumptions about dog performance, health or mood unless based on recorded data

### Rotating Decorative Imagery
- Hero/background/decorative images rotate through a curated bank
- Dog profile photos and user-uploaded media are always fixed
- All rotating images maintain the dark premium Ulvenik visual treatment

### Subscription Access Logic
- Core features: all users
- Sport Pack features (especially Competitions): Sport Pack subscribers only — never shown to Core users
- Trainer Pack features: Trainer Pack subscribers only
- Access gated both client-side AND server-side
- Consistent across every screen — if it appears in one place it must be gated in all places

---

## 10. DEPLOYMENT & ENVIRONMENTS

### Three Mandatory Environments

**Development**
- Test databases, dummy users, dev API keys, test subscriptions

**Staging**
- Internal testing, QA, UAT, beta releases
- Must mirror production as closely as possible
- Must NOT use live customer data

**Production**
- Live databases, live subscriptions, live media, live auth, live notifications
- Only authorised deployments reach production

### Source Control Requirements
- Protected main branch
- Feature branches
- Pull requests with code reviews
- Tagged releases
- Rollback capability
- Every production release traceable to a specific version

### CI/CD
- Every code change triggers: compilation, static analysis, unit tests, integration tests, build validation
- Code must not progress to staging if validation fails
- Deployment includes: database migrations, API deployment, mobile backend updates, background service updates, configuration validation

### Database Migrations
- All changes via controlled migration scripts
- Version controlled, repeatable, reversible where practical, data-preserving, tested before production
- Manual database modifications avoided

### Monitoring (production — continuous)
- API response times
- Database performance
- Storage usage
- Sync success rates
- Authentication failures
- Crash reports
- Media processing
- Background jobs
- Queue lengths
- Push notification delivery

### Backwards Compatibility
- Older app versions continue functioning wherever practical
- When dropping support: users receive advance notice, updates encouraged before functionality removed

---

## 11. PROJECT DELIVERY — WHAT MUST BE DELIVERED (V1)

### Primary Deliverables
- Native iOS Application
- Native Android Application
- Responsive Web Application
- Secure Backend API
- Cloud Database
- Cloud Media Storage
- Offline Synchronisation
- User Authentication
- Subscription Management
- Push Notifications
- Administrative Portal
- Complete Source Code
- Technical Documentation
- Deployment Documentation

### Definition of Done (a feature is ONLY complete when ALL of these are true)
1. Fully implemented
2. Matches approved UI design
3. Matches approved functional specification
4. Successfully tested
5. Works offline where applicable
6. Synchronises correctly
7. Performs reliably
8. Has no critical or major defects
9. Has been approved by the client

### Testing Requirements (sync must be tested under all of these)
- Stable internet
- Slow mobile connection
- Wi-Fi interruption
- Device restart during synchronisation
- Multiple devices editing simultaneously
- Extended offline periods
- Large media uploads

### Security Testing Must Verify
- Authentication
- Password reset
- Email verification
- Permission validation
- Subscription validation
- Data isolation
- API protection
- Secure media access
- Unauthorised users must NEVER access another user's data

### Accessibility Requirements
- VoiceOver (iOS)
- TalkBack (Android)
- Dynamic Type
- High Contrast
- Reduce Motion
- All interactive controls must have descriptive accessibility labels

### UI Acceptance
- Correct layouts, spacing, typography, colours, icons, animations, navigation, responsive behaviour
- Minor platform-specific differences (iOS/Android guidelines) acceptable where appropriate

---

## 12. SOURCE CODE & HANDOVER

### What the Client Receives on Final Payment
- iOS source code
- Android source code
- Web Application source code
- Backend API source code
- Authentication, sync, background worker, admin portal, notification service code
- Database schema + migration files + seed data
- Full repository access (with commit history, branches, tags, docs, issue tracking)
- Admin ownership of all services (Apple Dev, Google Play, Cloud hosting, Domain, DNS, DB, Object Storage, Email, Push Notifications, Analytics, Crash Reporting)
- All environment configuration (documented, transferred securely)
- List of all third-party services used (name, purpose, billing, login ownership)

### Documentation Package
- System architecture
- Database schema
- API documentation
- Sync overview
- Auth overview
- Deployment guide
- Admin guide
- Basic user guide
- Subscription management guide
- Backup and recovery procedures
- Build instructions for iOS, Android, Web, Backend
- Database migration guide
- Monitoring procedures
- Troubleshooting guide

**A new development team must be capable of rebuilding the platform using only the provided documentation.**

### Design Assets Delivered
- Figma project (latest approved versions)
- Logos (all variations)
- Icons
- Colour palette
- Typography references
- UI illustrations
- App Store screenshots
- Google Play screenshots
- App icons
- Splash screens

### Intellectual Property
Developer must confirm in writing:
- Custom code created specifically for Ulvenik transferred to client
- Rights to all incorporated third-party components confirmed
- No unauthorised proprietary material included

### Warranty Period Covers
- Functionality · Synchronisation · Authentication · Data integrity · Performance · Stability
- Does NOT cover: future OS update issues or client-requested changes (unless separately agreed)

---

## 13. PRODUCT ROADMAP — V1 SCOPE vs FUTURE

### V1 Must Include
**Core:** Dog Management · Training Records · Health · S&C · Goals · Timeline · Calendar · Statistics · Search
**Trainer Pack:** Client Management · Homework · Lesson Records · Reports · Permissions
**Sport Pack:** Sports · Competitions · Results · Qualifications · Awards

### Explicitly Excluded from V1
- AI Coaching
- Marketplace
- Community Feed
- Live Messaging
- Public Profiles
- Wearable Device Integration
- GPS Tracking
- Live Competitions
- Trainer Certification
- Club Management

**Architecture must support these without significant redevelopment.**

### Future Modules (post-V1, architecture must not block these)
- Club Management (members, training days, events, shared resources)
- Team Management (multiple handlers, family accounts, shared ownership)
- Equipment Management (inventory, maintenance, replacement dates)
- Breeding Records (litters, pedigrees, health testing, puppies)
- Official Integrations (governing bodies for competition entries, verified results, digital certificates)
- Advanced Analytics (deeper insights, always factual, never subjective scoring)
- AI Coaching
- GPS Tracking
- Wearable Device Integration
- Nutrition Module
- Community Features
- Marketplace

---

## 14. KEY RULES SUMMARY FOR DEVELOPMENT TEAM

1. **Nothing hardcoded** — all user-facing content must be dynamic and user-customisable
2. **Offline first, always** — every action saves locally first, cloud is secondary
3. **Single source of truth** — every record exists once, referenced by ID everywhere else
4. **Subscription gating is server-side AND client-side** — never client-side only
5. **Trainers never own client data** — clients always own their own data
6. **No subjective assessments** — progress/performance data is objective recorded data only
7. **No AI-generated content in V1** — messages, insights and copy are pre-written
8. **Rotating messages and imagery** — home screen messages and decorative images must cycle, never static
9. **Competition features = Sport Pack only** — never shown to Core or Trainer Pack-only users
10. **Media syncs independently** — sessions appear immediately, media attaches once upload completes
11. **Conflicts never silently resolved** — user is always informed if manual resolution needed
12. **Delete is soft by default** — permanent deletion only where explicitly required
13. **Accessibility is mandatory** — VoiceOver, TalkBack, Dynamic Type, High Contrast, Reduce Motion all required
14. **Three environments mandatory** — Dev, Staging, Production — never test on production
15. **Client receives full ownership** — all source code, all admin access, all assets on final delivery
