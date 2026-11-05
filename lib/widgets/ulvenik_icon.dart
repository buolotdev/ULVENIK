import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Standard Ulvenik Icon identifiers corresponding to the 27 official icons
/// from the Ulvenik Icon Guide.
class UlvenikIcons {
  UlvenikIcons._();

  static const String home = 'home';
  static const String dogs = 'dogs';
  static const String training = 'training';
  static const String timeline = 'timeline';
  static const String more = 'more';
  static const String back = 'back';
  static const String notifications = 'notifications';
  static const String search = 'search';
  static const String add = 'add';
  static const String edit = 'edit';
  static const String play = 'play';
  static const String recordSession = 'record_session';
  static const String goals = 'goals';
  static const String progress = 'progress';
  static const String health = 'health';
  static const String journey = 'journey';
  static const String exercises = 'exercises';
  static const String skills = 'skills';
  static const String history = 'history';
  static const String scheduledTraining = 'scheduled_training';
  static const String trainingTime = 'training_time';
  static const String calendar = 'calendar';
  static const String completed = 'completed';
  static const String male = 'male';
  static const String sort = 'sort';
  static const String details = 'details';
  static const String overflowMenu = 'overflow_menu';

  /// Path to the standalone SVG asset file in assets/icons/ulvenik/
  static String assetPath(String name) => 'assets/icons/ulvenik/$name.svg';

