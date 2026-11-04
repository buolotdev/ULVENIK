# Ulvenik — Screen-by-Screen Testing Instructions (Post–Timeline Insights)

All screens up to and including **Timeline Insights** remain untouched. Below is the ordered completion status and step-by-step testing guide for every screen built after **Timeline Insights**, following the exact order in the Frontend Handover document.

---

## BATCH 6 — Timeline (Remaining Screens)

### 1. Timeline Memories — `[x] Completed`
- **How to Access:**
  1. Tap **Timeline** in the bottom navigation bar.
  2. Tap the **•••** button in the top-right corner (or tap the dog selector header at the top and choose **Open Timeline Memories**).
  3. Select **Timeline Memories** from the menu.
- **How to Test Full Interactivity & Both States:**
  - **Populated State (Default):** View the **One Year Ago Today** anniversary hero card, tap **Open Original Event** to open the linked event details, or tap **Share This Memory** to copy/save the anniversary card.
  - **Expandable Memory Groups:** Tap **+ 3 more this month**, **+ More from 2023**, and **+ More from 2022** to dynamically expand and collapse hidden historical memories.
  - **Interactive Filtering & Year Browsing:** Tap **Filter Categories** or **Browse Years** in the bottom action strip above the navigation bar to filter memories live by category (Training, Goals, Health, S&C, Milestones, Competition, Puppyhood) or year (2022–2025), and tap **Clear** in the active filter banner to reset.
  - **Memory Detail & Reflections:** Tap any memory card to add/save a personal reflection note, bookmark it as a keepsake, or jump to the original event.
  - **Empty State:** Tap **•••** in the top-right corner and select **Switch to Empty State** to test the **No Memories Yet** screen, **MILESTONE ENGINE (STANDBY)** card, **Learn about Timeline Memories** sheet, and **Go to Timeline** action.


### 2. Timeline Activity Map — `[x] Completed`
- **How to Access:**
  1. Tap **Timeline** in the bottom navigation bar.
  2. Tap the **•••** button in the top-right corner (or tap the dog selector header at the top and choose **Open Activity Map**).
  3. Select **Timeline Activity Map** from the menu.
- **How to Test Full Interactivity & All 3 States:**
  - **Default Map State:** Explore the dark vector sector map with top summary cards (**23 Locations**, **Riverside Trail — Most Visited**, **147 Mapped Events**, and scrollable **68.4 km GPS Distance**), tap any category pill in the bottom legend (**TRAINING**, **S&C**, **HEALTH**, **GOALS**, **COMPETITION**) or the top filter icon to filter pins live, double-tap to zoom, or use the floating right-hand buttons to cycle map layers (Dark Vector, Topographic Terrain, Density Heatmap), toggle animated dashed GPS trails, and recenter.
  - **Marker Selected State:** Tap any cluster (**18**, **7**) or colored GPS pin on the map (or tap **Riverside Trail** in the top card strip) to transition into the regional topographic view with the **SELECTED** pin halo, coordinate badge, nearby location pills (**Box Hill Track**, **Vet Clinic HQ**, **South Meadows**), heart favourite toggle, **34 Visits / First Visit / Last Visit** metrics, **Recent Field Sessions** (tap to open full event details or sort **Chronological** vs **Longest First**), **View All Events Here**, and **Open in Timeline**.
  - **Animated & Touch-Interactive Route Profile Chart:** Tap the **Riverside Trail Loop** card on the Default map, tap **Route Profile** inside any selected location panel, or tap **Scent Work — Track B** to animate and scrub the GPS **Elevation** and **Pace** profile chart with live waypoint readouts.
  - **Empty State:** Tap **•••** in the top-right corner and select **Switch to Empty State** to test the **GPS ACTIVE • OFFLINE READY** radar grid, **No Recorded Locations** card, **WGS 84 • NORDIC SPORT GRID** scale bar, compass bearing toggle, and **Go to Timeline** button.


### 3. Timeline Compare — `[x] Completed`
- **How to Access:**
  1. Tap **Timeline** in the bottom navigation bar.
  2. Tap the **•••** button in the top-right corner (or tap the dog selector header at the top and choose **Open Timeline Compare**).
  3. Select **Timeline Compare** from the menu.
- **How to Test Full Interactivity & Both States:**
  - **Dynamic Period A vs Period B Selection:** Tap the **PERIOD A** card, the **PERIOD B** card, **Change Dates** in the bottom action bar, or the quick preset pills (**This Week vs Last Week**, **This Month vs Last Month**, **Sep vs Jul Season**) to dynamically recalculate all metrics, deltas, proportional category bars, and milestones live. Tap the center **VS** badge (or choose **Swap Period A ↔ Period B** in **•••**) to swap both windows.
  - **Animated & Touch-Interactive Charts:** Watch the **Categories** proportional multi-segment bars and the dual-series **Activity** line chart animate smoothly on load and period changes. Tap any category row (**Training**, **S&C**, **Health**, **Goals**, **Media**) to isolate its bar segment, tap **EVENTS / DAY** on the **Activity** card to toggle **CUMULATIVE** mode, and tap or drag horizontally across the chart to inspect live Period A vs Period B checkpoint readouts.
  - **Milestones & Export:** Tap **View Event →** on any row in the **Milestones** card to open the linked event details, or tap **Export** in the bottom-right strip to generate a PDF or CSV comparison report.
  - **Empty State:** Tap **•••** in the top-right corner and select **Switch to Empty State** to test the **Not Enough Timeline Data** view, **No Data** period headers, **What gets compared?** info card, and **Go to Timeline** button.


### 4. Timeline Smart Collections — `[x] Completed`
- **How to Access:**
  1. Tap **Timeline** in the bottom navigation bar.
  2. Tap the **•••** button in the top-right corner (or tap the dog selector header at the top and choose **Open Smart Collections**).
  3. Select **Timeline Smart Collections** from the menu.
- **How to Test Full Interactivity & Both States:**
  - **Populated Presets & Live Search:** Browse all 15 synced smart collections across **TIME-BASED RANGE**, **MEDIA & ARTIFACTS**, **SPORT & CONDITIONING**, and **HEALTH & BIOMETRICS** (including the featured **Vet Visits** card). Type in **Search collections...** (or tap the microphone icon for a quick preset query) and use **Sort** and **Filter** in the bottom bar to reorganize or filter by badge type.
  - **Collection Inspector & Animated Trend Chart:** Tap any collection card to inspect its live auto-match query rule, scrub or tap the animated **6-Month Auto-Match Trend** bar chart, pin or archive the collection, and tap any matched Timeline entry to open its full event details.
  - **Rule-Based Collection Builder:** Tap **Create Custom Smart Collection** (or **AUTO-COMPILED** / **+ New Rule-Based Smart Collection** in **•••**) to configure a name, category rule, media requirement, and minimum duration slider, compiling a live custom collection card onto the screen.
  - **Empty State:** Tap **•••** in the top-right corner and select **Switch to Empty State** to test the **No Collections Available** view, **Learn about Smart Collections** sheet, and **Go to Timeline** action.


### 5. Timeline Widgets — `[x] Completed`
- **How to Access:**
  1. Tap **Timeline** in the bottom navigation bar.
  2. Tap the **•••** button in the top-right corner (or tap the dog selector header at the top and choose **Open Timeline Widgets**).
  3. Select **Timeline Widgets** from the menu.
- **How to Test Full Interactivity & Both States:**
  - **Home Dashboard & Gallery Cards:** Inspect the top **Home Dashboard** preview tray (**3 Widgets Active** by default), tap **Edit Layout** to manage pinned dashboard slots, or tap any of the 14 widget cards across **ACTIVITY**, **STATISTICS**, **HEALTH**, **GOALS**, and **MEDIA** to select it.
  - **Size Switching, Animated Previews & Live Pinning:** Tap **S**, **M**, or **L** on any widget card to switch its size family, tap individual month bars inside **Monthly Activity** to highlight them, watch the animated streak counters, category bars, consistency heatmap, and **7/10** segmented goal ring, and tap **+ Add** or **✓ Added ✓** to dynamically add or remove widgets from **Home Dashboard**.
  - **Widget Configuration Drawer:** Tap the docked **Selected · Tap to configure** bar (or **+ Add Widget** in the bottom-right strip) to customize widget size (**Small**, **Medium**, **Large**), dog data source (**All Dogs**, **Murphy**, **Freya**), and accent color theme, or tap **Reset Layout** to restore defaults.
  - **Empty State:** Tap **•••** in the top-right corner and select **Switch to Empty State** to test the **No Timeline Widgets Added** view, **Learn about Timeline Widgets** modal, and **+ Add Widget ›** button.


---

## BATCH 7 — More & Settings

### 6. Ulvenik — More Page — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
- **How to Test Full Interactivity:**
  - **Handler Profile Card:** Tap the **Ruby Old** profile card (`ruby@email.com` · **Core + Trainer Pack**) at the top to open **More Dashboard** directly.
  - **Account Section:**
    - Tap **Account Settings** to edit your handler full name and email address and watch the top profile card and avatar initials update immediately.
    - Tap **Appearance** (`Dark Mode`) to open **Appearance Settings**.
    - Tap **Notifications** (`Off`) to open **Notification Settings**.
    - Tap **Privacy & Security** (`Email Not Verified`) to verify your email address live (updating the red badge to a green **Verified** pill) or toggle **Biometric App Lock**.
  - **Subscription Section:** Tap **Subscription Management** (`Core + Trainer Pack · Active`) to switch active packs and see the hero badge update live.
  - **Storage Section:** Tap **Offline Storage & Cloud Sync** (`Fully Synced`) to access **Backup & Sync**, **Offline Mode & Downloads**, and **Storage Management**.
  - **Community & Support Sections:** Tap **Ulvenik Rewards** (animated tier progress), **Refer a Friend** (one-tap invite code copy), **Community** (join/leave K9 groups), **Help & Support**, **Feedback & Feature Requests** (interactive category chips + submission), and **About Ulvenik** (`Version 1.0.0`).

### 7. Ulvenik — More Dashboard — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap the **Ruby Old** handler profile card at the top of the **More** page.
- **How to Test Full Interactivity:**
  - **Handler Hero Card:** Tap **Edit Profile** to update your handler display name and watch the header title and avatar initials update live, or tap the **RO** avatar circle (or **Change Profile Photo**) to switch avatar badge colours (**Nordic Sage**, **Forest Green**, **Alpine Blue**, **Bronze Earth**).
  - **Animated 2×2 KPI Grid:** Watch the **Dogs** (`3`), **Active Goals** (`5`), **Active Devices** (`2`), and **Cloud Sync** (`Synced`) cards animate in smoothly on open. Tap **Dogs** to jump to **My Dogs**, **Active Goals** to open **Goals**, **Active Devices** to inspect and revoke active field tablets/phones (watching the count update live), or **Cloud Sync** to trigger an immediate sync check.
  - **Account, Subscription & Preferences:** Test **Change Email Address**, **Change Password**, **Export My Data** (`.json` / `.csv` / `.pdf`), **Delete Account** (protected confirmation sheet), **Subscription Details**, **Billing History**, **Restore Purchases**, and live preference pickers for **Language**, **Country**, **Time Zone**, **Date & Time Format**, and **Measurement Units** (`Metric` / `Imperial`).
  - **Data & Storage Hub:** Tap **Backup & Sync**, **Offline Downloads**, or **Storage Management** directly from the **DATA & STORAGE** card, and explore **Help** and **About** sheets down to the `Ulvenik v1.0.0` footer.

### 8. Ulvenik — Notification Settings — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Notifications** under the **ACCOUNT** section (or open **More Dashboard** via the **Ruby Old** profile card and tap **Notifications** under **PREFERENCES**).
- **How to Test Full Interactivity:**
  - **Live Overview Card:** Watch the **Push** (`Enabled`), **Email** (`Enabled`), **Quiet Hours** (`Off`), and animated **18 Active notifications** counter update dynamically whenever you toggle individual switches or master controls, with the top-right **Saved** indicator pulsing green on every save.
  - **Push & Email Notification Controls:** Toggle **Enable Push Notifications** or **Receive Emails** master switches (dimming child rows when disabled), or toggle individual alerts across **TRAINING**, **STRENGTH & CONDITIONING**, **HEALTH**, **GOALS**, **TIMELINE**, **COMPETITIONS** (`Sport Pack` badge), and **TRAINER** (`Trainer Pack` badge).
  - **Quiet Hours & Reminder Timing:** Toggle **Enable Quiet Hours**, tap **Start Time** (`10:00 PM`) or **End Time** (`07:00 AM`) to choose custom quiet schedules via the dark time picker, and tap **Training**, **Health**, **Goals**, or **Competitions** under **REMINDER TIMING** to customize lead times.
  - **Sounds, Badge, History & Reset:** Switch between **Default**, **Silent**, and **System Sound** (and tap **Custom Sounds · Coming Soon**), toggle **Show App Badge**, tap **View Notification History** to filter or clear delivered logs, and tap **Reset Notification Settings** at the bottom to restore factory defaults.

### 9. Ulvenik — Appearance Settings — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Appearance** (`Dark Mode`) under the **ACCOUNT** section (or open **More Dashboard** via the **Ruby Old** profile card and tap **Appearance** under **PREFERENCES**).
- **How to Test Full Interactivity:**
  - **Live Interactive Preview Card:** Watch the mock Ulvenik frame at the top (`Updates instantly as you change settings`) morph in real time as you adjust **Theme**, **Text Size**, and **Display Density**. You can also tap the mock action pill or bottom navigation dots inside the preview frame directly.
  - **Theme Selector:** Tap **System** (`Default`), **Dark**, or **Light** to switch the active theme card and watch the preview frame and **Saved** indicator respond immediately; tap `<` to return and see the `Appearance` subtitle update live.
  - **Text Size & Display Density:** Select **Small**, **Default** (`Recommended`), **Large**, or **Extra Large** under **TEXT SIZE**, and switch between **Comfortable** (`Recommended`), **Compact** (`More content on screen`), and **Spacious** (`More breathing room`) under **DISPLAY DENSITY**.
  - **Reduce Motion, Haptic Feedback & Reset:** Toggle **Reduce Motion** (snapping transition durations immediately), toggle **Haptic Feedback**, and tap **Reset Appearance Settings** at the bottom to restore defaults via confirmation sheet.

