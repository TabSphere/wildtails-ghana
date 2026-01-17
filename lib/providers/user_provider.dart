import 'package:flutter/foundation.dart';

enum UserLevel {
  seedling, explorer, ranger, guardian, champion;
  String get title => ['Seedling', 'Explorer', 'Ranger', 'Guardian', 'Champion'][index];
  String get icon => ['🌱', '🔍', '🏕️', '🛡️', '🏆'][index];
  int get minPoints => [0, 100, 500, 1500, 5000][index];
  
  static UserLevel fromPoints(int points) {
    if (points >= 5000) return champion;
    if (points >= 1500) return guardian;
    if (points >= 500) return ranger;
    if (points >= 100) return explorer;
    return seedling;
  }
}

class AppUser {
  final String id;
  final String displayName;
  final bool isGhanaian;
  final int points;
  final UserLevel level;
  final List<String> visitedParkIds;
  final List<String> savedParkIds;
  final List<String> earnedBadgeIds;

  AppUser({
    required this.id,
    required this.displayName,
    this.isGhanaian = false,
    this.points = 0,
    this.level = UserLevel.seedling,
    this.visitedParkIds = const [],
    this.savedParkIds = const [],
    this.earnedBadgeIds = const [],
  });

  double get levelProgress {
    if (level == UserLevel.champion) return 1.0;
    final nextLevel = UserLevel.values[level.index + 1];
    return (points - level.minPoints) / (nextLevel.minPoints - level.minPoints);
  }

  AppUser copyWith({
    String? displayName,
    bool? isGhanaian,
    int? points,
    UserLevel? level,
    List<String>? visitedParkIds,
    List<String>? savedParkIds,
    List<String>? earnedBadgeIds,
  }) {
    return AppUser(
      id: id,
      displayName: displayName ?? this.displayName,
      isGhanaian: isGhanaian ?? this.isGhanaian,
      points: points ?? this.points,
      level: level ?? this.level,
      visitedParkIds: visitedParkIds ?? this.visitedParkIds,
      savedParkIds: savedParkIds ?? this.savedParkIds,
      earnedBadgeIds: earnedBadgeIds ?? this.earnedBadgeIds,
    );
  }
}

class UserProvider extends ChangeNotifier {
  AppUser _user = AppUser(
    id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
    displayName: 'Wildlife Explorer',
    points: 75,
  );

  AppUser get user => _user;
  List<String> get savedParkIds => _user.savedParkIds;

  void addPoints(int points) {
    final newPoints = _user.points + points;
    _user = _user.copyWith(
      points: newPoints,
      level: UserLevel.fromPoints(newPoints),
    );
    notifyListeners();
  }

  void markParkVisited(String parkId) {
    if (_user.visitedParkIds.contains(parkId)) return;
    _user = _user.copyWith(
      visitedParkIds: [..._user.visitedParkIds, parkId],
    );
    addPoints(50);
  }

  void toggleSavedPark(String parkId) {
    final saved = List<String>.from(_user.savedParkIds);
    if (saved.contains(parkId)) {
      saved.remove(parkId);
    } else {
      saved.add(parkId);
    }
    _user = _user.copyWith(savedParkIds: saved);
    notifyListeners();
  }

  bool isParkSaved(String parkId) => _user.savedParkIds.contains(parkId);
}