  static const Map<String, String> _svgStrings = {
    add: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M12 4v16M4 12h16" fill="none" />
  </svg>''',

    back: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M20 12H4M10 6l-6 6 6 6" fill="none" />
  </svg>''',

    calendar: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="3.5" y="5" width="17" height="15.5" rx="2.5" fill="none" />
  <path d="M3.5 10h17M8 3v4M16 3v4" fill="none" />
  <path d="M8.5 15h7" fill="none" />
  </svg>''',

    completed: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="9" fill="none" />
  <path d="m7.8 12.3 3 3 5.5-6" fill="none" />
  </svg>''',

    details: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="m9 4 8 8-8 8" fill="none" />
  </svg>''',

    dogs: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="currentColor">
  <ellipse cx="5.5" cy="11" rx="2" ry="2.7" transform="rotate(-20 5.5 11)" />
  <ellipse cx="9.8" cy="5.8" rx="2" ry="2.8" transform="rotate(-8 9.8 5.8)" />
  <ellipse cx="14.2" cy="5.8" rx="2" ry="2.8" transform="rotate(8 14.2 5.8)" />
  <ellipse cx="18.5" cy="11" rx="2" ry="2.7" transform="rotate(20 18.5 11)" />
  <path d="M12 11c-3 0-6 3.5-6 6.2 0 2 1.6 2.8 3 2.8 1.2 0 2-.5 3-.5s1.8.5 3 .5c1.4 0 3-.8 3-2.8C18 14.5 15 11 12 11z" />
  </svg>''',

    edit: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M4 20l.8-4L16 4.8a1.8 1.8 0 0 1 2.5 0l.7.7a1.8 1.8 0 0 1 0 2.5L8 19.2z" fill="none" />
  <path d="M14 7l3 3" fill="none" />
  </svg>''',

    exercises: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="5" y="4.5" width="14" height="17" rx="2.5" fill="none" />
  <rect x="9" y="2.5" width="6" height="4" rx="1" fill="none" />
  <path d="M8.5 12h7M8.5 15.5h7M8.5 19h3" fill="none" />
  </svg>''',

    goals: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="9"/>
  <circle cx="12" cy="12" r="5"/>
  <path d="m21 3-9 9"/>
  <path d="m15.5 3.5 5 5"/>
</svg>''',

    health: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
  <path d="M6.5 12h2.5l1.5-3 2.5 6 1.5-3h3"/>
</svg>''',

    history: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" fill="none" />
  <path d="M3 3v5h5" fill="none" />
  <path d="M12 7v5l4 2" fill="none" />
  </svg>''',

    home: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M3 11.5 12 3.5l9 8" fill="none" />
  <path d="M5.5 10v10.5h13V10" fill="none" />
  <path d="M10 20.5v-5.5h4v5.5" fill="none" />
  </svg>''',

    journey: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="5" cy="19" r="2"/>
  <path d="M7 19h2a4 4 0 0 0 4-4v-2a4 4 0 0 1 4-4h1"/>
  <path d="M18 2a3.5 3.5 0 0 0-3.5 3.5c0 2.5 3.5 5.5 3.5 5.5s3.5-3 3.5-5.5A3.5 3.5 0 0 0 18 2z"/>
  <circle cx="18" cy="5.5" r="1" fill="currentColor"/>
</svg>''',

    male: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="10" cy="14" r="5.5" fill="none" />
  <path d="m14 10 6-6M15 4h5v5" fill="none" />
  </svg>''',

    more: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="currentColor">
  <circle cx="4.5" cy="12" r="2" />
  <circle cx="12" cy="12" r="2" />
  <circle cx="19.5" cy="12" r="2" />
  </svg>''',

    notifications: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M12 2.5v1.2" fill="none" />
  <path d="M12 3.7a6 6 0 0 0-6 6v4.8L4 18.5h16l-2-4V9.7a6 6 0 0 0-6-6z" fill="none" />
  <path d="M9.8 21a2.4 2.4 0 0 0 4.4 0" fill="none" />
  </svg>''',

    overflowMenu: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="currentColor">
  <circle cx="12" cy="4.5" r="2" />
  <circle cx="12" cy="12" r="2" />
  <circle cx="12" cy="19.5" r="2" />
  </svg>''',

    play: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="9" fill="none" />
  <path d="M10 8.2v7.6l6-3.8z" fill="none" />
  </svg>''',

    progress: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="3.5" y="13" width="4" height="7.5" rx="1" fill="none" />
  <rect x="10" y="8.5" width="4" height="12" rx="1" fill="none" />
  <rect x="16.5" y="3.5" width="4" height="17" rx="1" fill="none" />
  </svg>''',

    recordSession: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M11 21H7a2.5 2.5 0 0 1-2.5-2.5v-13A2.5 2.5 0 0 1 7 3h7l5.5 5.5V11" fill="none" />
  <path d="M14 3v4a1.5 1.5 0 0 0 1.5 1.5h4" fill="none" />
  <path d="M8 12h4M8 16h3" fill="none" />
  <path d="M17 14v6M14 17h6" fill="none" />
  </svg>''',

    scheduledTraining: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="3.5" y="5" width="17" height="15.5" rx="2.5" fill="none" />
  <path d="M3.5 10h17M8 3v4M16 3v4" fill="none" />
  <path d="m9 15.5 2.2 2.2 4-4.3" fill="none" />
  </svg>''',

    search: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="10.5" cy="10.5" r="6.5" fill="none" />
  <path d="M15.5 15.5 21 21" fill="none" />
  </svg>''',

    skills: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M12 3.5 21 8l-9 4.5L3 8z" fill="none" />
  <path d="m3 12 9 4.5 9-4.5" fill="none" />
  <path d="m3 16 9 4.5 9-4.5" fill="none" />
  </svg>''',

    sort: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M7 20V4M3.5 7.5 7 4l3.5 3.5M17 4v16M13.5 16.5 17 20l3.5-3.5" fill="none" />
  </svg>''',

    timeline: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="5" cy="18" r="2.5"/>
  <circle cx="12" cy="11" r="2.5"/>
  <circle cx="19" cy="5" r="2.5"/>
  <line x1="6.8" y1="16.2" x2="10.2" y2="12.8"/>
  <line x1="13.8" y1="9.2" x2="17.2" y2="6.8"/>
</svg>''',

    training: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="4.5" y="3.5" width="15" height="17" rx="2.5" fill="none" />
  <path d="M8.5 9h7M8.5 12.5h7M8.5 16h4" fill="none" />
  </svg>''',

    trainingTime: '''<svg  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="9" fill="none" />
  <path d="M12 7v5.5l3.5 2" fill="none" />
  </svg>''',

  };

  /// Returns the SVG string for the given icon name, or null if not found.
  static String? getSvgString(String name) => _svgStrings[name];

