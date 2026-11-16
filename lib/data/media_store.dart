import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'persist.dart';

/// Dog Media library data: one item per file, however many records or
/// collections reach it. Per dog, in memory until a backend exists. No sample
/// media is ever created.
enum MediaType { photo, video, document }

MediaType mediaTypeFor(String fileName) {
  final ext = fileName.contains('.') ? fileName.split('.').last.toLowerCase() : '';
  if (const ['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif', 'bmp'].contains(ext)) return MediaType.photo;
  if (const ['mp4', 'mov', 'm4v', 'avi', 'webm', 'mkv', '3gp'].contains(ext)) return MediaType.video;
  return MediaType.document;
}

/// A file chosen by the user (name, where it lives on the device, size).
class MediaFile {
  final String name;
  final String? path;
  final int size;
  const MediaFile(this.name, this.path, this.size);
}

Future<List<MediaFile>> pickMediaFiles({FileType type = FileType.any}) async {
  final r = await FilePicker.pickFiles(type: type);
  final out = <MediaFile>[];
  for (final f in r) {
    int size = 0;
    try {
      size = await f.xFile.length();
    } catch (_) {}
    out.add(MediaFile(f.name, f.path, size));
  }
  return out;
}

/// A route back to the record a file is attached to. Closures are evaluated
/// live so renamed records show their new name.
class MediaLink {
  final String key; // unique per record, e.g. 'sc:ID'
  final String section; // Training | S&C | Health | Sport
  final String Function() label;
  final List<String> Function() collections; // names for automatic collections
  final Widget Function(BuildContext) open;
  const MediaLink({
    required this.key,
    required this.section,
    required this.label,
    required this.collections,
    required this.open,
  });
}

class MediaItem {
  final String id;
  final String name;
  final String? path;
  final int size;
  final MediaType type;
  String title;
  String description;
  DateTime mediaDate; // when the media belongs to — editable
  final DateTime uploadedAt; // when it was added to Ulvenik
  bool favourite;
  final Set<String> collectionIds;
  final List<MediaLink> links;
  MediaItem({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.type,
    required this.mediaDate,
    required this.uploadedAt,
    this.title = '',
    this.description = '',
    this.favourite = false,
    Set<String>? collectionIds,
    List<MediaLink>? links,
  })  : collectionIds = collectionIds ?? {},
        links = links ?? [];

  String get displayTitle => title.trim().isNotEmpty ? title.trim() : name;
}

class MediaCollection {
  final String id;
  String name;
  MediaCollection(this.id, this.name);
}

class MediaStore extends ChangeNotifier {
  MediaStore._();
  static final MediaStore instance = MediaStore._();

  final Map<String, List<MediaItem>> _items = {};
  final Map<String, List<MediaCollection>> _collections = {};
  int _seq = 0;
  String newId() => 'm${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  List<MediaItem> items(String dog) => List.of(_items[dog] ?? const []);

  MediaItem? item(String dog, String id) {
    for (final i in _items[dog] ?? const <MediaItem>[]) {
      if (i.id == id) return i;
    }
    return null;
  }

  /// Adds files. A file already in this dog's library (same path and name) is
  /// reused, so a retry or a second link never makes a second copy.
  List<MediaItem> addFiles(
    String dog,
    List<MediaFile> files, {
    String title = '',
    String description = '',
    DateTime? mediaDate,
    Set<String> collectionIds = const {},
    List<MediaLink> links = const [],
  }) {
    final list = _items.putIfAbsent(dog, () => []);
    final out = <MediaItem>[];
    for (final f in files) {
      var existing = list.where((i) => i.name == f.name && i.path == f.path && i.size == f.size).firstOrNull;
      existing ??= MediaItem(
        id: newId(),
        name: f.name,
        path: f.path,
        size: f.size,
        type: mediaTypeFor(f.name),
        mediaDate: mediaDate ?? DateTime.now(),
        uploadedAt: DateTime.now(),
        title: files.length == 1 ? title : '',
        description: description,
      );
      if (!list.contains(existing)) list.add(existing);
      existing.collectionIds.addAll(collectionIds);
      for (final l in links) {
        if (!existing.links.any((x) => x.key == l.key)) existing.links.add(l);
      }
      out.add(existing);
    }
    notifyListeners();
    return out;
  }

  /// Files attached inside a record appear here automatically, still tied to
  /// that record.
  void attach(String dog, List<MediaFile> files, MediaLink link, {DateTime? mediaDate}) {
    if (files.isEmpty) return;
    addFiles(dog, files, mediaDate: mediaDate, links: [link]);
  }

  /// Removes the link to a record (e.g. when the record is deleted). The file
  /// itself stays in the library.
  void unlinkRecord(String dog, String key) {
    for (final i in _items[dog] ?? const <MediaItem>[]) {
      i.links.removeWhere((l) => l.key == key);
    }
    notifyListeners();
  }

  void unlink(MediaItem i, String key) {
    i.links.removeWhere((l) => l.key == key);
    notifyListeners();
  }

