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
    home: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M3 9.5L12 3l9 6.5V20a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
  <polyline points="9 22 9 12 15 12 15 22"/>
</svg>''',

    dogs: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
  <ellipse cx="4.5" cy="10" rx="1.8" ry="2.6" transform="rotate(-25 4.5 10)"/>
  <ellipse cx="9.2" cy="5.8" rx="2" ry="2.8" transform="rotate(-10 9.2 5.8)"/>
  <ellipse cx="14.8" cy="5.8" rx="2" ry="2.8" transform="rotate(10 14.8 5.8)"/>
  <ellipse cx="19.5" cy="10" rx="1.8" ry="2.6" transform="rotate(25 19.5 10)"/>
  <path d="M12 10.5c-3.2 0-6 2.1-6 5.2 0 2.2 1.8 4.3 4 4.3 1.1 0 1.6-.7 2-.7s.9.7 2 .7c2.2 0 4-2.1 4-4.3 0-3.1-2.8-5.2-6-5.2z"/>
</svg>''',

    training: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="4" y="3" width="16" height="18" rx="2"/>
  <line x1="8" y1="8" x2="16" y2="8"/>
  <line x1="8" y1="12" x2="16" y2="12"/>
  <line x1="8" y1="16" x2="12" y2="16"/>
</svg>''',

    timeline: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="5" cy="18" r="2.5"/>
  <circle cx="12" cy="11" r="2.5"/>
  <circle cx="19" cy="5" r="2.5"/>
  <line x1="6.8" y1="16.2" x2="10.2" y2="12.8"/>
  <line x1="13.8" y1="9.2" x2="17.2" y2="6.8"/>
</svg>''',

    more: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
  <circle cx="6" cy="12" r="2"/>
  <circle cx="12" cy="12" r="2"/>
  <circle cx="18" cy="12" r="2"/>
</svg>''',

    back: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <line x1="19" y1="12" x2="5" y2="12"/>
  <polyline points="12 19 5 12 12 5"/>
</svg>''',

    notifications: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
  <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
</svg>''',

    search: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="11" cy="11" r="7"/>
  <line x1="21" y1="21" x2="16.65" y2="16.65"/>
</svg>''',

    add: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <line x1="12" y1="5" x2="12" y2="19"/>
  <line x1="5" y1="12" x2="19" y2="12"/>
</svg>''',

    edit: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"/>
</svg>''',

    play: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="10"/>
  <polygon points="10 8 16 12 10 16 10 8" fill="currentColor"/>
</svg>''',

    recordSession: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
  <polyline points="14 2 14 8 20 8"/>
  <line x1="12" y1="18" x2="12" y2="12"/>
  <line x1="9" y1="15" x2="15" y2="15"/>
</svg>''',

    goals: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="10"/>
  <circle cx="12" cy="12" r="6"/>
  <path d="m22 2-10 10"/>
  <path d="m16 2 6 6"/>
</svg>''',

    progress: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="3" y="13" width="4" height="8" rx="1"/>
  <rect x="10" y="8" width="4" height="13" rx="1"/>
  <rect x="17" y="3" width="4" height="18" rx="1"/>
</svg>''',

    health: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M19.5 12.572l-7.5 7.428l-7.5 -7.428a5 5 0 1 1 7.5 -6.566a5 5 0 1 1 7.5 6.572"/>
  <polyline points="7 12 10 12 11.5 9 13.5 15 12 17 12"/>
</svg>''',

    journey: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="6" cy="19" r="3"/>
  <path d="M9 19h8.5a3.5 3.5 0 0 0 0-7h-11a3.5 3.5 0 0 1 0-7H15"/>
  <circle cx="18" cy="5" r="3"/>
</svg>''',

    exercises: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>
  <rect x="8" y="2" width="8" height="4" rx="1" ry="1"/>
  <line x1="9" y1="12" x2="15" y2="12"/>
  <line x1="9" y1="16" x2="13" y2="16"/>
</svg>''',

    skills: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <polygon points="12 2 2 7 12 12 22 7 12 2"/>
  <polyline points="2 12 12 17 22 12"/>
  <polyline points="2 17 12 22 22 17"/>
</svg>''',

    history: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/>
  <polyline points="3 3 3 8 8 8"/>
  <polyline points="12 7 12 12 15 15"/>
