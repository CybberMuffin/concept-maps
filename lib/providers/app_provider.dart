import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  List<MapModel> maps;
  MapModel _currentMap;

  MapModel get currentMap => _currentMap;

  set currentMap(MapModel currentMap) {
    _currentMap = currentMap;
    notifyListeners();
  }

  Future<void> fetchAllMaps() async {
    maps ??= await ApiService.fetchBranches();
    return maps;
  }
}