### 10. Ulvenik — Backup & Sync — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Offline Storage & Cloud Sync** and choose **Backup & Sync** (or open **More Dashboard** via the **Ruby Old** profile card and tap **Backup & Sync** under **DATA & STORAGE**).
- **How to Test Full Interactivity:**
  - **Sync Status & Animated Cloud Meter:** View **Status** (`Synced`), **Last Sync** (`Today · 14:37`), **Devices** (`2 Active`), and the animated **Cloud Storage: 1.2 GB used of 5 GB** progress bar; tap the cloud storage row (or any row under **BACKUP INFORMATION**) to inspect the interactive segmented cloud storage breakdown.
  - **Automatic & Mobile Data Controls:** Toggle **Automatic Cloud Sync** (watching **Status** dynamically switch between `Synced` and `Paused`) and toggle **Sync Using Mobile Data**.
  - **Live Manual Sync Simulation:** Tap **Sync Now** under **MANUAL SYNC** to trigger a rotating sync icon, live `0% -> 100%` progress meter, top-right **SYNCING -> SAVED** badge transition, and updated **Last Sync** / **Last Backup** timestamps.
  - **Connected Devices:** Inspect **iPhone 16 Pro** (`THIS DEVICE`) and tap the trash icon beside **MacBook Pro** to disconnect it via confirmation sheet (watching **Devices** drop from `2 Active` to `1 Active` and revealing **+ Link Companion Device** to re-pair).

### 11. Ulvenik — Offline Mode & Downloads — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Offline Storage & Cloud Sync** and choose **Offline Mode & Downloads** (or open **More Dashboard** via the **Ruby Old** profile card and tap **Offline Downloads** under **DATA & STORAGE**).
- **How to Test Full Interactivity:**
  - **Live Overview Card:** Inspect **Offline Mode** (`Enabled`), **Downloaded** (`3.2 GB`), **Last Updated** (`Today · 08:14`), and **Device Storage** (`12.4 GB free`), all updating dynamically as you download or clear content.
  - **Offline Mode & Available Offline Toggles:** Toggle **Enable Offline Mode**, and toggle individual offline modules (**Dog Profiles**, **Training Records**, **S&C Records**, **Health Records**, **Goals**, **Timeline**, **Statistics**, **Videos**, **Photos**, and **Documents & Attachments**).
  - **Download Quality & Live Download Progress:** Select **High Quality**, **Balanced**, or **Data Saver**, then tap **Download Latest Data** to run a live `0% -> 100%` download progress simulation that recalculates storage totals based on your selected quality and modules.
  - **Interactive Animated Storage Breakdown & Removal:** Watch the multi-segment proportional storage bar animate in under **STORAGE**, tap **Videos** (`2.4 GB`), **Photos** (`480 MB`), **Training Data** (`180 MB`), **Health Data** (`96 MB`), or **Documents** (`64 MB`) to isolate and highlight its share, or tap **Remove Downloaded Content** at the bottom to free local storage via confirmation sheet.

### 12. Ulvenik — Storage Management — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Offline Storage & Cloud Sync** and choose **Storage Management** (or open **More Dashboard** via the **Ruby Old** profile card and tap **Storage Management** under **DATA & STORAGE**).
- **How to Test Full Interactivity:**
  - **Animated Overview & Segmented Storage Bar:** Watch the **Ulvenik Storage** (`4.3 GB`) total and multi-segment colour bar animate in smoothly alongside **Available** (`82.1 GB`), **Cache** (`840 MB`), **Downloads** (`3.2 GB`), and **Other** (`260 MB`).
  - **Interactive Breakdown:** Tap any row under **BREAKDOWN** (**Dog Photos**, **Training Records**, **S&C Records**, **Health Records**, **Timeline**, **Documents & Attachments**, **Cached Files**) to highlight its segment in the overview bar, or tap **Videos** (`2.6 GB >`) to inspect and delete individual 4K/HD training video clips and watch storage totals recalculate live.
  - **Clear Cache & Downloaded Media:** Tap **Clear Cache** under **CACHE** to wipe the `840 MB` temporary cache immediately, or tap **Manage Downloaded Media** (`3.2 GB >`) to inspect individual video clips or jump straight to **Offline Mode & Downloads**.
  - **Optimise Storage, Database & Remove All:** Tap **Optimise Storage** under **OPTIMISE** to run a live spinning compaction pass that updates **Local Database Size** and **Last Optimised** (`Just now`), or tap **Remove All Local Downloads** at the bottom to safely clear local downloads via confirmation sheet.


### 13. Help Centre — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to the **Support & Feedback** section and tap **Help Centre**.
- **How to Test Full Interactivity:**
  - **Live Search & Category Filtering:** Type any keyword (such as `sync`, `offline`, `subscription`, or `dog`) into the **Search Help Articles** bar to filter matching FAQs and help articles in real time, use the horizontal category filter chips (**All**, **Getting Started**, **Account & Subscription**, **Training & Health**, **Troubleshooting**, **Privacy & Security**) to narrow results, and tap the **×** clear icon to reset.
  - **Quick Actions Grid:** Tap **Contact Support**, **Report a Bug**, or **Feature Requests** to navigate directly to each dedicated support screen, or tap **FAQs** to open the interactive **Frequently Asked Questions** drawer with category chips and expandable Q&A accordions.
  - **Popular & Categorised Help Articles:** Browse the **POPULAR** badge rows and all five topic groups (**GETTING STARTED**, **ACCOUNT & SUBSCRIPTION**, **TRAINING & HEALTH**, **TROUBLESHOOTING**, **PRIVACY & SECURITY**), and tap any article row to open the full **Article Reader** sheet.
  - **Article Reader Controls:** Inside any article, review the numbered step-by-step guide and pro tip, expand or collapse **Common Questions**, toggle the **Bookmark** icon, copy the guide steps to the clipboard, or vote **Yes, helpful** / **Still need help** (with a one-tap **Contact Support Directly** shortcut).

### 14. Contact Support — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to **Support & Feedback** and tap **Contact Support** (or tap **Help Centre** and select the **Contact Support** quick action card).
- **How to Test Full Interactivity:**
  - **Category Selector:** Tap the **Support Category** selector row (**General Question** by default) to choose from **General Question**, **Account & Login**, **Subscription & Billing**, **Sync & Offline Mode**, **Training & S&C Logs**, **Health Records & Reminders**, or **Privacy & Data Export**.
  - **Subject & Description Inputs:** Type into **Subject** (`0 / 100` live character counter) and **Description** (`0 / 5,000` live formatted counter) and verify focus border highlighting and live validation when submitting empty fields.
  - **Attachments Manager:** Tap the dashed **Add Attachment** area to attach sample screenshots, recordings, or documents, or tap the **×** button next to **screenshot_01.png** (or newly added files) to remove them dynamically.
  - **Diagnostics & Contact Email:** Toggle **Include Diagnostic Information** on or off to include/exclude **App Version** (`2.4.1`), **Device** (`iPhone 15 Pro`), **OS Version** (`iOS 17.4`), and **Subscription** (`Dog Owner Plan`), edit the **Reply To** email address, and tap **Send Support Request** to view the interactive confirmation receipt with **Copy Ticket ID** and **New Request** actions.

### 15. Report a Bug — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to **Support & Feedback** and tap **Report a Bug** (or tap **Help Centre** and select the **Report a Bug** quick action card).
- **How to Test Full Interactivity:**
  - **Bug Category Selector:** Tap **Select a category** under **Bug Category** to choose from **Crash or App Freeze**, **Sync & Offline Queue**, **Training & Session Logging**, **Strength & Conditioning**, **Health Records & Reminders**, **Timeline & Media Uploads**, **Visual or Layout Issue**, or **Account & Subscription** (each tagged with its priority area).
  - **Title, Description & Steps to Reproduce:** Enter a **Bug Title** (`0 / 100`), describe **What happened?** (`0 / 5,000`), and optionally add numbered **Steps to Reproduce** (`0 / 2,000` monospace field) while testing focus states and live validation.
  - **Attachments:** Tap the dashed **Add Attachment** button to add diagnostic recordings, crash traces, or screenshots, or tap **×** next to **bug_screenshot.png** (`2.1 MB`) to remove attached files.
  - **Diagnostics & Submission:** Toggle **Include Diagnostic Information** on or off to include/exclude all 7 environment metrics (**App Version**, **Build Number**, **Device**, **OS Version**, **Screen Resolution**, **Language**, **Subscription**), then tap **Submit Bug Report** to view the engineering tracking receipt with **Copy Bug ID** and **Report Another** controls.

### 16. Feature Requests — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to **Support & Feedback** and tap **Feature Requests** (or tap **Help Centre** and select the **Feature Requests** quick action card).
- **How to Test Full Interactivity:**
  - **Live Search & Status Filter Pills:** Type into **Search Feature Requests** or tap the status filter pills (**All**, **Popular**, **Under Review**, **Planned**, **In Development**) to filter both community and personal ideas dynamically.
  - **Interactive Upvoting & Live Vote Counters:** Tap **Voted ✓** / **Vote** on **Training Templates** (`1,248 votes`), **Smart Health Insights** (`847 votes`), or **Multi-Dog Training Session** (`612 votes`) to toggle your vote and increment or decrement the live vote count immediately.
  - **Submit New Feature Sheet:** Tap **Submit New Feature**, choose an area chip (**Training**, **Health**, **Strength & Conditioning**, **Timeline**, **Dogs & Profiles**, **Export & Sync**), enter a **Feature Title** and **Details & Use Case**, and tap **Submit Feature Request** to add your idea live to the **MY REQUESTS** list.
  - **Request Details Drawer:** Tap any card in **POPULAR** or any row in **MY REQUESTS** (**Offline Goal Tracking**, **Custom Reward Icons**, **Export to PDF**, or newly submitted ideas) to inspect full details and toggle your vote inside the drawer.

### 17. About Ulvenik — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to the **Legal & About** section and tap **About Ulvenik**.
- **How to Test Full Interactivity:**
  - **Brand Overview, Philosophy & Vision:** Review the mountain crest hero card (**Ulvenik · Version 1.0.0 · The Journey Builds the Wolf.**), **WHAT IS ULVENIK?**, **OUR PHILOSOPHY**, and **OUR VISION**, and tap any of the 8 handler/owner roles inside **WHO IS IT FOR?** (**Pet Dog Owners**, **Puppy Owners**, **Professional Dog Trainers**, **Working Dog Handlers**, **Sport Competitors**, **Behaviourists**, **Breeders**, **Dog Clubs & Training Groups**) to expand role-specific highlights.
  - **App Information Copy Actions:** Tap **Version** (`1.0.0`) or **Released** (`1 September 2026`) under **APP INFORMATION** (or **Version 1.0.0** in the hero header) to copy release metadata to the clipboard.
  - **Interactive Links:** Under **LINKS**, tap **What's New**, **Privacy Policy**, **Terms & Conditions**, or **Open Source Licences** to navigate directly to each dedicated screen.
  - **Contact Actions:** Under **CONTACT**, tap **Support Email** (`support@ulvenik.com`) to copy the address or launch the **Contact Support** form, and tap **Official Website** (`ulvenik.com`) or **Instagram** (`@ulvenik`) to copy official links.

### 18. Privacy Policy — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to the **Legal & About** section and tap **Privacy Policy** (or open **About Ulvenik** and tap **Privacy Policy** under **LINKS**).
- **How to Test Full Interactivity:**
  - **Reading Progress & Live Clause Search:** Scroll through the document to watch the Forest-Green reading progress bar update under the header, or tap the **Search** icon in the top-right corner to filter matching policy clauses (**Introduction**, **Information We Collect**, **How We Use Your Information**, **Data Storage & Security**, **Your Rights**) in real time.
  - **Expandable Table of Contents:** Tap **Table of Contents** under **CONTENTS** to expand all 6 numbered sections and tap any heading to smooth-scroll directly to that section.
  - **Copy Policy & Data Protection Actions:** Tap the **Copy** icon next to **LAST UPDATED • 1 September 2026** to copy a structured policy summary, tap the inline **support@ulvenik.com** link under **Your Rights** or **Support Email** under **QUESTIONS?** to copy the address or launch **Contact Support**, and tap **Official Website** (`ulvenik.com`) to copy the official URL.

### 19. Terms & Conditions — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to the **Legal & About** section and tap **Terms & Conditions** (or open **About Ulvenik** and tap **Terms & Conditions** under **LINKS**).
- **How to Test Full Interactivity:**
  - **Reading Progress, Search & Revision Badge:** Scroll through the agreement to watch the Forest-Green reading progress indicator update, tap the **Search** icon in the top-right corner to filter matching legal sections live, or tap the **REV 4.2** badge next to **LAST UPDATED 15 September 2026** to view revision notes and copy a structured terms summary.
  - **Interactive 10-Section Table of Contents:** Collapse or expand **Table of Contents** under **CONTENTS**, tap **1. Acceptance of Terms**, **2. Use of the Platform**, **3. User Accounts**, **4. Subscription & Billing**, **8. Termination**, or **10. Contact Us** to smooth-scroll directly to that section on the page, or tap **5. Acceptable Use**, **6. Intellectual Property**, **7. Limitation of Liability**, or **9. Changes to Terms** to open its dedicated clause reader drawer.
  - **Questions & Legal Support Actions:** Tap the inline **support@ulvenik.com** link under **5. Termination** or **Support Email** inside the **QUESTIONS?** card to copy the address or open **Contact Support**, and tap **Official Website** (`ulvenik.com`) to copy the official website link.

### 20. What's New — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to the **Support & Information** (or **About**) section and tap **What's New** (or open **About Ulvenik** and tap **What's New**).
- **How to Test Full Interactivity:**
  - **Latest Release Details & Feedback:** On the **Version 1.2.0** hero card with the **CURRENT** badge, tap **View Details** to open the full categorized release notes sheet, copy release notes to the clipboard, toggle feedback reaction chips (**Helpful**, **Great Update**, **Performance Boost**), and toggle **Acknowledge Release Notes**.
  - **Live Release Search & Category Filtering:** Type keywords or version numbers into **Search Release Notes** (or tap the magnifying glass icon in the top-right corner to reveal category filter pills: **All**, **New Features**, **Improvements**, **Bug Fixes**, **Other Changes**) to dynamically filter and auto-expand matching releases, then tap **Reset filter** or the clear icon to restore all releases.
  - **Expandable Previous Releases:** Tap **Version 1.1.0**, **Version 1.0.1** (expanded by default), or **Version 1.0.0** to smoothly expand and collapse categorized bullet points, or long-press any release card to open its full feedback and copy sheet.
  - **Version Status Check:** In the **YOUR VERSION** card at the bottom, tap **You're using the latest version of Ulvenik.** to run a live update check with status confirmation.

### 21. Open Source Licences — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to **Legal & Attribution** (or open **About Ulvenik**) and tap **Open Source Licences**.
- **How to Test Full Interactivity:**
  - **Live Library Search:** Type a library name, version, or keyword (such as `Flutter`, `Firebase`, `chart`, or `router`) into **Search Libraries** and verify the **LIBRARIES** count updates live (e.g., `2 of 8` vs `8 Total`), then tap the clear icon to reset.
  - **Licence Type Filter Pills:** Tap **All Licences**, **BSD 3-CLAUSE**, **APACHE 2.0**, or **MIT** below the search bar to filter the list by licence family.
  - **Full Licence Viewer & Copy Action:** Tap any library row (**Flutter**, **Firebase**, **provider**, **go_router**, **image_picker**, **shared_preferences**, **fl_chart**, or **intl**) to open the full legal licence viewer sheet showing package version, repository path, description, and selectable full licence text, then tap **Copy Licence Text** to copy it to the clipboard.

