import 'dart:io';
import 'package:flutter/widgets.dart';
import 'persist.dart';

/// Saved framing for a wide cover photo, stored relative to the frame size.
class DogCoverCrop {
  final double scale;
  final double dx;
  final double dy;
  const DogCoverCrop({this.scale = 1, this.dx = 0, this.dy = 0});
  static const none = DogCoverCrop();

  Map<String, dynamic> toJson() => {'scale': scale, 'dx': dx, 'dy': dy};
  factory DogCoverCrop.fromJson(Map m) => DogCoverCrop(
        scale: (m['scale'] as num?)?.toDouble() ?? 1,
        dx: (m['dx'] as num?)?.toDouble() ?? 0,
        dy: (m['dy'] as num?)?.toDouble() ?? 0,
      );
}

/// A dog profile: real saved record, not fixed demo data. Edits, the chosen
/// cover photo and its framing, archiving and deleting all change the one
/// saved dog and persist to the device.
class DogInfo {
  final String id;
  String name;
  String breed;
  String age;
  String sex;
  String? photoUrl; // seeded sample photo
  String? localPhotoPath; // a photo the user picked, takes priority
  DogCoverCrop coverCrop;
  DateTime? lastActive;
  bool isClient;
  String? ownerName;
  int sessionCount;
  int totalMinutes; // sum of recorded session durations only
  bool archived;

  DogInfo({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.sex,
    this.photoUrl,
    this.localPhotoPath,
    this.coverCrop = DogCoverCrop.none,
    this.lastActive,
    this.isClient = false,
    this.ownerName,
    this.sessionCount = 0,
    this.totalMinutes = 0,
    this.archived = false,
  });

  /// "Breed · age · sex", the approved secondary line on dog cards.
  String get details => '$breed · $age · $sex';

  /// The photo to show: a user-picked photo first, else the seeded one.
  ImageProvider? get photoProvider {
    if (localPhotoPath != null && localPhotoPath!.isNotEmpty) return FileImage(File(localPhotoPath!));
    if (photoUrl != null) return NetworkImage(photoUrl!);
    return null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'breed': breed,
        'age': age,
        'sex': sex,
        'photoUrl': photoUrl,
        'localPhotoPath': localPhotoPath,
        'coverCrop': coverCrop.toJson(),
        'lastActive': lastActive?.toIso8601String(),
        'isClient': isClient,
        'ownerName': ownerName,
        'sessionCount': sessionCount,
        'totalMinutes': totalMinutes,
        'archived': archived,
      };

  factory DogInfo.fromJson(Map m) => DogInfo(
        id: m['id'],
        name: m['name'],
        breed: m['breed'],
        age: m['age'],
        sex: m['sex'],
        photoUrl: m['photoUrl'],
        localPhotoPath: m['localPhotoPath'],
        coverCrop: m['coverCrop'] is Map ? DogCoverCrop.fromJson(m['coverCrop'] as Map) : DogCoverCrop.none,
        lastActive: DateTime.tryParse('${m['lastActive'] ?? ''}'),
        isClient: m['isClient'] ?? false,
        ownerName: m['ownerName'],
        sessionCount: m['sessionCount'] ?? 0,
        totalMinutes: m['totalMinutes'] ?? 0,
        archived: m['archived'] ?? false,
      );
}

class DogsStore extends ChangeNotifier {
  DogsStore._();
  static final DogsStore instance = DogsStore._();

