import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'add_client_screen.dart';
import 'client_dog_profile_screen.dart';
import 'client_notes_screen.dart';
import 'client_profile_screen.dart';
import 'clients_page_screen.dart';
import 'create_goal_screen.dart';
import 'edit_client_screen.dart';
import 'global_calendar_screen.dart';
import 'record_session_screen.dart';
import 'trainer_analytics_screen.dart';
import 'trainer_notifications_screen.dart';
import 'trainer_profile_screen.dart';
import 'trainer_workspace_settings_screen.dart';

class TrainerBusinessProfile {
  final String businessName;
  final String trainerName;
  final String tagline;
  final String credentials;
  final String email;
  final String phone;
  final String website;
  final String location;
  final String bio;
  final List<String> specialisms;
  final bool showLogoOnReports;
  final bool showCredentialsOnPortal;
  final bool allowDirectBookingRequests;

  const TrainerBusinessProfile({
    required this.businessName,
    required this.trainerName,
    required this.tagline,
    required this.credentials,
    required this.email,
    required this.phone,
    required this.website,
    required this.location,
    required this.bio,
    required this.specialisms,
    this.showLogoOnReports = true,
    this.showCredentialsOnPortal = true,
    this.allowDirectBookingRequests = true,
  });

  String get firstName {
    final trimmed = trainerName.trim();
    if (trimmed.isEmpty) return 'Trainer';
    return trimmed.split(RegExp(r'\s+')).first;
  }

  TrainerBusinessProfile copyWith({
    String? businessName,
    String? trainerName,
    String? tagline,
    String? credentials,
    String? email,
    String? phone,
    String? website,
    String? location,
    String? bio,
    List<String>? specialisms,
    bool? showLogoOnReports,
    bool? showCredentialsOnPortal,
    bool? allowDirectBookingRequests,
  }) {
    return TrainerBusinessProfile(
      businessName: businessName ?? this.businessName,
      trainerName: trainerName ?? this.trainerName,
      tagline: tagline ?? this.tagline,
      credentials: credentials ?? this.credentials,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      specialisms: specialisms ?? this.specialisms,
      showLogoOnReports: showLogoOnReports ?? this.showLogoOnReports,
      showCredentialsOnPortal:
          showCredentialsOnPortal ?? this.showCredentialsOnPortal,
      allowDirectBookingRequests:
          allowDirectBookingRequests ?? this.allowDirectBookingRequests,
    );
  }
}

class TrainerClientDog {
  final String id;
  final String name;
  final String breed;
  final String ageLabel;
  final String sexLabel;
  final String weightLabel;
  final String status;
  final String focusArea;
  final int sessionsCompleted;
  final int activeGoals;
  final int homeworkAssigned;
  final double progressRatio;
  final String medicalAlert;
  final List<double> weeklyAdherence;

  const TrainerClientDog({
    required this.id,
    required this.name,
    required this.breed,
    required this.ageLabel,
    this.sexLabel = 'Male · Intact',
    this.weightLabel = '28.4 kg',
    this.status = 'Active',
    this.focusArea = 'Obedience & Recall',
    this.sessionsCompleted = 14,
    this.activeGoals = 3,
    this.homeworkAssigned = 2,
    this.progressRatio = 0.78,
    this.medicalAlert = 'None reported',
    this.weeklyAdherence = const [0.65, 0.80, 0.72, 0.90, 0.85, 0.78, 0.92],
  });

  TrainerClientDog copyWith({
    String? name,
    String? breed,
    String? ageLabel,
    String? sexLabel,
    String? weightLabel,
    String? status,
    String? focusArea,
    int? sessionsCompleted,
    int? activeGoals,
    int? homeworkAssigned,
    double? progressRatio,
    String? medicalAlert,
    List<double>? weeklyAdherence,
  }) {
    return TrainerClientDog(
      id: id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      ageLabel: ageLabel ?? this.ageLabel,
      sexLabel: sexLabel ?? this.sexLabel,
      weightLabel: weightLabel ?? this.weightLabel,
      status: status ?? this.status,
      focusArea: focusArea ?? this.focusArea,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      activeGoals: activeGoals ?? this.activeGoals,
      homeworkAssigned: homeworkAssigned ?? this.homeworkAssigned,
      progressRatio: progressRatio ?? this.progressRatio,
      medicalAlert: medicalAlert ?? this.medicalAlert,
      weeklyAdherence: weeklyAdherence ?? this.weeklyAdherence,
    );
  }
}

class TrainerClient {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String status; // Active, Pending, Paused, Archived
  final String programme;
  final String joinedLabel;
  final String nextSessionLabel;
  final String lastActivityLabel;
  final String internalNotes;
  final bool portalConnected;
  final bool shareSessionSummaries;
  final bool shareHomeworkTasks;
  final bool canViewHealthRecords;
  final int lessonsCompleted;
  final int lessonsRemaining;
  final List<TrainerClientDog> dogs;

  const TrainerClient({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.status,
    required this.programme,
    required this.joinedLabel,
    required this.nextSessionLabel,
    required this.lastActivityLabel,
    required this.internalNotes,
    this.portalConnected = true,
    this.shareSessionSummaries = true,
    this.shareHomeworkTasks = true,
    this.canViewHealthRecords = false,
    this.lessonsCompleted = 8,
    this.lessonsRemaining = 4,
    required this.dogs,
  });

  String get firstName {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'Client';
    return trimmed.split(RegExp(r'\s+')).first;
  }

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'CL';
    if (parts.length == 1) {
      return parts.first
          .substring(0, math.min(2, parts.first.length))
          .toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get dogNamesSummary =>
      dogs.isEmpty ? 'No dogs linked' : dogs.map((d) => d.name).join(', ');

  TrainerClient copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? status,
    String? programme,
    String? joinedLabel,
    String? nextSessionLabel,
    String? lastActivityLabel,
    String? internalNotes,
    bool? portalConnected,
    bool? shareSessionSummaries,
    bool? shareHomeworkTasks,
    bool? canViewHealthRecords,
    int? lessonsCompleted,
    int? lessonsRemaining,
    List<TrainerClientDog>? dogs,
  }) {
    return TrainerClient(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      status: status ?? this.status,
      programme: programme ?? this.programme,
      joinedLabel: joinedLabel ?? this.joinedLabel,
      nextSessionLabel: nextSessionLabel ?? this.nextSessionLabel,
      lastActivityLabel: lastActivityLabel ?? this.lastActivityLabel,
      internalNotes: internalNotes ?? this.internalNotes,
      portalConnected: portalConnected ?? this.portalConnected,
      shareSessionSummaries:
          shareSessionSummaries ?? this.shareSessionSummaries,
      shareHomeworkTasks: shareHomeworkTasks ?? this.shareHomeworkTasks,
      canViewHealthRecords: canViewHealthRecords ?? this.canViewHealthRecords,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      lessonsRemaining: lessonsRemaining ?? this.lessonsRemaining,
      dogs: dogs ?? this.dogs,
    );
  }
}