### 22. Settings — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Settings** (or tap the gear icon in the **More** header).
- **How to Test Full Interactivity:**
  - **Settings Search:** Tap the magnifying glass icon in the top-right corner of **Settings** to open the live search bar and filter setting groups by keyword (such as `Units`, `Biometrics`, `Quiet Hours`, or `Cache`).
  - **Account Identity & Appearance:** Tap the **James Harlow** (**TRAINER PLAN**) account card to view or update account details; tap **Appearance** to switch between **Dark Mode**, **System Default**, and **High Contrast Dark** or toggle **Reduce Motion**, watching the row subtitle update live.
  - **Preferences Selectors:** Tap **Units & Measurements** (`kg · km · °C`), **Date & Time** (`DD/MM/YYYY · 24-hour`), and **Language** (`English`) to switch weight, distance, temperature, date/time formats, first day of week, and display language with instant live subtitle updates.
  - **Privacy, Sessions, Storage & Notifications:** Tap **Privacy & Security** to toggle **Biometric Unlock**, **Session Management Lock**, or launch **Two-Factor Authentication**; tap **Active Sessions** to revoke signed-in secondary devices; tap **Storage & Sync** to inspect the animated interactive storage breakdown bar, toggle **Sync Large Videos on Wi-Fi Only**, and run **Sync Now**; tap **Notifications** to toggle **Push Notifications** and **Quiet Hours**.
  - **Support, About & Advanced Controls:** Tap **Help Centre**, **Contact Support**, **Report a Bug**, or **Feature Requests** to submit inquiries; tap **About Ulvenik**, **What's New**, or **Legal** to navigate to release notes and open-source attributions; tap **Reset Preferences** to restore default settings, **Clear Cached Data** to free temporary storage, or **Sign Out** to confirm signing out.

### 23. Notifications Page — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Notifications** (or tap the bell icon in the header).
- **How to Test Full Interactivity:**
  - **KPI Summary Counters & Category Tabs:** Tap **UNREAD**, **TODAY**, **UPCOMING**, or **OVERDUE** in the top summary strip, or tap the category filter pills (**All**, **Unread**, **Health**, **Training**, **Goals**, **System**) and top-right search icon to dynamically filter notifications.
  - **Mark All Read & Settings Shortcut:** Tap **Mark All Read** to clear all unread green indicator dots and watch the **UNREAD** counter drop to `0`; tap **Settings** next to it to jump directly to notification and app settings.
  - **Swipe, Long-Press & Detail Actions:** Swipe right on any notification row (or long-press it) to toggle its **Read / Unread** state; swipe left to dismiss it to **Archive** (and tap **Archive** / **Back to Inbox** in the **EARLIER** header to view or restore archived alerts); tap any notification row (**Medication Reminder**, **Veterinary Appointment**, **Goal Completed**, **Training Reminder**, or **Backup Complete**) to open its detail sheet and trigger its quick action.
  - **Live Telemetry Sync Status:** Tap **Telemetry Sync: Online · GPS Collar #4** at the bottom of the page to inspect collar battery/GNSS lock status and toggle telemetry sync standby mode.

### 24. Profile Page — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap your profile card (**James Harlow**) at the top of **More** (or open **Settings** and tap **James Harlow**).
- **How to Test Full Interactivity:**
  - **Live Profile Synchronization & Photo Picker:** Tap **Edit Profile** (in the hero button row, the top-right pencil icon, or under **MY PROFILE**) to open **Edit Profile**, save changes to your name, contact details, location, or biography, and verify your **Profile** header and initials update immediately; tap **Change Photo** (or tap the **JH** avatar) to switch monogram accent styles, apply camera/library portraits, or reset to default initials.
  - **Animated Training Streak & 14-Day Activity Chart:** Tap the **Current Training Streak · 18 Days · RECORD ›** card (or tap the **6 DOGS · 2,418 SESSIONS · 163 GOALS · 4 yrs ULVENIK** bar) to open the animated 14-day bar chart, tap individual day bars to inspect daily session volume, and tap **Record Quick Session (+1 Day Streak)** to increment your streak and total session count live.
  - **Membership, Trainer Pack & Preferences:** Tap **Manage Subscription** under **Core + Trainer Pack** to toggle billing cycle and auto-renew; tap **Trainer Profile** and **My Clients** under **TRAINER PACK** to inspect your verified trainer identity and active client roster; tap **Appearance**, **Units & Date Format**, **Display Preferences**, **Notification Settings**, **Privacy & Security**, **Storage & Sync**, **About Ulvenik**, or **Sign Out** to configure preferences live.

### 25. Edit Profile — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar and tap your profile card (**James Harlow**) to open **Profile**.
  2. Tap **Edit Profile** (in the hero button row, the top-right pencil icon, or under **MY PROFILE**).
- **How to Test Full Interactivity:**
  - **Form Validation & Live Profile Sync:** Clear **FIRST NAME**, **LAST NAME**, or **DISPLAY NAME** and tap **Save** or **Save Changes** to verify inline field validation; then enter a new **DISPLAY NAME** (for example, `James R. Harlow`), tap **Save Changes**, and verify **Profile** immediately updates your displayed name and monogram initials.
  - **Regional & Measurement Selectors:** Under **REGIONAL SETTINGS**, tap **COUNTRY**, **LANGUAGE**, and **TIME ZONE** to select regional preferences (with automatic time zone alignment when changing country); under **MEASUREMENT PREFERENCES**, tap **WEIGHT**, **DISTANCE**, and **TEMPERATURE** to switch between metric and imperial units and verify the updated units sync back to **Profile**.
  - **Account Email & Password Sheets:** Under **ACCOUNT**, tap **Email Address** (**VERIFIED**) to stage a validated new email address and watch the masked address preview update live, or tap **Password** to update your password and refresh the `Last changed` timestamp.
  - **Unsaved-Changes Discard Confirmation:** Edit any field or dropdown without saving and tap the top-left back button (or system back gesture) to trigger the **Discard Unsaved Changes?** confirmation sheet (**Keep Editing** vs **Discard Changes**).

---

## BATCH 8 — Account & Utility

### 26. Billing History — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap your profile card at the top (or scroll to **SUBSCRIPTION**), then tap **Billing History** (or open **Subscription Details** and tap **Billing History**).
- **How to Test Full Interactivity:**
  - **Year & Status Transaction Filtering:** Tap the sliders filter icon in the top-right corner of **Billing History** to expand the filter panel, switch **Billing Year** between **2025**, **2024**, and **All Years**, or filter **Payment Status** by **All**, **Renewed**, **Paid**, **Refunded**, and **Trial**, then tap **Reset** to restore the default view.
  - **Account Summary & Interactive Monthly Spend Chart:** Tap any row inside **ACCOUNT SUMMARY** (**CURRENT PLAN**, **BILLING PLATFORM**, **LAST PAYMENT**, or **NEXT RENEWAL**) to open the **Account Billing Overview** sheet featuring an animated monthly spend bar chart—tap individual month bars (**Mar**–**Jul**) to inspect monthly totals, and tap **Export Annual Statement (CSV)** to export your statement.
  - **Invoice Receipt Preview & PDF Download:** Tap any transaction row (**Core Annual Renewal**, **Trainer Pack Monthly**, **Refund — Sport Pack**, or **Promotional Trial**) to open its itemized **Receipt** sheet showing transaction date, Apple App Store order ID, net subtotal, UK VAT breakdown, and status badge; tap **Download PDF Receipt** to generate and save the PDF (adding a downloaded check icon to that invoice row), **Copy ID** to copy the invoice code, or **Email Copy** to send the receipt.

### 27. Subscription Details — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to **SUBSCRIPTION** and tap **Subscription Management** / **Subscription Details** (or tap your profile card at the top of **More**, then tap **Subscription Details**).
- **How to Test Full Interactivity:**
  - **Manage Core Subscription & Billing Cycle Toggle:** On the **Ulvenik Core** hero card (**ACTIVE**), tap **Manage Subscription** to switch between **Annual (£59.99 / yr · SAVE 37%)** and **Monthly (£7.99 / mo)**—watching the membership subtitle and renewal date update live—or test **Pause Auto-Renewal / Cancel Membership** with confirmation and one-tap reactivation.
  - **Active Packs Management (`Trainer Pack` & `Sport Pack`):** Under **YOUR PACKS** (or by tapping the **TRAINER PACK** / **SPORT PACK** pills on the hero card), tap **Manage** on either pack to switch its billing cycle between **Monthly** and **Annual** or tap **Remove** to move it down to **ADD TO YOUR MEMBERSHIP**.
  - **Add-On Pack Activation (`Club Pack`):** Under **ADD TO YOUR MEMBERSHIP**, tap **Add Pack** on **Club Pack** (`£4.99 / month` or `£39.99 / year`), choose a billing cycle, and tap **Confirm & Add Club Pack** to activate it live into **YOUR PACKS** and add the **CLUB PACK** badge to the **Ulvenik Core** hero card.
  - **Entitlement Quotas, Billing History, Restore Purchases & Promo Codes:** Tap the `?` help icon in the top-right header to inspect animated interactive entitlement quota bars (**Cloud Media Vault**, **Client Roster Seats**, **Sport Seasons**); under **MANAGE**, tap **Billing History** to open past receipts, **Restore Purchases** to verify entitlements, or **Redeem Code** to apply a promotional code (such as `ULVENIK30` or `CLUBTRIAL`).

### 28. Restore Purchases — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Subscription Management** / **Subscription Details** and tap **Restore Purchases** under **MANAGE** (or tap your profile card at the top of **More**, then tap **Restore Purchases**).
- **How to Test Full Interactivity:**
  - **Purchase Platform Selector:** Inside the central card, tap **PURCHASE PLATFORM** (**Apple App Store**) to switch between **Apple App Store**, **Google Play Store**, and **Ulvenik Web Billing** before scanning.
  - **Animated Receipt Verification Scan:** Tap the **Restore Purchases** button at the bottom to watch the cloud-receipt icon animate, the progress bar advance step-by-step, and **Core Membership**, **Trainer Pack**, and **Sport Pack** each transition sequentially into verified **RESTORED** badges with renewal dates.
  - **Entitlement Receipt Tokens, Retry & Billing Support:** Tap any restored item (**Core Membership**, **Trainer Pack**, or **Sport Pack**) to inspect and copy its verification token; tap **Scan Again** to re-verify, or tap **Still missing an add-on Pack? Troubleshoot or contact Billing Support** (or the footer note) to open recovery guidance with **Retry Scan** and **Contact Support** actions.


### 29. Delete Account — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap your profile card at the top, then under **ACCOUNT** tap **Delete Account** (or open **Settings** and tap **Delete Account**).
- **How to Test Full Interactivity:**
  - **Data Erasure & Statutory Retention Inspection:** Tap any of the 16 items under **WHAT WILL BE PERMANENTLY DELETED** (such as **Dog Profiles**, **Training Sessions**, or **Photos & Videos**) to inspect live record volumes and jump straight to **Export This Data First**, or tap any row under **WHAT MAY BE RETAINED** to view its statutory retention window and legal basis.
  - **Before You Delete Alternatives (`Manage Subscription`, `Sign Out Instead`, `Export My Data First`):** Under **BEFORE YOU DELETE**, tap **Manage Subscription** to review or cancel auto-renewal, **Sign Out Instead** to open the safe sign-out confirmation sheet, or **Export My Data First** to archive your workspace before erasure.
  - **Identity Verification, Reason Selector & Consequence Checkboxes:** Under **VERIFY YOUR IDENTITY**, tap **Confirm with Face ID / Touch ID** to authenticate biometrically (or type at least 6 characters into **PASSWORD** with the eye visibility toggle), tap **REASON FOR LEAVING (OPTIONAL)** to select a departure reason, and tick both permanent-deletion acknowledgement checkboxes to unlock **Delete My Account**.
  - **Typed `DELETE` Final Confirmation & Abort Recovery:** Tap **Delete My Account** to open the destructive confirmation sheet, type `DELETE` to enable **Permanently Delete My Account**, confirm to queue deletion, and test **Abort Deletion** on the active banner (or **Finish & Exit** to return to sign-in).

### 30. Export My Data — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap your profile card at the top, then under **ACCOUNT** tap **Export My Data** (or open **Delete Account** and tap **Export My Data First**).
- **How to Test Full Interactivity:**
  - **Expandable Data Scope Accordions & `Select All` Toggle:** Under **SELECT DATA TO INCLUDE**, tap **Select All** / **Deselect All** in the top-right pill, or expand and collapse **Account**, **Dogs**, **Training**, **Health**, **Media & Documents**, and **Packs** to toggle individual data checkboxes (such as **Equipment**, **Rewards**, **Photos**, and **Videos**).
  - **Live Archive Size Calculation & Animated Breakdown Bar:** Toggle scopes, switch **EXPORT FORMAT** between **ZIP Archive**, **PDF Summary**, **CSV Data**, and **JSON Backup**, or change **MEDIA QUALITY** (**Original Quality**, **Optimised Quality**, **Exclude Media**) to watch **Estimated export size** and the multi-segment storage breakdown bar recalculate smoothly in real time.
  - **Date Range Presets & Password Archive Encryption:** Under **DATE RANGE**, switch from **All Data** to **Custom Date Range** and pick **Last 3 months**, **Last 6 months**, **Last 12 months**, or **Last 18 months**; under **SECURITY**, toggle **Protect with Password** on to reveal the **ARCHIVE ENCRYPTION PASSWORD** input with show/hide visibility toggle.
  - **Animated Export Preparation & Ready-to-Download Archive Card:** Tap **Generate Export** to watch the step-by-step preparation progress bar advance to 100% and reveal the **Archive Ready to Download** card with **Download Archive**, **Copy 48h Link**, and **Rebuild Export** actions.

