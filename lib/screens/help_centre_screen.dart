import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'contact_support_screen.dart';
import 'feature_requests_screen.dart';
import 'report_bug_screen.dart';

class _HelpArticle {
  final String id;
  final String section;
  final String title;
  final String subtitle;
  final bool isPopular;
  final String readTime;
  final List<String> steps;
  final String proTip;
  final List<Map<String, String>> relatedFaqs;

  const _HelpArticle({
    required this.id,
    required this.section,
    required this.title,
    required this.subtitle,
    this.isPopular = false,
    required this.readTime,
    required this.steps,
    required this.proTip,
    required this.relatedFaqs,
  });
}

class _FaqEntry {
  final String id;
  final String category;
  final String question;
  final String answer;

  const _FaqEntry({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });
}

class HelpCentreScreen extends StatefulWidget {
  const HelpCentreScreen({super.key});

  @override
  State<HelpCentreScreen> createState() => _HelpCentreScreenState();
}

class _HelpCentreScreenState extends State<HelpCentreScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  final Set<String> _expandedFaqIds = <String>{};
  final Set<String> _bookmarkedArticleIds = <String>{};
  final Map<String, bool> _articleHelpfulVotes = <String, bool>{};

  static const List<String> _categories = [
    'All',
    'Getting Started',
    'Account & Subscription',
    'Training & Health',
    'Troubleshooting',
    'Privacy & Security',
  ];

  static const List<_FaqEntry> _faqs = [
    _FaqEntry(
      id: 'faq_1',
      category: 'Getting Started',
      question: 'How many dogs can I add to my Ulvenik workspace?',
      answer:
          'You can add unlimited dog profiles under Dogs -> Add Dog. Each dog maintains an isolated training log, health record history, S&C progression, and Timeline feed.',
    ),
    _FaqEntry(
      id: 'faq_2',
      category: 'Troubleshooting',
      question: 'Does Ulvenik work completely offline in low-signal field areas?',
      answer:
          'Yes. Training sessions, S&C logs, weight entries, and Timeline notes are stored locally first and automatically sync in the background as soon as connectivity returns.',
    ),
    _FaqEntry(
      id: 'faq_3',
      category: 'Account & Subscription',
      question: 'How do I restore my subscription on a new phone?',
      answer:
          'Sign in with the same Ulvenik account email, open More -> Subscription, and tap Restore Purchases. Your Pro entitlements and cloud backups will sync immediately.',
    ),
    _FaqEntry(
      id: 'faq_4',
      category: 'Training & Health',
      question: 'Can I link a training session directly to an active goal?',
      answer:
          'Yes. While recording or editing any session, select one or more active skills or goals to automatically contribute session duration and criteria ratings toward progress.',
    ),
    _FaqEntry(
      id: 'faq_5',
      category: 'Privacy & Security',
      question: 'Can I export a full copy of my dog\'s records at any time?',
      answer:
          'Absolutely. Go to More -> Import / Export or Timeline Export to generate structured CSV, JSON, or veterinary PDF summaries of your data.',
    ),
    _FaqEntry(
      id: 'faq_6',
      category: 'Troubleshooting',
      question: 'Why are some Timeline photos taking longer to sync?',
      answer:
          'High-resolution media waits for Wi-Fi by default if Data Saver is active. Check Sync Settings or pull down on Timeline to trigger an immediate manual sync.',
    ),
  ];

  static const List<_HelpArticle> _popularArticles = [
    _HelpArticle(
      id: 'pop_recording_first',
      section: 'Getting Started',
      title: 'Recording Your First Training Session',
      subtitle: 'Log your first session step by step',
      isPopular: true,
      readTime: '3 min read',
      steps: [
        'Open the Training tab from the bottom navigation bar and tap Record Session.',
        'Choose your active dog profile, select an activity type (e.g., Scent Work, Obedience, Agility), and optionally pick a saved template.',
        'Log duration, environment conditions, linked skills, and session notes while training or afterward.',
        'Tap Save Session to publish the entry directly to your dog\'s Training log and Timeline.',
      ],
      proTip:
          'Save frequent drill structures as Session Templates so you can start field logging in two taps.',
      relatedFaqs: [
        {
          'q': 'Can I edit a session after saving it?',
          'a':
              'Yes. Open Session Details from Training or Timeline and tap Edit to update metrics, media, or notes.',
        },
        {
          'q': 'Do offline sessions still count toward streaks?',
          'a':
              'Yes, sessions are stamped with the actual local time they were recorded.',
        },
      ],
    ),
    _HelpArticle(
      id: 'pop_sync_problems',
      section: 'Troubleshooting',
      title: 'Sync Problems',
      subtitle: 'Fix issues with data not syncing',
      isPopular: true,
      readTime: '4 min read',
      steps: [
        'Verify your device has an active internet connection and VPN/firewall rules are not blocking cloud sync.',
        'Confirm you are signed into the same Ulvenik account across devices under More -> Account.',
        'Pull down to refresh on Timeline or Dogs to force an immediate delta sync.',
        'If media uploads remain queued, check available local storage and Wi-Fi media upload preferences.',
      ],
      proTip:
          'Never uninstall the app while unsynced offline entries are queued—contact support with diagnostic logs attached first.',
      relatedFaqs: [
        {
          'q': 'How can I tell if items are still waiting to sync?',
          'a':
              'Pending offline records display a subtle sync indicator until cloud confirmation completes.',
        },
      ],
    ),
    _HelpArticle(
      id: 'pop_subscription',
      section: 'Account & Subscription',
      title: 'Subscription Management',
      subtitle: 'Upgrade, downgrade or cancel',
      isPopular: true,
      readTime: '2 min read',
      steps: [
        'Navigate to More -> Account & Subscription to view your current plan tier and renewal date.',
        'Switch between monthly and annual billing cycles or review included workspace features.',
        'Subscriptions billed through Apple App Store or Google Play are managed directly in your platform subscription settings.',
        'If you cancel, full access continues through the end of the current paid billing period.',
      ],
      proTip:
          'Even if a Pro plan expires, your historical dog records remain safe and exportable.',
      relatedFaqs: [
        {
          'q': 'Will cancelling delete my dogs or training history?',
          'a':
              'No. Your data remains intact in your account and can be exported at any time.',
        },
      ],
    ),
    _HelpArticle(
      id: 'pop_offline_mode',
      section: 'Troubleshooting',
      title: 'Offline Mode',
      subtitle: 'Using Ulvenik without an internet connection',
      isPopular: true,
      readTime: '3 min read',
      steps: [
        'Open Ulvenik before heading into remote training areas while signed in so your active workspace is cached locally.',
        'Record Training Sessions, Strength & Conditioning workouts, Health events, and Timeline notes as normal.',
        'Photos captured offline are queued locally and uploaded automatically once connectivity is restored.',
        'Conflict resolution preserves chronological integrity across all offline entries.',
      ],
      proTip:
          'Pre-open recently added dog profiles before going off-grid so full media thumbnails are cached on device.',
      relatedFaqs: [
        {
          'q': 'Is there a limit to how long I can stay offline?',
          'a':
              'You can log offline for days at a time—entries remain safely stored in encrypted local storage until synced.',
        },
      ],
    ),
    _HelpArticle(
      id: 'pop_adding_dog',
      section: 'Getting Started',
      title: 'Adding Your First Dog',
      subtitle: 'Add and configure your dog\'s profile',
      isPopular: true,
      readTime: '2 min read',
      steps: [
        'Tap Dogs in the bottom navigation bar and select Add Dog.',
        'Enter your dog\'s call name, registered name (optional), breed, date of birth, sex, and baseline weight.',
        'Upload a clear profile photo and configure primary sports or working focus areas.',
        'Save the profile to unlock dedicated Training, S&C, Health, and Timeline workspaces for your dog.',
      ],
      proTip:
          'Adding an accurate date of birth enables puppyhood developmental milestones and Timeline Memories anniversaries.',
      relatedFaqs: [
        {
          'q': 'Can I archive a dog profile later without deleting data?',
          'a':
              'Yes, profiles can be archived while preserving every historical Timeline and health record.',
        },
      ],
    ),
  ];

  static const List<_HelpArticle> _allSectionArticles = [
    // GETTING STARTED
    _HelpArticle(
      id: 'gs_account',
      section: 'Getting Started',
      title: 'Creating an Account',
      subtitle: 'Set up your Ulvenik profile',
      readTime: '2 min read',
      steps: [
        'Register using your email address or supported single sign-on provider.',
        'Verify your email address using the 6-digit verification code sent to your inbox.',
        'Set your preferred measurement units (kg/lbs, km/mi) and notification preferences.',
      ],
      proTip: 'Enable Two-Factor Authentication right after setup for maximum account security.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'gs_first_dog',
      section: 'Getting Started',
      title: 'Adding Your First Dog',
      subtitle: 'Add and configure your dog\'s profile',
      readTime: '2 min read',
      steps: [
        'Open the Dogs tab and tap Add Dog.',
        'Provide your dog\'s name, breed, date of birth, and optional microchip/registration details.',
        'Save to initialise your dog\'s dedicated workspace.',
      ],
      proTip: 'Switch effortlessly between multiple dogs from the workspace switcher at the top of key screens.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'gs_first_session',
      section: 'Getting Started',
      title: 'Recording Your First Training Session',
      subtitle: 'Log your first session step by step',
      readTime: '3 min read',
      steps: [
        'Go to Training and tap Record Session.',
        'Pick an activity, log duration, environment, and skill ratings, then tap Save.',
        'Review your session breakdown anytime in Session Details or Timeline.',
      ],
      proTip: 'Attach short video clips to compare body mechanics and criteria progress over months.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'gs_sc',
      section: 'Getting Started',
      title: 'Strength & Conditioning',
      subtitle: 'Get started with Strength & Conditioning tracking',
      readTime: '3 min read',
      steps: [
        'Open Strength & Conditioning to browse exercises by category or equipment.',
        'Log sets, reps, hold durations, and custom metrics for each conditioning activity.',
        'Review recorded sessions and custom metrics on the Strength & Conditioning dashboard.',
      ],
      proTip: 'Pair Strength & Conditioning logs with Equipment items from your shared Equipment Library.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'gs_health',
      section: 'Getting Started',
      title: 'Managing Health Records',
      subtitle: 'Add and organise health data',
      readTime: '3 min read',
      steps: [
        'Open Health Dashboard to log vaccinations, vet visits, medications, weight, dental care, or injuries.',
        'Attach clinic PDFs, lab results, or invoices directly to any health record.',
        'Configure Health Reminders so booster dates and preventative treatments are never missed.',
      ],
      proTip: 'Export a clean Health Timeline summary before specialist or physiotherapy appointments.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'gs_goals',
      section: 'Getting Started',
      title: 'Using Goals',
      subtitle: 'Set and track training goals',
      readTime: '3 min read',
      steps: [
        'Create structured short-term or trial-readiness goals with target dates and milestones.',
        'Link relevant skills and activities so logged sessions automatically advance progress.',
        'Celebrate completed goals as permanent achievements on your dog\'s Timeline.',
      ],
      proTip: 'Break complex competition behaviours into 3–4 measurable sub-milestones.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'gs_timeline',
      section: 'Getting Started',
      title: 'Using Timeline',
      subtitle: 'Understand the Timeline feature',
      readTime: '3 min read',
      steps: [
        'Browse a unified chronological journal of every training session, health event, milestone, and weight entry.',
        'Use Timeline Filters, Calendar view, Search, and Favourites to pinpoint key moments.',
        'Revisit anniversaries and major milestones in Timeline Memories.',
      ],
      proTip: 'Bookmark pivotal breakthroughs to access them instantly in Timeline Favourites.',
      relatedFaqs: [],
    ),

    // ACCOUNT & SUBSCRIPTION
    _HelpArticle(
      id: 'acc_manage',
      section: 'Account & Subscription',
      title: 'Managing Your Account',
      subtitle: 'Update your profile and preferences',
      readTime: '2 min read',
      steps: [
        'Open More -> Account to edit your display name, region, time zone, and default units.',
        'Review connected sign-in providers and active session security.',
      ],
      proTip: 'Unit changes convert display values non-destructively without altering stored precision.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'acc_email',
      section: 'Account & Subscription',
      title: 'Changing Email Address',
      subtitle: 'How to update your login email',
      readTime: '2 min read',
      steps: [
        'Navigate to Account Settings and select Change Email Address.',
        'Confirm your current password and enter your new email address.',
        'Enter the verification code sent to your new inbox to finalise the change.',
      ],
      proTip: 'Your previous email receives a security alert whenever a login email change is requested.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'acc_password',
      section: 'Account & Subscription',
      title: 'Password Assistance',
      subtitle: 'Reset or change your password',
      readTime: '2 min read',
      steps: [
        'Tap Forgot Password on the sign-in screen or Change Password inside Account Security.',
        'Use a strong passphrase of at least 10 characters combining letters, numbers, and symbols.',
      ],
      proTip: 'Updating your password signs out unrecognised sessions on other devices.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'acc_sub',
      section: 'Account & Subscription',
      title: 'Subscription Management',
      subtitle: 'Upgrade, downgrade or cancel',
      readTime: '2 min read',
      steps: [
        'Open More -> Subscription to inspect your active tier and renewal schedule.',
        'Manage plan upgrades, downgrades, or cancellations via your store billing portal.',
      ],
      proTip: 'Annual plans save significantly compared to month-to-month billing.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'acc_billing',
      section: 'Account & Subscription',
      title: 'Billing Questions',
      subtitle: 'Invoices, charges and payment methods',
      readTime: '3 min read',
      steps: [
        'Receipts and VAT/tax invoices are issued automatically after each renewal.',
        'Update payment cards directly in Apple ID Payment & Shipping or Google Play Payments.',
      ],
      proTip: 'Need a custom invoice note? Reach out via Contact Support -> Account & Billing.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'acc_restore',
      section: 'Account & Subscription',
      title: 'Restoring Purchases',
      subtitle: 'Restore a previous subscription',
      readTime: '2 min read',
      steps: [
        'Ensure your device is signed into the Apple ID or Google account used for the original purchase.',
        'Open Subscription settings in Ulvenik and tap Restore Purchases.',
      ],
      proTip: 'Restart the app once if store entitlement propagation takes more than 30 seconds.',
      relatedFaqs: [],
    ),

    // TRAINING & HEALTH
    _HelpArticle(
      id: 'th_sessions',
      section: 'Training & Health',
      title: 'Training Sessions',
      subtitle: 'Logging and reviewing sessions',
      readTime: '3 min read',
      steps: [
        'Record structured sessions with duration, location, surface, weather, and performance ratings.',
        'Filter historical sessions by sport, skill, or date range.',
      ],
      proTip: 'Consistent concise notes after each session make long-term pattern analysis effortless.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'th_health',
      section: 'Training & Health',
      title: 'Health Records',
      subtitle: 'Recording and organising health data',
      readTime: '3 min read',
      steps: [
        'Categorise records across Vet Visits, Vaccinations, Medications, Supplements, Allergies, Dental, and Surgery.',
        'Track recovery protocols and physiotherapy notes alongside training load.',
      ],
      proTip: 'Link follow-up reminders directly when logging a vet visit or medication course.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'th_sc',
      section: 'Training & Health',
      title: 'Strength & Conditioning',
      subtitle: 'Strength & Conditioning tracking and session types',
      readTime: '3 min read',
      steps: [
        'Build custom exercises or choose from the canine conditioning library.',
        'Track unilateral balance, core stability, proprioception, and warm-up/cool-down adherence.',
      ],
      proTip: 'Respect rest intervals and log soreness notes to prevent overreaching.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'th_stats',
      section: 'Training & Health',
      title: 'Statistics',
      subtitle: 'Understanding your progress data',
      readTime: '3 min read',
      steps: [
        'View weekly and monthly training volume, sport distribution, and consistency trends.',
        'Compare workload spikes against health or recovery events.',
      ],
      proTip: 'Switch time horizons (30D, 90D, 1Y, All) to spot seasonal conditioning patterns.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'th_media',
      section: 'Training & Health',
      title: 'Videos & Photos',
      subtitle: 'Uploading and managing media',
      readTime: '2 min read',
      steps: [
        'Attach photos or training clips to sessions, milestones, and health records.',
        'Inspect full-screen media inside Timeline Event Details.',
      ],
      proTip: 'Trim long videos to key reps for faster uploads and cleaner review.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'th_equipment',
      section: 'Training & Health',
      title: 'Equipment',
      subtitle: 'Managing your equipment library',
      readTime: '2 min read',
      steps: [
        'Catalogue harnesses, long lines, scent tins, balance discs, and conditioning gear.',
        'Link equipment items to sessions and track wear or replacement intervals.',
      ],
      proTip: 'Archive retired gear so historical session links stay accurate without cluttering active lists.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'th_timeline',
      section: 'Training & Health',
      title: 'Timeline',
      subtitle: 'Recording and browsing Timeline events',
      readTime: '3 min read',
      steps: [
        'Browse every logged event in chronological order with instant category colour coding.',
        'Export filtered slices or inspect frequency analytics in Timeline Insights & Statistics.',
      ],
      proTip: 'Use Timeline Search to locate vet clinics, judges, locations, or trial notes in milliseconds.',
      relatedFaqs: [],
    ),

    // TROUBLESHOOTING
    _HelpArticle(
      id: 'ts_sync',
      section: 'Troubleshooting',
      title: 'Sync Problems',
      subtitle: 'Fix issues with data not syncing',
      readTime: '4 min read',
      steps: [
        'Check network connectivity and pull to refresh to trigger manual synchronisation.',
        'Verify your account session hasn\'t expired after a password update.',
      ],
      proTip: 'Attach diagnostic logs when reporting persistent sync issues so engineers can trace queue state.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'ts_offline',
      section: 'Troubleshooting',
      title: 'Offline Mode',
      subtitle: 'Using Ulvenik without an internet connection',
      readTime: '3 min read',
      steps: [
        'Log sessions and health notes offline as normal; Ulvenik queues changes locally.',
        'Reconnect to Wi-Fi or mobile data to sync queued records automatically.',
      ],
      proTip: 'Offline entries preserve exact creation timestamps.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'ts_backup',
      section: 'Troubleshooting',
      title: 'Backup & Restore',
      subtitle: 'Back up and restore your data',
      readTime: '3 min read',
      steps: [
        'Cloud sync continuously backs up your workspace when signed in.',
        'Create manual portable archives anytime from Import / Export.',
      ],
      proTip: 'Download an annual archive snapshot for your personal offline records.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'ts_storage',
      section: 'Troubleshooting',
      title: 'Storage Issues',
      subtitle: 'Free up space on your device',
      readTime: '2 min read',
      steps: [
        'Clear cached media thumbnails without deleting cloud-stored originals.',
        'Ensure at least 500 MB of free device storage before recording video-heavy sessions.',
      ],
      proTip: 'Clearing local media cache never removes synced training or health data.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'ts_login',
      section: 'Troubleshooting',
      title: 'Login Problems',
      subtitle: 'Can\'t sign in? Start here',
      readTime: '2 min read',
      steps: [
        'Double-check whether you originally registered with Email/Password, Apple, or Google.',
        'Use Forgot Password if needed and check spam folders for verification emails.',
      ],
      proTip: 'Ensure device date & time are set to Automatic so 2FA codes validate properly.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'ts_notifications',
      section: 'Troubleshooting',
      title: 'Notifications',
      subtitle: 'Fix missing or unwanted notifications',
      readTime: '2 min read',
      steps: [
        'Confirm notifications are enabled both in Ulvenik Settings and OS system permissions.',
        'Check Focus / Do Not Disturb schedules and battery optimisation exclusions.',
      ],
      proTip: 'Customise Health Reminders separately from training streak nudges.',
      relatedFaqs: [],
    ),

    // PRIVACY & SECURITY
    _HelpArticle(
      id: 'ps_privacy',
      section: 'Privacy & Security',
      title: 'Privacy',
      subtitle: 'How Ulvenik handles your data',
      readTime: '3 min read',
      steps: [
        'Ulvenik never sells your personal data or your dogs\' records to third parties or advertisers.',
        'Your training logs, health files, and notes remain private to your workspace.',
      ],
      proTip: 'Read our full Privacy Policy under More -> Legal for complete transparency.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'ps_security',
      section: 'Privacy & Security',
      title: 'Security',
      subtitle: 'Keeping your account secure',
      readTime: '3 min read',
      steps: [
        'All traffic is encrypted in transit with TLS and protected at rest.',
        'Enable Two-Factor Authentication (2FA) for an extra layer of account protection.',
      ],
      proTip: 'Store your 2FA recovery codes in a password manager.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'ps_dataprotection',
      section: 'Privacy & Security',
      title: 'Data Protection',
      subtitle: 'Your rights and our obligations',
      readTime: '3 min read',
      steps: [
        'Exercise UK GDPR & EU GDPR rights to access, rectify, export, or erase personal data.',
        'Submit formal data protection enquiries directly to our privacy team.',
      ],
      proTip: 'Self-service export and deletion tools are built directly into your account settings.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'ps_export',
      section: 'Privacy & Security',
      title: 'Exporting Data',
      subtitle: 'Download a copy of your data',
      readTime: '2 min read',
      steps: [
        'Open More -> Import / Export or Timeline Export.',
        'Select your dog profile, date range, and preferred format (CSV, JSON, or PDF).',
      ],
      proTip: 'PDF exports are formatted cleanly for sharing with vets, coaches, or physiotherapists.',
      relatedFaqs: [],
    ),
    _HelpArticle(
      id: 'ps_delete',
      section: 'Privacy & Security',
      title: 'Deleting Your Account',
      subtitle: 'Permanently remove your account',
      readTime: '2 min read',
      steps: [
        'Export any records you wish to keep before initiating account deletion.',
        'Go to Account Settings -> Delete Account and confirm permanent erasure.',
      ],
      proTip: 'Account deletion permanently removes cloud workspaces after the safety grace window.',
      relatedFaqs: [],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  bool get _isFiltering =>
      _searchQuery.trim().isNotEmpty || _selectedCategory != 'All';

  List<_HelpArticle> _articlesForSection(String section) {
    final q = _searchQuery.trim().toLowerCase();
    return _allSectionArticles.where((a) {
      if (a.section != section) return false;
      if (_selectedCategory != 'All' && a.section != _selectedCategory) {
        return false;
      }
      if (q.isEmpty) return true;
      return a.title.toLowerCase().contains(q) ||
          a.subtitle.toLowerCase().contains(q) ||
          a.section.toLowerCase().contains(q) ||
          a.steps.any((s) => s.toLowerCase().contains(q));
    }).toList();
  }

  List<_HelpArticle> get _filteredPopularArticles {
    final q = _searchQuery.trim().toLowerCase();
    return _popularArticles.where((a) {
      if (_selectedCategory != 'All' && a.section != _selectedCategory) {
        return false;
      }
      if (q.isEmpty) return true;
      return a.title.toLowerCase().contains(q) ||
          a.subtitle.toLowerCase().contains(q) ||
          a.section.toLowerCase().contains(q);
    }).toList();
  }

  List<_FaqEntry> get _filteredFaqs {
    final q = _searchQuery.trim().toLowerCase();
    return _faqs.where((f) {
      if (_selectedCategory != 'All' && f.category != _selectedCategory) {
        return false;
      }
      if (q.isEmpty) return true;
      return f.question.toLowerCase().contains(q) ||
          f.answer.toLowerCase().contains(q) ||
          f.category.toLowerCase().contains(q);
    }).toList();
  }

  void _openContactSupport() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ContactSupportScreen()),
    );
  }

  void _openReportBug() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ReportBugScreen()),
    );
  }

  void _openFeatureRequests() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const FeatureRequestsScreen()),
    );
  }

  void _openFaqSheet() {
    String modalCategory = _selectedCategory;
    final Set<String> modalExpanded = <String>{
      ..._expandedFaqIds,
      if (_expandedFaqIds.isEmpty) _faqs.first.id,
    };

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final visibleFaqs = _faqs.where((f) {
              if (modalCategory == 'All') return true;
              return f.category == modalCategory;
            }).toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.82,
              minChildSize: 0.5,
              maxChildSize: 0.94,
              expand: false,
              builder: (_, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border(top: BorderSide(color: _cardBorder)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: _stoneGrey.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
                        child: Row(
                          children: [
                            const Icon(Icons.menu_book_outlined,
                              color: _mint,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Frequently Asked Questions',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              icon: const Icon(Icons.close_rounded,
                                color: _stoneGrey,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (_, idx) {
                            final cat = _categories[idx];
                            final active = modalCategory == cat;
                            return GestureDetector(
                              onTap: () {
                                setModalState(() => modalCategory = cat);
                                setState(() => _selectedCategory = cat);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: active ? _forest : _carbon,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: active
                                        ? _mint.withValues(alpha: 0.4)
                                        : _cardBorder,
                                  ),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    color: active ? _offWhite : _stoneGrey,
                                    fontSize: 12,
                                    fontWeight: active
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                          itemCount: visibleFaqs.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (_, idx) {
                            final faq = visibleFaqs[idx];
                            final expanded = modalExpanded.contains(faq.id);
                            return Container(
                              decoration: BoxDecoration(
                                color: _carbon,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: _cardBorder),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  setModalState(() {
                                    if (expanded) {
                                      modalExpanded.remove(faq.id);
                                      _expandedFaqIds.remove(faq.id);
                                    } else {
                                      modalExpanded.add(faq.id);
                                      _expandedFaqIds.add(faq.id);
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  faq.category.toUpperCase(),
                                                  style: const TextStyle(
                                                    color: _mint,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.8,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  faq.question,
                                                  style: const TextStyle(
                                                    color: _offWhite,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.35,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          UlvenikIcon.fromMaterial(
                                            expanded
                                                ? Icons.keyboard_arrow_up_rounded
                                                : Icons
                                                    .keyboard_arrow_down_rounded,
                                            color: _stoneGrey,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      if (expanded) ...[
                                        const SizedBox(height: 12),
                                        Container(
                                          height: 1,
                                          color: _cardBorder,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          faq.answer,
                                          style: const TextStyle(
                                            color: _stoneGrey,
                                            fontSize: 13,
                                            height: 1.5,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _openArticleReader(_HelpArticle article) {
    final Set<int> openRelatedIndices = <int>{0};

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final isBookmarked = _bookmarkedArticleIds.contains(article.id);
            final helpfulVote = _articleHelpfulVotes[article.id];

            return DraggableScrollableSheet(
              initialChildSize: 0.84,
              minChildSize: 0.55,
              maxChildSize: 0.94,
              expand: false,
              builder: (_, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border(top: BorderSide(color: _cardBorder)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _stoneGrey.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _forest.withValues(alpha: 0.28),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: _forest.withValues(alpha: 0.6),
                                ),
                              ),
                              child: Text(
                                article.section.toUpperCase(),
                                style: const TextStyle(
                                  color: _mint,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              article.readTime,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 12,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: isBookmarked
                                  ? 'Remove bookmark'
                                  : 'Save article',
                              onPressed: () {
                                setState(() {
                                  if (isBookmarked) {
                                    _bookmarkedArticleIds.remove(article.id);
                                  } else {
                                    _bookmarkedArticleIds.add(article.id);
                                  }
                                });
                                setModalState(() {});
                              },
                              icon: UlvenikIcon.fromMaterial(
                                isBookmarked
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                color: isBookmarked ? _mint : _stoneGrey,
                                size: 20,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copy article summary',
                              onPressed: () {
                                final text =
                                    '${article.title}\n${article.subtitle}\n\n${article.steps.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}';
                                Clipboard.setData(ClipboardData(text: text));
                                AppSnackbar.show(
                                  context,
                                  title: 'Copied to Clipboard',
                                  message:
                                      'Guide steps copied for quick reference.',
                                  type: SnackbarType.success,
                                );
                              },
                              icon: const Icon(Icons.copy_rounded,
                                color: _stoneGrey,
                                size: 18,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              icon: const Icon(Icons.close_rounded,
                                color: _stoneGrey,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: _cardBorder),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                          children: [
                            Text(
                              article.title,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              article.subtitle,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 14,
                                height: 1.45,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'STEP-BY-STEP GUIDE',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.1,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _carbon,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: _cardBorder),
                              ),
                              child: Column(
                                children: List.generate(article.steps.length, (i) {
                                  final isLast = i == article.steps.length - 1;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: isLast ? 0 : 14,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                _forest.withValues(alpha: 0.25),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: _forest
                                                  .withValues(alpha: 0.65),
                                            ),
                                          ),
                                          child: Text(
                                            '${i + 1}',
                                            style: const TextStyle(
                                              color: _mint,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            article.steps[i],
                                            style: const TextStyle(
                                              color: _offWhite,
                                              fontSize: 13.5,
                                              height: 1.5,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _forest.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _forest.withValues(alpha: 0.45),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.tips_and_updates_outlined,
                                    color: _mint,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      article.proTip,
                                      style: const TextStyle(
                                        color: _offWhite,
                                        fontSize: 13,
                                        height: 1.45,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (article.relatedFaqs.isNotEmpty) ...[
                              const SizedBox(height: 22),
                              const Text(
                                'COMMON QUESTIONS',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...List.generate(article.relatedFaqs.length, (idx) {
                                final qa = article.relatedFaqs[idx];
                                final open = openRelatedIndices.contains(idx);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _carbon,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: _cardBorder),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        setModalState(() {
                                          if (open) {
                                            openRelatedIndices.remove(idx);
                                          } else {
                                            openRelatedIndices.add(idx);
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    qa['q'] ?? '',
                                                    style: const TextStyle(
                                                      color: _offWhite,
                                                      fontSize: 13.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                ),
                                                UlvenikIcon.fromMaterial(
                                                  open
                                                      ? Icons
                                                          .keyboard_arrow_up_rounded
                                                      : Icons
                                                          .keyboard_arrow_down_rounded,
                                                  color: _stoneGrey,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                            if (open) ...[
                                              const SizedBox(height: 8),
                                              Text(
                                                qa['a'] ?? '',
                                                style: const TextStyle(
                                                  color: _stoneGrey,
                                                  fontSize: 13,
                                                  height: 1.45,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                            const SizedBox(height: 22),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _carbon,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: _cardBorder),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Was this article helpful?',
                                    style: TextStyle(
                                      color: _offWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _articleHelpfulVotes[article.id] =
                                                  true;
                                            });
                                            setModalState(() {});
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: helpfulVote == true
                                                  ? _forest
                                                  : _obsidian,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: helpfulVote == true
                                                    ? _mint.withValues(
                                                        alpha: 0.5,
                                                      )
                                                    : _cardBorder,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.thumb_up_alt_outlined,
                                                  size: 16,
                                                  color: helpfulVote == true
                                                      ? _offWhite
                                                      : _stoneGrey,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Yes, helpful',
                                                  style: TextStyle(
                                                    color: helpfulVote == true
                                                        ? _offWhite
                                                        : _stoneGrey,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _articleHelpfulVotes[article.id] =
                                                  false;
                                            });
                                            setModalState(() {});
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: helpfulVote == false
                                                  ? _forest.withValues(
                                                      alpha: 0.22,
                                                    )
                                                  : _obsidian,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: helpfulVote == false
                                                    ? _mint.withValues(
                                                        alpha: 0.45,
                                                      )
                                                    : _cardBorder,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.thumb_down_alt_outlined,
                                                  size: 16,
                                                  color: helpfulVote == false
                                                      ? _offWhite
                                                      : _stoneGrey,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Still need help',
                                                  style: TextStyle(
                                                    color: helpfulVote == false
                                                        ? _offWhite
                                                        : _stoneGrey,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (helpfulVote == true) ...[
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Thanks for your feedback — glad this helped!',
                                      style: TextStyle(
                                        color: _mint,
                                        fontSize: 12.5,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                  if (helpfulVote == false) ...[
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          _openContactSupport();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _forest,
                                          foregroundColor: _offWhite,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        icon: const Icon(Icons.chat_bubble_outline_rounded,
                                          size: 16,
                                        ),
                                        label: const Text(
                                          'Contact Support Directly',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final popularItems = _filteredPopularArticles;
    final gettingStartedItems = _articlesForSection('Getting Started');
    final accountItems = _articlesForSection('Account & Subscription');
    final trainingHealthItems = _articlesForSection('Training & Health');
    final troubleshootingItems = _articlesForSection('Troubleshooting');
    final privacySecurityItems = _articlesForSection('Privacy & Security');
    final matchingFaqs = _filteredFaqs;

    final hasAnyResults = popularItems.isNotEmpty ||
        gettingStartedItems.isNotEmpty ||
        accountItems.isNotEmpty ||
        trainingHealthItems.isNotEmpty ||
        troubleshootingItems.isNotEmpty ||
        privacySecurityItems.isNotEmpty ||
        (_isFiltering && matchingFaqs.isNotEmpty);

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            border: Border(bottom: BorderSide(color: _cardBorder, width: 1)),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const UlvenikIcon(UlvenikIcons.back,
                      color: _stoneGrey,
                      size: 26,
                    ),
                    splashRadius: 20,
                  ),
                  const Text(
                    'Help Centre',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        children: [
          // Search Bar
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(
                color: _offWhite,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
              cursorColor: _mint,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                prefixIcon: const UlvenikIcon(UlvenikIcons.search,
                  color: _stoneGrey,
                  size: 19,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        icon: const Icon(Icons.close_rounded,
                          color: _stoneGrey,
                          size: 18,
                        ),
                      )
                    : null,
                hintText: 'Search Help Articles',
                hintStyle: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),

          // Interactive Category Filter Chips (appear when searching or filtering)
          if (_isFiltering) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, idx) {
                  final cat = _categories[idx];
                  final selected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? _forest : _carbon,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: selected
                              ? _mint.withValues(alpha: 0.45)
                              : _cardBorder,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? _offWhite : _stoneGrey,
                          fontSize: 12,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // QUICK ACTIONS (shown in default state)
          if (_searchQuery.trim().isEmpty) ...[
            const SizedBox(height: 22),
            _buildSectionHeader('QUICK ACTIONS'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Contact Support',
                    onTap: _openContactSupport,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.bug_report_outlined,
                    label: 'Report a Bug',
                    onTap: _openReportBug,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.lightbulb_outline_rounded,
                    label: 'Feature Requests',
                    onTap: _openFeatureRequests,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.menu_book_outlined,
                    label: 'FAQs',
                    onTap: _openFaqSheet,
                  ),
                ),
              ],
            ),
          ],

          // Live Expandable FAQ Accordions when searching/filtering
          if (_isFiltering && matchingFaqs.isNotEmpty) ...[
            const SizedBox(height: 22),
            _buildSectionHeader('MATCHING FAQS'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: List.generate(matchingFaqs.length, (i) {
                  final faq = matchingFaqs[i];
                  final expanded = _expandedFaqIds.contains(faq.id);
                  final isLast = i == matchingFaqs.length - 1;
                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.vertical(
                          top: i == 0 ? const Radius.circular(16) : Radius.zero,
                          bottom: isLast
                              ? const Radius.circular(16)
                              : Radius.zero,
                        ),
                        onTap: () {
                          setState(() {
                            if (expanded) {
                              _expandedFaqIds.remove(faq.id);
                            } else {
                              _expandedFaqIds.add(faq.id);
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.help_outline_rounded,
                                    color: _stoneGrey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      faq.question,
                                      style: const TextStyle(
                                        color: _offWhite,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  UlvenikIcon.fromMaterial(
                                    expanded
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: _stoneGrey,
                                    size: 19,
                                  ),
                                ],
                              ),
                              if (expanded) ...[
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    faq.answer,
                                    style: const TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 13,
                                      height: 1.45,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (!isLast)
                        const Divider(height: 1, thickness: 1, color: _cardBorder),
                    ],
                  );
                }),
              ),
            ),
          ],

          // POPULAR
          if (popularItems.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('POPULAR'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: List.generate(popularItems.length, (i) {
                  final item = popularItems[i];
                  final isLast = i == popularItems.length - 1;
                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.vertical(
                          top: i == 0 ? const Radius.circular(16) : Radius.zero,
                          bottom: isLast
                              ? const Radius.circular(16)
                              : Radius.zero,
                        ),
                        onTap: () => _openArticleReader(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              const UlvenikIcon(UlvenikIcons.progress,
                                color: _stoneGrey,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  softWrap: false,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _forest,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'POPULAR',
                                  style: TextStyle(
                                    color: _offWhite,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const UlvenikIcon(UlvenikIcons.details,
                                color: _stoneGrey,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isLast)
                        const Divider(height: 1, thickness: 1, color: _cardBorder),
                    ],
                  );
                }),
              ),
            ),
          ],

          // GETTING STARTED
          if (gettingStartedItems.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('GETTING STARTED'),
            const SizedBox(height: 10),
            _buildArticleGroupCard(
              items: gettingStartedItems,
              leadingBuilder: () => const Icon(Icons.school_outlined,
                color: _stoneGrey,
                size: 18,
              ),
            ),
          ],

          // ACCOUNT & SUBSCRIPTION
          if (accountItems.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('ACCOUNT & SUBSCRIPTION'),
            const SizedBox(height: 10),
            _buildArticleGroupCard(
              items: accountItems,
              leadingBuilder: () => const Icon(Icons.person_outline_rounded,
                color: _stoneGrey,
                size: 18,
              ),
            ),
          ],

          // TRAINING & HEALTH
          if (trainingHealthItems.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('TRAINING & HEALTH'),
            const SizedBox(height: 10),
            _buildArticleGroupCard(
              items: trainingHealthItems,
              leadingBuilder: () => Transform.rotate(
                angle: 0.785,
                child: const UlvenikIcon(UlvenikIcons.exercises,
                  color: _stoneGrey,
                  size: 17,
                ),
              ),
            ),
          ],

          // TROUBLESHOOTING
          if (troubleshootingItems.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('TROUBLESHOOTING'),
            const SizedBox(height: 10),
            _buildArticleGroupCard(
              items: troubleshootingItems,
              leadingBuilder: () => const Icon(Icons.sync_rounded,
                color: _stoneGrey,
                size: 18,
              ),
            ),
          ],

          // PRIVACY & SECURITY
          if (privacySecurityItems.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('PRIVACY & SECURITY'),
            const SizedBox(height: 10),
            _buildArticleGroupCard(
              items: privacySecurityItems,
              leadingBuilder: () => const Icon(Icons.shield_outlined,
                color: _stoneGrey,
                size: 18,
              ),
            ),
          ],

          // Empty search fallback
          if (!hasAnyResults) ...[
            const SizedBox(height: 44),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  const Icon(Icons.search_off_rounded,
                    color: _stoneGrey,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No articles matching "${_searchQuery.trim()}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Try searching with broader keywords or reach out directly to our support team.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      height: 1.45,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _selectedCategory = 'All';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _offWhite,
                          side: const BorderSide(color: _cardBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Reset Search'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _openContactSupport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Contact Support'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 88,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UlvenikIcon.fromMaterial(icon, color: _stoneGrey, size: 20),
              Text(
                label,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleGroupCard({
    required List<_HelpArticle> items,
    required Widget Function() leadingBuilder,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: isLast ? const Radius.circular(16) : Radius.zero,
                ),
                onTap: () => _openArticleReader(item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  child: Row(
                    children: [
                      leadingBuilder(),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.subtitle,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const UlvenikIcon(UlvenikIcons.details,
                        color: _stoneGrey,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Divider(height: 1, thickness: 1, color: _cardBorder),
            ],
          );
        }),
      ),
    );
  }
}