class TrainerPackStore {
  TrainerPackStore._();

  static final ValueNotifier<TrainerBusinessProfile> businessNotifier =
      ValueNotifier<TrainerBusinessProfile>(
    const TrainerBusinessProfile(
      businessName: 'Take the Lead Essex',
      trainerName: 'Liv Old',
      tagline: 'Precision Working Dog & Companion Coaching',
      credentials: 'IMDT Accredited · Guild of Dog Trainers · Canine First Aid',
      email: 'liv@takethelead-essex.co.uk',
      phone: '+44 7700 900418',
      website: 'www.takethelead-essex.co.uk',
      location: 'Chelmsford, Essex, UK',
      bio:
          'Evidence-led 1-to-1 obedience, gundog foundations, and sport dog preparation across Chelmsford and wider Essex.',
      specialisms: [
        'Obedience & Recall',
        'Working Gundogs',
        'IGP Foundations',
        'Reactivity Rehab',
        'Puppy Development',
      ],
    ),
  );

  static final ValueNotifier<List<TrainerClient>> clientsNotifier =
      ValueNotifier<List<TrainerClient>>([
    const TrainerClient(
      id: 'c_emma',
      fullName: 'Emma Johnson',
      email: 'emma.johnson@outlook.com',
      phone: '+44 7712 448910',
      location: 'Chelmsford, Essex',
      status: 'Active',
      programme: '6-Week Advanced Obedience & Recall',
      joinedLabel: 'Joined Sep 2026',
      nextSessionLabel: 'Today · 09:00',
      lastActivityLabel: '1h ago',
      internalNotes:
          'Highly consistent handler. Prefers structured written homework checklists after field sessions.',
      lessonsCompleted: 11,
      lessonsRemaining: 4,
      dogs: [
        TrainerClientDog(
          id: 'd_murphy',
          name: 'Murphy',
          breed: 'Working Cocker Spaniel',
          ageLabel: '2 yrs 4 mos',
          sexLabel: 'Male · Neutered',
          weightLabel: '14.8 kg',
          status: 'Active',
          focusArea: 'Off-Lead Whistle Recall & Steadiness',
          sessionsCompleted: 18,
          activeGoals: 4,
          homeworkAssigned: 3,
          progressRatio: 0.84,
          medicalAlert: 'Sensitive to poultry treats — use venison/fish only',
          weeklyAdherence: [0.70, 0.82, 0.78, 0.92, 0.88, 0.85, 0.94],
        ),
        TrainerClientDog(
          id: 'd_bramble',
          name: 'Bramble',
          breed: 'English Springer Spaniel',
          ageLabel: '11 mos',
          sexLabel: 'Female · Intact',
          weightLabel: '15.2 kg',
          status: 'Active',
          focusArea: 'Loose-Lead Foundations',
          sessionsCompleted: 6,
          activeGoals: 2,
          homeworkAssigned: 1,
          progressRatio: 0.62,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_james',
      fullName: 'James Harlow',
      email: 'j.harlow@btinternet.com',
      phone: '+44 7845 302190',
      location: 'Brentwood, Essex',
      status: 'Active',
      programme: '1-to-1 Recall & Impulse Control',
      joinedLabel: 'Joined Oct 2026',
      nextSessionLabel: 'Today · 11:30',
      lastActivityLabel: '3h ago',
      internalNotes:
          'Emergency vet contact still needed on profile. Uploading weekly recall clips reliably.',
      lessonsCompleted: 5,
      lessonsRemaining: 3,
      dogs: [
        TrainerClientDog(
          id: 'd_bella_james',
          name: 'Bella',
          breed: 'Labrador Retriever',
          ageLabel: '1 yr 8 mos',
          sexLabel: 'Female · Spayed',
          weightLabel: '26.5 kg',
          status: 'Active',
          focusArea: 'High-Distraction Recall',
          sessionsCompleted: 9,
          activeGoals: 3,
          homeworkAssigned: 2,
          progressRatio: 0.71,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_sarah',
      fullName: 'Sarah & Bella',
      email: 'sarah.mitchell@gmail.com',
      phone: '+44 7901 662314',
      location: 'Maldon, Essex',
      status: 'Active',
      programme: 'Puppy Confidence & Socialisation',
      joinedLabel: 'Joined Nov 2026',
      nextSessionLabel: 'Thu · 14:00',
      lastActivityLabel: '1h ago',
      internalNotes:
          'Accepted client portal invitation today. Initial assessment booked for Thursday afternoon.',
      lessonsCompleted: 1,
      lessonsRemaining: 5,
      dogs: [
        TrainerClientDog(
          id: 'd_bella_sarah',
          name: 'Bella',
          breed: 'Golden Retriever',
          ageLabel: '6 mos',
          sexLabel: 'Female · Intact',
          weightLabel: '17.4 kg',
          status: 'Active',
          focusArea: 'Settling & Calm Greetings',
          sessionsCompleted: 2,
          activeGoals: 3,
          homeworkAssigned: 1,
          progressRatio: 0.45,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_oliver',
      fullName: 'Oliver Grant',
      email: 'oliver.grant@ukmail.co.uk',
      phone: '+44 7799 118420',
      location: 'Colchester, Essex',
      status: 'Active',
      programme: 'IGP Track & Heelwork Block',
      joinedLabel: 'Joined Aug 2026',
      nextSessionLabel: 'Fri · 08:30',
      lastActivityLabel: 'Yesterday',
      internalNotes: 'Preparing Rex for spring club BH-VT trial.',
      lessonsCompleted: 16,
      lessonsRemaining: 4,
      dogs: [
        TrainerClientDog(
          id: 'd_rex',
          name: 'Rex',
          breed: 'German Shepherd',
          ageLabel: '3 yrs 1 mo',
          weightLabel: '34.0 kg',
          focusArea: 'IGP Heelwork & Article Indication',
          progressRatio: 0.89,
        ),
        TrainerClientDog(
          id: 'd_kaia',
          name: 'Kaia',
          breed: 'Belgian Malinois',
          ageLabel: '1 yr 5 mos',
          sexLabel: 'Female · Intact',
          weightLabel: '25.1 kg',
          focusArea: 'Engagement & Grip Development',
          progressRatio: 0.76,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_hannah',
      fullName: 'Hannah Brooks',
      email: 'hannah.brooks@icloud.com',
      phone: '+44 7732 554098',
      location: 'Billericay, Essex',
      status: 'Active',
      programme: 'Reactivity Decompression Plan',
      joinedLabel: 'Joined Jul 2026',
      nextSessionLabel: 'Sat · 10:00',
      lastActivityLabel: '2d ago',
      internalNotes: 'Great threshold progress around joggers.',
      dogs: [
        TrainerClientDog(
          id: 'd_archie',
          name: 'Archie',
          breed: 'Border Collie',
          ageLabel: '2 yrs 9 mos',
          weightLabel: '19.6 kg',
          focusArea: 'Neutrality Around Dogs',
          progressRatio: 0.74,
        ),
        TrainerClientDog(
          id: 'd_pip',
          name: 'Pip',
          breed: 'Border Terrier',
          ageLabel: '5 yrs',
          weightLabel: '8.9 kg',
          focusArea: 'Recall Around Wildlife',
          progressRatio: 0.81,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_daniel',
      fullName: 'Daniel Mercer',
      email: 'dmercer@mercerconsulting.co.uk',
      phone: '+44 7811 290844',
      location: 'Shenfield, Essex',
      status: 'Active',
      programme: 'Gundog Whistle & Retrieve',
      joinedLabel: 'Joined Jun 2026',
      nextSessionLabel: 'Mon · 09:30',
      lastActivityLabel: '2d ago',
      internalNotes: 'Stop whistle crisp at 40 metres.',
      dogs: [
        TrainerClientDog(
          id: 'd_tarka',
          name: 'Tarka',
          breed: 'Labrador Retriever',
          ageLabel: '3 yrs',
          weightLabel: '29.0 kg',
          focusArea: 'Blind Retrieves & Directional Casts',
          progressRatio: 0.88,
        ),
        TrainerClientDog(
          id: 'd_wren',
          name: 'Wren',
          breed: 'Working Cocker Spaniel',
          ageLabel: '1 yr 2 mos',
          sexLabel: 'Female · Intact',
          weightLabel: '12.7 kg',
          focusArea: 'Quartering Pattern',
          progressRatio: 0.67,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_chloe',
      fullName: 'Chloe Bennett',
      email: 'chloe.b@gmail.com',
      phone: '+44 7766 809123',
      location: 'Witham, Essex',
      status: 'Active',
      programme: 'Adolescent Focus Package',
      joinedLabel: 'Joined Oct 2026',
      nextSessionLabel: 'Tue · 16:00',
      lastActivityLabel: '3d ago',
      internalNotes: 'Working on doorway manners and calm car exits.',
      dogs: [
        TrainerClientDog(
          id: 'd_milo_c',
          name: 'Milo',
          breed: 'Vizsla',
          ageLabel: '14 mos',
          weightLabel: '24.2 kg',
          focusArea: 'Impulse Control & Settle',
          progressRatio: 0.64,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_marcus',
      fullName: 'Marcus Reid',
      email: 'marcus.reid@proton.me',
      phone: '+44 7922 340911',
      location: 'Braintree, Essex',
      status: 'Active',
      programme: 'Urban Heelwork & Public Access',
      joinedLabel: 'Joined Sep 2026',
      nextSessionLabel: 'Wed · 11:00',
      lastActivityLabel: '4d ago',
      internalNotes: 'Cafe settle homework 100% completed.',
      dogs: [
        TrainerClientDog(
          id: 'd_odin',
          name: 'Odin',
          breed: 'Dobermann',
          ageLabel: '2 yrs 2 mos',
          weightLabel: '36.5 kg',
          focusArea: 'Town Centre Neutrality',
          progressRatio: 0.79,
        ),
        TrainerClientDog(
          id: 'd_freya',
          name: 'Freya',
          breed: 'Dobermann',
          ageLabel: '4 yrs',
          sexLabel: 'Female · Spayed',
          weightLabel: '31.2 kg',
          focusArea: 'Distance Down-Stay',
          progressRatio: 0.91,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_lucy',
      fullName: 'Lucy Pembroke',
      email: 'lucy.pembroke@yahoo.co.uk',
      phone: '+44 7708 991204',
      location: 'Danbury, Essex',
      status: 'Active',
      programme: 'Agility Handling & Contacts',
      joinedLabel: 'Joined May 2026',
      nextSessionLabel: 'Thu · 17:30',
      lastActivityLabel: '4d ago',
      internalNotes: '2-on-2-off contact behaviour solid.',
      dogs: [
        TrainerClientDog(
          id: 'd_ziggy',
          name: 'Ziggy',
          breed: 'Shetland Sheepdog',
          ageLabel: '3 yrs 6 mos',
          weightLabel: '9.4 kg',
          focusArea: 'Weave Pole Entries',
          progressRatio: 0.86,
        ),
        TrainerClientDog(
          id: 'd_nova',
          name: 'Nova',
          breed: 'Border Collie',
          ageLabel: '1 yr 9 mos',
          sexLabel: 'Female · Intact',
          weightLabel: '16.8 kg',
          focusArea: 'Running Dogwalk Prep',
          progressRatio: 0.73,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_sam',
      fullName: 'Sam Whitaker',
      email: 'sam.whitaker@outlook.com',
      phone: '+44 7854 712039',
      location: 'Ingatestone, Essex',
      status: 'Active',
      programme: 'Scentwork & Mantrailing',
      joinedLabel: 'Joined Aug 2026',
      nextSessionLabel: 'Sat · 13:00',
      lastActivityLabel: '5d ago',
      internalNotes: 'Passive indication on clove & gun oil clean.',
      dogs: [
        TrainerClientDog(
          id: 'd_barney',
          name: 'Barney',
          breed: 'Basset Fauve de Bretagne',
          ageLabel: '4 yrs 1 mo',
          weightLabel: '16.5 kg',
          focusArea: 'Vehicle Exterior Searches',
          progressRatio: 0.82,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_priya',
      fullName: 'Priya Nair',
      email: 'priya.nair@nhs.net',
      phone: '+44 7740 618290',
      location: 'Chelmsford, Essex',
      status: 'Active',
      programme: 'Confidence & Vet Handling',
      joinedLabel: 'Joined Sep 2026',
      nextSessionLabel: 'Sun · 10:30',
      lastActivityLabel: '5d ago',
      internalNotes: 'Chin-rest cooperative care progressing well.',
      dogs: [
        TrainerClientDog(
          id: 'd_kobi',
          name: 'Kobi',
          breed: 'Australian Shepherd',
          ageLabel: '2 yrs',
          weightLabel: '22.8 kg',
          focusArea: 'Cooperative Muzzle & Grooming',
          progressRatio: 0.77,
        ),
        TrainerClientDog(
          id: 'd_ruki',
          name: 'Ruki',
          breed: 'Miniature Poodle',
          ageLabel: '5 yrs',
          sexLabel: 'Female · Spayed',
          weightLabel: '7.6 kg',
          focusArea: 'Confidence on Surfaces',
          progressRatio: 0.85,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_tom',
      fullName: 'Tom Aldridge',
      email: 'tom.aldridge@gmail.com',
      phone: '+44 7988 450122',
      location: 'writtle, Essex',
      status: 'Active',
      programme: 'Working Retriever Prep',
      joinedLabel: 'Joined Apr 2026',
      nextSessionLabel: 'Next Tue · 08:00',
      lastActivityLabel: '6d ago',
      internalNotes: 'Water entries and cold game delivery steady.',
      dogs: [
        TrainerClientDog(
          id: 'd_moss',
          name: 'Moss',
          breed: 'Labrador Retriever',
          ageLabel: '3 yrs 8 mos',
          weightLabel: '30.5 kg',
          focusArea: 'Water Work & Steadiness',
          progressRatio: 0.92,
        ),
        TrainerClientDog(
          id: 'd_fern',
          name: 'Fern',
          breed: 'Flatcoated Retriever',
          ageLabel: '2 yrs 1 mo',
          sexLabel: 'Female · Intact',
          weightLabel: '27.4 kg',
          focusArea: 'Memory Retrieves',
          progressRatio: 0.80,
        ),
        TrainerClientDog(
          id: 'd_reed',
          name: 'Reed',
          breed: 'Labrador Retriever',
          ageLabel: '9 mos',
          weightLabel: '23.0 kg',
          focusArea: 'Placeboard Foundations',
          progressRatio: 0.58,
        ),
      ],
    ),
    const TrainerClient(
      id: 'c_nina_paused',
      fullName: 'Nina Kowalski',
      email: 'nina.k@gmail.com',
      phone: '+44 7719 882310',
      location: 'South Woodham Ferrers',
      status: 'Paused',
      programme: 'Post-Op Hydro & Calm Enrichment',
      joinedLabel: 'Joined Mar 2026',
      nextSessionLabel: 'Paused until Dec',
      lastActivityLabel: '2w ago',
      portalConnected: false,
      internalNotes: 'Temporarily paused for 4 weeks post-TPLO clearance.',
      dogs: [
        TrainerClientDog(
          id: 'd_loki',
          name: 'Loki',
          breed: 'Weimaraner',
          ageLabel: '4 yrs',
          status: 'Paused',
          focusArea: 'Scent Enrichment & Crate Calm',
          progressRatio: 0.69,
        ),
      ],
    ),
  ]);

  static int get activeClientCount =>
      clientsNotifier.value.where((c) => c.status == 'Active').length;

  static int get activeDogCount => clientsNotifier.value
      .where((c) => c.status == 'Active')
      .fold<int>(0, (sum, c) => sum + c.dogs.length);

  static TrainerClient findClient(String? clientId) {
    final list = clientsNotifier.value;
    if (clientId != null) {
      for (final c in list) {
        if (c.id == clientId) return c;
      }
    }
    return list.first;
  }

  static (TrainerClient, TrainerClientDog) findClientAndDog({
    String? clientId,
    String? dogId,
  }) {
    final list = clientsNotifier.value;
    if (dogId != null) {
      for (final c in list) {
        for (final d in c.dogs) {
          if (d.id == dogId) return (c, d);
        }
      }
    }
    final client = findClient(clientId);
    final dog = client.dogs.isNotEmpty
        ? client.dogs.first
        : const TrainerClientDog(
            id: 'd_default',
            name: 'Murphy',
            breed: 'Working Cocker Spaniel',
            ageLabel: '2 yrs 4 mos',
          );
    return (client, dog);
  }

  static void addClient(TrainerClient client) {
    clientsNotifier.value = [client, ...clientsNotifier.value];
  }

  static void updateClient(TrainerClient updated) {
    clientsNotifier.value = [
      for (final existing in clientsNotifier.value)
        if (existing.id == updated.id) updated else existing,
    ];
  }

  static void removeClient(String clientId) {
    clientsNotifier.value =
        clientsNotifier.value.where((c) => c.id != clientId).toList();
  }

  static void updateBusiness(TrainerBusinessProfile updated) {
    businessNotifier.value = updated;
  }
}

class _AttentionItem {
  final String id;
  final String title;
  final String subtitle;
  final String timeAgo;
  final Color dotColor;
  final IconData icon;
  final String clientId;
  final String? dogId;
  final bool opensEditClient;
  bool resolved = false;

  _AttentionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.dotColor,
    required this.icon,
    required this.clientId,
    this.dogId,
    this.opensEditClient = false,
  });
}

class _ScheduleLesson {
  final String id;
  final String time;
  final String clientDogTitle;
  final String sessionType;
  final String locationLabel;
  final bool hasLocationPin;
  final String clientId;
  final String dogId;
  String status; // CONFIRMED, UPCOMING, COMPLETED

  _ScheduleLesson({
    required this.id,
    required this.time,
    required this.clientDogTitle,
    required this.sessionType,
    required this.locationLabel,
    required this.hasLocationPin,
    required this.clientId,
    required this.dogId,
    required this.status,
  });
}

class _RecentActivityEntry {
  final String id;
  final String text;
  final String dogName;
  final String timeAgo;
  final bool hasPersonalBestStar;
  final String clientId;
  final String dogId;

  const _RecentActivityEntry({
    required this.id,
    required this.text,
    required this.dogName,
    required this.timeAgo,
    this.hasPersonalBestStar = false,
    required this.clientId,
    required this.dogId,
  });
}

class TrainerDashboardScreen extends StatefulWidget {
  const TrainerDashboardScreen({super.key});

  @override
  State<TrainerDashboardScreen> createState() => _TrainerDashboardScreenState();
}

class _TrainerDashboardScreenState extends State<TrainerDashboardScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _cardBg = AppColors.cardsCarbon; // #1A1F22
  static const Color _tileBg = Color(0xFF212629);
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _mintBright = Color(0xFFB1F0D6);
  static const Color _sage = Color(0xFFB6CCB5);
  static const Color _alpineBlue = AppColors.infoAlpineBlue; // #5D8FAF
  static const Color _textPrimary = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _textSecondary = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _border = AppColors.cardBorder; // rgba(255,255,255,0.08)

  late final AnimationController _animController;
  late final Animation<double> _curvedAnim;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  bool _hasUnreadNotifications = true;
  int _hwAssignedCount = 14;
  int _selectedDayIndex = 3; // Default highlights Thursday ('T') per Figma

  static const List<String> _dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const List<String> _dayFullNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const List<int> _weeklyLessonsByDay = [1, 2, 1, 2, 1, 1, 0];
  static const List<double> _weeklyBarHeights = [
    0.42,
    0.72,
    0.58,
    0.78,
    0.74,
    0.34,
    0.14,
  ];

  late final List<_AttentionItem> _attentionItems = [
    _AttentionItem(
      id: 'att_hw',
      title: '3 Homework Assignments Pending Review',
      subtitle: 'Murphy · Emma Johnson',
      timeAgo: '2 hours ago',
      dotColor: _forest,
      icon: Icons.assignment_outlined,
      clientId: 'c_emma',
      dogId: 'd_murphy',
    ),
    _AttentionItem(
      id: 'att_inc',
      title: 'Incomplete client profile',
      subtitle: 'James Harlow',
      timeAgo: 'Yesterday',
      dotColor: _sage,
      icon: Icons.person_outline_rounded,
      clientId: 'c_james',
      dogId: 'd_bella_james',
      opensEditClient: true,
    ),
    _AttentionItem(
      id: 'att_inv',
      title: 'New client invitation accepted',
      subtitle: 'Sarah & Bella',
      timeAgo: '1 hour ago',
      dotColor: _forest,
      icon: Icons.check_circle_outline_rounded,
      clientId: 'c_sarah',
      dogId: 'd_bella_sarah',
    ),
  ];

  late final List<_ScheduleLesson> _todaySchedule = [
    _ScheduleLesson(
      id: 'sch_1',
      time: '09:00',
      clientDogTitle: 'Emma · Murphy',
      sessionType: 'Obedience Session',
      locationLabel: 'Chelmsford Training Ground',
      hasLocationPin: true,
      clientId: 'c_emma',
      dogId: 'd_murphy',
      status: 'CONFIRMED',
    ),
    _ScheduleLesson(
      id: 'sch_2',
      time: '11:30',
      clientDogTitle: 'James · Bella',
      sessionType: 'Recall Session',
      locationLabel: 'Private Session',
      hasLocationPin: false,
      clientId: 'c_james',
      dogId: 'd_bella_james',
      status: 'UPCOMING',
    ),
  ];

  late final List<_RecentActivityEntry> _recentActivity = [
    const _RecentActivityEntry(
      id: 'act_1',
      text: 'Emma completed Recall Homework',
      dogName: 'Murphy',
      timeAgo: '1h ago',
      clientId: 'c_emma',
      dogId: 'd_murphy',
    ),
    const _RecentActivityEntry(
      id: 'act_2',
      text: 'James uploaded a training video',
      dogName: 'Bella',
      timeAgo: '3h ago',
      clientId: 'c_james',
      dogId: 'd_bella_james',
    ),
    const _RecentActivityEntry(
      id: 'act_3',
      text: 'Murphy achieved a Personal Best',
      dogName: 'Murphy',
      timeAgo: 'Yesterday',
      hasPersonalBestStar: true,
      clientId: 'c_emma',
      dogId: 'd_murphy',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _curvedAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int get _pendingReviewsCount =>
      _attentionItems.where((item) => !item.resolved).length;

  void _openWorkspaceSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TrainerWorkspaceSettingsScreen(),
      ),
    );
  }

  void _openTrainerAnalytics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TrainerAnalyticsScreen(),
      ),
    );
  }

  void _openTrainerNotifications() {
    setState(() => _hasUnreadNotifications = false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TrainerNotificationsScreen(),
      ),
    );
  }

  void _openTrainerProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TrainerProfileScreen(),
      ),
    );
  }

  void _openClientsPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ClientsPageScreen(),
      ),
    );
  }

  Future<void> _openAddClient() async {
    final added = await Navigator.of(context).push<TrainerClient>(
      MaterialPageRoute(
        builder: (_) => const AddClientScreen(),
      ),
    );
    if (!mounted || added == null) return;
    setState(() {});
    AppSnackbar.show(
      context,
      title: 'Client Added',
      message: '${added.fullName} is now live in your Trainer Pack.',
      type: SnackbarType.success,
    );
  }

  void _openClientNotes() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ClientNotesScreen(),
      ),
    );
  }

  void _openClientProfile(String clientId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientProfileScreen(clientId: clientId),
      ),
    );
  }

  void _openClientDogProfile(String clientId, String dogId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientDogProfileScreen(
          clientId: clientId,
          dogId: dogId,
        ),
      ),
    );
  }

  void _handleAttentionTap(_AttentionItem item) {
    if (item.opensEditClient) {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (_) => EditClientScreen(clientId: item.clientId),
        ),
      )
          .then((_) {
        if (mounted) setState(() {});
      });
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.subtitle} · ${item.timeAgo}',
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _openClientProfile(item.clientId);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textPrimary,
                          side: const BorderSide(color: _border),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const UlvenikIcon(UlvenikIcons.overflowMenu, size: 17),
                        label: const Text('Client Profile'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (item.dogId != null) {
                            _openClientDogProfile(item.clientId, item.dogId!);
                          } else {
                            _openClientNotes();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _mintBright,
                          side: BorderSide(color: _forest.withValues(alpha: 0.7)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const UlvenikIcon(UlvenikIcons.dogs, size: 17),
                        label: const Text('Dog Profile'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _openClientNotes();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textSecondary,
                          side: const BorderSide(color: _border),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const UlvenikIcon(UlvenikIcons.training, size: 17),
                        label: const Text('Client Notes'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() => item.resolved = !item.resolved);
                          AppSnackbar.show(
                            context,
                            title: item.resolved
                                ? 'Marked Reviewed'
                                : 'Reopened Item',
                            message: item.resolved
                                ? 'Pending review count updated.'
                                : '${item.title} moved back to pending.',
                            type: SnackbarType.success,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _textPrimary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: UlvenikIcon.fromMaterial(
                          item.resolved
                              ? Icons.replay_rounded
                              : Icons.check_rounded,
                          size: 17,
                        ),
                        label: Text(
                          item.resolved ? 'Reopen' : 'Mark Reviewed',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLessonActionSheet(_ScheduleLesson lesson) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      lesson.time,
                      style: const TextStyle(
                        color: _mintBright,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lesson.clientDogTitle,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    _buildScheduleStatusPill(lesson.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${lesson.sessionType} · ${lesson.locationLabel}',
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RecordSessionScreen(
                            initialActivityName: lesson.sessionType,
                            initialCategory: 'Obedience',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _textPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const UlvenikIcon(UlvenikIcons.play, size: 20),
                    label: const Text(
                      'Record Session',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _openClientProfile(lesson.clientId);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textPrimary,
                          side: const BorderSide(color: _border),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Client Profile'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _openClientDogProfile(lesson.clientId, lesson.dogId);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textPrimary,
                          side: const BorderSide(color: _border),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Dog Profile'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            lesson.status = lesson.status == 'CONFIRMED'
                                ? 'COMPLETED'
                                : 'CONFIRMED';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _mintBright,
                          side: BorderSide(color: _forest.withValues(alpha: 0.7)),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          lesson.status == 'CONFIRMED' ? 'Complete' : 'Confirm',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStartLessonPicker() {
    final activeClients = TrainerPackStore.clientsNotifier.value
        .where((c) => c.status == 'Active')
        .take(5)
        .toList();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Record Client Session',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Select a client & dog to begin live session recording',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 14),
                ...activeClients.map((client) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RecordSessionScreen(
                            initialActivityName:
                                '${client.firstName} · ${client.dogNamesSummary}',
                            initialCategory: 'Obedience',
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: _forest.withValues(alpha: 0.22),
                      child: Text(
                        client.initials,
                        style: const TextStyle(
                          color: _mintBright,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: Text(
                      client.fullName,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${client.dogNamesSummary} · ${client.programme}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: const UlvenikIcon(UlvenikIcons.play,
                      color: _mintBright,
                      size: 20,
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAssignTaskSheet() {
    final taskCtrl = TextEditingController();
    final clients = TrainerPackStore.clientsNotifier.value;
    TrainerClient selectedClient = clients.first;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 22,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Assign Homework Task',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: selectedClient.id,
                    dropdownColor: _tileBg,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Client & Dog',
                      labelStyle: const TextStyle(color: _textSecondary),
                      filled: true,
                      fillColor: _tileBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _border),
                      ),
                    ),
                    items: clients.take(6).map((c) {
                      return DropdownMenuItem<String>(
                        value: c.id,
                        child: Text('${c.fullName} (${c.dogNamesSummary})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      setModalState(() {
                        selectedClient = TrainerPackStore.findClient(val);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: taskCtrl,
                    style: const TextStyle(color: _textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'e.g. 3× 5-minute long-line whistle recalls',
                      hintStyle: const TextStyle(color: _textSecondary),
                      filled: true,
                      fillColor: _tileBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final title = taskCtrl.text.trim().isEmpty
                            ? 'Whistle Recall Homework'
                            : taskCtrl.text.trim();
                        final dog = selectedClient.dogs.isNotEmpty
                            ? selectedClient.dogs.first
                            : const TrainerClientDog(
                                id: 'd_murphy',
                                name: 'Murphy',
                                breed: 'Working Cocker Spaniel',
                                ageLabel: '2 yrs',
                              );
                        Navigator.pop(ctx);
                        setState(() {
                          _hwAssignedCount += 1;
                          _recentActivity.insert(
                            0,
                            _RecentActivityEntry(
                              id: 'act_${DateTime.now().millisecondsSinceEpoch}',
                              text:
                                  'Assigned "$title" to ${selectedClient.firstName}',
                              dogName: dog.name,
                              timeAgo: 'Just now',
                              clientId: selectedClient.id,
                              dogId: dog.id,
                            ),
                          );
                        });
                        AppSnackbar.show(
                          context,
                          title: 'Task Assigned',
                          message:
                              'Sent "$title" to ${selectedClient.fullName}.',
                          type: SnackbarType.success,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Send Homework to Client',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAllActivitySheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Client Activity',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openClientNotes();
                      },
                      child: const Text(
                        'Client Notes →',
                        style: TextStyle(
                          color: _mintBright,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._recentActivity.map((entry) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(ctx);
                      _openClientDogProfile(entry.clientId, entry.dogId);
                    },
                    title: Text(
                      entry.text,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      '${entry.dogName} · ${entry.timeAgo}',
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: const UlvenikIcon(UlvenikIcons.details,
                      color: _textSecondary,
                      size: 18,
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      body: SafeArea(
        child: ValueListenableBuilder<TrainerBusinessProfile>(
          valueListenable: TrainerPackStore.businessNotifier,
          builder: (context, business, _) {
            return ValueListenableBuilder<List<TrainerClient>>(
              valueListenable: TrainerPackStore.clientsNotifier,
              builder: (context, clients, _) {
                final activeClients =
                    clients.where((c) => c.status == 'Active').length;
                final activeDogs = clients
                    .where((c) => c.status == 'Active')
                    .fold<int>(0, (s, c) => s + c.dogs.length);

                return AnimatedBuilder(
                  animation: _curvedAnim,
                  builder: (context, _) {
                    return Column(
                      children: [
                        _buildAppBar(canPop),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeroCard(
                                  business: business,
                                  activeClients: activeClients,
                                  activeDogs: activeDogs,
                                ),
                                const SizedBox(height: 18),
                                _buildInlineSearchBar(),
                                if (_searchQuery.trim().isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  _buildLiveSearchMatches(clients),
                                ],
                                const SizedBox(height: 22),
                                _buildAttentionRequiredSection(),
                                const SizedBox(height: 22),
                                _buildTodaysScheduleSection(),
                                const SizedBox(height: 22),
                                _buildQuickActionsSection(),
                                const SizedBox(height: 22),
                                _buildRecentActivitySection(),
                                const SizedBox(height: 22),
                                _buildBusinessSnapshotSection(
                                  activeClients: activeClients,
                                  activeDogs: activeDogs,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(bool canPop) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(
          bottom: BorderSide(color: _border, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (canPop) ...[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: UlvenikIcon(UlvenikIcons.back,
                  color: _textPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
          const Expanded(
            child: Text(
              'Trainer Dashboard',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                fontFamily: 'Inter',
              ),
            ),
          ),
          IconButton(
            tooltip: 'Search workspace',
            visualDensity: VisualDensity.compact,
            onPressed: () {
              _searchFocusNode.requestFocus();
            },
            icon: const UlvenikIcon(UlvenikIcons.search,
                color: _textSecondary, size: 22),
          ),
          IconButton(
            tooltip: 'Analytics',
            visualDensity: VisualDensity.compact,
            onPressed: _openTrainerAnalytics,
            icon: const UlvenikIcon(UlvenikIcons.progress,
              color: _textSecondary,
              size: 21,
            ),
          ),
          IconButton(
            tooltip: 'Notifications',
            visualDensity: VisualDensity.compact,
            onPressed: _openTrainerNotifications,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const UlvenikIcon(UlvenikIcons.notifications,
                  color: _textSecondary,
                  size: 22,
                ),
                if (_hasUnreadNotifications)
                  Positioned(
                    right: 1,
                    top: 1,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: _forest,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Workspace Settings',
            visualDensity: VisualDensity.compact,
            onPressed: _openWorkspaceSettings,
            icon: const UlvenikIcon(UlvenikIcons.sort,
              color: _textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard({
    required TrainerBusinessProfile business,
    required int activeClients,
    required int activeDogs,
  }) {
    final p = _curvedAnim.value;
    final lessonsToday = (4 * p).round();
    final animClients = (activeClients * p).round();
    final animDogs = (activeDogs * p).round();
    final animReviews = (_pendingReviewsCount * p).round();

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _openTrainerProfile,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF15191C),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _forest.withValues(alpha: 0.85),
                            width: 1.2,
                          ),
                        ),
                        child: const UlvenikIcon(UlvenikIcons.overflowMenu,
                          color: _textSecondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              business.businessName,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              business.trainerName,
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 7),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3.5,
                              ),
                              decoration: BoxDecoration(
                                color: _forest.withValues(alpha: 0.20),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: _forest.withValues(alpha: 0.85),
                                ),
                              ),
                              child: const Text(
                                'TRAINER PACK',
                                style: TextStyle(
                                  color: _mintBright,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.65,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const UlvenikIcon(UlvenikIcons.details,
                        color: _textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Good morning, ${business.firstName}',
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: _border, height: 1),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildHeroMetricCell(
                    value: '$lessonsToday',
                    label: 'SESSIONS TODAY',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const GlobalCalendarScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const VerticalDivider(color: _border, width: 1),
                Expanded(
                  child: _buildHeroMetricCell(
                    value: '$animClients',
                    label: 'ACTIVE CLIENTS',
                    onTap: _openClientsPage,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: _border, height: 1),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildHeroMetricCell(
                    value: '$animDogs',
                    label: 'CLIENT DOGS',
                    onTap: _openClientsPage,
                  ),
                ),
                const VerticalDivider(color: _border, width: 1),
                Expanded(
                  child: _buildHeroMetricCell(
                    value: '$animReviews',
                    label: 'REVIEWS PENDING',
                    onTap: () {
                      if (_attentionItems.isNotEmpty) {
                        _handleAttentionTap(_attentionItems.first);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMetricCell({
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.55,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineSearchBar() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _border, width: 1),
        ),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.search, color: _textSecondary, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: 'Search clients, dogs, records...',
                hintStyle: TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
                _searchFocusNode.unfocus();
              },
              child: const UlvenikIcon(UlvenikIcons.back,
                color: _textSecondary,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLiveSearchMatches(List<TrainerClient> clients) {
    final q = _searchQuery.trim().toLowerCase();
    final matches = clients.where((c) {
      return c.fullName.toLowerCase().contains(q) ||
          c.programme.toLowerCase().contains(q) ||
          c.dogs.any((d) =>
              d.name.toLowerCase().contains(q) ||
              d.breed.toLowerCase().contains(q));
    }).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _forest.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CLIENT & DOG MATCHES (${matches.length})',
                style: const TextStyle(
                  color: _mintBright,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  fontFamily: 'Inter',
                ),
              ),
              GestureDetector(
                onTap: _openClientsPage,
                child: const Text(
                  'All Clients →',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (matches.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'No matching clients or dogs found.',
                style: TextStyle(color: _textSecondary, fontSize: 13),
              ),
            )
          else
            ...matches.take(4).map((client) {
              return InkWell(
                onTap: () => _openClientProfile(client.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: _forest.withValues(alpha: 0.2),
                        child: Text(
                          client.initials,
                          style: const TextStyle(
                            color: _mintBright,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              client.fullName,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${client.dogNamesSummary} · ${client.location}',
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const UlvenikIcon(UlvenikIcons.details,
                        color: _textSecondary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: _textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildAttentionRequiredSection() {
    final q = _searchQuery.trim().toLowerCase();
    final filtered = _attentionItems.where((item) {
      if (q.isEmpty) return true;
      return item.title.toLowerCase().contains(q) ||
          item.subtitle.toLowerCase().contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('ATTENTION REQUIRED'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: filtered.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No attention items match your search.',
                    style: TextStyle(color: _textSecondary, fontSize: 13),
                  ),
                )
              : Column(
                  children: List.generate(filtered.length, (i) {
                    final item = filtered[i];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () => _handleAttentionTap(item),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 15,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: item.resolved
                                        ? _textSecondary.withValues(alpha: 0.35)
                                        : item.dotColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                UlvenikIcon.fromMaterial(
                                  item.icon,
                                  color: _textSecondary,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: item.resolved
                                              ? _textSecondary
                                              : _textPrimary,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          decoration: item.resolved
                                              ? TextDecoration.lineThrough
                                              : null,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        item.subtitle,
                                        style: const TextStyle(
                                          color: _textSecondary,
                                          fontSize: 12.5,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.timeAgo,
                                  style: const TextStyle(
                                    color: _textSecondary,
                                    fontSize: 11.5,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const UlvenikIcon(UlvenikIcons.details,
                                  color: _textSecondary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (i < filtered.length - 1)
                          const Divider(color: _border, height: 1),
                      ],
                    );
                  }),
                ),
        ),
      ],
    );
  }

  Widget _buildTodaysScheduleSection() {
    final q = _searchQuery.trim().toLowerCase();
    final filtered = _todaySchedule.where((s) {
      if (q.isEmpty) return true;
      return s.clientDogTitle.toLowerCase().contains(q) ||
          s.sessionType.toLowerCase().contains(q) ||
          s.locationLabel.toLowerCase().contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("TODAY'S SCHEDULE"),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              ...List.generate(filtered.length, (i) {
                final lesson = filtered[i];
                return Column(
                  children: [
                    InkWell(
                      onTap: () => _showLessonActionSheet(lesson),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 52,
                              child: Text(
                                lesson.time,
                                style: const TextStyle(
                                  color: _textPrimary,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lesson.clientDogTitle,
                                    style: const TextStyle(
                                      color: _textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    lesson.sessionType,
                                    style: const TextStyle(
                                      color: _textSecondary,
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      if (lesson.hasLocationPin) ...[
                                        const UlvenikIcon(UlvenikIcons.timeline,
                                          color: _textSecondary,
                                          size: 13.5,
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                      Expanded(
                                        child: Text(
                                          lesson.locationLabel,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: _textSecondary,
                                            fontSize: 12.5,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildScheduleStatusPill(lesson.status),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: _border, height: 1),
                  ],
                );
              }),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const GlobalCalendarScreen(),
                    ),
                  );
                },
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 13, 16, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'View Full Calendar',
                        style: TextStyle(
                          color: _mintBright,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(width: 5),
                      UlvenikIcon(UlvenikIcons.details,
                        color: _mintBright,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleStatusPill(String status) {
    final isConfirmed = status == 'CONFIRMED' || status == 'COMPLETED';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isConfirmed
            ? _forest.withValues(alpha: 0.22)
            : const Color(0xFF252B2E),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isConfirmed
              ? _forest.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.14),
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isConfirmed ? _mintBright : _sage,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('QUICK ACTIONS'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionTile(
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'Add Client',
                      onTap: _openAddClient,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickActionTile(
                      icon: Icons.play_circle_outline_rounded,
                      label: 'Record Session',
                      onTap: _showStartLessonPicker,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickActionTile(
                      icon: Icons.assignment_outlined,
                      label: 'Assign Task',
                      onTap: _showAssignTaskSheet,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionTile(
                      icon: Icons.fitness_center_rounded,
                      rotateIcon: true,
                      label: 'Record\nSession',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RecordSessionScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickActionTile(
                      icon: Icons.outlined_flag_rounded,
                      label: 'Create Goal',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CreateGoalScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickActionTile(
                      icon: Icons.calendar_today_outlined,
                      label: 'Open\nCalendar',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const GlobalCalendarScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool rotateIcon = false,
  }) {
    final iconWidget = UlvenikIcon.fromMaterial(icon, color: _sage, size: 20);
    return Material(
      color: _tileBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 82,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              rotateIcon
                  ? Transform.rotate(angle: -math.pi / 4, child: iconWidget)
                  : iconWidget,
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    final q = _searchQuery.trim().toLowerCase();
    final filtered = _recentActivity.where((a) {
      if (q.isEmpty) return true;
      return a.text.toLowerCase().contains(q) ||
          a.dogName.toLowerCase().contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('RECENT ACTIVITY'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Column(
                  children: List.generate(
                    math.min(3, filtered.length),
                    (i) {
                      final entry = filtered[i];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: i == math.min(3, filtered.length) - 1 ? 0 : 14,
                        ),
                        child: InkWell(
                          onTap: () =>
                              _openClientDogProfile(entry.clientId, entry.dogId),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _tileBg,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.07),
                                  ),
                                ),
                                child: Text(
                                  entry.dogName,
                                  style: const TextStyle(
                                    color: _textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              if (entry.hasPersonalBestStar) ...[
                                const SizedBox(width: 6),
                                const UlvenikIcon(UlvenikIcons.goals,
                                  color: _forest,
                                  size: 15,
                                ),
                              ],
                              const SizedBox(width: 10),
                              Text(
                                entry.timeAgo,
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 11.5,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Divider(color: _border, height: 1),
              InkWell(
                onTap: _showAllActivitySheet,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 13, 16, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'View All Activity',
                        style: TextStyle(
                          color: _mintBright,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(width: 5),
                      UlvenikIcon(UlvenikIcons.details,
                        color: _mintBright,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessSnapshotSection({
    required int activeClients,
    required int activeDogs,
  }) {
    final p = _curvedAnim.value;
    final totalWeekLessons =
        _weeklyLessonsByDay.fold<int>(0, (sum, n) => sum + n);
    final selectedDayCount = _weeklyLessonsByDay[_selectedDayIndex];
    final rightChartLabel = _selectedDayIndex == 3
        ? 'Current Week: $totalWeekLessons'
        : '${_dayFullNames[_selectedDayIndex]}: $selectedDayCount ${selectedDayCount == 1 ? 'session' : 'sessions'}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('BUSINESS SNAPSHOT'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSnapshotMetric(
                        value: '${(activeClients * p).round()}',
                        label: 'Active Clients',
                        onTap: _openClientsPage,
                      ),
                    ),
                    const VerticalDivider(color: _border, width: 1),
                    Expanded(
                      child: _buildSnapshotMetric(
                        value: '${(activeDogs * p).round()}',
                        label: 'Client Dogs',
                        onTap: _openClientsPage,
                      ),
                    ),
                    const VerticalDivider(color: _border, width: 1),
                    Expanded(
                      child: _buildSnapshotMetric(
                        value: '${(totalWeekLessons * p).round()}',
                        label: 'Sessions Week',
                        onTap: _openTrainerAnalytics,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: _border, height: 1),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSnapshotMetric(
                        value: '${(_hwAssignedCount * p).round()}',
                        label: 'HW Assigned',
                        onTap: _showAssignTaskSheet,
                      ),
                    ),
                    const VerticalDivider(color: _border, width: 1),
                    Expanded(
                      child: _buildSnapshotMetric(
                        value: '${(31 * p).round()}',
                        label: 'Active Goals',
                        onTap: _openWorkspaceSettings,
                      ),
                    ),
                    const VerticalDivider(color: _border, width: 1),
                    Expanded(
                      child: _buildSnapshotMetric(
                        value: '${(47 * p).round()}',
                        label: 'Sessions',
                        onTap: _openClientNotes,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: _border, height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Weekly Session Volume',
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _selectedDayIndex = 3),
                          child: Text(
                            rightChartLabel,
                            style: const TextStyle(
                              color: _alpineBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        void updateDayFromX(double dx) {
                          final idx = ((dx / constraints.maxWidth) * 7)
                              .floor()
                              .clamp(0, 6);
                          if (_selectedDayIndex != idx) {
                            setState(() => _selectedDayIndex = idx);
                          }
                        }

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (d) => updateDayFromX(d.localPosition.dx),
                          onHorizontalDragUpdate: (d) =>
                              updateDayFromX(d.localPosition.dx),
                          child: SizedBox(
                            height: 62,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(7, (i) {
                                final isSelected = i == _selectedDayIndex;
                                final barHeight = math.max(
                                  4.0,
                                  38.0 * _weeklyBarHeights[i] * p,
                                );
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: i == 6 ? 0 : 7,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          height: barHeight,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? _alpineBlue
                                                : _alpineBlue.withValues(
                                                    alpha: i == 6 ? 0.18 : 0.36,
                                                  ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          _dayLetters[i],
                                          style: TextStyle(
                                            color: isSelected
                                                ? _textPrimary
                                                : _textSecondary,
                                            fontSize: 11,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSnapshotMetric({
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