  final List<DogInfo> _dogs = [];
  int _seq = 0;
  String _newId() => 'dog${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  Future<void> load() async {
    final j = await Persist.read('store.dogs');
    if (j is List && j.isNotEmpty) {
      _dogs
        ..clear()
        ..addAll([for (final m in j.cast<Map>()) DogInfo.fromJson(m)]);
    } else {
      _seedOnce();
    }
    notifyListeners();
  }

  void _save() => Persist.write('store.dogs', [for (final d in _dogs) d.toJson()]);

  void _touch() {
    _save();
    notifyListeners();
  }

  List<DogInfo> get all => _dogs.where((d) => !d.archived).toList();
  List<DogInfo> get myDogs => all.where((d) => !d.isClient).toList();
  List<DogInfo> get clientDogs => all.where((d) => d.isClient).toList();
  List<DogInfo> get archivedDogs => _dogs.where((d) => d.archived).toList();

  DogInfo dogNamed(String name) => _dogs.firstWhere(
        (d) => d.name == name,
        orElse: () => all.isNotEmpty ? all.first : _dogs.first,
      );

  void setPhoto(DogInfo d, String path) {
    d.localPhotoPath = path;
    _touch();
  }

  void setCoverCrop(DogInfo d, DogCoverCrop crop) {
    d.coverCrop = crop;
    _touch();
  }

  void setArchived(DogInfo d, bool v) {
    d.archived = v;
    _touch();
  }

  void delete(String id) {
    _dogs.removeWhere((d) => d.id == id);
    _touch();
  }

  /// The illustrative starting dogs, seeded once when nothing has been saved
  /// yet (e.g. a fresh install). Never re-added once the user has any dogs.
  void _seedOnce() {
    const img = 'https://lh3.googleusercontent.com/aida-public/';
    _dogs.addAll([
      DogInfo(
        id: _newId(), name: 'Murphy', breed: 'Golden Retriever', age: '4 yrs', sex: 'Male',
        photoUrl: '${img}AB6AXuDAm6Qjx7r8IjMbUPAoPZtLHLuvG0GSyXyqNYoE-0HvkL8R0uhRqzAJo_IppFqkRZBUCIxwx_3DkTS4wwh3N2HO0mGuLtzrdN0LrtKI6IeWju_DR5KZ5RlBnWoTDSUEt2FYMzjNLNcwt6GWeEOnLyHpsSF0KVQmVQ98Mpd5SIk2NoCP5PUwyYhXrhnZdD80Ah582bGM_kFuz7Z7DQoRmDKYzIqnKSgMYx8MPX4YMiDSzEnfyRyHxdQ',
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
        sessionCount: 128, totalMinutes: 2520,
      ),
      DogInfo(
        id: _newId(), name: 'Bella', breed: 'Belgian Malinois', age: '2 yrs', sex: 'Female',
        photoUrl: '${img}AB6AXuA_FGLheOQECXltZJ7TsUvazbqLiSre1yRRKuQezkUBBZQ72U7xo9pc_zOrINWFZo7mLR2Ml-xjS2Z8_yKiR8etkKnpixjmkyGf5DtZF637KRF0kKrTTdiJ8u__KVQnHJ65-PQgSPDIQh8eLlq1BHg9yEN2POU9Xfc1RSkS8yEXEGlkysd7ZGtZLiWvC9iVPdKV30xIgiL3ooXAxC9Z0iLRQxJkidNmE7oJrDOQA7GdhUFY_apTsHQ',
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
        sessionCount: 64, totalMinutes: 1310,
      ),
      DogInfo(id: _newId(), name: 'Monty', breed: 'Mixed Breed', age: '1 yr', sex: 'Male'),
      DogInfo(
        id: _newId(), name: 'Luna', breed: 'Border Collie', age: '5 yrs', sex: 'Female',
        photoUrl: '${img}AB6AXuD-dBzJ3N-iY9n3LL7Zjg-9n9zNG8t0rH2uPeaa4gsfQeqLIyVQ9EfpR71y6T19BFQFcx2pR9R0b-D2q9nV9zEk-1GGDSB3MyGVoEfUgINo-TBo_H7kxre8TJ3nJtnamMVrZHYDCh3yFMH9hhETUUce8CvddXDdjljTpk4DRmnO7MPoXouW9jaMcJZiL9iR3sPBW056jR8HpE4xVtatKp4IOVIwTtw0dPKosa_kZxvey903ZD03YVA',
        lastActive: DateTime.now().subtract(const Duration(days: 3)),
      ),
      DogInfo(
        id: _newId(), name: 'Axel', breed: 'Dutch Shepherd', age: '3 yrs', sex: 'Male',
        photoUrl: '${img}AB6AXuDvoTz5a9TC8u0P6-Md-scQcGedKfr4MXS6Ie8LAbxJyqbiVSDXuswe5WMfqrcXgK1s_YinkrDcT3cJA9UGsimRU0FgiHrxtMc0wZsYzNUajf_uPPHrYen5iRNaMD4_V7SkMj-abO0YqW5ydXjqfTvaWiimGC222XSr8xkdo8-ZRh9wtLIghLjSVf6OlVKj43jAkmQ98l9R9zgAoO7JzPugZGsSnyF6j8IkQjXebvcBQa3Th9WsTbE',
        lastActive: DateTime.now().subtract(const Duration(days: 7)),
      ),
      DogInfo(id: _newId(), name: 'Nova', breed: 'German Shepherd', age: '6 mos', sex: 'Female'),
      DogInfo(
        id: _newId(), name: 'Bailey', breed: 'Labrador Retriever', age: '3 yrs', sex: 'Female',
        isClient: true, ownerName: 'Olivia Reed',
        lastActive: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
    _save();
  }
}