  /// List of all 27 official icon keys.
  static List<String> get allIcons => _svgStrings.keys.toList();

  /// Material icons that are semantically identical to an official guide icon.
  /// Every other Material icon is intentionally NOT remapped and stays standard.
  static final Map<int, String> _materialMap = _initMaterialMap();

  static Map<int, String> _initMaterialMap() {
    final map = <int, String>{};
    void mapGroup(List<IconData> icons, String key) {
      for (final ic in icons) {
        map[ic.codePoint] = key;
      }
    }

    mapGroup([
      Icons.home, Icons.home_outlined, Icons.home_rounded,
    ], home);
    mapGroup([
      Icons.pets, Icons.pets_outlined, Icons.pets_rounded,
    ], dogs);
    mapGroup([
      Icons.description, Icons.description_outlined, Icons.article, Icons.article_outlined, Icons.list_alt, Icons.list_alt_outlined, Icons.receipt_long_outlined, Icons.summarize_outlined,
    ], training);
    mapGroup([
      Icons.timeline, Icons.timeline_rounded, Icons.route_outlined, Icons.alt_route, Icons.alt_route_rounded,
    ], timeline);
    mapGroup([
      Icons.more_horiz, Icons.more_horiz_outlined, Icons.more_horiz_rounded,
    ], more);
    mapGroup([
      Icons.arrow_back, Icons.arrow_back_rounded, Icons.arrow_back_ios, Icons.arrow_back_ios_new, Icons.arrow_back_ios_new_rounded, Icons.chevron_left, Icons.chevron_left_rounded,
    ], back);
    mapGroup([
      Icons.notifications, Icons.notifications_active, Icons.notifications_active_outlined, Icons.notifications_none, Icons.notifications_none_rounded, Icons.notifications_outlined, Icons.add_alert,
    ], notifications);
    mapGroup([
      Icons.search, Icons.search_rounded,
    ], search);
    mapGroup([
      Icons.add, Icons.add_rounded, Icons.add_circle_outline, Icons.add_circle_outline_rounded, Icons.add_circle,
    ], add);
    mapGroup([
      Icons.edit, Icons.edit_outlined, Icons.edit_rounded, Icons.edit_note, Icons.edit_note_outlined, Icons.edit_note_rounded,
    ], edit);
    mapGroup([
      Icons.play_arrow, Icons.play_arrow_outlined, Icons.play_arrow_rounded, Icons.play_circle, Icons.play_circle_fill, Icons.play_circle_outline, Icons.play_circle_outline_rounded,
    ], play);
    mapGroup([
      Icons.note_add, Icons.note_add_outlined, Icons.post_add,
    ], recordSession);
    mapGroup([
      Icons.track_changes, Icons.track_changes_outlined, Icons.track_changes_rounded, Icons.adjust,
    ], goals);
    mapGroup([
      Icons.bar_chart, Icons.bar_chart_rounded, Icons.bar_chart_outlined, Icons.show_chart, Icons.show_chart_rounded, Icons.insights, Icons.insights_outlined, Icons.insights_rounded, Icons.trending_up, Icons.trending_up_rounded, Icons.analytics, Icons.analytics_outlined,
    ], progress);
    mapGroup([
      Icons.monitor_heart, Icons.monitor_heart_outlined, Icons.health_and_safety, Icons.health_and_safety_outlined, Icons.vaccines, Icons.vaccines_outlined, Icons.medication, Icons.medication_outlined, Icons.local_hospital, Icons.local_hospital_outlined, Icons.medical_services, Icons.medical_services_outlined, Icons.healing, Icons.healing_outlined,
    ], health);
    mapGroup([
      Icons.fitness_center, Icons.fitness_center_outlined, Icons.fitness_center_rounded, Icons.assignment, Icons.assignment_outlined, Icons.checklist,
    ], exercises);
    mapGroup([
      Icons.layers, Icons.layers_outlined,
    ], skills);
    mapGroup([
      Icons.history, Icons.history_outlined, Icons.history_rounded, Icons.restore,
    ], history);
    mapGroup([
      Icons.event_available_outlined, Icons.event_note, Icons.event_note_outlined,
    ], scheduledTraining);
    mapGroup([
      Icons.schedule, Icons.schedule_outlined, Icons.schedule_rounded, Icons.timer, Icons.timer_outlined, Icons.access_time, Icons.access_time_outlined, Icons.access_time_rounded,
    ], trainingTime);
    mapGroup([
      Icons.calendar_today, Icons.calendar_today_outlined, Icons.event, Icons.event_outlined, Icons.calendar_month, Icons.calendar_month_outlined, Icons.date_range_outlined,
    ], calendar);
    mapGroup([
      Icons.check_circle, Icons.check_circle_outline, Icons.check_circle_outline_rounded, Icons.check_circle_rounded, Icons.task_alt, Icons.task_alt_rounded, Icons.verified, Icons.verified_outlined,
    ], completed);
    mapGroup([
      Icons.male, Icons.male_rounded,
    ], male);
    mapGroup([
      Icons.sort, Icons.swap_vert, Icons.swap_vert_rounded, Icons.import_export,
    ], sort);
    mapGroup([
      Icons.chevron_right, Icons.chevron_right_rounded, Icons.arrow_forward_ios, Icons.arrow_forward, Icons.arrow_forward_rounded,
    ], details);
    mapGroup([
      Icons.more_vert, Icons.more_vert_rounded,
    ], overflowMenu);

    return map;
  }

