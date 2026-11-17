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

  // Added Nov 2026 from client-approved references (Training v34 p31,
  // Dog Overview p4). Save / views / favourite follow the same line style.
  static const String strengthConditioning = 'strength_conditioning';
  static const String rewards = 'rewards';
  static const String equipment = 'equipment';
  static const String save = 'save';
  static const String listView = 'list_view';
  static const String cardView = 'card_view';
  static const String favourite = 'favourite';
  static const String favouriteFilled = 'favourite_filled';

  /// Path to the standalone SVG asset file in assets/icons/ulvenik/
  static String assetPath(String name) => 'assets/icons/ulvenik/$name.svg';

  /// List of all official icon keys, matching the files in assets/icons/ulvenik/.
  static const List<String> allIcons = [
    home, dogs, training, timeline, more, back, notifications, search, add,
    edit, play, recordSession, goals, progress, health, journey, exercises,
    skills, history, scheduledTraining, trainingTime, calendar, completed,
    male, sort, details, overflowMenu, strengthConditioning, rewards,
    equipment, save, listView, cardView, favourite, favouriteFilled,
  ];

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
    if (!UlvenikIcons.allIcons.contains(icon)) {
      return SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.help_outline, size: size, color: effectiveColor),
      );
    }

    return SvgPicture.asset(
      UlvenikIcons.assetPath(icon),
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticsLabel: semanticsLabel ?? icon,
      colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
    );
  }
}
