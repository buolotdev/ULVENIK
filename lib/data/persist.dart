import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Tiny helper so every store saves and restores itself the same way. Reads
/// and writes never throw; a failed write leaves the previous saved copy in
/// place. Writes for one key are queued so the newest data always wins.
class Persist {
  Persist._();

  static final Map<String, String> _pending = {};
  static final Set<String> _running = {};

  static Future<Object?> read(String key) async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(key);
      return raw == null ? null : jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  static Future<void> write(String key, Object value) async {
    _pending[key] = jsonEncode(value);
    if (_running.contains(key)) return; // the running loop will pick up the newest value
    _running.add(key);
    try {
      while (_pending.containsKey(key)) {
        final data = _pending.remove(key)!;
        try {
          final p = await SharedPreferences.getInstance();
          await p.setString(key, data);
        } catch (_) {}
      }
    } finally {
      _running.remove(key);
    }
  }
}

DateTime? dt(Object? v) => v is String ? DateTime.tryParse(v) : null;
