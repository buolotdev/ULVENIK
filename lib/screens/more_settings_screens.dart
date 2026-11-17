import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/app_settings.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'language_settings_screen.dart';
import 'region_pickers.dart';

Future<bool> _confirmDiscard(BuildContext context) async {
  final r = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Discard changes?',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('You have unsaved changes.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
          const SizedBox(height: 18),
          PrimaryButton(label: 'Keep Editing', onPressed: () => Navigator.pop(ctx, false)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: AppColors.cardBorder)),
              child: Text('Discard Changes', style: TextStyle(color: AppColors.primaryTextOffWhite)),
            ),
          ),
        ]),
      ),
    ),
  );
  return r ?? false;
}

Widget _switchRow(String title, String? helper, bool value, ValueChanged<bool>? onChanged) => SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeThumbColor: AppColors.primaryForestGreen,
      title: Text(title, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15)),
      subtitle: helper == null
          ? null
          : Text(helper, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
      value: value,
      onChanged: onChanged,
    );

// ═══ My Profile ═════════════════════════════════════════════════════════════

/// My Profile: photo and personal name only. One Save Changes; nothing is
/// shown as saved until it is written to the device.
class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _s = AppSettings.instance;
  late final _first = TextEditingController(text: _s.firstName);
  late final _last = TextEditingController(text: _s.lastName);
  late final _display = TextEditingController(text: _s.displayNameRaw);
  late String _photo = _s.photoPath;
  String? _firstError;
  bool _saving = false;

  bool get _dirty =>
      _first.text != _s.firstName ||
      _last.text != _s.lastName ||
      _display.text != _s.displayNameRaw ||
      _photo != _s.photoPath;

  @override
  void initState() {
    super.initState();
    for (final c in [_first, _last, _display]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _display.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final src = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: Icon(Icons.photo_camera_outlined, color: AppColors.primaryTextOffWhite),
            title: Text('Take Photo', style: TextStyle(color: AppColors.primaryTextOffWhite)),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.photo_library_outlined, color: AppColors.primaryTextOffWhite),
            title: Text('Choose from Library', style: TextStyle(color: AppColors.primaryTextOffWhite)),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
          if (_photo.isNotEmpty)
            ListTile(
              title: const Text('Remove Photo', style: TextStyle(color: Color(0xFFFFB4AB))),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _photo = '');
              },
            ),
        ]),
      ),
    );
    if (src == null) return; // cancelled: the existing photo stays
    try {
      final f = await ImagePicker().pickImage(source: src, maxWidth: 1024, imageQuality: 88);
      if (f != null) setState(() => _photo = f.path);
    } catch (_) {
      if (mounted) {
        AppSnackbar.show(context,
            message: 'Couldn’t open your photos. Check that access is allowed in your device settings.',
            type: SnackbarType.error);
      }
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    final first = _first.text.trim();
    if (first.isEmpty) {
      setState(() => _firstError = 'Enter your first name.');
      return;
    }
    setState(() => _saving = true);
    final ok = await _s.saveProfile(first: first, last: _last.text.trim(), display: _display.text.trim(), photo: _photo);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      AppSnackbar.show(context,
          message: 'Your changes couldn’t be saved. They’re still here — try again.', type: SnackbarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valid = _first.text.trim().isNotEmpty;
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard(context) && context.mounted) Navigator.pop(context);
      },
      child: HealthScaffold(
        title: 'My Profile',
        bottom: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: (_dirty && valid && !_saving) ? _save : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryForestGreen,
              foregroundColor: AppColors.onForestGreen,
              disabledBackgroundColor: AppColors.cardsCarbon,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickPhoto,
                child: Column(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox(
                      width: 96,
                      height: 96,
                      child: _photo.isNotEmpty
                          ? Image.file(File(_photo),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => ColoredBox(color: AppColors.cardsCarbon))
                          : ColoredBox(
                              color: AppColors.cardsCarbon,
                              child: Center(
                                child: Text(
                                  _first.text.trim().isEmpty ? '?' : _first.text.trim()[0].toUpperCase(),
                                  style: TextStyle(color: AppColors.secondarySage, fontSize: 34, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Change photo',
                      style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
            const FieldLabel('First name', required: true),
            TextField(
              controller: _first,
              onChanged: (_) => _firstError == null ? null : setState(() => _firstError = null),
              textCapitalization: TextCapitalization.words,
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
              decoration: healthDecoration('Enter your first name', error: _firstError),
            ),
            const FieldLabel('Last name'),
            TextField(
              controller: _last,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
              decoration: healthDecoration('Enter your last name'),
            ),
            const FieldLabel('Display name'),
            TextField(
              controller: _display,
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
              decoration: healthDecoration('Enter a display name'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Used to identify you in Ulvenik and on reports you choose to share. This does not create a public profile.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══ Appearance ═════════════════════════════════════════════════════════════

/// Appearance: text size, animations and touch feedback. Changes apply and
/// save immediately (no Save button); nothing is shown as saved on failure.
class AppearancePrefsScreen extends StatelessWidget {
  const AppearancePrefsScreen({super.key});

  Future<void> _apply(BuildContext context, Future<bool> f) async {
    final ok = await f;
    if (!ok && context.mounted) {
      AppSnackbar.show(context, message: 'That change couldn’t be saved. Please try again.', type: SnackbarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSettings.instance;
    return ListenableBuilder(
      listenable: s,
      builder: (context, _) => HealthScaffold(
        title: 'Appearance',
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const SectionLabel('Theme'),
            Row(
              children: [
                for (final mode in AppSettings.themeModes) ...[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _apply(context, s.setThemeMode(mode)),
                      child: Container(
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: s.themeMode == mode
                              ? AppColors.primaryForestGreen.withValues(alpha: 0.18)
                              : AppColors.cardsCarbon,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: s.themeMode == mode ? AppColors.primaryForestGreen : AppColors.cardBorder),
                        ),
                        child: Text(mode,
                            style: TextStyle(
                                color: s.themeMode == mode
                                    ? AppColors.primaryTextOffWhite
                                    : AppColors.secondaryTextStoneGrey,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  if (mode != AppSettings.themeModes.last) const SizedBox(width: 10),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text('Device follows your phone’s own Dark/Light setting.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            const SizedBox(height: 18),
            const SectionLabel('Text size'),
            for (final t in AppSettings.textSizes)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(t, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                trailing: s.textSize == t ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                onTap: () => _apply(context, s.setTextSize(t)),
              ),
            const SizedBox(height: 6),
            Text('Ulvenik also follows your device’s text size.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            const SizedBox(height: 18),
            _switchRow('Reduce Animations', 'Use fewer animations and simpler transitions.', s.reduceAnimations,
                (v) => _apply(context, s.setReduceAnimations(v))),
            _switchRow('Touch Feedback', 'Subtle vibrations when using controls.', s.touchFeedback,
                (v) => _apply(context, s.setTouchFeedback(v))),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () async {
                final ok = await showModalBottomSheet<bool>(
                  context: context,
                  backgroundColor: AppColors.cardsCarbon,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (ctx) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text('Reset to defaults?',
                            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text(
                          'Text size returns to Standard, Reduce Animations turns off and Touch Feedback turns on. Your records, media, reminders and regional preferences are not affected.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.4),
                        ),
                        const SizedBox(height: 18),
                        PrimaryButton(label: 'Reset to Defaults', onPressed: () => Navigator.pop(ctx, true)),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: AppColors.cardBorder)),
                            child: Text('Cancel', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
                if (ok == true) await s.resetAppearance();
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  minimumSize: const Size(double.infinity, 48)),
              child: const Text('Reset to Defaults'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══ Regional Preferences ═══════════════════════════════════════════════════

/// Regional Preferences: independent display choices, saved together with one
/// Save Changes. They change how values are shown, never the stored records.
class RegionalPreferencesScreen extends StatefulWidget {
  const RegionalPreferencesScreen({super.key});

  @override
  State<RegionalPreferencesScreen> createState() => _RegionalPreferencesScreenState();
}

class _RegionalPreferencesScreenState extends State<RegionalPreferencesScreen> {
  final _s = AppSettings.instance;
  late String _weight = _s.weightUnit;
  late String _distance = _s.distanceUnit;
  late String _date = _s.dateFormat;
  late bool _h24 = _s.clock24;
  late String _week = _s.weekStart;
  late String _country = _s.country;
  late bool _autoTz = _s.autoTimeZone;
  late String _tz = _s.timeZone;
  bool _saving = false;

  bool get _dirty =>
      _country != _s.country ||
      _autoTz != _s.autoTimeZone ||
      _tz != _s.timeZone ||
      _weight != _s.weightUnit ||
      _distance != _s.distanceUnit ||
      _date != _s.dateFormat ||
      _h24 != _s.clock24 ||
      _week != _s.weekStart;

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final r = await Future.wait([
      _s.setWeightUnit(_weight),
      _s.setDistanceUnit(_distance),
      _s.setDateFormat(_date),
      _s.setClock24(_h24),
      _s.setWeekStart(_week),
      _s.setCountry(_country),
      _s.setAutoTimeZone(_autoTz),
      _s.setTimeZone(_tz),
    ]);
    if (!mounted) return;
    setState(() => _saving = false);
    if (r.every((e) => e)) {
      Navigator.pop(context);
    } else {
      AppSnackbar.show(context,
          message: 'Your changes couldn’t be saved. They’re still here — try again.', type: SnackbarType.error);
    }
  }

  String get _dateExample => switch (_date) {
        '14 Mar 2026' => '14 Mar 2026',
        'MM/DD/YYYY' => '03/14/2026',
        'YYYY-MM-DD' => '2026-03-14',
        _ => '14/03/2026',
      };

  @override
  Widget build(BuildContext context) {
    final w = _weight == 'kg' ? '32.4 kg' : '71.4 lb';
    final d = _distance == 'km' ? '4.8 km' : '3.0 mi';
    final t = _h24 ? '14:30' : '2:30 PM';
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard(context) && context.mounted) Navigator.pop(context);
      },
      child: HealthScaffold(
        title: 'Regional Preferences',
        bottom: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: (_dirty && !_saving) ? _save : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryForestGreen,
              foregroundColor: AppColors.onForestGreen,
              disabledBackgroundColor: AppColors.cardsCarbon,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text('Changing units only affects how values are displayed. Stored data is never modified.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4)),
            const SectionLabel('Country or region'),
            OutlinedButton(
              onPressed: () async {
                final c = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => CountryPickerScreen(current: _country)));
                if (c != null) setState(() => _country = c);
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  backgroundColor: AppColors.cardsCarbon,
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size(double.infinity, 46)),
              child: Text(_country.isEmpty ? 'Select a country or region' : _country),
            ),
            const SectionLabel('Language'),
            OutlinedButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSettingsScreen()));
                if (mounted) setState(() {});
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  backgroundColor: AppColors.cardsCarbon,
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size(double.infinity, 46)),
              child: Text(_s.language),
            ),
            const SectionLabel('Time zone'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppColors.primaryForestGreen,
              title: Text('Use device time zone', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              subtitle: Text(
                _autoTz
                    ? 'Follows this device (${DateTime.now().timeZoneName}, UTC ${DateTime.now().timeZoneOffset.isNegative ? '-' : '+'}${DateTime.now().timeZoneOffset.inHours.abs().toString().padLeft(2, '0')}:${(DateTime.now().timeZoneOffset.inMinutes.abs() % 60).toString().padLeft(2, '0')}).'
                    : 'Using the zone below.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
              ),
              value: _autoTz,
              onChanged: (v) => setState(() => _autoTz = v),
            ),
            if (!_autoTz) ...[
              OutlinedButton(
                onPressed: () async {
                  final z = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => TimeZonePickerScreen(current: _tz)));
                  if (z != null) setState(() => _tz = z);
                },
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryTextOffWhite,
                    side: BorderSide(color: AppColors.cardBorder),
                    backgroundColor: AppColors.cardsCarbon,
                    alignment: Alignment.centerLeft,
                    minimumSize: const Size(double.infinity, 46)),
                child: Text(_tz.isEmpty ? 'Select a time zone' : _tz.replaceAll('_', ' ')),
              ),
              if (_tz.isNotEmpty && zoneInfo(_tz) != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${zoneInfo(_tz)!.offset} · ${zoneInfo(_tz)!.abbr} · now ${zoneInfo(_tz)!.clock}',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                ),
            ],
            const SizedBox(height: 18),
            const SectionLabel('Weight'),
            ChoiceRow(options: const ['kg', 'lb'], value: _weight, onChanged: (v) => setState(() => _weight = v)),
            const SizedBox(height: 14),
            const SectionLabel('Distance'),
            ChoiceRow(options: const ['km', 'mi'], value: _distance, onChanged: (v) => setState(() => _distance = v)),
            const SizedBox(height: 14),
            const SectionLabel('Date format'),
            ChoiceRow(
                options: const ['14 Mar 2026', 'DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'],
                value: _date,
                onChanged: (v) => setState(() => _date = v)),
            const SizedBox(height: 14),
            const SectionLabel('Time format'),
            ChoiceRow(
                options: const ['12-hour', '24-hour'],
                value: _h24 ? '24-hour' : '12-hour',
                onChanged: (v) => setState(() => _h24 = v == '24-hour')),
            const SizedBox(height: 14),
            const SectionLabel('Week starts on'),
            ChoiceRow(options: const ['Monday', 'Sunday'], value: _week, onChanged: (v) => setState(() => _week = v)),
            const SizedBox(height: 22),
            HealthCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Example values',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Examples using your selected units.',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                const SizedBox(height: 10),
                Text('$w · $d', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
                Text('$_dateExample · $t', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
              ]),
            ),
            const SizedBox(height: 12),
            Text('Saved record times are preserved; their displayed format may change.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4)),
          ],
        ),
      ),
    );
  }
}

// ═══ Notification Settings ══════════════════════════════════════════════════

/// Notification Settings: which kinds of alert are allowed. These do not
/// create schedules; reminders keep the time saved on their own record.
class NotificationPrefsScreen extends StatelessWidget {
  const NotificationPrefsScreen({super.key});

  Future<void> _apply(BuildContext context, Future<bool> f) async {
    final ok = await f;
    if (!ok && context.mounted) {
      AppSnackbar.show(context, message: 'That change couldn’t be saved. Please try again.', type: SnackbarType.error);
    }
  }

  Future<void> _pickTime(BuildContext context, String current, Future<bool> Function(String) save) async {
    final p = current.split(':');
    final t = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: int.tryParse(p.first) ?? 22, minute: int.tryParse(p.last) ?? 0));
    if (t == null || !context.mounted) return;
    final v = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    await _apply(context, save(v));
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSettings.instance;
    return ListenableBuilder(
      listenable: s,
      builder: (context, _) {
        final push = s.notify('push');
        return HealthScaffold(
          title: 'Notification Settings',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _switchRow('Push Notifications', 'Receive reminders and updates on this device.', push,
                  (v) => _apply(context, s.setNotify('push', v))),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Your device also controls whether Ulvenik may send notifications. These choices only say which alerts you want.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4),
                ),
              ),
              const SectionLabel('Reminders'),
              for (final e in AppSettings.notifyKeys.entries)
                _switchRow(e.value, null, s.notify(e.key), push ? (v) => _apply(context, s.setNotify(e.key, v)) : null),
              const SizedBox(height: 14),
              const SectionLabel('Quiet Hours'),
              _switchRow('Quiet Hours', 'Silence notification sounds during these hours.', s.quietHours,
                  (v) => _apply(context, s.setQuietHours(v))),
              if (s.quietHours) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Starts', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                  trailing: Text(s.quietStart, style: TextStyle(color: AppColors.secondaryTextStoneGrey)),
                  onTap: () => _pickTime(context, s.quietStart, s.setQuietStart),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Ends', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                  trailing: Text(s.quietEnd, style: TextStyle(color: AppColors.secondaryTextStoneGrey)),
                  onTap: () => _pickTime(context, s.quietEnd, s.setQuietEnd),
                ),
                if (s.quietStart == s.quietEnd)
                  const Text('Start and end times are the same, so quiet hours are ambiguous.',
                      style: TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
                Text('Saved reminders are still delivered at their saved time.',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              ],
              const SizedBox(height: 14),
              const SectionLabel('Email'),
              _switchRow('Product News', 'Occasional news about Ulvenik.', s.productNews,
                  (v) => _apply(context, s.setProductNews(v))),
              Text('Essential account and billing emails are managed separately.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              const SizedBox(height: 14),
              _switchRow('App Icon Badge', 'Show unread notifications on the app icon.', s.appBadge,
                  (v) => _apply(context, s.setAppBadge(v))),
            ],
          ),
        );
      },
    );
  }
}

/// Small row used by the More hub.
Widget moreRow({required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) =>
    Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Icon(icon, size: 22, color: AppColors.secondarySage),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15)),
                if (subtitle != null)
                  Text(subtitle, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              ]),
            ),
            UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
          ]),
        ),
      ),
    );
