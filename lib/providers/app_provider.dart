import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  MapModel currentMap;
  Node focusNode;
  bool bottomSheetFlag;

  String animationId;
  bool animationStart = false;

  List<Node> tree;

  List<String> recentList = ["Dart", "String"];

  Future<MapModel> getMapModel(String field) async {
    if (field != currentMap?.field) currentMap = null;
    currentMap ??= await ApiService.fetchConceptRelations(field);
    return currentMap;
  }

  void setFocusNode(Node node) {
    focusNode = node;
    notifyListeners();
  }

  void setBottomSheetFlag(bool flag) {
    bottomSheetFlag = flag;
    notifyListeners();
  }

  void setAnimationParam(String id) {
    animationId = id;
    animationStart = true;
    notifyListeners();
  }

  void setTree(List<Node> t) {
    tree = t;
  }

  void addSearchHistory(String recentItem) {
    recentList.insert(0, recentItem);
  }

  void removeSearchHistory() {
    recentList.removeLast();
  }
}
