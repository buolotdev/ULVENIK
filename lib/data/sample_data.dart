/// Compat shim: Dogs and Goals now come from their own saved stores
/// (DogsStore, GoalsStore) so every screen shows the same, persisted data.
library;

export 'goals_store.dart' show GoalInfo, GoalStatus, GoalTracking, GoalsStore;
export 'dogs_store.dart' show DogInfo, DogCoverCrop, DogsStore;

import 'goals_store.dart';
import 'dogs_store.dart';

class SampleData {
  SampleData._();

  static List<DogInfo> get dogs => DogsStore.instance.all;
  static List<DogInfo> get myDogs => DogsStore.instance.myDogs;
  static List<DogInfo> get clientDogs => DogsStore.instance.clientDogs;

  static DogInfo dogNamed(String name) => DogsStore.instance.dogNamed(name);

  /// Compat: delegates to the real, saved GoalsStore.
  static List<GoalInfo> goalsFor(String dogName) => GoalsStore.instance.goalsFor(dogName);
}
