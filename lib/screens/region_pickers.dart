import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';

const kCountries = <String>[
  'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan',
  'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia',
  'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria', 'Burkina Faso', 'Burundi', 'Cambodia', 'Cameroon',
  'Canada', 'Cape Verde', 'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia', 'Comoros', 'Congo (DRC)',
  'Congo (Republic)', 'Costa Rica', 'Côte d’Ivoire', 'Croatia', 'Cuba', 'Cyprus', 'Czechia', 'Denmark', 'Djibouti',
  'Dominican Republic', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Eswatini',
  'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana', 'Greece', 'Guatemala',
  'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Honduras', 'Hong Kong', 'Hungary', 'Iceland', 'India', 'Indonesia',
  'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya', 'Kuwait',
  'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg',
  'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Mauritania', 'Mauritius', 'Mexico', 'Moldova',
  'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Myanmar', 'Namibia', 'Nepal', 'Netherlands',
  'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North Macedonia', 'Norway', 'Oman', 'Pakistan', 'Palestine', 'Panama',
  'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Poland', 'Portugal', 'Qatar', 'Romania', 'Russia', 'Rwanda',
  'Saudi Arabia', 'Senegal', 'Serbia', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Somalia', 'South Africa',
  'South Korea', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria', 'Taiwan',
  'Tajikistan', 'Tanzania', 'Thailand', 'Togo', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan', 'Uganda',
  'Ukraine', 'United Arab Emirates', 'United Kingdom', 'United States', 'Uruguay', 'Uzbekistan', 'Venezuela', 'Vietnam',
  'Yemen', 'Zambia', 'Zimbabwe',
];

/// Searchable country / region picker. Returns the chosen name (or null).
class CountryPickerScreen extends StatefulWidget {
  final String current;
  const CountryPickerScreen({super.key, required this.current});

  @override
  State<CountryPickerScreen> createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends State<CountryPickerScreen> {
  final _q = TextEditingController();

  @override
  void initState() {
    super.initState();
    _q.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _q.text.trim().toLowerCase();
    final list = kCountries.where((c) => q.isEmpty || c.toLowerCase().contains(q)).toList();
    return HealthScaffold(
      title: 'Country or Region',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          const Text('Changing your country won’t change your language, units or time zone.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4)),
          const SizedBox(height: 12),
          TextField(controller: _q, style: const TextStyle(color: AppColors.primaryTextOffWhite), decoration: healthDecoration('Search countries and regions...')),
          const SizedBox(height: 8),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('No matching countries or regions.', style: TextStyle(color: AppColors.secondaryTextStoneGrey))),
            ),
          for (final c in list)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(c, style: const TextStyle(color: AppColors.primaryTextOffWhite)),
              trailing: c == widget.current ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
              onTap: () => Navigator.pop(context, c),
            ),
        ],
      ),
    );
  }
}

bool _tzReady = false;

/// Current offset and abbreviation for a named zone on a given date — computed
/// from the zone rules, so daylight saving is handled.
({String clock, String offset, String abbr})? zoneInfo(String name, [DateTime? at]) {
  try {
    if (!_tzReady) {
      tzdata.initializeTimeZones();
      _tzReady = true;
    }
    final loc = tz.getLocation(name);
    final now = at == null ? tz.TZDateTime.now(loc) : tz.TZDateTime.from(at, loc);
    final off = now.timeZoneOffset;
    final sign = off.isNegative ? '-' : '+';
    final h = off.inHours.abs().toString().padLeft(2, '0');
    final m = (off.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return (
      clock: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      offset: 'UTC $sign$h:$m',
      abbr: now.timeZoneName,
    );
  } catch (_) {
    return null;
  }
}

List<String> allZoneNames() {
  if (!_tzReady) {
    tzdata.initializeTimeZones();
    _tzReady = true;
  }
  return tz.timeZoneDatabase.locations.keys.toList()..sort();
}

/// Searchable list of named zones with their real offset today.
class TimeZonePickerScreen extends StatefulWidget {
  final String current;
  const TimeZonePickerScreen({super.key, required this.current});

  @override
  State<TimeZonePickerScreen> createState() => _TimeZonePickerScreenState();
}

class _TimeZonePickerScreenState extends State<TimeZonePickerScreen> {
  final _q = TextEditingController();
  late final List<String> _zones = allZoneNames();

  @override
  void initState() {
    super.initState();
    _q.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _q.text.trim().toLowerCase().replaceAll(' ', '_');
    final list = _zones.where((z) => q.isEmpty || z.toLowerCase().contains(q)).take(80).toList();
    return HealthScaffold(
      title: 'Time Zone',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TextField(controller: _q, style: const TextStyle(color: AppColors.primaryTextOffWhite), decoration: healthDecoration('Search city, region or zone...')),
          const SizedBox(height: 8),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('No matching time zones.', style: TextStyle(color: AppColors.secondaryTextStoneGrey))),
            ),
          for (final z in list)
            Builder(builder: (_) {
              final i = zoneInfo(z);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(z.replaceAll('_', ' '), style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                subtitle: i == null ? null : Text('${i.offset} · ${i.clock}', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                trailing: z == widget.current ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                onTap: () => Navigator.pop(context, z),
              );
            }),
        ],
      ),
    );
  }
}