### 31. Change Email Address — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap your profile card at the top, then under **ACCOUNT** tap **Change Email Address** (or open **Edit Profile** / **Account Settings** and tap **Change Email Address**).
- **How to Test Full Interactivity:**
  - **Live Email Syntax, Duplicate Check & Domain Suggestions:** Type into **NEW EMAIL ADDRESS** to test live validation (entering `olivia@email.com` warns that it matches **CURRENT EMAIL**, typing `@` surfaces one-tap domain suggestions like `@gmail.com` or `@icloud.com`, and entering a valid address turns the underline green with a verified check icon).
  - **Password Verification & Face ID Toggle:** Once typing a new email, enter your current password with the eye visibility toggle, or tap **Use Face ID** / **Face ID Active** to toggle biometric session verification and unlock **Continue**.
  - **Verification Code Entry, Resend Cooldown & Link Simulation:** Tap **Continue** to transition to the **Verify Your New Email** step; tap **Paste Demo Code (482910)** (or type a 6-digit code) and tap **Verify & Update Email**—or tap **Simulate Link Click**—to promote your new email to **PRIMARY EMAIL ACTIVE**, or use **Resend Email** and **Edit Email**.

### 32. Change Password — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap your profile card at the top, then under **ACCOUNT** tap **Change Password** (or open **Settings** and tap **Change Password**).
- **How to Test Full Interactivity:**
  - **Show/Hide Password Visibility Toggles & Passphrase Generator:** Tap the eye icons on **Current Password**, **New Password**, and **Confirm New Password** to reveal or mask each field independently, or tap **Suggest Strong** next to **New Password** to cycle through strong passphrase suggestions that auto-populate confirmation.
  - **5-Segment Strength Bar & Real-Time Requirement Checkmarks:** Edit **New Password** to watch the 5-segment strength bar animate across **Weak**, **Fair**, **Good**, **Strong**, and **Very Strong** while the 5 requirement checkmarks (**Minimum 8 characters**, **At least one uppercase letter**, **At least one lowercase letter**, **At least one number**, and **At least one special character**) update live.
  - **Match Validation, Device Sign-Out Switch & Update Confirmation:** Type into **Confirm New Password** to see live **Matches** / **Does not match** validation, toggle **Sign out of all other devices** to inspect active session revocation details, and tap **Update Password** to complete rotation and open the **Password Updated** confirmation sheet.

### 33. Calendar Page — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Calendar** under **TOOLS** / **WORKSPACE** (or tap your profile card at the top of **More**, then open **Calendar**).
- **How to Test Full Interactivity:**
  - **Dog Workspace Pills, Category Filter Pills & Live Search:** Tap **All Dogs**, **Murphy**, **Monty**, or **Minnie** (or tap `+` next to the dog pills to add a new dog filter), tap any category pill (**All Categories**, **Training**, **Health**, **Goals**, **Physio**, **Competitions**) or the top-right sliders icon, and tap the top-right search icon to filter scheduled and upcoming items live.
  - **Interactive Month Navigation, Multi-View Tabs & Date Selection:** Use `<`, `>`, and **Today** around **September 2026** to navigate months, tap any date cell in the **Month** grid (such as **12**, **16**, **19**, **21**, or **23**) to watch the selected-day agenda card and **UPCOMING** feed update immediately, or switch across **Month**, **Week** (featuring an animated 7-day workload bar chart), **Day**, **Year**, and **Agenda** tabs.
  - **Event Status Toggles, Quick-Add Links & `+` Add Event Sheet:** Tap any scheduled item (such as **Morning Obedience Session**, **Vet Check-Up**, or **Complete Recall Goal**) to mark it **Complete** / **Mark Planned** or **Delete** it; tap **+ Add Training**, **+ Add Health**, **+ Add Reminder**, or the floating green **`+`** button to schedule a new event onto the selected date with live preset titles, time slots, and dog selection.

### 34. Global Search â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap the **Search** icon in the top-right header (or select **Global Search** from the **More** workspace tools).
- **How to Test Full Interactivity:**
  - **Live Cross-Module Search & Highlighting:** Inspect the default **Recall** search query with live Forest Green keyword highlighting across **TRAINING SESSIONS**, **GOALS**, and **MEDIA**, or type any keyword (such as **Murphy**, **Freya**, **Rabies**, **IGP**, or **Sarah**) to filter results dynamically in real time.
  - **Active Filter Chips & Scope Pills:** Tap **Ã—** on **Murphy** or **Training** to remove individual active filters, or tap **Clear All** to expand the full horizontal scope filter pills (**All**, **Dogs**, **Training**, **Goals**, **Health**, **Timeline**, **Media**, **Competitions**, **Clients**) and quick dog toggles (**Murphy**, **Monty**, **Freya**).
  - **Recent Searches & Workspace Discovery:** Tap **Ã—** inside the search field to clear the query and view **RECENT SEARCHES** (tap any item to re-run, tap its **Ã—** to remove individually, or tap **Clear All** to wipe history) alongside quick category cards.
  - **Result Preview & Linked Navigation:** Tap any search result row to open its summary preview sheet with recorded metrics, then tap the primary action button (**Open Session Details**, **Open Goal Details**, **Open Dog Profile**, **Open Health Record**, or **Open Timeline Event**) to navigate directly to the linked screen, or tap **Cancel** in the top-right corner to close the modal.


### 35. Country or Region â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to **PREFERENCES** (or open **App Settings**) and tap **Country or Region**.
- **How to Test Full Interactivity:**
  - **Current & Suggested Region Cards:** Inspect the **CURRENT COUNTRY** card (**United Kingdom Â· GB Â· Great Britain** with **CURRENT** pill) and the **SUGGESTED** card showing **Device Region detected: United Kingdom**.
  - **Live Search & Alphabet Rail:** Type any country name, ISO code, or kennel club registry into **Search countries or regions** (and tap **Ã—** to clear), or tap/drag along the right-hand **Aâ€“Z** index rail to smoothly jump directly to any letter group in **ALL COUNTRIES**.
  - **Interactive Selection & Registry Preview:** Tap any country row (**Australia**, **Austria**, **Canada**, **Denmark**, **Finland**, **France**, **Germany**, **Norway**, **Sweden**, **Switzerland**, **United Kingdom**, or **United States**) to highlight it with the Forest Green selection bar, preview its regional kennel club and currency context inside **CURRENT COUNTRY**, and light up both **Continue** buttons.
  - **Apply & Save Feedback:** Tap **Continue** in the top-right header or bottom dock to apply the selected country and update the **CURRENT COUNTRY** card live.


### 36. Language â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to **PREFERENCES** (or open **App Settings**) and tap **Language**.
- **How to Test Full Interactivity:**
  - **Current Language & Device Language Toggle:** Inspect the **CURRENT LANGUAGE** card (**English (United Kingdom)** with **CURRENT** pill) and toggle **Use Device Language** on or off to automatically match your device language or pick manually.
  - **Live Language Search:** Type any native title, English name, or translated tab keyword into **Search languages** to filter **SUPPORTED LANGUAGES** live, and tap **Ã—** inside the search field to clear it.
  - **Interactive Selection & Translated Preview:** Tap any language row (**English (United Kingdom)**, **English (United States)**, **Deutsch**, **EspaÃ±ol**, **FranÃ§ais**, or **Svenska**) to highlight it with the Forest Green selection bar and display a live translated navigation preview banner inside **CURRENT LANGUAGE**.
  - **Upcoming Languages & Apply:** Tap **More languages coming soon** to open the **Upcoming Languages** bottom sheet and register a launch notification vote (**Norsk (BokmÃ¥l)**, **Dansk**, **Suomi**, **Nederlands**, or **Italiano**), then tap **Apply** in the top-right header or **Apply Language** in the bottom dock to commit your language choice.

### 37. Measurement Units â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to **PREFERENCES** (or open **App Settings**) and tap **Measurement Units**.
- **How to Test Full Interactivity:**
  - **System Presets & Active Summary Card:** Inspect the **CURRENT SYSTEM** card (**Metric Â· kg Â· km Â· cm Â· Â°C** with **METRIC** badge), then tap **Metric**, **Imperial**, or **Custom** (*Mix & match*) to switch all unit categories at once and watch the summary card and checkmark update live.
  - **Granular Category Pickers:** Under **MEASUREMENT CATEGORIES**, tap any row across **BODY** (**Dog Weight**, **Height & Body**), **ACTIVITY** (**Distance**, **Short Distance**, **Duration**), or **ENVIRONMENT** (**Temperature**, **Liquid Volume**) to open its unit picker bottom sheet and mix individual units (automatically switching the system preset to **Custom** when mixed).
  - **Live Sample Preview Grid:** Inspect the 2Ã—2 **PREVIEW** grid (**DOG WEIGHT**, **DISTANCE**, **JUMP HEIGHT**, **TEMPERATURE**) updating every sample value in real time as you switch systems or individual categories, and tap **JUMP HEIGHT** (or the preview caption) to toggle between **JUMP HEIGHT** and **ELEVATION GAIN** examples.
  - **Save Preferences:** Tap **Save** in the top-right header or **Save Measurement Units** in the bottom dock to apply your selected measurement units.

### 38. Date & Time Format â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to **PREFERENCES** (or open **App Settings**) and tap **Date & Time Format**.
- **How to Test Full Interactivity:**
  - **Current Format & Regional Toggle:** Inspect the **CURRENT FORMAT** card (**29 July 2026 Â· 14:35 Â· Week starts Monday**) and toggle **Use Regional Format** to automatically align date, clock, and week-start conventions with your selected country or customize them manually.
  - **Date, Clock & Week Selectors:** Tap any **DATE FORMAT** option (**29 July 2026**, **DD/MM/YYYY**, **MM/DD/YYYY**, **YYYY-MM-DD**, or **29 Jul 2026**), switch **TIME FORMAT** between **24-Hour** and **12-Hour**, and switch **FIRST DAY OF WEEK** between **Monday** and **Sunday**.
  - **Live Sample Timestamp Previews:** Watch both **CURRENT FORMAT** and the **PREVIEW** card (**TRAINING SESSION**, **REMINDER**, and **CALENDAR WEEK** day order) reformat every date, time range, and weekday sequence immediately as you tap different options.
  - **Save Preferences:** Tap **Save** in the top-right header or **Save Date & Time Format** in the bottom dock to save your display preferences.

### 39. Time Zone â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Scroll to **PREFERENCES** (or open **App Settings**) and tap **Time Zone**.
- **How to Test Full Interactivity:**
  - **Automatic vs. Manual Time Zone Sync:** Inspect the **CURRENT TIME ZONE** card (**Europe/London Â· 13:42 Â· UTC +01:00** with **AUTOMATIC** pill) and toggle **Use Device Time Zone** off to unlock full-brightness manual selection (**MANUAL** pill), or tap any city/search bar directly to switch to manual mode automatically.
  - **Live World Time Zone Search:** Type any city, country, IANA identifier, or UTC offset (such as **Madrid**, **Stockholm**, **New York**, **Dubai**, **Tokyo**, **Karachi**, or **UTC +02:00**) into **Search city, country or time zone**, and tap **Ã—** to clear the query.
  - **Regional Groups & Live Local Time Preview:** Tap any city across **SUGGESTED** or **ALL TIME ZONES** (**EUROPE**, **NORTH AMERICA**, **ASIA**, **OCEANIA**) to highlight it with the Forest Green selection bar and watch both **CURRENT TIME ZONE** and **PREVIEW** (**TIME ZONE**, **CURRENT TIME**, and **UTC OFFSET** zone title) update immediately.
  - **Save Time Zone:** Tap **Save** in the top-right header or **Save Time Zone** in the bottom dock to save your active time zone.

### 40. Change Photo & Profile Photo Empty State â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar and open **Profile** or **Edit Profile**.
  2. Tap the **Profile Photo** avatar (or open **Change Photo**).
- **How to Test Full Interactivity:**
  - **Populated Profile & Change Photo Bottom Sheet:** Inspect the **Handler Profile** backdrop (**Lars Viken Â· K9 Tracking Specialist â€¢ Level 4**) with the **Profile Photo** bottom sheet (**CURRENT ACTIVE** circular preview with Forest Green ring and status dot). Tap **Cancel** to dismiss the sheet, then tap the avatar, **â€¢â€¢â€¢**, or **Change Profile Photo** to reopen the modal bottom sheet.
  - **Take Photo & Choose from Photo Library:** Tap **Take Photo** or **Choose from Photo Library** (or tap any thumbnail under **RECENT LIBRARY PHOTOS**) to open the full-screen **Image Editor** crop flow and apply your cropped portrait back onto the profile.
  - **Remove Current Photo â†’ Empty State:** Tap **Remove Current Photo** in the bottom sheet to switch immediately into the **No Profile Photo** empty state featuring the **AK** initials circle, camera badge, **Take Photo** button, and **Choose Photo** action.
  - **Restore Photo from Empty State:** From **No Profile Photo**, tap **Take Photo**, **Choose Photo**, or the avatar camera badge to capture or select a photo, crop it in the **Image Editor**, and transition seamlessly back to the populated profile photo state.


### 41. Image Editor (Crop Guide) â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar and open **Profile** or **Edit Profile**.
  2. Tap the **Profile Photo** avatar (or **Change Photo**) to open the **Profile Photo** action sheet, then tap **Take Photo** or **Choose from Photo Library**.
- **How to Test Full Interactivity:**
  - **Interactive Crop Viewport & Pinch/Pan Framing:** Drag or pinch inside the circular crop guide (with darkened vignette mask and cardinal alignment ticks) to pan and zoom the portrait, double-tap the photo to quick-zoom in and out, or tap the subtle **Circle Guide / Square Guide** indicator above **PREVIEW** to toggle aperture shapes.
  - **Rotate, Reset & Smooth Zoom Slider:** Tap **Rotate** to rotate the photo in 90Â° steps, drag the horizontal zoom slider (`1.0Ã—` to `3.0Ã—`) to scale smoothly, and tap **Reset** to restore the original orientation, zoom, and pan position.
  - **Real-Time Dual Avatar Previews:** Watch both circular **PREVIEW** badges (**Profile** and **Trainer Badge**) mirror every pan, zoom, and 90Â° rotation live in real time.
  - **Choose Another Photo & Save:** Tap **Choose Another Photo** in the bottom dock to switch portraits from your library without leaving the editor, then tap **Save** in the top-right header or **Save Profile Photo** at the bottom to apply your cropped avatar (or tap **Cancel** to exit without saving).

---

## BATCH 9 â€” Media & Library