</svg>''',

    scheduledTraining: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
  <line x1="16" y1="2" x2="16" y2="6"/>
  <line x1="8" y1="2" x2="8" y2="6"/>
  <line x1="3" y1="10" x2="21" y2="10"/>
  <polyline points="9 16 11 18 15 13"/>
</svg>''',

    trainingTime: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="10"/>
  <polyline points="12 6 12 12 16 14"/>
</svg>''',

    calendar: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
  <line x1="16" y1="2" x2="16" y2="6"/>
  <line x1="8" y1="2" x2="8" y2="6"/>
  <line x1="3" y1="10" x2="21" y2="10"/>
  <line x1="8" y1="14" x2="8.01" y2="14"/>
  <line x1="12" y1="14" x2="12.01" y2="14"/>
  <line x1="16" y1="14" x2="16.01" y2="14"/>
  <line x1="8" y1="18" x2="8.01" y2="18"/>
  <line x1="12" y1="18" x2="12.01" y2="18"/>
  <line x1="16" y1="18" x2="16.01" y2="18"/>
</svg>''',

    completed: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="10"/>
  <polyline points="8 12 11 15 16 9"/>
</svg>''',

    male: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="10" cy="14" r="6"/>
  <line x1="14.2" y1="9.8" x2="21" y2="3"/>
  <polyline points="15 3 21 3 21 9"/>
</svg>''',

    sort: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M7 3v18"/>
  <path d="m11 7-4-4-4 4"/>
  <path d="M17 21V3"/>
  <path d="m13 17 4 4 4-4"/>
</svg>''',

    details: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <polyline points="9 18 15 12 9 6"/>
</svg>''',

    overflowMenu: '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
  <circle cx="12" cy="5" r="2"/>
  <circle cx="12" cy="12" r="2"/>
  <circle cx="12" cy="19" r="2"/>