  /// Returns the official guide icon key for a Material icon, or null when the
  /// guide has no equivalent (the original Material icon must then be used).
  static String? mapMaterial(IconData icon) => _materialMap[icon.codePoint];
}

/// A pixel-perfect vector icon widget that renders Ulvenik's official icons.
///
/// Supports automatic dynamic tinting, sizing, and semantics matching Flutter's
/// standard [Icon] widget.
class UlvenikIcon extends StatelessWidget {
  /// One of the identifiers from [UlvenikIcons], e.g. [UlvenikIcons.home].
  final String icon;

  /// The size of the icon in logical pixels. Defaults to 24.0.
  final double size;

  /// The color to apply to the icon vector. Defaults to the ambient [IconTheme]
  /// or [Colors.white].
  final Color? color;

  /// Optional accessibility label.
  final String? semanticsLabel;

  /// Standard Material icon rendered when the guide has no equivalent icon.
  final IconData? _materialFallback;

  const UlvenikIcon(
    this.icon, {
    super.key,
    this.size = 24.0,
    this.color,
    FontWeight? fontWeight,
    String? semanticsLabel,
    String? semanticLabel,
  })  : semanticsLabel = semanticsLabel ?? semanticLabel,
        _materialFallback = null;

  const UlvenikIcon._material(
    IconData materialIcon, {
    super.key,
    this.size = 24.0,
    this.color,
    this.semanticsLabel,
  })  : icon = '',
        _materialFallback = materialIcon;

  /// Creates an icon from a Material [IconData]. If the official Ulvenik guide
  /// has an equivalent icon it is used; otherwise the standard Material icon is
  /// rendered unchanged.
  factory UlvenikIcon.fromMaterial(
    IconData materialIcon, {
    Key? key,
    double size = 24.0,
    Color? color,
    FontWeight? fontWeight,
    String? semanticsLabel,
    String? semanticLabel,
  }) {
    final mapped = UlvenikIcons.mapMaterial(materialIcon);
    if (mapped == null) {
      return UlvenikIcon._material(
        materialIcon,
        key: key,
        size: size,
        color: color,
        semanticsLabel: semanticsLabel ?? semanticLabel,
      );
    }
    return UlvenikIcon(
      mapped,
      key: key,
      size: size,
      color: color,
      semanticsLabel: semanticsLabel ?? semanticLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? IconTheme.of(context).color ?? Colors.white;
    final fallback = _materialFallback;
    if (fallback != null) {
      return Icon(fallback,
          size: size, color: color, semanticLabel: semanticsLabel);
    }
    final svgString = UlvenikIcons.getSvgString(icon);

    if (svgString == null) {
      return SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.help_outline, size: size, color: effectiveColor),
      );
    }

    return SvgPicture.string(
      svgString,
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticsLabel: semanticsLabel ?? icon,
      colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
    );
  }
}
