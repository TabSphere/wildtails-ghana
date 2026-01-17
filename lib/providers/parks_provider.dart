import 'package:flutter/foundation.dart';
import '../models/park_model.dart';

class ParksProvider extends ChangeNotifier {
  List<Park> get parks => ghanaParks;

  Park? getParkById(String id) {
    try {
      return parks.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Park> getParksByType(ParkType type) {
    return parks.where((p) => p.type == type).toList();
  }

  List<Park> searchParks(String query) {
    final q = query.toLowerCase();
    return parks.where((p) =>
      p.name.toLowerCase().contains(q) ||
      p.region.toLowerCase().contains(q) ||
      p.description.toLowerCase().contains(q)
    ).toList();
  }

  List<String> get allRegions {
    return parks.map((p) => p.region).toSet().toList()..sort();
  }
}
