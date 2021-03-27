import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:concept_maps/models/graph_entities/node.dart';

class AppProvider with ChangeNotifier {
  MapModel currentMap;
  Node focusNode;

  Future<MapModel> getMapModel(String field) async {
    if (field != currentMap?.field) currentMap = null;
    currentMap ??= await ApiService.fetchConceptRelations(field);
    return currentMap;
  }

  void setFocusNode(Node node){
    focusNode = node;
    notifyListeners();
  }
}