  void link(MediaItem i, MediaLink l) {
    if (!i.links.any((x) => x.key == l.key)) i.links.add(l);
    notifyListeners();
  }

  void toggleFavourite(MediaItem i) {
    i.favourite = !i.favourite;
    notifyListeners();
  }

  void update(MediaItem i, {String? title, String? description, DateTime? mediaDate}) {
    if (title != null) i.title = title;
    if (description != null) i.description = description;
    if (mediaDate != null) i.mediaDate = mediaDate;
    notifyListeners();
  }

  void delete(String dog, Iterable<String> ids) {
    final set = ids.toSet();
    _items[dog]?.removeWhere((i) => set.contains(i.id));
    notifyListeners();
  }

  // ── Collections ─────────────────────────────────────────────────────────
  List<MediaCollection> collections(String dog) => List.of(_collections[dog] ?? const []);

  MediaCollection createCollection(String dog, String name) {
    final c = MediaCollection(newId(), name.trim());
    _collections.putIfAbsent(dog, () => []).add(c);
    notifyListeners();
    return c;
  }

  void renameCollection(MediaCollection c, String name) {
    c.name = name.trim();
    notifyListeners();
  }

  /// Deleting a collection only removes the grouping; the files stay.
  void deleteCollection(String dog, String id) {
    _collections[dog]?.removeWhere((c) => c.id == id);
    for (final i in _items[dog] ?? const <MediaItem>[]) {
      i.collectionIds.remove(id);
    }
    notifyListeners();
  }

  void addToCollection(Iterable<MediaItem> items, String collectionId) {
    for (final i in items) {
      i.collectionIds.add(collectionId);
    }
    notifyListeners();
  }

  void removeFromCollection(MediaItem i, String collectionId) {
    i.collectionIds.remove(collectionId);
    notifyListeners();
  }

  /// Automatic collections from linked records: named after the linked
  /// skills, exercises, activities, sports or the record itself. Empty ones
  /// don't exist. Names are read live, so a rename shows straight away.
  Map<String, List<MediaItem>> autoCollections(String dog) {
    final out = <String, List<MediaItem>>{};
    for (final i in _items[dog] ?? const <MediaItem>[]) {
      final names = <String>{};
      for (final l in i.links) {
        final n = l.collections().where((e) => e.trim().isNotEmpty).toList();
        names.addAll(n.isEmpty ? [l.label()] : n);
      }
      for (final n in names) {
        if (n.trim().isEmpty) continue;
        out.putIfAbsent(n, () => []).add(i);
      }
    }
    return out;
  }

  // ── Persistence ─────────────────────────────────────────────────────────
  /// Rebuilds a record link from its saved key (set at app start).
  static MediaLink? Function(String dog, String key)? linkResolver;
  bool _loading = false;

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (!_loading) _save();
  }

  void _save() => Persist.write('store.media', {
        'items': {
          for (final e in _items.entries)
            e.key: [
              for (final i in e.value)
                {
                  'id': i.id, 'name': i.name, 'path': i.path, 'size': i.size, 'type': i.type.name,
                  'title': i.title, 'description': i.description, 'mediaDate': i.mediaDate.toIso8601String(),
                  'uploadedAt': i.uploadedAt.toIso8601String(), 'favourite': i.favourite,
                  'collections': i.collectionIds.toList(), 'links': [for (final l in i.links) l.key],
                }
            ]
        },
        'collections': {for (final e in _collections.entries) e.key: [for (final c in e.value) {'id': c.id, 'name': c.name}]},
      });

  Future<void> load() async {
    final j = await Persist.read('store.media');
    if (j is! Map) return;
    _loading = true;
    try {
      _collections
        ..clear()
        ..addAll({
          for (final e in ((j['collections'] as Map?) ?? {}).entries)
            e.key as String: [for (final c in (e.value as List).cast<Map>()) MediaCollection(c['id'], c['name'])]
        });
      _items
        ..clear()
        ..addAll({
          for (final e in ((j['items'] as Map?) ?? {}).entries)
            e.key as String: [
              for (final m in (e.value as List).cast<Map>())
                MediaItem(
                  id: m['id'], name: m['name'], path: m['path'], size: m['size'] ?? 0,
                  type: MediaType.values.firstWhere((t) => t.name == m['type'], orElse: () => MediaType.document),
                  mediaDate: DateTime.parse(m['mediaDate']), uploadedAt: DateTime.parse(m['uploadedAt']),
                  title: m['title'] ?? '', description: m['description'] ?? '', favourite: m['favourite'] ?? false,
                  collectionIds: {for (final c in (m['collections'] as List? ?? [])) '$c'},
                  links: [
                    for (final k in (m['links'] as List? ?? []))
                      ?linkResolver?.call(e.key as String, '$k'),
                  ],
                )
            ]
        });
    } catch (_) {
    } finally {
      _loading = false;
      super.notifyListeners();
    }
  }

}