### 42. Ulvenik â€” Media Library â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Media Library**.
- **How to Test Full Interactivity:**
  - **Summary Metrics Card:** Tap **147 PHOTOS**, **34 VIDEOS**, or **12 DOCS** inside the top summary card to filter the grid directly to that media category, or tap **2.4 GB STORAGE** to jump straight into **Storage Manager**.
  - **Category Underline Tabs:** Switch smoothly between **All**, **Photos**, **Videos**, and **Documents** and watch the green indicator bar and 3-column grid update immediately.
  - **Media Grid Tiles & Viewers:** Tap any photo tile (e.g., **14 Jul**) to open **Photo Viewer**, tap any video tile (e.g., **0:45 Â· 13 Jul** or **1:20 Â· 9 Jul**) to open **Video Viewer**, or tap any document tile (e.g., **Vet Report Â· PDF**) to open **Document Viewer**.
  - **Favourites & Context Actions:** Tap the gold heart badge (`â˜…`/`â™¥`) in the top-left corner of starred tiles to toggle favourite status immediately, or long-press any grid tile to open its quick-action menu (**Add/Remove from Favourites**, **Add to Collection**, **Delete Media**).
  - **Top Action Icons:** Tap the **Search** magnifying glass icon to open **Media Search**, tap the **Sliders** tools icon to open the **Media Library Tools** hub (**Media Upload Manager**, **Media Collections**, **Favourites**, and **Storage Manager**), or tap the **Filter & Sort** icon to filter by dog workspace (**All Dogs**, **Kodi**, **Freja**, **BjÃ¸rn**), sort order (**Newest First**, **Oldest First**, **Largest Size**), and **Starred / Favourites Only**.

### 43. Ulvenik â€” Video Viewer â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Media Library**.
  3. Tap any video tile in the grid (such as **0:45 Â· 13 Jul** or **1:20 Â· 9 Jul**).
- **How to Test Full Interactivity:**
  - **Immersive Black Player & Chrome Toggle:** Notice the pure black full-immersion viewer with zero bottom navigation bar. Tap anywhere on the video frame to toggle the on-screen player controls on or off.
  - **Play/Pause, Scrubber, Frame Step, Mute, Speed & Fullscreen:** Tap the central **Play / Pause** button to advance the live timestamp and green progress scrubber, drag the **Scrubber** anywhere between `0:00` and total duration, tap **-1f** or **+1f** to step frame-by-frame, tap the **Speaker** icon to mute/unmute, tap **1Ã—** to cycle playback speed (**0.5Ã—**, **1Ã—**, **2Ã—**), or tap the **Fullscreen** corner icon (or **Open**) to launch the edge-to-edge fullscreen player.
  - **5-Button Action Strip:** Tap **Favourite** to toggle the gold heart live, **Share**, **Download** (marking the clip **Saved** offline), **Open**, or **Delete** (with confirmation dialog).
  - **Linked Record, Editable Notes, Tags & Related Videos:** Tap **Training Session â€” 12 Jul 2026** under **LINKED RECORD** to inspect the session metrics summary, tap **Edit** next to **NOTES** (or via the top-right `â‹®` menu) to update session notes live, tap **TAGS** pills (**Tracking**, **Outdoor**, **Distance Work**, **Session 14**), and tap any clip under **RELATED VIDEOS** (**0:52 Â· 10 Jul**, **1:14 Â· 8 Jul**, **2:05 Â· 4 Jul**) to load and play that clip immediately.

### 44. Ulvenik â€” Photo Viewer â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Media Library**.
  3. Tap any photo tile in the grid (such as **14 Jul** or **12 Jul**).
- **How to Test Full Interactivity:**
  - **Immersive Black Carousel, Pinch-Zoom & Swipe:** Notice the pure black full-immersion photo viewer with zero bottom navigation bar. Pinch-zoom (or double-tap) on the hero photograph to inspect fine detail up to `4Ã—`, swipe horizontally across all 12 session photographs, or tap the left `<` and right `>` arrows to step through slides while watching the `3 of 12` badge and metadata card update live.
  - **EXIF & Camera Metadata Sheet:** Tap the `4032 Ã— 3024 Â· 3.8 MB Â· EXIF` footer row inside the metadata card (or tap `â‹®` â†’ **View EXIF & Camera Info**) to inspect full camera, lens, exposure, colour profile, and GPS elevation metadata.
  - **Favourite Gold Badge & Action Strip:** Tap **Favourite** to toggle the gold heart (`â™¥`) live per photo, **Share**, **Download**, **Open Record** (opening the linked training session summary), or **Delete** (with confirmation dialog).
  - **Linked Record, Tags & Related Photos Strip:** Tap **Training Session â€” 12 Jul 2026** under **LINKED RECORD**, toggle **TAGS** pills (**Tracking**, **Outdoor**, **Distance Work**, **Competition Prep**), or tap any thumbnail in the **RELATED PHOTOS** strip (**12 Jul**, **10 Jul**, **8 Jul**, **5 Jul**, etc.) to jump the hero carousel straight to that frame with an active green selection border.


### 45. Ulvenik â€” Document Viewer â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Media Library**.
  3. Tap any document tile in the grid (such as **Vet Report Â· PDF**, **Vaccination Certificate Â· PDF**, or **Hip & Elbow Screening Â· PDF**), or switch to the **Documents** tab first and tap a document card.
- **How to Test Full Interactivity:**
  - **Multi-Page Switcher & Interactive Zoom:** Swipe horizontally across the rendered PDF pages, tap the left `<` and right `>` arrows, or tap the **Page 1** â€“ **Page 4** chips below the viewport to jump directly between pages while watching the `1 of 4` badge update live. Double-tap or pinch-zoom on the page (or tap the **100%** zoom pill to cycle **100%**, **150%**, **200%**).
  - **Search-in-Document Highlighting:** Tap the **Search** magnifying glass icon in the top bar (or via `â‹®` â†’ **Search in Document**), type a keyword or tap quick search chips (**Cleared**, **Hip**, **58 bpm**, **Rabies**, **96 / 100**) to highlight every matching term directly on the page in amber and jump between matches across pages using the `â†‘` / `â†“` arrows.
  - **Page Bookmarking & 5-Button Action Strip:** Tap the **Bookmark** ribbon icon on the document viewport (or in the `â‹®` menu) to bookmark specific pages with a gold badge, and use the 5-button action bar (**Favourite**, **Share**, **Download** offline toggle, **Open** full-screen reader, and **Delete** confirmation).
  - **Linked Record, Editable Notes, Tags & Related Documents:** Tap **Veterinary Checkup â€” 10 Jul 2026** under **LINKED RECORD** to inspect clinical summary metrics, tap **Edit** next to **NOTES** to update handler/clinical annotations live, tap **TAGS** pills to highlight tag terms inside the document, and tap any card under **RELATED DOCUMENTS** to switch documents immediately.


### 46. Ulvenik â€” Media Upload Manager â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Media Library**.
  3. Tap the **Upload / Sliders** tools action in the top header (or the **Media Uploads** quick pill) and select **Media Upload Manager**.
- **How to Test Full Interactivity:**
  - **Live Animated Upload Progress & Queue Promotion:** Watch active files under **UPLOADING** (**Koda_Training_Session_14.jpg**, **Koda_Outdoor_Run.jpg**, **Session14_Recall.mp4**) animate smoothly toward `100%` while the remaining megabytes and pulsing **Sync active** indicator inside **UPLOAD STATUS** update live; as each upload finishes, it moves automatically into **COMPLETED TODAY** and promotes the next file from **WAITING**.
  - **Per-File Pause, Resume, Retry & Cancel:** Tap the `â¸` / `â–¶` icon on any active upload card to pause or resume that file individually, tap `âœ•` to cancel a single item, tap **WAITING** on any queued card (or **Show all**) to prioritise it immediately, or tap **Koda_Training_Video_Recall.mp4** (or its red `â†»` retry icon) under **FAILED** to resume from `45%`.
  - **Master Queue Actions & Batch Edit Mode:** Test **Retry All Failed**, **Pause All**, **Resume All**, **Cancel All** (with confirmation dialog), **Clear Completed**, and tap **Edit** in the top bar to multi-select items for batch removal.
  - **Wi-Fi Only Sync & Add Media Simulation:** Toggle the **Wi-Fi Only Sync** switch between Wi-Fi-only and cellular sync, and tap **+ Add Media** to queue a new training photo, 1080p drill clip, or PDF certificate into the live upload stream.


### 47. Ulvenik â€” Media Collections â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Media Library**.
  3. Tap the **Collections** quick pill or tap the **Sliders** tools icon in the top bar and choose **Media Collections**.
- **How to Test Full Interactivity:**
  - **Search, Sort & Dog Workspace Filtering:** Tap the **Search** magnifying glass icon in the top bar to filter collections or contained media items live by keyword and dog chips (**All Dogs**, **Kodi**, **Freja**, **BjÃ¸rn**), or tap the `=` sort/filter icon to reorder albums by **Recently Updated**, **Most Items**, or **Alphabetical (Aâ€“Z)**.
  - **Inspect Collection Media & Open Viewers:** Tap any album card (**Agility Training â€” Summer**, **Vet Visit Records**, **Competition Day â€” Oslo**, **Scent & Search Trials**, or **Obedience Notes & Briefs**) to open its media sheet, then tap any photo, video clip, or PDF inside to launch **Photo Viewer**, **Video Viewer**, or **Document Viewer** directly.
  - **Create Live Collection (`+`):** Tap `+` in the top-right corner, enter a collection name, choose a dog workspace and cover style (**Trail Cover**, **Fjord Cover**, or **Folder Icon**), and tap **Create Collection** to add the new album immediately at the top of the list.


### 48. Ulvenik â€” Storage Manager â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Media Library**.
  3. Tap **2.4 GB STORAGE** inside the top summary card (or tap the **Sliders** tools icon and select **Storage Manager**).
- **How to Test Full Interactivity:**
  - **2Ã—2 Storage Overview & Animated Category Bar:** Inspect **Cloud Storage** (`2.4 GB`), **Device Storage** (`1.1 GB`), **Offline Files** (`340 MB`), **Cache** (`128 MB`), and **Available on Device** (`14.2 GB`), and tap segments in the animated category bar (or tap any card under **STORAGE BREAKDOWN**) to highlight that category dynamically.
  - **Large-Media Cleanup Selector (`Manage`):** Tap **Manage** on **Photos**, **Videos**, **Documents**, or **Offline Records** to open the local cleanup selector, check off large downloaded files, and tap **Free Selected** to reclaim megabytes live across **Device Storage** and **Available on Device**.
  - **Device Optimisation & Upload Quality:** Toggle **Optimise Device Storage** under **OPTIMISATION** to see live local savings (`~320 MB`), and switch between **Original Quality**, **High Quality** (recommended), **Balanced**, and **Data Saver** under **UPLOAD QUALITY**.
  - **Cloud Sync & Granular Cache Clearing:** Tap **Last Synchronised** to refresh sync status, tap **Open Upload Manager â†’** under **CLOUD SYNC** to jump straight to **Media Uploads**, and test **Clear Image Cache**, **Clear Video Cache**, **Clear Document Cache**, or **Clear All Cache** under **CACHE**.


### 49. Ulvenik â€” Media Search â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Media Library**.
  3. Tap the **Search** magnifying glass icon in the top header.
- **How to Test Full Interactivity:**
  - **Live Keyword Search & Initial / Empty States:** Type keywords in the search bar (e.g., `agility`, `vet`, `pdf`, `tracking`, `oslo`) to filter the 3-column results grid immediately, tap `âœ•` inside the search field to inspect **RECENT SEARCHES** and **SUGGESTED KEYWORDS**, or enter a non-matching term to trigger the **No media found** state with **Reset Filters**.
  - **Type, Category, Dog & Date Filter Chips:** Filter search results across **All**, **Photos**, **Videos**, **Documents**, **Training**, and **Competition**, refine further by dog (**All Dogs**, **Kodi**, **Freja**, **BjÃ¸rn**) and date (**Any Date**, **Jul 2026**, **Jun 2026**), and tap **Sort: Most Relevant** to switch between **Most Relevant**, **Newest First**, **Oldest First**, and **Favourites First**.
  - **Open Results in Viewers & Star Toggling:** Tap any photo tile to open **Photo Viewer**, tap any video tile (`0:42`, `1:15`, `1:34`) to open **Video Viewer**, tap any document tile (**Agility_Guide.pdf**, **Vet_Report_Clearance.pdf**) to open **Document Viewer**, or tap the gold heart badge (`â™¥`) on starred tiles to toggle favourite status in place.


### 50. Ulvenik â€” Favourites â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Media Library**.
  3. Tap the **Favourites** quick pill (or tap the **Sliders** tools icon in the top bar and choose **Favourites**).