</svg>''',
  };

  /// Returns the SVG string for the given icon name, or null if not found.
  static String? getSvgString(String name) => _svgStrings[name];

  /// List of all 27 official icon keys.
  static List<String> get allIcons => _svgStrings.keys.toList();

  static final Map<int, String> _materialMap = _initMaterialMap();

  static Map<int, String> _initMaterialMap() {
    final map = <int, String>{};
    void mapGroup(List<IconData> icons, String key) {
      for (final ic in icons) {
        map[ic.codePoint] = key;
      }
    }

    // home
    mapGroup([
      Icons.home, Icons.home_outlined, Icons.home_rounded,
    ], home);

    // dogs
    mapGroup([
      Icons.pets, Icons.pets_outlined, Icons.pets_rounded,
    ], dogs);

    // training
    mapGroup([
      Icons.description, Icons.description_outlined, Icons.article, Icons.article_outlined,
      Icons.note, Icons.note_outlined, Icons.sticky_note_2_outlined, Icons.list_alt,
      Icons.list_alt_outlined, Icons.picture_as_pdf, Icons.picture_as_pdf_outlined, Icons.receipt_long_outlined,
      Icons.table_chart, Icons.table_chart_outlined, Icons.table_rows_outlined, Icons.view_headline,
      Icons.view_list, Icons.summarize_outlined, Icons.insert_drive_file_outlined, Icons.file_copy_outlined,
      Icons.content_paste_outlined, Icons.notes_rounded, Icons.note_alt_outlined, Icons.subtitles_outlined,
      Icons.menu_book_outlined, Icons.book_outlined, Icons.school_outlined, Icons.science_outlined,
      Icons.data_object, Icons.data_object_outlined, Icons.data_object_rounded, Icons.format_list_bulleted,
      Icons.format_list_bulleted_rounded, Icons.list, Icons.attach_file, Icons.attach_file_rounded,
      Icons.attachment,
    ], training);

    // timeline
    mapGroup([
      Icons.timeline, Icons.timeline_rounded, Icons.route_outlined, Icons.linear_scale,
      Icons.alt_route, Icons.alt_route_rounded, Icons.location_on, Icons.location_on_outlined,
      Icons.location_off_outlined, Icons.map_outlined, Icons.place_outlined, Icons.my_location,
      Icons.gps_fixed_rounded, Icons.near_me_outlined, Icons.directions_run, Icons.directions_walk_outlined,
      Icons.hiking, Icons.travel_explore_rounded, Icons.hub_outlined, Icons.tour_outlined,
      Icons.terrain, Icons.terrain_rounded, Icons.park, Icons.park_outlined,
      Icons.landscape, Icons.landscape_outlined, Icons.cell_tower_rounded, Icons.train_outlined,
    ], timeline);

    // more
    mapGroup([
      Icons.more_horiz, Icons.more_horiz_outlined, Icons.more_horiz_rounded, Icons.menu,
      Icons.dehaze_rounded, Icons.density_medium,
    ], more);

    // back
    mapGroup([
      Icons.arrow_back, Icons.arrow_back_ios, Icons.arrow_back_ios_new_rounded, Icons.chevron_left,
      Icons.chevron_left_rounded, Icons.close, Icons.close_rounded, Icons.cancel_outlined,
      Icons.cancel_rounded, Icons.clear, Icons.clear_rounded, Icons.undo,
      Icons.undo_rounded, Icons.delete_outline, Icons.delete_outline_rounded, Icons.delete_sweep_outlined,
      Icons.remove, Icons.remove_circle_outline, Icons.deselect, Icons.horizontal_rule_rounded,
      Icons.highlight_off, Icons.block,
    ], back);

    // notifications
    mapGroup([
      Icons.notifications, Icons.notifications_active, Icons.notifications_active_outlined, Icons.notifications_none,
      Icons.notifications_none_rounded, Icons.notifications_off, Icons.notifications_outlined, Icons.notifications_paused_outlined,
      Icons.add_alert, Icons.alarm_on_outlined, Icons.error_outline_rounded, Icons.warning_amber_rounded,
      Icons.info_outline, Icons.info_outline_rounded, Icons.chat_bubble_outline_rounded, Icons.mail_outline,
      Icons.mail_outline_rounded, Icons.mark_email_read_outlined, Icons.mark_email_unread_outlined, Icons.feedback_outlined,
      Icons.campaign_outlined, Icons.priority_high_rounded, Icons.tips_and_updates_outlined, Icons.lightbulb_outline,
      Icons.lightbulb_outline_rounded, Icons.support_agent_rounded, Icons.support_rounded, Icons.hearing_outlined,
      Icons.snooze, Icons.bug_report, Icons.bug_report_outlined, Icons.help_outline_rounded,
      Icons.mode_comment_outlined,
    ], notifications);

    // search
    mapGroup([
      Icons.search, Icons.search_rounded, Icons.search_off, Icons.search_off_rounded,
      Icons.manage_search, Icons.manage_search_rounded, Icons.explore_outlined,
    ], search);

    // add
    mapGroup([
      Icons.add, Icons.add_rounded, Icons.add_circle_outline, Icons.add_circle_outline_rounded,
      Icons.create_new_folder, Icons.group_add_outlined, Icons.person_add_alt_1_outlined, Icons.bookmark_add_outlined,
    ], add);

    // edit
    mapGroup([
      Icons.edit, Icons.edit_outlined, Icons.edit_rounded, Icons.edit_note,
      Icons.edit_note_outlined, Icons.edit_note_rounded, Icons.edit_square, Icons.border_color,
      Icons.content_cut_outlined, Icons.crop, Icons.crop_rounded, Icons.crop_landscape,
      Icons.crop_original_rounded, Icons.crop_free_rounded, Icons.gesture, Icons.rate_review_outlined,
      Icons.palette_outlined,
    ], edit);

    // play
    mapGroup([
      Icons.play_arrow, Icons.play_arrow_outlined, Icons.play_circle, Icons.play_circle_fill,
      Icons.play_circle_outline, Icons.play_circle_outline_rounded, Icons.pause, Icons.pause_circle_filled,
      Icons.pause_circle_outline, Icons.pause_rounded, Icons.stop, Icons.videocam,
      Icons.videocam_outlined, Icons.video_call, Icons.movie_outlined, Icons.photo,
      Icons.photo_outlined, Icons.photo_camera, Icons.photo_camera_outlined, Icons.photo_camera_back_outlined,
      Icons.photo_library_outlined, Icons.camera_alt_outlined, Icons.camera_alt_rounded, Icons.camera_outlined,
      Icons.image, Icons.image_outlined, Icons.perm_media_outlined, Icons.mic,
      Icons.mic_none, Icons.mic_outlined, Icons.volume_up_outlined, Icons.volume_off_outlined,
      Icons.music_note_outlined,
    ], play);

    // recordSession
    mapGroup([
      Icons.note_add, Icons.note_add_outlined, Icons.post_add, Icons.add_task_rounded,
      Icons.add_photo_alternate, Icons.add_photo_alternate_outlined,
    ], recordSession);

    // goals
    mapGroup([
      Icons.track_changes, Icons.track_changes_outlined, Icons.track_changes_rounded, Icons.flag,
      Icons.flag_outlined, Icons.outlined_flag, Icons.outlined_flag_rounded, Icons.emoji_events,
      Icons.emoji_events_outlined, Icons.emoji_events_rounded, Icons.star, Icons.star_border,
      Icons.star_border_rounded, Icons.star_rounded, Icons.stars, Icons.military_tech,
      Icons.workspace_premium, Icons.workspace_premium_outlined, Icons.sports_score, Icons.sports_score_rounded,
      Icons.card_giftcard_rounded, Icons.redeem_rounded, Icons.adjust, Icons.adjust_rounded,
      Icons.thumb_up_alt_outlined, Icons.thumb_up_alt_rounded, Icons.thumb_up_off_alt_outlined, Icons.thumb_up_outlined,
      Icons.thumb_down_alt_outlined, Icons.sentiment_satisfied_alt_outlined,
    ], goals);

    // progress
    mapGroup([
      Icons.bar_chart, Icons.bar_chart_rounded, Icons.bar_chart_outlined, Icons.show_chart,
      Icons.show_chart_rounded, Icons.insights, Icons.insights_outlined, Icons.insights_rounded,
      Icons.trending_up, Icons.trending_up_rounded, Icons.trending_flat, Icons.analytics,
      Icons.analytics_outlined, Icons.pie_chart_outline_rounded, Icons.donut_large, Icons.auto_graph,
      Icons.speed, Icons.speed_outlined, Icons.speed_rounded, Icons.space_dashboard_outlined,
      Icons.dashboard_customize_outlined, Icons.ssid_chart, Icons.grid_view_outlined, Icons.grid_view_rounded,
      Icons.numbers_outlined, Icons.signal_cellular_4_bar_rounded,
    ], progress);

    // health
    mapGroup([
      Icons.favorite, Icons.favorite_border, Icons.favorite_border_rounded, Icons.favorite_outline,
      Icons.favorite_rounded, Icons.local_hospital, Icons.local_hospital_outlined, Icons.healing,
      Icons.healing_outlined, Icons.medication, Icons.medication_outlined, Icons.medication_liquid_outlined,
      Icons.medical_services, Icons.medical_services_outlined, Icons.health_and_safety, Icons.health_and_safety_outlined,
      Icons.monitor_heart, Icons.monitor_heart_outlined, Icons.vaccines, Icons.vaccines_outlined,
      Icons.personal_injury, Icons.emergency_outlined, Icons.spa, Icons.spa_outlined,
      Icons.self_improvement, Icons.cleaning_services_outlined, Icons.water,
      Icons.water_drop, Icons.water_drop_outlined, Icons.waves, Icons.waves_rounded,
    ], health);

    // journey
    mapGroup([
      Icons.alt_route, Icons.route_outlined,
    ], journey);

    // exercises
    mapGroup([
      Icons.fitness_center, Icons.fitness_center_outlined, Icons.fitness_center_rounded, Icons.assignment,
      Icons.assignment_outlined, Icons.assignment_turned_in_outlined, Icons.checklist, Icons.checklist_rtl_outlined,
      Icons.task_alt, Icons.task_alt_rounded, Icons.monitor_weight_outlined, Icons.scale,
      Icons.scale_outlined, Icons.sports_gymnastics, Icons.sports_tennis, Icons.sports_baseball_outlined,
      Icons.sports_kabaddi_outlined, Icons.pool, Icons.pool_outlined, Icons.stairs,
      Icons.straighten_outlined, Icons.straighten_rounded, Icons.accessibility_new, Icons.accessibility_new_outlined,
      Icons.accessibility_new_rounded, Icons.back_hand_outlined, Icons.pan_tool_outlined, Icons.work_outline_rounded,
    ], exercises);

    // skills
    mapGroup([
      Icons.layers, Icons.layers_outlined, Icons.auto_stories, Icons.inventory_2,
      Icons.inventory_2_outlined, Icons.archive, Icons.archive_outlined, Icons.unarchive_outlined,
      Icons.category, Icons.category_outlined, Icons.bookmark, Icons.bookmark_outline,
      Icons.bookmark_rounded, Icons.bookmark_border, Icons.bookmark_border_outlined, Icons.bookmark_border_rounded,
      Icons.bolt, Icons.bolt_outlined, Icons.bolt_rounded, Icons.flash_on_rounded,
      Icons.auto_awesome, Icons.auto_awesome_motion, Icons.auto_awesome_outlined, Icons.tag_rounded,
      Icons.local_offer_outlined, Icons.local_offer_rounded, Icons.push_pin, Icons.push_pin_outlined,
      Icons.collections_bookmark_outlined, Icons.collections_outlined, Icons.backpack, Icons.checkroom,
      Icons.eco, Icons.eco_outlined, Icons.psychology, Icons.psychology_outlined,
      Icons.widgets_outlined, Icons.aspect_ratio, Icons.sell_outlined, Icons.view_in_ar_outlined,
    ], skills);

    // history
    mapGroup([
      Icons.history, Icons.history_outlined, Icons.history_rounded, Icons.history_toggle_off,
      Icons.history_toggle_off_rounded, Icons.replay_rounded, Icons.restore, Icons.restart_alt,
      Icons.restart_alt_rounded, Icons.refresh, Icons.refresh_rounded, Icons.sync,
      Icons.sync_rounded, Icons.sync_alt, Icons.autorenew_rounded, Icons.repeat,
      Icons.repeat_outlined, Icons.settings_backup_restore, Icons.cloud_sync_outlined, Icons.update,
      Icons.update_outlined, Icons.compare_arrows,
    ], history);

    // scheduledTraining
    mapGroup([
      Icons.event_available_outlined, Icons.event_note, Icons.event_note_outlined, Icons.calendar_month,
      Icons.calendar_month_outlined, Icons.event_repeat_outlined,
    ], scheduledTraining);

    // trainingTime
    mapGroup([
      Icons.schedule, Icons.schedule_outlined, Icons.schedule_rounded, Icons.timer,
      Icons.timer_outlined, Icons.access_time, Icons.access_time_outlined, Icons.access_time_rounded,
      Icons.timelapse_outlined, Icons.hourglass_bottom_rounded, Icons.hourglass_empty, Icons.hourglass_empty_rounded,
      Icons.alarm,
    ], trainingTime);

    // calendar
    mapGroup([
      Icons.calendar_today, Icons.calendar_today_outlined, Icons.event, Icons.event_outlined,
      Icons.event_busy, Icons.event_busy_outlined, Icons.grid_on, Icons.grid_on_rounded,
    ], calendar);

    // completed
    mapGroup([
      Icons.check, Icons.check_rounded, Icons.check_circle, Icons.check_circle_outline,
      Icons.check_circle_outline_rounded, Icons.check_circle_rounded, Icons.done_all_rounded, Icons.verified,
      Icons.verified_outlined, Icons.verified_rounded, Icons.verified_user_outlined, Icons.verified_user_rounded,
      Icons.check_box_rounded, Icons.check_box_outlined, Icons.check_box_outline_blank_rounded, Icons.radio_button_checked,
      Icons.radio_button_checked_rounded, Icons.radio_button_off, Icons.radio_button_off_rounded, Icons.radio_button_unchecked,
      Icons.radio_button_unchecked_rounded, Icons.circle, Icons.fiber_manual_record, Icons.safety_check,
    ], completed);

    // male
    mapGroup([
      Icons.male, Icons.male_rounded,
    ], male);

    // sort
    mapGroup([
      Icons.sort, Icons.sort_by_alpha, Icons.swap_vert, Icons.swap_vert_rounded,
      Icons.swap_horiz, Icons.swap_horiz_rounded, Icons.filter_list, Icons.filter_list_off,
      Icons.filter_alt, Icons.filter_alt_off, Icons.filter_alt_outlined, Icons.tune,
      Icons.tune_rounded, Icons.drag_handle, Icons.drag_handle_rounded, Icons.drag_indicator,
      Icons.unfold_more, Icons.unfold_more_rounded, Icons.expand_more, Icons.expand_less,
      Icons.keyboard_arrow_down, Icons.keyboard_arrow_down_rounded, Icons.keyboard_arrow_up, Icons.keyboard_arrow_up_rounded,
      Icons.arrow_drop_down, Icons.arrow_downward, Icons.arrow_downward_rounded, Icons.arrow_upward,
      Icons.arrow_upward_rounded, Icons.settings, Icons.settings_outlined, Icons.build_outlined,
      Icons.construction, Icons.import_export, Icons.balance, Icons.toggle_on,
      Icons.toggle_on_outlined, Icons.toggle_off_outlined,
    ], sort);

    // details
    mapGroup([
      Icons.chevron_right, Icons.chevron_right_rounded, Icons.arrow_forward, Icons.arrow_forward_rounded,
      Icons.arrow_circle_down_outlined, Icons.visibility, Icons.visibility_outlined, Icons.visibility_off,
      Icons.visibility_off_outlined, Icons.open_in_new, Icons.open_in_new_rounded, Icons.open_in_full,
      Icons.fullscreen_rounded, Icons.fullscreen_exit_rounded, Icons.north_east, Icons.zoom_in_rounded,
      Icons.touch_app, Icons.ads_click, Icons.link, Icons.link_rounded,
      Icons.link_off, Icons.send_outlined,
    ], details);

    // overflowMenu
    mapGroup([
      Icons.more_vert, Icons.share, Icons.share_outlined, Icons.ios_share,
      Icons.ios_share_outlined, Icons.ios_share_rounded, Icons.download, Icons.download_outlined,
      Icons.download_rounded, Icons.download_done_rounded, Icons.file_download, Icons.file_download_outlined,
      Icons.download_for_offline_outlined, Icons.upload, Icons.upload_file, Icons.upload_file_outlined,
      Icons.upload_file_rounded, Icons.file_upload_outlined, Icons.cloud_download, Icons.cloud_download_outlined,
      Icons.cloud_upload, Icons.cloud_upload_outlined, Icons.cloud_outlined, Icons.cloud_done,
      Icons.cloud_done_outlined, Icons.cloud_off_outlined, Icons.lock, Icons.lock_outline,
      Icons.lock_outline_rounded, Icons.lock_open_outlined, Icons.lock_open_rounded, Icons.security_rounded,
      Icons.shield, Icons.shield_outlined, Icons.privacy_tip_outlined, Icons.fingerprint_rounded,
      Icons.key_rounded, Icons.folder_outlined, Icons.folder_open, Icons.folder_open_outlined,
      Icons.folder_open_rounded, Icons.folder_shared_outlined, Icons.folder_special_outlined, Icons.folder_zip_outlined,
      Icons.folder_off_outlined, Icons.storage_outlined, Icons.dns_outlined, Icons.save_outlined,
      Icons.copy, Icons.copy_outlined, Icons.copy_rounded, Icons.print_outlined,
      Icons.print_rounded, Icons.credit_card_outlined, Icons.person, Icons.person_outline,
      Icons.person_outline_rounded, Icons.person_rounded, Icons.account_circle_outlined, Icons.people_outline_rounded,
      Icons.groups_outlined, Icons.supervisor_account_outlined, Icons.badge_outlined, Icons.phone_android_rounded,
      Icons.phone_iphone_rounded, Icons.tablet_mac_rounded, Icons.laptop_mac_rounded, Icons.devices_rounded,
      Icons.smartphone_rounded, Icons.wifi_rounded, Icons.wifi_off_rounded, Icons.public,
      Icons.public_rounded, Icons.public_off_rounded, Icons.language_rounded, Icons.translate_rounded,
      Icons.apple, Icons.apartment_rounded, Icons.battery_charging_full, Icons.wb_sunny_outlined,
      Icons.wb_cloudy_outlined, Icons.nightlight_outlined, Icons.nightlight_round_outlined, Icons.code_rounded,
      Icons.swipe_left_outlined, Icons.select_all, Icons.vertical_align_top, Icons.local_fire_department,
      Icons.local_fire_department_outlined, Icons.local_fire_department_rounded, Icons.restaurant, Icons.restaurant_rounded,
      Icons.lens_blur, Icons.phone_outlined,
    ], overflowMenu);

    return map;
  }

  /// Maps an arbitrary Material [IconData] to the closest official Ulvenik icon key.
  static String mapMaterial(IconData icon) {
    return _materialMap[icon.codePoint] ?? details;
  }
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

  const UlvenikIcon(
    this.icon, {
    super.key,
    this.size = 24.0,
    this.color,
    FontWeight? fontWeight,
    String? semanticsLabel,
    String? semanticLabel,
  }) : semanticsLabel = semanticsLabel ?? semanticLabel;

  /// Convenient factory to create an [UlvenikIcon] mapped directly from any
  /// existing Material [IconData], guaranteeing that only official Ulvenik icons
  /// are rendered.
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
