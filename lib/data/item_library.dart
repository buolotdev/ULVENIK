import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User-created Rewards and Equipment libraries. Nothing is preloaded. Items
/// are archived rather than erased, so past sessions keep their recorded names.
enum LibraryKind { rewards, equipment }

class LibraryItem {
  final String id;
  String name;
  String type;
  String notes;
  bool archived;
  LibraryItem({required this.id, required this.name, this.type = '', this.notes = '', this.archived = false});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'type': type, 'notes': notes, 'archived': archived};
  factory LibraryItem.fromJson(Map<String, dynamic> j) => LibraryItem(
      id: j['id'] as String,
      name: j['name'] as String,
      type: (j['type'] as String?) ?? '',
      notes: (j['notes'] as String?) ?? '',
      archived: (j['archived'] as bool?) ?? false);
}

class ItemLibraryStore extends ChangeNotifier {
  ItemLibraryStore._();
  static final ItemLibraryStore instance = ItemLibraryStore._();

  final Map<LibraryKind, List<LibraryItem>> _items = {LibraryKind.rewards: [], LibraryKind.equipment: []};
  final Map<LibraryKind, List<String>> _types = {LibraryKind.rewards: [], LibraryKind.equipment: []};
  SharedPreferences? _p;
  int _seq = 0;

  String _k(LibraryKind k, String what) => 'library.${k.name}.$what';

  Future<void> load() async {
    try {
      _p = await SharedPreferences.getInstance();
      for (final k in LibraryKind.values) {
        final raw = _p!.getString(_k(k, 'items'));
        if (raw != null) {
          _items[k] = [for (final j in jsonDecode(raw) as List) LibraryItem.fromJson(j as Map<String, dynamic>)];
        }
        _types[k] = _p!.getStringList(_k(k, 'types')) ?? [];
      }
    } catch (_) {}
  }

  Future<void> _save(LibraryKind k) async {
    try {
      final p = _p ?? await SharedPreferences.getInstance();
      _p = p;
      await p.setString(_k(k, 'items'), jsonEncode([for (final i in _items[k]!) i.toJson()]));
      await p.setStringList(_k(k, 'types'), _types[k]!);
    } catch (_) {}
  }

  List<LibraryItem> items(LibraryKind k, {bool archived = false}) =>
      _items[k]!.where((i) => i.archived == archived).toList();
  List<String> types(LibraryKind k) => List.of(_types[k]!);
  List<String> names(LibraryKind k) => [for (final i in items(k)) i.name];

  String newId() => 'lib${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  void addType(LibraryKind k, String type) {
    final t = type.trim();
    if (t.isEmpty || _types[k]!.any((e) => e.toLowerCase() == t.toLowerCase())) return;
    _types[k]!.add(t);
    _save(k);
    notifyListeners();
  }

  void renameType(LibraryKind k, String from, String to) {
    final t = to.trim();
    if (t.isEmpty) return;
    final i = _types[k]!.indexOf(from);
    if (i >= 0) _types[k]![i] = t;
    for (final it in _items[k]!) {
      if (it.type == from) it.type = t;
    }
    _save(k);
    notifyListeners();
  }

  void removeType(LibraryKind k, String type) {
    _types[k]!.remove(type);
    for (final it in _items[k]!) {
      if (it.type == type) it.type = '';
    }
    _save(k);
    notifyListeners();
  }

  /// Adds or finds an item by name (case-insensitive). Used by session forms.
  LibraryItem addByName(LibraryKind k, String name) {
    final n = name.trim();
    final existing = _items[k]!.where((i) => i.name.toLowerCase() == n.toLowerCase()).firstOrNull;
    if (existing != null) {
      existing.archived = false;
      _save(k);
      notifyListeners();
      return existing;
    }
    final it = LibraryItem(id: newId(), name: n);
    _items[k]!.add(it);
    _save(k);
    notifyListeners();
    return it;
  }

  void save(LibraryKind k, LibraryItem item) {
    if (!_items[k]!.any((i) => i.id == item.id)) _items[k]!.add(item);
    if (item.type.isNotEmpty && !_types[k]!.any((e) => e.toLowerCase() == item.type.toLowerCase())) {
      _types[k]!.add(item.type);
    }
    _save(k);
    notifyListeners();
  }

  void setArchived(LibraryKind k, LibraryItem item, bool v) {
    item.archived = v;
    _save(k);
    notifyListeners();
  }
}