- **How to Test Full Interactivity:**
  - **Category Underline Tabs:** Switch smoothly across **All**, **Photos**, **Videos**, **Documents**, and **Training** while watching the green underline indicator and filtered favourites list update immediately.
  - **Gold Star / Heart Unfavourite & Instant Undo:** Tap the gold badge (`#B8920A`) in the bottom-right corner of any thumbnail (**Agility Finals â€” Ã–rebro**, **Weave Pole Session #12**, **Vet Report â€” July 2026**, etc.) to unfavourite it immediately, then tap **Undo** in the floating snackbar or top restore banner to put it right back.
  - **Search & Sort Order:** Tap the **Search** magnifying glass icon to filter favourites by title or dog name, or tap the **Filter & Sort** sliders icon to filter by dog (**All Dogs**, **Zeus**, **Luna**, **Kodi**) and sort by **Recently Added**, **Oldest Added**, or **Alphabetical (Aâ€“Z)**.
  - **Open Starred Items in Viewers:** Tap any starred **Photo** row to open **Photo Viewer**, tap any **Video** row to open **Video Viewer**, tap any **Document** row to open **Document Viewer**, or tap a starred **Training Session** / **Goal** row to inspect its milestone summary and watch its linked session clip.

---

## BATCH 10 â€” Sport Pack

### 51. Ulvenik â€” Sport Pack Overview â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Sport Pack Overview**.
- **How to Test Full Interactivity:**
  - **Active Dog Switcher:** Tap the **Zeus (Belgian Malinois)** card under **ACTIVE DOG** to switch between **Zeus**, **Freja**, and **Koda** and watch the animated summary counters update smoothly.
  - **Animated Sport Summary Grid:** Watch the 6-cell summary metrics (**3 Total Sports**, **42 Sport Skills**, **286 Training Sessions**, **2 Upcoming Competitions**, **9 Competitions Completed**, **7 Qualifications**) animate on load; tap **Total Sports** to open **My Sports**, tap **Upcoming Competitions** or **Competitions Completed** to jump directly into **Competitions Overview** on the corresponding tab, or tap **Sport Skills** / **Training Sessions** to open **Sport Details (IGP)**.
  - **My Sports Cards:** Tap **All Sports** to open **My Sports**, or tap **IGP**, **Agility**, or **PSA** directly to inspect its sport progression and breakdown.
  - **Upcoming Competitions & Recent Activity:** Tap **Essex Working Dog Trial** (`Entered`) or **Club Trial â€” Autumn 2026** (`Planned`) to open **Competition Details**, tap any **Recent Activity** row to inspect its session/qualification log banner, or tap **IGP 1** / **Best Protection Work** under **Qualifications & Awards** to inspect full qualification details.
  - **Live Search & Quick Actions (`+`):** Tap the top-right **Search** icon to filter sports, competitions, recent activity, and qualifications in real time, tap the top-right **`+`** button to open **Create Sport**, or tap the floating green **`+`** button to launch any Sport Pack workflow (**Create Sport**, **Record Competition Result**, **Competitions Overview**, **My Sports**).


### 52. Ulvenik â€” My Sports â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Tap **All Sports** next to **MY SPORTS** (or tap **Total Sports** in the summary card).
- **How to Test Full Interactivity:**
  - **Animated Sport Summary & Touch-Interactive Session Share Bar:** Watch the 6 summary metrics (**3 Total Sports**, **3 Active Sports**, **0 Archived Sports**, **38 Total Skills**, **486 Total Sessions**, **11 Total Competitions**) and the segmented session-share bar animate on load; tap any bar segment to focus on that sport's share, tap **Active Sports** / **Archived Sports** / **Total Skills** / **Total Sessions** to filter or re-sort the list, or tap **Total Competitions** to jump into **Competitions Overview**.
  - **Live Search & Filter/Sort Sheet:** Tap the top-right **Search** icon to filter sports by name, organisation, or level in real time, or tap the **Filter** icon to filter by **All / Active / Archived** and sort by **Most Sessions**, **Most Skills**, **Most Competitions**, or **Name (Aâ€“Z)**.
  - **Sport Cards & Archive Workflow:** Tap **IGP**, **Agility**, or **PSA** to open its **Sport Details** view, or tap the sport badge pill (or long-press a card) to archive and restore sports dynamically and see the **Active** / **Archived** counters update immediately.
  - **Add Sport:** Tap the top-right **`+`** icon or the floating green **`+`** button to open **Create Sport**.


### 53. Ulvenik â€” Sport Details (IGP) â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Tap the **IGP** card under **MY SPORTS** (or tap any sport card inside **My Sports**).
- **How to Test Full Interactivity:**
  - **Hero Status & Overview:** Tap the **Active** status pill in the top **IGP** header card (or use the top-right **`...`** menu) to toggle between **Active** and **Archived** states, and inspect the live **Overview** breakdown (**Created March 2024**, **18 Skills**, **54 Exercises**, **286 Sessions**, **7 Competitions**, **4 Qualifications**, **2 Awards**, **Last Activity**).
  - **Skills, Competitions & Qualifications:** Tap **Heelwork**, **Retrieve**, or **Tracking** to inspect phase/session stats, tap **View All 18 Skills â†’** to expand the skill list inline, tap **Essex Working Dog Trial** or **Club Trial â€” Spring 2026** to open **Competition Details**, or tap **View All 7 Competitions â†’** to open **Competitions Overview**.
  - **Animated Phase Score Rings & Progression Chart:** Under **STATISTICS**, watch the 4 counters (**286 Training Sessions**, **142h Training Hours**, **7 Competitions**, **4 Qualifications**), the **Phase A / Phase B / Phase C** circular score rings, and the 5-trial progression bars animate on load; tap any phase ring to isolate that phase's trend or tap any trial bar (**Nov 25** through **Sep 26**) to inspect that trial's exact phase scores.
  - **Editable Notes, Quick Actions & More Options:** Tap **Edit** (or the **NOTES** card) to update training/judge feedback, test all 4 **QUICK ACTIONS** (**Create Skill**, **Record Training Session**, **Add Competition**, **Add Qualification or Award**), or use **Edit Sport**, **Archive Sport**, and **Delete Sport** under **MORE OPTIONS**.


### 54. Ulvenik â€” Create Sport â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Tap the top-right **`+`** icon (or open the floating **`+`** menu and tap **Create Sport**).
- **How to Test Full Interactivity:**
  - **Sport Photo / Emblem Picker:** Tap the dashed **Add photo (optional)** circle at the top of the card to pick a sport emblem preset (**Working Protection Crest**, **Tracking & Scent Paw**, **Speed & Agility Hurdle**, **Championship Rosette**, or **Choose from Gallery**) or clear the selected photo.
  - **Quick Templates & Underline Form Fields:** Tap any preset chip (**+ Mondioring**, **+ Nosework**, **+ Obedience**, **+ Canicross**) to auto-populate the form, or type directly into **SPORT NAME \***, **DESCRIPTION**, **ORGANISATION**, **CURRENT LEVEL**, and **NOTES**.
  - **Validation & Live Save:** Clear **SPORT NAME \*** and tap **Create Sport** (or top-right **Save**) to verify required-field validation, then enter a sport name and tap **Create Sport** to add it directly to **Sport Pack Overview** and **My Sports** (or edit an existing sport via **Edit Sport** inside **Sport Details**).


### 55. Ulvenik â€” Competitions Overview â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Tap **All Trials** next to **UPCOMING COMPETITIONS** (or tap **Upcoming Competitions** / **Competitions Completed** in the summary card).
- **How to Test Full Interactivity:**
  - **Animated Status Filter Cards:** Watch the 4 top status counters (**2 Upcoming**, **7 Completed**, **1 Withdrawn**, **0 Cancelled**) animate on load; tap any card to filter the competition list by that status (tap again or tap **Show All** to clear).
  - **Live Search & Discipline Filter Sheet:** Tap the top-right **Search** icon to search by event title, city, date, or sport, or tap the **Filter** icon to combine status and sport discipline filters (**All**, **IGP**, **Agility**, **PSA**).
  - **Competition Rows & Animated Season Score Progression:** Tap **Essex Working Dog Trial**, **Club Trial â€” Autumn 2026**, **IGP National 2026**, **Club Trial â€” Spring 2026**, or **District Qualifier** to open **Competition Details**; scroll to **SEASON SCORE PROGRESSION** and tap any animated trial bar to inspect its score percentage, placement, and jump directly via **Inspect â†’**.
  - **Schedule Entry or Record Result (`+`):** Tap the floating green **`+`** button to either schedule a new **Upcoming / Planned** competition entry or open **Record Competition Result**.


### 56. Ulvenik â€” Competition Details â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Tap **Essex Working Dog Trial** under **UPCOMING COMPETITIONS** (or tap any competition row inside **Competitions Overview**).
- **How to Test Full Interactivity:**
  - **Competition Information & Edit Sheet:** Inspect the 9-row **COMPETITION INFORMATION** card (**Date**, **Start Time**, **Organisation**, **Judge Hans MÃ¼ller**, **Club**, **Venue Barleyfields Training Ground**, **Entry Number 47**, **Entry Class IGP 2**, **Handler James Walker**) and tap **Edit Competition** at the bottom (or via **`...`**) to modify event details live.
  - **Result State & Animated Phase Rings / Readiness Bars:** On an upcoming trial, tap any animated **Phase A / Phase B / Phase C** readiness bar under **RESULT** to inspect target criteria, then tap **Record Result** to log scores â€” upon returning (or when opening a **Completed** trial), watch the **Official Score** and **Phase A / B / C** circular score rings animate and update **QUALIFICATIONS & AWARDS** automatically.
  - **Editable Notes & Document Attachments:** Tap **Edit Notes** inside the **NOTES** card to update preparation reminders, tap **Open** on **Entry Confirmation.pdf** or **Running Order.pdf** under **ATTACHMENTS** to preview document contents, or tap **`...` â†’ Add Scorebook / Schedule PDF** to attach a new file.


### 57. Ulvenik â€” Record Competition Result â€” `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Tap **Essex Working Dog Trial** to open **Competition Details**, then tap **Record Result** (or open the floating **`+`** menu on **Sport Pack Overview** / **Competitions Overview** and tap **Record Competition Result**).
- **How to Test Full Interactivity:**
  - **Competition Context & Result Status Selector:** Tap the top competition header card when opened standalone to switch which trial you are recording, or tap the **Completed** dropdown under **RESULT STATUS \*** to choose between **Completed**, **Qualified**, **Did Not Qualify**, and **Withdrawn**.
  - **Animated Phase Score Rings & Live Score Calculation:** Watch the **Phase A / Phase B / Phase C** circular score rings animate on load; tap any phase ring and drag the fine-tune slider to watch **SCORE** (`287.5 / 300`) and **OVERALL RESULT** (`Excellent`) recalculate automatically in real time (or edit **OVERALL RESULT**, **SCORE**, and **PLACEMENT** directly).
  - **Qualifications, Awards, Comments & Attachments:** Tap **+ Add Qualification** or **+ Add Award** to add removable honour chips (or tap **`âœ•`** on **IGP 1** to remove), edit **JUDGE'S COMMENTS** and **PERSONAL NOTES**, tap **Add Attachment** to attach extra scorecards (or tap **`âœ•`** on **Score Sheet.pdf** to remove), then tap **Save Result** (or top-right **Save**) to persist the official result across **Competition Details**, **Competitions Overview**, and **Sport Pack Overview**.

### 58. Qualifications, Titles & Awards — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Tap **All Qualifications** next to **QUALIFICATIONS & AWARDS** (or tap **Qualifications** in the **Sport Summary** card, or open the floating **`+`** menu and tap **Qualifications & Awards**).
- **How to Test Full Interactivity:**
  - **Interactive Summary Strip:** Tap **4 Qualifications**, **1 Titles**, or **3 Awards** in the horizontal summary strip to filter the list by category (tap again to clear), or tap **15 Sep 2026 Latest** to jump directly into the newest official qualification inspector.
  - **Live Search & Multi-Facet Filter Sheet:** Tap the top-right **Search** icon to search by title, sport, judge, or venue in real time, or tap the **Filter** icon to filter by **Dog Workspace** (**All Dogs**, **Rex**, **Luna**, **Fenris**), **Sport Discipline** (**IGP**, **AGILITY**, **OBEDIENCE**, **TRACKING**), **Achievement Type**, and **Season / Year**, then clear filters via **Reset** on the active filter banner.
  - **Phase Breakdown Inspector & Archive Toggle:** Tap any achievement card (**IGP 1**, **Best Protection Work**, **IPO Champion 2025**, **BH**, **Kennel Club Foundation Certificate**) to open its inspector sheet with animated phase score bars and minimum pass markers — tap any phase bar to view the judge's phase notes and tap **Share Official Qualification Summary**; at the bottom of the list, tap **Show 4 earlier 2024 qualifications & awards** to expand archived season records.
  - **Log New Qualification, Title or Award (`+`):** Tap the floating green **`+`** button to open the logging sheet, tap a quick preset chip (**IGP 2**, **FH 1 Tracking**, **Clean Run Award**, **Nordic Winner 2026**) or enter custom details, pick a date, and tap **Save Achievement** to prepend it live.

### 59. Sport Statistics — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Open the floating **`+`** menu and tap **Sport Statistics** (or tap **View Full Sport Statistics** inside **Sport Details**).
- **How to Test Full Interactivity:**
  - **Period Filter Pills & Custom Calendar Scope:** Tap **Last 30 Days**, **Last 90 Days**, **This Year**, or scroll horizontally to **All Time** to watch all counters and charts animate smoothly, or tap the top-right **Calendar** icon to filter by **Sport Discipline** (**All Sports**, **IGP**, **Agility**, **PSA**) and pick a custom date range.
  - **Animated & Touch-Interactive Monthly Volume Chart:** Under **TRAINING**, tap or drag horizontally across **Apr**, **May**, **Jun**, **Jul**, **Aug**, and **Sep** to highlight each month and inspect its live session, hour, and discipline split tooltip; tap **Apr – Sep 2026** in the chart header to toggle between **Monthly Session Volume** bars and **Monthly Training Hours** curve mode.
  - **Summary, Skills, Competitions & Achievements Drill-Downs:** Tap **286 Training Sessions** or **142h Training Hours** to inspect animated discipline share bars, tap **18 Skills / 54 Exercises** to inspect active vs untrained curriculum drills, tap **Competitions** (**7 Entered · 5 Completed · 2 Upcoming · 1 Withdrawn**) to jump to **Competitions Overview**, or tap **Achievements** (**4 Qualifications · 1 Titles · 3 Awards · 0 Certificates**) to open **Qualifications & Awards**.
  - **Export & Share Statistics:** Tap the top-right **Share** icon to export a **Season PDF Report**, **CSV Session Ledger**, or **Coach / Club Snapshot**.

### 60. Add Competition — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Open the floating **`+`** menu and tap **Add Competition** (or tap **Add Competition** inside **Competitions Overview** or **Sport Details**).
- **How to Test Full Interactivity:**
  - **Competition Information & Auto-Detect Weather:** Enter **Competition Name \***, select **Sport \*** (**IGP**, **Agility**, **PSA**, **Obedience**, **Mondioring**, **Tracking**, **Nosework**), switch **Dog \*** (**Milo**, **Zeus**, **Freja**, **Koda**), pick **Date \***, **Start Time**, **End Time**, **Venue**, **Address**, **Country**, **Organising Club**, **Judge(s)**, **Class / Division**, **Entry Number**, and **Handler** — watch **Weather** auto-populate once date/location are selected (or tap **Auto-detect** to unlock manual entry).
  - **Date-Driven Status & Event Category:** Pick a future or past date to see **STATUS** (**Upcoming**, **In Progress**, **Completed**, **Cancelled**) update automatically, or tap any status pill manually and enter an **Event Category** under **COMPETITION TYPE**.
  - **Link Goals, Equipment Library & Media Attachments:** Tap **Link Goals** to attach training goals as removable chips, tap **Add Equipment** to select trial gear from the Equipment Library, and tap **Add Photos**, **Add Videos**, or **Add Documents** under **MEDIA** to attach venue maps, walk-through clips, or entry PDFs.
  - **Live Notes Counter, Reminder & Validation:** Type into **NOTES** (`0 / 2000` live counter), toggle **Competition Reminder** to pick a lead-time pill (**1 Day Before · 08:00**, **3 Days Before · 18:00**, **Morning of Trial · 06:30**), test required-field validation (or **Quick Fill**), then tap **Create Competition** (or top-right **Save**) to add the entry live to **Sport Pack Overview** and **Competitions Overview**.

### 61. Competition Results — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Open the floating **`+`** menu and tap **Competition Results** (or open a completed trial inside **Competitions Overview**).
- **How to Test Full Interactivity:**
  - **Hero Score Summary & Trial Switcher:** Watch **92.4 pts**, **1st Place**, and **QUALIFIED** animate on load inside the **Regional Agility Trial 2026** card, or tap the hero card to switch between completed trial result sheets.
  - **Outcome, Qualification Status, Placing & Auto-Calculated Percentage:** Toggle **Competition Outcome** (**Passed**, **Failed**, **Withdrawn**, **Eliminated**, **Disqualified**, **Retired**) and **Qualification Status** (**Qualified**, **Not Qualified**, **Pending**), edit **OVERALL**, **CLASS**, or **TEAM** ranks, and edit **Total Score** / **Maximum Score** to watch **Percentage** (`92.4%`) and the hero badge update live alongside the **Personal Best** switch.
  - **Animated Section Score Breakdown Bars & Customisable Sections:** Under **SECTION SCORES**, tap any animated section bar (**Agility Round 1**, **Agility Round 2**) to highlight its card, edit **SCORE** or **MAX** to recalculate totals automatically, or tap **`+ Add Section Score`** to add custom rounds.
  - **Faults, Awards, Multi-Judge Feedback & Attachments:** Edit **Fault Points**, **Penalty Points**, **Time Faults**, and **Eliminations**, add or remove **AWARDS** chips (**First Place**, **Qualification Certificate**, **High in Trial**), tap **`+ Add Judge`** under **JUDGE FEEDBACK**, update **NOTES**, and tap **Score Sheets**, **Certificates**, **Photos**, or **Videos** under **ATTACHMENTS** (tap thumbnails to preview, long-press to remove) before tapping **Save Results**.


### 62. Achievements & Title — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar, then tap **Sport Pack Overview**.
  2. Tap **Certificates & Documents** (or tap **All Qualifications** and select **Titles & Milestones**, or tap **Achievements & Titles** under the Sport Pack actions menu).
- **How to Test Full Interactivity:**
  - **Dynamic KPI Tiles & Summary Badges:** Watch the **3 Titles Earned**, **12 Qualifications**, **7 Major Awards**, and **100% Pass Rate** metric cards animate on load; tap any metric card to filter and highlight matching record categories.
  - **Multi-Filter Chips & Live Search:** Tap the top-right **magnifying glass** to search achievements, titles, competitions, or judges live; tap horizontal filter chips (**All Disciplines**, **IGP**, **Agility**, **Tracking**, **Obedience**) to filter all recorded achievements in real time.
  - **Expandable Accordion Sections & Score Progression Bars:** Tap to expand or collapse **TITLES**, **QUALIFICATIONS**, **MAJOR AWARDS**, **PERSONAL BESTS**, and **CAREER MILESTONES**; under each title card, inspect the animated phase score bars (**Tracking**, **Obedience**, **Protection** with pass minimum markers), tap **Certificate** to open the verified certificate viewer, and tap **Show More** to expand historical archive records.
  - **Log New Title or Achievement (`+`):** Tap the floating **`+`** button to open the title logging sheet, enter title name, event, date, issuing authority (e.g. SV / FCI), attach score breakdowns, and tap **Save Title** to see it prepend dynamically to the active list.

### 63. Certificates & Documents — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Certificates & Documents** (or tap **More** -> **Sport Pack Overview** -> tap **Certificate** on any verified qualification or title).
- **How to Test Full Interactivity:**
  - **Document Counter & Sort Bottom Sheet:** Tap the **Most Recent ∨** dropdown next to **12 Documents** to open the sort bottom sheet (**Most Recent**, **Oldest First**, **Title A-Z**, **File Size Largest**) and verify the document list reorders immediately.
  - **Interactive Category Filter Chips & Live Search:** Tap any horizontal chip (**All**, **Certificates**, **Score Sheets**, **Judge Sheets**, **Entry Documents**, **Health Clearance**, **Awards**) to filter documents by category, tap the top-right **Search** icon to open the search bar and filter records live by title or trial name, or tap the **Filter** icon to open the multi-category filter modal and tap **Apply Filter**.
  - **Document Inspection Viewer:** Tap any document card (such as **IGP3 Title Certificate**, **Tracking Score Sheet — Round 1**, or **Judge Sheet — Protection Phase**) to open the comprehensive document sheet featuring verified registry badges, date of issuance, dog assignment, and SHA-256 digital signature status; tap **Download** or **View Full** to test preview actions, or tap **Delete Document** to confirm removal with live list updates.
  - **Upload & Add Document Sheet (`+`):** Tap the header **`+`** button or the floating green **`+`** button in the bottom-right corner to open the upload modal; select **Document Type**, fill in **Document Title**, **Event / Competition**, and **Issuing Body**, attach a document scan, and tap **Upload & Save** to add it to the live document list with immediate snackbar confirmation.

## BATCH 11 — Trainer Pack

### 64. Trainer Workspace Settings — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Trainer Dashboard**, then tap the top-right **Workspace Settings** gear icon.
- **How to Test Full Interactivity:**
  - **Timeframe Picker & Category Tabs:** Tap the **This Month** pill in the header to open **Select Timeframe** (**This Week**, **This Month**, **Last 3 Months**, **This Year**), or switch across **Overview**, **Training**, **S&C**, **Skills**, and **Health** to replay all chart animations and recalculate workspace metrics dynamically.
  - **KPI Grid & Animated Sparklines:** Watch **Total Training Time**, **Sessions**, **Training Frequency**, and **Success Rate** animate on entrance; tap any KPI card to highlight and focus it.
  - **Interactive Weekly Trend & Session Breakdown:** Tap or drag horizontally across the **Training Time** weekly trend chart to inspect individual point durations, and tap the **Session Breakdown** donut ring or any category row (**General Training**, **Strength & Cond.**, **Competition**) to isolate segment time shares.
  - **Training Heatmap & Best Streak Ring:** Tap any cell in the 7-day (**M**–**S**) **Training Heatmap** grid to inspect Morning, Afternoon, or Evening session counts vs rest slots, and verify the animated **BEST STREAK** percentage ring at the bottom.

### 65. Trainer Dashboard — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Tap **Trainer Dashboard**.
- **How to Test Full Interactivity:**
  - **Business Identity & Live Summary Metrics:** Tap the **Take the Lead Essex / Liv Old** header card to open **Trainer Profile & Business Identity** (and verify edits reflect live upon returning), watch the **4 Lessons Today**, **12 Active Clients**, **21 Client Dogs**, and **3 Reviews Pending** counters animate on load, and tap **Active Clients** or **Client Dogs** to open the **Clients Page**.
  - **Live Workspace Search & Notifications:** Type into **Search clients, dogs, records...** (or tap the top-right magnifying glass) to filter alerts, schedule lessons, recent activity, and live client/dog matches; tap the top-right **notification bell** to inspect trainer alerts or the **Workspace Settings** gear icon to open **Trainer Workspace Settings**.
  - **Attention Required & Today's Schedule:** Tap **3 Homework Assignments Pending Review** or **New client invitation accepted** to open client/dog review actions and toggle **Mark Reviewed** (updating **Reviews Pending** live), tap **Incomplete client profile** (**James Harlow**) to jump directly into **Edit Client**, or tap **09:00 Emma · Murphy** / **11:30 James · Bella** to confirm, complete, or start a lesson, and tap **View Full Calendar →**.
  - **Quick Actions, Recent Activity & Animated Weekly Volume:** Tap **Add Client**, **Start Lesson**, **Assign Task** (adding a live homework task that increments **HW Assigned** and prepends to **Recent Activity**), **Record Session**, **Create Goal**, or **Open Calendar**; tap **47 Recorded** or **View All Activity →** to jump to **Client Notes**; and tap or drag across the **Weekly Lesson Volume** (**M**–**S**) bars to inspect daily lesson counts.

### 66. Trainer Profile & Business Identity — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard** and tap the **Take the Lead Essex / Liv Old** business identity card at the top.
- **How to Test Full Interactivity:**
  - **Cover Banner & Live Edit Identity Sheet:** Tap the top-right **Ulvenik emblem** badge on the misty pine banner to cycle cover atmospheres, or tap the top-right **pencil** icon (or avatar) to edit **Business Name**, **Trainer Name**, **About Bio**, **Contact** details, and add new **Expertise** tags — saving updates both **Trainer Profile** and **Trainer Dashboard** live.
  - **Animated Stats Strip:** Watch **12 Active Clients**, **21 Client Dogs**, and **47 Sessions** animate on load; tap **Active Clients** or **Client Dogs** to jump to the **Clients Page**, or tap **Sessions** to open **Trainer Workspace Settings**.
  - **Expertise, Qualifications & Certificates:** Tap any pill under **EXPERTISE** (**GUNDOGS**, **RECALL**, **LOOSE LEAD**, **REACTIVITY**, **PUPPY TRAINING**, **BEHAVIOUR MODIFICATION**, **IGP**) to highlight it, and tap **IMDT Member**, **Canine First Aid**, or **DBS Checked** under **QUALIFICATIONS** to inspect the verified credential sheet and copy the certificate reference.
  - **Services & Contact Actions:** Tap **One-to-One Lessons**, **Behaviour Consultations**, or **Puppy Packages** under **SERVICES** to edit service summaries and durations live, and tap any row under **CONTACT** (**liv@taketheleadessex.co.uk**, **taketheleadessex.co.uk**, **@taketheleadessex**) to copy it with instant confirmation.

### 67. Clients Page — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard** and tap **Active Clients** (or **Client Dogs**) in the top summary card.
- **How to Test Full Interactivity:**
  - **Live Search, Multi-Filter Chips & Sort Sheet:** Type into **Search clients, dogs or email...** (and tap **×** to clear), toggle horizontal filter chips (**ACTIVE CLIENTS**, **HOMEWORK DUE**, **TRAINING PLAN**, **SESSION TODAY**, **INACTIVE**, **FAVOURITES**) to watch the filter badge counter and **Clients** count update live, or tap the top-right **Filter** sliders and **Sorted by: Recently Active** (**swap arrows**) to filter archived clients and re-sort by **Recently Active**, **Next Session**, **Name (A–Z)**, or **Most Dogs**.
  - **Swipe-Left Quick Actions & Favourites:** Swipe left on any client card (or tap the card's bottom-right chevron; **James Harlow** starts previewed open) to reveal **VIEW**, **EDIT**, and **ARCHIVE** actions, tap any avatar badge to toggle the gold **Favourite** star, or tap **`...`** on a client card for quick navigation to **Client Profile**, **Edit Client**, and **Client Notes**.
  - **Add Client & Live Directory Updates:** Tap the top-right **`+`**, the floating bottom-right **`+`** button, or **`+ Add Client`** in the **No Clients Yet** empty-state card to create a new client and verify it appears immediately at the top of the directory.

### 68. Client Profile — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard**, tap **Active Clients**, and tap **Emma Johnson** (or any client card).
- **How to Test Full Interactivity:**
  - **Identity Header, Favourite Star & Contact Actions:** Toggle the top-right gold **Favourite** star, tap **Call** or **Email** on the client card, and tap **Emerg. Contact** or **Vet Practice** (**On File**) in the 6-cell metadata strip to inspect file details.
  - **Quick Actions & Animated Client Statistics:** Tap **Dogs** (scrolls to dog cards), **Homework** (opens task assignment & status sheet), **Client Notes** (opens **Client Notes**), **Progress** (replays statistics & chart animations), **Reports** (generates a report and increments **Reports Generated** live), or **Share**; tap any cell in **STATISTICS** or tap/drag across the **6-Week Activity & Adherence** (**W1**–**W6**) bars to inspect weekly log counts and adherence percentages.
  - **Client Dogs, Homework & Private Notes:** Tap **Murphy** (`IGP`) or **Bella** under **DOGS** to open the **Client Dog Profile**, tap any task under **HOMEWORK** (**Recall Foundation Practice**, **Loose Lead Consistency**, **Place Training**) to cycle **IN PROGRESS** / **COMPLETED** / **OVERDUE**, or tap **View All Notes →** under **NOTES** to open **Client Notes**.
  - **Sharing Permissions & Client Management Sheet:** Tap any row under **PERMISSIONS** (**Training Records**, **Goals**, **Media**, **Health Records**) or **Manage Permissions →** to toggle access live, and use the bottom management card (or top-right **`...`**) to **Edit Client**, **Archive Client**, **Export Client**, **Share Client**, or **Delete Client**.

### 69. Client Dog Profile — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard**, tap **Active Clients**, tap **Emma Johnson**, and tap **Murphy** under **DOGS**.
- **How to Test Full Interactivity:**
  - **Hero Banner, Owner Link & Session Starters:** Tap **Owner: Emma Johnson** to jump back to **Client Profile**, or tap **Start Training Session** and **Start S&C Session** to launch pre-populated session recording for **Murphy**.
  - **Overview, Animated Quick Stats & 8-Tile Actions Grid:** Watch **47 Total Sessions**, **18 S&C Sessions**, and **38.5h Hours Trained** animate on entrance (tap any card to highlight it), and tap **Training**, **S&C**, **Timeline**, **Health**, **Goals**, **Statistics**, **Videos**, or **Reports** under **ACTIONS**.
  - **Touch-Interactive Active Goals, Videos & Health Summary:** Tap or drag horizontally across the green progress bars on **Recall Under High Distraction** (**68% complete**) and **IGP 1 Scent Pad Tracking** (**45% complete**) to update milestone progress live, tap **Recall Drill** (`01:45`) or **Heelwork Focus** (`03:12`) under **RECENT VIDEOS** to open the video player, and tap **View & Edit Health & Safety** (or the **Health & Safety** tile under **ACTIONS**) to open the dedicated trainer reference sheet displaying **Allergies & Sensitivities**, **Physical Limitations**, **Current Medication**, **Important Conditions**, **Emergency Vet**, and **General Health Notes**, and tap **Edit Health & Safety Notes** to test modifying safety notes with instant confirmation.
  - **Trainer Access Permissions & Dog Management Sheet:** Switch between **VIEW ONLY**, **ADD RECORDS**, **EDITABLE**, and **FULL ACCESS** under **PERMISSIONS (TRAINER ACCESS)** to update the hero badge and permission callout live, and tap **Edit Dog Profile**, **Share Progress Report**, **Export Dog Records**, or **Archive Dog (Owner Permission Required)** in the bottom contextual card (or top-right **`⋮`** menu).

### 70. Add Client — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard** and tap **Add Client** under **QUICK ACTIONS** (or tap **`+`** on the **Clients Page**).
- **How to Test Full Interactivity:**
  - **Basic, Contact & Collapsible Address Details:** Enter **First Name \***, **Last Name \***, **Company**, **Nickname**, **Email Address**, and **Mobile Number**, expand or collapse **Add Address** under **ADDRESS**, and tap **Norway** to choose a country from the picker sheet.
  - **Private Trainer Notes, Permissions & Client Access Switches:** Add private observations under **TRAINER NOTES**, select **VIEW ONLY**, **STANDARD TRAINER**, or **FULL ACCESS** under **TRAINER PERMISSIONS**, and toggle any of the 7 switches under **CLIENT ACCESS** (**View Training Records**, **View Health Records**, **View Goals**, **View Reports**, **Upload Videos**, **Add Notes**, **Edit Existing Records**).
  - **Invite Message Counter, Add Dog Now & Live Creation:** Toggle **Send Invitation**, type a **Personal Message** to watch the **`0 / 500`** character counter update live, optionally enable **Add Dog Now** under **AFTER SAVING** to attach an initial dog immediately, and tap **Create Client** (or top-right **Save**) to open the newly created profile and see it reflected live across **Clients Page** and **Trainer Dashboard**.


### 71. Edit Client — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard**, tap **Active Clients**, open **Emma Johnson**, and tap **Edit Client** (or tap the **pencil** icon / swipe left on any client in the **Clients Page**).
- **How to Test Full Interactivity:**
  - **Profile Header & Photo Modal:** Tap the camera badge on the **EJ** avatar circle to open the **Change Client Photo** bottom sheet (**Take Photo**, **Choose from Gallery**, **Remove Photo**); edit the client name and watch the avatar initials and header name update in real time.
  - **Personal, Contact & Address Fields:** Edit **First Name \***, **Last Name \***, **Preferred Name**, **Company**, **Email Address**, **Mobile Number**, **Address Line 1 & 2**, **Town / City**, and **Postcode / ZIP**; tap **Country** to open the country selection sheet and switch between regional options.
  - **Private Trainer Notes:** Edit the multi-line **TRAINER NOTES** field and observe the lock icon and helper notice confirming notes remain private and are never shared with clients.
  - **Permission Preset Buttons & Individual Switches:** Tap **VIEW ONLY**, **STANDARD TRAINER**, or **FULL ACCESS** under **TRAINER PERMISSIONS** to batch-toggle all 9 individual capability switches (**View Training**, **Add Training Sessions**, **Edit Training Sessions**, **View Health**, **Edit Health**, **Create Goals**, **Upload Videos**, **View Reports**, **Export Reports**), or manually flip any switch to watch the preset automatically switch to **CUSTOM**.
  - **Client Status Selector & Save / Discard Actions:** Select **ACTIVE**, **INACTIVE**, or **ARCHIVED** under **CLIENT STATUS** to watch the status description update; tap **Save Changes** (or top-right **Save**) to show the loading indicator and commit changes with a success snackbar, or tap **Cancel** to open the **Discard Changes?** confirmation dialog.

### 72. Client Notes — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard**, select a client (**Emma & Murphy**), and tap **Client Notes** on the **Client Profile** screen.
- **How to Test Full Interactivity:**
  - **Live Search & Category Filtering:** Type into **Search notes...** (or tap the top-right magnifying glass to focus and **Cancel** to clear), and tap any horizontal category pill (**ALL**, **PINNED**, **TRAINING**, **BEHAVIOUR**, **HEALTH**, **HOMEWORK**) to filter notes live across **PINNED** and **NOTES**.
  - **Visibility & Attachment Filter Sheet:** Tap the top-right **filter** icon (with the green status dot) to filter notes by **All Notes**, **Trainer Private Only**, or **Client-Visible**, toggle **Has Attachments (PDF / Media)** or **Show Archived Notes**, and clear active filters from the inline banner.
  - **Pinning, Swipe-Left Actions & Detail Sheet:** Tap the green **pushpin** icon on a note card to pin or unpin it, swipe left on any note card (or tap **VIEW**, **EDIT**, and **ARCHIVE** inside the **SWIPE GESTURE PREVIEW** tray) to reveal quick actions, or tap a card to inspect full observations, media pills (**1 PDF**, **2 Photos**, **1 Video**), and toggle **Client-Visible** vs **Trainer Private** live.
  - **Add & Edit Client Notes:** Tap the floating bottom-right **+** button (or top-right **+**) to create a new client note with category selection, media attachments, pin switch, and client portal visibility toggle.


### 73. Client Homework — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard**, select a client (**Emma & Murphy**), and tap **Homework** on the **Client Profile** screen.
- **How to Test Full Interactivity:**
  - **Live Search, Status Pills & Sorting:** Type into **Search homework...** (or tap **Cancel** to reset), tap status filter pills (**ACTIVE**, **COMPLETED**, **OVERDUE**, **HIGH PRIORITY**, **IN PROGRESS**, **NOT STARTED**), or tap **Sort: Earliest Due** (and the top-right **filter** icon) to filter by dog (**Murphy**, **Rex**), archived status, or sort order live.
  - **Animated Progress Bars & Swipe Actions:** Watch assignment completion bars animate smoothly on load and filter switches, swipe left on any homework card (or use **VIEW**, **EDIT**, and **ARCHIVE** in the **SWIPE GESTURE PREVIEW** bar) to edit plans or archive with one-tap **Undo**.
  - **Assign New Homework & Live Sync:** Tap the bottom-right **+** button (or top-right **+**) to assign a new homework plan with dog tags, target due date, high-priority toggle, and trainer criteria, or tap any homework card to open **Homework Details** and sync updated progress back automatically.

### 74. Homework Details — `[x] Completed`
- **How to Access:**
  1. Open **Client Homework** from **Client Profile** (under **More** -> **Trainer Dashboard**).
  2. Tap any homework card (such as **Week 4 Focus & Decoy Engagement Drills**) or tap **VIEW** in the swipe action tray.
- **How to Test Full Interactivity:**
  - **Mark Complete & Animated Progress Tracking:** Tap **Mark as Complete** (or **Completed · Tap to Reopen**) on the top **HOMEWORK** card, or tap **Completed (+1)** / **Remaining** inside the **PROGRESS** card to step rep counts (**8 / 12**) up or down while the overall completion percentage and progress bars animate smoothly.
  - **Interactive Linked Exercises & Submissions:** Tap the circular check toggle on **Eye Contact Drill (15m)** or **Neutral Decoy Pass-by** under **LINKED EXERCISES** to mark drills complete immediately (or tap a drill row to adjust rep counts), tap **Reviewing** beside **CLIENT SUBMISSIONS (2)** to cycle review status, and tap submission or **ATTACHMENTS (2)** cards (**DecoyPass.mp4**, **Protocol.pdf**) to inspect full previews.
  - **Trainer Feedback & Shared Notes:** Tap **+ Add Feedback** inside **TRAINER FEEDBACK** to post new behaviorist coaching notes, tap **+ Add Note** (or tap an existing note) under **NOTES (SHARED NOTE)** to log client or trainer observations, or use the top-right **⋮** menu to edit instructions or reset reps.

### 75. Client Progress — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard**, select a client (**Emma & Murphy**), and tap **Client Progress** on the **Client Profile** screen.
- **How to Test Full Interactivity:**
  - **Period Selector & Skill Category Pills:** Tap **This Month** in the top-right corner to switch between **This Week**, **This Month**, **Last 3 Months**, and **Year to Date**, and tap horizontal category pills (**Overview**, **Training**, **S&C**, **Skills**, **Health**) to smoothly re-animate all sparklines, KPI deltas, and charts.
  - **Touch-Scrubbable Weekly Trend Chart:** Tap or drag horizontally across the **Training Time** progression line chart to scrub across weekly data points with a live vertical guide and exact date/duration readout.
  - **Interactive Top Skills Ring & Consistency Heatmap:** Tap any skill row (**Focus & Drive**, **Agility & S&C**, **Heelwork**, **Other Modules**) or tap the **Top Skills** donut ring directly to highlight individual segments, and tap any day cell in the 28-day **Your Consistency** heatmap to inspect daily session summaries.

### 76. Shared Records — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard**, select a client (**Emma & Murphy**), and tap **Shared Records** on the **Client Profile** screen.
- **How to Test Full Interactivity:**
  - **Category Pills, Search & Direction Filters:** Search inside **Search shared records...**, tap horizontal category pills (**ALL**, **TRAINING**, **HEALTH**, **GOALS**, **REPORTS**, **MEDIA**), or tap the top-right **funnel** icon to filter by **Shared by You**, **Shared by Client**, or **Show Active Access Only**.
  - **Granular Access Levels, Share/Revoke & Swipe Tray:** Tap any shared record card to inspect its summary, switch permission badges (**FULL ACCESS**, **EDIT**, **COMMENT**, **VIEW ONLY**), or toggle **Actively Shared with Emma Johnson** on/off; or swipe left on a card (or use **VIEW**, **PERMS**, and **STOP** in **SWIPE GESTURE PREVIEW**) while watching **SHARING HISTORY** update live (tap **View Full History** for the complete audit log).
  - **Share New Record & Consolidated Report:** Tap the floating **+** button to share a new session, health, video, or goal record, or tap **Generate Shared Report** at the bottom to preview and export a consolidated PDF packet of active shared items.

### 77. Client Permissions — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard**, select a client, and tap **Client Permissions** on the **Client Profile** screen.
- **How to Test Full Interactivity:**
  - **Role Preset Selector:** Tap any of the four **PERMISSION PRESETS** cards (**View Only**, **Standard Trainer**, **Full Access**, **Custom**) to batch-update all 34 granular switches across the nine capability modules and watch the header badge (**STANDARD TRAINER**, **VIEW ONLY**, **FULL ACCESS**, **CUSTOM**) update live.
  - **Granular Module Switches:** Toggle individual permissions across **Dog Profile**, **Training**, **Strength & Conditioning**, **Health**, **Goals**, **Homework**, **Media**, **Reports**, and **Notes** — flipping any individual switch automatically transitions the active preset to **Custom**.
  - **Reset, Confirmation Sheet & Audit History:** Tap **Reset** (or **Reset to Standard Trainer**) to restore baseline trainer defaults, or tap **Save** / **Save Permissions** to open the confirmation sheet, review the enabled permission count, and commit a new timestamped entry to **PERMISSION HISTORY**.

### 78. Trainer Reports — `[x] Completed`
- **How to Access:**
  1. Tap **More** in the bottom navigation bar.
  2. Open **Trainer Dashboard** (or **Client Profile**) and tap **Trainer Reports**.
- **How to Test Full Interactivity:**
  - **Search, Period Pills & Touch-Interactive Summary Chart:** Search via **Search reports...**, tap timeframe pills (**All Periods**, **Sep – Oct**, **Aug – Sep**, **Jul – Sep**, **Q3 Review**) or the top-right **sliders** filter icon (filter by **LUNA**, **BEAR**, or **Shared with Client Only**), and tap or drag across the animated monthly report volume & mastery chart to inspect monthly PDF output.
  - **Swipe-Left Copy/Delete & Report Preview Sheet:** Swipe left on any report card (including the pre-revealed **Comprehensive Q3 Client Review** tray) to **COPY** a report as a draft or **DELETE** with **Undo**, or tap any report card to inspect animated evaluation breakdowns, toggle **Shared in Client Portal**, **Export PDF**, or **Send Report**.
  - **Generate New Trainer Report:** Tap the bottom-right **+** button to choose a report template, select dogs (**LUNA**, **BEAR**) and evaluation window, toggle immediate client notification, and generate a new PDF report live.

## NEW SCREENS — Rewards

### 79. Rewards Management — `[x] Completed`
- **How to Access:**
  1. Tap **Training** in the bottom navigation bar.
  2. Scroll to the quick-action tiles and tap **Rewards & Reinforcers**.
- **How to Test Full Interactivity:**
  - **Working Dog Context Switcher:** View the active **Rook · Belgian Malinois (`IGP-3 SPORT`)** header card and tap it to switch between working dogs (**Rook**, **Murphy**, and **Koda**).
  - **Live Search & Type Filtering:** Tap the top-right **magnifying glass** icon to filter rewards live by keyword or notes, or tap any horizontal **REWARD TYPES** chip (**All**, **Food**, **Toy**, **Praise**, **Play**, **Competition**) to filter the rewards list and update the live item count (**6 items**).
  - **Animated & Touch-Interactive Reinforcer Mix Bar:** Tap the **6 items** counter next to **MY REWARDS** to expand an animated proportional **REINFORCER MIX** breakdown bar, and tap any colored bar segment or legend item to isolate that category.
  - **Add, Edit, Delete & Manage Types:** Tap any reward card (**Freeze-Dried Liver**, **Tug Toy**, **Verbal Praise**, **Kibble**, **Tennis Ball**, **Chase Game**) or its **pencil** icon to edit it, tap the **trash** icon to confirm deletion with live list updates, tap **Manage Types** to configure reward categories, or tap the bottom-right **+** button to add a new reward.


### 80. Add Reward — `[x] Completed`
- **How to Access:**
  1. Tap **Training** in the bottom navigation bar and tap **Rewards & Reinforcers**.
  2. Tap the floating green **+** button in the bottom-right corner.
- **How to Test Full Interactivity:**
  - **Personalised Modal Header & Name Input:** View the bottom sheet header personalised to the selected dog (**Rewards are personal to Rook.**), enter any **REWARD NAME** (with live validation if left blank), or tap **×** / **Cancel** to dismiss.
  - **Reward Type Chips & Inline Custom Type Creation:** Select any **REWARD TYPE** pill (**Food**, **Toy**, **Praise**, **Play**, **Competition**, **High Drive**), or tap the dashed **+ New Type** pill to type and add a brand-new reward category on the spot.
  - **Optional Notes & Live Save:** Enter notes under **DESCRIPTION** and tap **Save Reward** to immediately prepend the new reward to the main **MY REWARDS** list and update the total item count.


### 81. Edit Reward — `[x] Completed`
- **How to Access:**
  1. Tap **Training** in the bottom navigation bar and tap **Rewards & Reinforcers**.
  2. Tap any reward card (such as **Freeze-Dried Liver**) or tap the **pencil** icon on the right side of any reward card.
- **How to Test Full Interactivity:**
  - **Pre-Populated Reward Details:** View the **Edit Reward** bottom sheet pre-filled with the selected reward's **REWARD NAME**, active **REWARD TYPE** pill (**Food ✓**, **Toy**, **Praise**, **Play**, **Competition**, **High Drive**), and **DESCRIPTION** notes.
  - **Live Category Reassignment & Custom Type Creation:** Tap another **REWARD TYPE** pill to change the reward's category badge, or tap the dashed **+ New Type** pill to create and assign a custom reward category inline.
  - **Save Changes & Destructive Delete Confirmation:** Tap **Save Changes** to update the reward card in real time on the **Rewards** screen, tap **Cancel** / **×** to discard edits, or tap **Delete Reward** at the bottom to confirm permanent removal.


### 82. Manage Reward Types — `[x] Completed`
- **How to Access:**
  1. Tap **Training** in the bottom navigation bar and tap **Rewards & Reinforcers**.
  2. Tap **Manage Types** in the **REWARD TYPES** section header.
- **How to Test Full Interactivity:**
  - **Active & Archived Reward Categories:** Inspect all active reward categories with their linked reward counts, colour badges, and custom icons, and toggle individual types between active and archived states while watching the **Rewards** filter strip update live.
  - **Create & Edit Custom Reward Types:** Tap **+ Add Type** (or tap the **pencil** icon on any reward type row) to open the **Reward Type** editor sheet, customise its name, badge colour, icon, and description, and save changes live.
  - **Reordering & Safe Deletion:** Reorder reward types to adjust their display priority across **Rewards**, or tap the **trash** icon on a type row to review linked reward warnings and confirm archiving or deletion.
