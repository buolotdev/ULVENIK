import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide saved settings: one source of truth for every route that shows
/// them. Each change is written to device storage straight away; if the write
/// fails the previous value stays and [lastError] is set.
class AppSettings extends ChangeNotifier {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  SharedPreferences? _p;
  String? lastError;

  static const textSizes = ['Small', 'Standard', 'Large', 'Extra Large'];
  static const _textFactor = {'Small': 0.9, 'Standard': 1.0, 'Large': 1.15, 'Extra Large': 1.3};

  Future<void> load() async {
    try {
      _p = await SharedPreferences.getInstance();
    } catch (_) {
      _p = null;
    }
  }

  String _s(String k, String d) => _p?.getString(k) ?? d;
  bool _b(String k, bool d) => _p?.getBool(k) ?? d;

  /// Saves one value. Returns false (value unchanged) on failure.
  Future<bool> _set(String k, Object v) async {
    try {
      final p = _p ?? await SharedPreferences.getInstance();
      _p = p;
      final ok = switch (v) {
        bool b => await p.setBool(k, b),
        String s => await p.setString(k, s),
        _ => false,
      };
      lastError = ok ? null : 'That change couldn’t be saved. Please try again.';
      notifyListeners();
      return ok;
    } catch (_) {
      lastError = 'That change couldn’t be saved. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // ── Profile ─────────────────────────────────────────────────────────────
  String get firstName => _s('profile.first', '');
  String get lastName => _s('profile.last', '');
  String get displayNameRaw => _s('profile.display', '');
  String get photoPath => _s('profile.photo', '');

  /// Display name, falling back to the saved personal name.
  String get displayName {
    if (displayNameRaw.trim().isNotEmpty) return displayNameRaw.trim();
    return [firstName, lastName].where((e) => e.trim().isNotEmpty).join(' ');
  }

  Future<bool> saveProfile(
      {required String first, required String last, required String display, required String photo}) async {
    final a = await _set('profile.first', first);
    final b = await _set('profile.last', last);
    final c = await _set('profile.display', display);
    final d = await _set('profile.photo', photo);
    return a && b && c && d;
  }

  // ── Appearance ──────────────────────────────────────────────────────────
  static const themeModes = ['Dark', 'Light', 'Device'];
  bool _listeningToDevice = false;

  /// 'Dark', 'Light' or 'Device' (follows the OS setting).
  String get themeMode => _s('app.themeMode', 'Dark');

  Future<bool> setThemeMode(String v) => _set('app.themeMode', v);

  /// The effective brightness right now, resolving 'Device' against the
  /// OS setting and staying live if the OS setting changes mid-session.
  bool get isDark {
    if (themeMode == 'Light') return false;
    if (themeMode == 'Dark') return true;
    if (!_listeningToDevice) {
      _listeningToDevice = true;
      final existing = PlatformDispatcher.instance.onPlatformBrightnessChanged;
      PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
        existing?.call();
        notifyListeners();
      };
    }
    return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
  }

  String get textSize => _s('app.textSize', 'Standard');
  double get textFactor => _textFactor[textSize] ?? 1.0;
  bool get reduceAnimations => _b('app.reduceAnimations', false);
  bool get touchFeedback => _b('app.touchFeedback', true);

  Future<bool> setTextSize(String v) => _set('app.textSize', v);
  Future<bool> setReduceAnimations(bool v) => _set('app.reduceAnimations', v);
  Future<bool> setTouchFeedback(bool v) => _set('app.touchFeedback', v);

  Future<void> resetAppearance() async {
    await _set('app.textSize', 'Standard');
    await _set('app.reduceAnimations', false);
    await _set('app.touchFeedback', true);
  }

  // ── App Lock (local to this device) ─────────────────────────────────────
  bool get appLock => _b('security.appLock', false);
  Future<bool> setAppLock(bool v) => _set('security.appLock', v);

  // ── Regional ────────────────────────────────────────────────────────────
  String get weightUnit => _s('region.weight', 'kg');
  String get distanceUnit => _s('region.distance', 'km');
  String get dateFormat => _s('region.date', '14 Mar 2026');
  bool get clock24 => _b('region.clock24', true);
  String get weekStart => _s('region.weekStart', 'Monday');
  String get country => _s('region.country', '');
  String get language => _s('region.language', 'Use device language');

  Future<bool> setWeightUnit(String v) => _set('region.weight', v);
  Future<bool> setDistanceUnit(String v) => _set('region.distance', v);
  Future<bool> setDateFormat(String v) => _set('region.date', v);
  Future<bool> setClock24(bool v) => _set('region.clock24', v);
  Future<bool> setWeekStart(String v) => _set('region.weekStart', v);
  Future<bool> setCountry(String v) => _set('region.country', v);
  bool get autoTimeZone => _b('region.autoTz', true);
  String get timeZone => _s('region.tz', '');
  Future<bool> setAutoTimeZone(bool v) => _set('region.autoTz', v);
  Future<bool> setTimeZone(String v) => _set('region.tz', v);
  Future<bool> setLanguage(String v) => _set('region.language', v);

  // ── Notifications (preferences only; they do not create reminders) ──────
  static const notifyKeys = <String, String>{
    'training': 'Training Reminders',
    'sc': 'S&C Reminders',
    'medication': 'Medication Reminders',
    'vaccination': 'Vaccination Reminders',
    'vet': 'Vet Appointment Reminders',
    'weight': 'Weight Check Reminders',
    'supplement': 'Supplement Reminders',
    'goal': 'Goal Reminders',
    'goalAchieved': 'Goal Achievements',
    'competition': 'Competition Reminders',
    'memories': 'Memories',
  };
  bool notify(String key) => _b('notify.$key', key == 'push' ? false : true);
  Future<bool> setNotify(String key, bool v) => _set('notify.$key', v);

  bool get quietHours => _b('notify.quiet', false);
  String get quietStart => _s('notify.quietStart', '22:00');
  String get quietEnd => _s('notify.quietEnd', '07:00');
  bool get productNews => _b('notify.news', false);
  bool get appBadge => _b('notify.badge', true);
  Future<bool> setQuietHours(bool v) => _set('notify.quiet', v);
  Future<bool> setQuietStart(String v) => _set('notify.quietStart', v);
  Future<bool> setQuietEnd(String v) => _set('notify.quietEnd', v);
  Future<bool> setProductNews(bool v) => _set('notify.news', v);
  Future<bool> setAppBadge(bool v) => _set('notify.badge', v);
}
